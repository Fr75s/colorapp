 
# ColorApp

## A desktop tool to quickly create and manage color schemes

### Summary

This is a simple tool that allows you to create and manage color schemes. You are able to create or generate color lists, as well as convert between color codes (Hex, RGB, HSV, HSL) seamlessly. As the only part that requires an online connection is color generation, this tool can be useful in providing easy color conversion offline.

This tool was initially created a few months back, around late July 2022. I am uploading it here now (in October) to allow the source code of this app to be freely visible.

Currently, no actual builds are planned. If desired, I may create build scripts to package this app as an AppImage or Flatpak later. Any non-Linux build will come later, as I currently do not know how to package PyQt apps for Windows/MacOS.



### Running the app

To run this app, you will need to have the following installed:

- Python 3
- Qt5

As well, the following non-builtin python dependencies (installable through `pip`) are needed:

- PyQt5
- requests

Finally, run the following command in the top-level folder of the application:

```
python3 -m colorapp
```

(note that upon opening, you may encounter a large number of errors. This is due to the colors used in the app's UI not being assigned upon the app's launch. This doesn't matter, however, as all the colors are assigned by the time the app is visible, meaning that these errors do not affect anything.)

This app was created and tested on my personal machine that runs Linux. This app is not guaranteed to work on a Windows/MacOS machine, but feel free to try, run, or find a way to make it work on these operating systems.
