import os, sys
from xdg import xdg_data_home, xdg_config_home

## Genral Information
info = {
	"NAME": "ColorApp",
	"VERSION": "0.2.0",
	"AUTHOR": "Fr75s",
	"URL": ""
}

paths = {
	"DATA": os.path.join(xdg_data_home(), "colorapp/"),
	"CONF": os.path.join(xdg_config_home(), "colorapp/")
}

version_info = info["NAME"] + " v" + info["VERSION"] + ". Made by " + info["AUTHOR"]

colors = {
	"main": "#26282d",
	"side": "#1e2126",
	"tool": "#16171a",
	"text": "#f2f6ff"
}

options = {
	"simpledisp": False,
	"altcolschemegen": False
}
