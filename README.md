# GestureControlledCamera2D
A Camera2D node controlled through gestures. It's also an example of how to use the [Godot Touch Input Manager](https://github.com/Federico-Ciuffardi/Godot-Touch-Input-Manager).

## How to use
### 1 - Seting up [Godot Touch Input Manager](https://github.com/Federico-Ciuffardi/Godot-Touch-Input-Manager)
* Dowload the latest release from https://github.com/Federico-Ciuffardi/Godot-Touch-Input-Manager/releases
* Extract the downloaded *.zip* file somewhere in you project
* Locate newly extracted `InputManager.gd`, and [Autoload](https://docs.godotengine.org/en/3.1/getting_started/step_by_step/singletons_autoload.html) it.

### 2 - Using GestureControlledCamera2D
* Dowload the latest release from https://github.com/Federico-Ciuffardi/GestureControlledCamera2D/releases
* Extract the downloaded *.zip* file somewhere in you project
* Add the GestureControlledCamera2D node (GCC2D.tscn) to the scene and make sure to set `Current` to `On`
* Customize the [script variables](#script-variables) to your liking (optional)

Check out the [example](https://github.com/Federico-Ciuffardi/GestureControlledCamera2D/releases/download/v1.0.0/GestureControlledCamera-Example.zip)!

## Script variables

| Name             | Description                                         |
|------------------|-----------------------------------------------------|
| Max Zoom         | The camera will not zoom in any further than this   |
| Min Zoom         | The browser will not zoom out any further than this | 
| Zoom Gesture     | The gesture that will control the camera zoom       | 
| Rotation gesture | The gesture that will control the camera rotation   | 
| Movement Gesture | The gesture that will control the camera movement   | 

## Versioning
Using [SemVer](http://semver.org/) for versioning. For the versions available, see the [releases](https://github.com/Federico-Ciuffardi/IOSU/releases) 

## Authors
* Federico Ciuffardi

Feel free to append yourself here if you've made contributions.

## Note
Thank you for checking out this repository, you can send all your questions and feedback to Federico.Ciuffardi@outlook.com.

If you are up to contribute on some way please contact me :)
