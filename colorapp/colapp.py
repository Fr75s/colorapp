#!/usr/bin/python3
###
# The Main Script
###

import os, sys, json, requests

from .const import *

from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *

class RequestWorker(QObject):

	# Signals
	complete = pyqtSignal()
	returnData = pyqtSignal("QVariant", int)

	task = 0
	task_data = []

	def __init__(self, idx, tdata):
		super().__init__()
		self.task = idx
		self.task_data = tdata

	def run(self):
		if (self.task == 1):
			modename = "analogic"
			if self.task_data[1] == 1:
				modename = "triad"

			colorscheme_request_url = "https://www.thecolorapi.com/scheme?hex=" + self.task_data[0].strip("#") + "&mode=" + modename + "&format=json&count=6"

			print(f"Getting colors with {colorscheme_request_url}")

			request_success = False
			try:
				page = requests.get(colorscheme_request_url, timeout=15)
				request_success = True
			except Exception as e:
				print("Network Error")

			if (request_success):
				print("Request Successful")
				raw_content = page.json()

				colorlist = []
				for raw_color in raw_content["colors"]:
					this_color = {}
					this_color["col"] = raw_color["hex"]["value"].lower()
					this_color["name"] = raw_color["name"]["value"]
					this_color["idx"] = 0.0

					colorlist.append(this_color)

				self.returnData.emit(colorlist, 10)

			else:
				self.returnData.emit(["There was a network Error."], 11)

			self.complete.emit()



class MainAppBackend(QObject):

	sendData = pyqtSignal("QVariant", int)

	def __init__(self):
		super().__init__()

	def send_data(self):
		print("Initializing")
		self.update_options()
		self.sendData.emit(self.get_previews(), 2)

	def update_options(self):
		self.sendData.emit(options, 1)

	def toggle_option(self, option):
		options[option] = not(options[option])

		self.update_options()

	def save_colors(self, colorlist, file_path):
		cl_length = colorlist.property("length").toInt()
		cl_conv = []
		for i in range(0, cl_length):
			color_object = colorlist.property(i).toQObject()
			color_object_meta = color_object.metaObject()

			color_dict = {}
			for j in range(1, color_object_meta.propertyCount()):
				color_object_meta_property = color_object_meta.property(j)

				property_name = color_object_meta_property.name()
				property_value = color_object.property(property_name)

				#print(f"{property_name}: {property_value}")
				color_dict[property_name] = property_value

			cl_conv.append(color_dict)

		file_content = json.dumps(cl_conv, indent = 4)
		print(file_content)

		with open(file_path, "w") as out:
			out.write(file_content)

	def load_colorfile(self, file_path):
		content = json.load(open(file_path))

		# Validity Check

		# Check if root element is list
		validityPass = False
		if (type(content) == list):
			# Check if list has elements
			if len(content) > 0:
				# Check if list's elements are all objects
				valid = True
				for i in content:
					if type(i) != dict:
						valid = False
				if valid:
					# Check if all objects contain property "col" (color)
					for i in content:
						if not("col" in i):
							valid = False
					if valid:
						validityPass = True
						self.sendData.emit(content, -1)

		if not(validityPass):
			print("Couldn't load file")

	# Generate Colors
	def gen_colors(self, basecolor, mode):

		# Init worker
		self.thread = QThread()
		self.reqWorker = RequestWorker(1, [basecolor, mode])
		self.reqWorker.moveToThread(self.thread)

		# Define behaviors on start and finish
		self.thread.started.connect(self.reqWorker.run)
		self.reqWorker.complete.connect(self.thread.quit)
		self.reqWorker.complete.connect(self.reqWorker.deleteLater)
		self.thread.finished.connect(self.thread.deleteLater)

		self.reqWorker.returnData.connect(self.gen_colors_return)

		self.thread.start()

	def gen_colors_return(self, data, return_id):
		self.sendData.emit(data, return_id)

	# Preview Function, intended to get all the "previews" to preview colors in multiple design contexts. Sadly not implemented yet.
	def get_previews(self):
		previews_builtin = os.listdir(os.path.dirname(__file__) + "/PreviewsBuiltin")
		return previews_builtin


def main():
	# Main Function

	print("Starting application")
	print(version_info)

	app = QApplication(sys.argv)
	app.setApplicationName(info["NAME"])
	app.setApplicationVersion(info["VERSION"])
	app.setOrganizationName("Fr75s")

	engine = QQmlApplicationEngine()
	engine.quit.connect(app.quit)
	engine.load(os.path.dirname(__file__) + '/main.qml')
	root = engine.rootObjects()[0]

	backend = MainAppBackend()
	root.setProperty('backend', backend)
	root.setProperty('colors', colors)
	root.setProperty('info', info)

	root.loaded.connect(backend.send_data)
	root.saveColors.connect(backend.save_colors)
	root.loadColors.connect(backend.load_colorfile)
	root.togopt.connect(backend.toggle_option)

	root.generateColors.connect(backend.gen_colors)

	sys.exit(app.exec())
