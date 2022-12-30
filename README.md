# nows_app

#### Video Demo:  [https://youtu.be/P8iCu2nqF2k](https://youtu.be/P8iCu2nqF2k)
#### Description:

NOWS is an Android application that allows users to view and publish location based events.

## Basic Application Description

The aim of the NOWS application is to host and display a realtime database of postcards or "Nowcards", published by the users of the application.
These Nowcards appear on the interactive map of the application as a set of clickable location markers.

Each Nowcard has a timer, and a dedicated "attend" button, that keeps track of how many other users have decided to "attend" the event. 
After a certain period of time has passed, the Nowcard gets deleted from the database.
Each time the Nowcard "attend" button is clicked by viewers in the area, this timer is postponed.

## Interface
### Home Screen Display <img src="https://i.ibb.co/C2yt8w0/gif-screen.gif" width="280" align="right">
The home screen of the application consists of:
 - Interactive map displaying user's current location and Nowcard markers
 - NOW post button
 - Account avatar button / or "log In" button
 - Light/dark mode switch button
 - Location button
 - Attribution for map tile providers and\
 Flutter map package.
<br/><br/>

The map screen is deliberately monochrome\
and void of unnecessary detail.\
The aim of the map is only to display existing Nowcard markers\
and update user location marker.\
There is a limit set for maximum and minimum zoom levels\
since the application aims to display Nowcard markers\
within a walking distance from a user.

Light/Dark mode replaces the map tiles with different\
contrasting set, to allow for better viewing experience\
in direct sunlight or during nighttime.

Every subsecuent interface window requested by the user,\
keeps the state of the Map Screen, so as to avoid unnecessary\
data fetching and loading times.

The Border of each window has a transparency factor,\
for design aesthitic purposes.
<br/><br/>
<br/><br/>

### Login Window <img src="https://i.ibb.co/fQ6ndgs/Screenshot-20221204-142416.jpg" width="280" align="right">
If the Firebase Authentication fails during Application initialization,\
the user is presented with "Login" text button, that prompts the user\
to input his/her credentials.

<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>

### Registration Window <img src="https://i.ibb.co/VwgGfkJ/Screenshot-20221204-143804.jpg" width="280" align="right">
If the user presses the "Register here!" button,\
the application displays a registration form. 
<br/><br/>
The registration process requires the user to: 
 - upload an avatar image
 - Create a username
 - Input an existing email address 
 - Create a password

After the user submitted the registration form,\
the application remembers the new authentication state,\
and brings the newly authenticated user back to the home screen.

<br/><br/>
<br/><br/>

### Account Window <img src="https://i.ibb.co/sVRcQjY/Screenshot-20221204-142712.jpg" width="280" align="right">
If the user has already authenticated\
the text button changes state to a Circular Avatar button.
<br/><br/>
When pressed, the application shows the Account Display,\
which allows the user to:
 - Change username
 - Change user avatar
 - Logout
 - Delete user account

<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>

### Account Deletion Window <img src="https://i.ibb.co/zn6JhfL/Screenshot-20221204-143319.jpg" width="280" align="right">
Deletion of the account requires user's reauthentication\
as a security step. After the user has succesfully reauthenticated,\
the "Firebase Authentication Cervice" deletes the user's credentials.\
Additionally, the application requests the "Firebase Realtime Database"\
and the "Firebase Storage" to delete user's\
avatar image, and username data.

<br/><br/>
<br/><br/>

### NOWS post button<img src="https://i.ibb.co/H4JStt2/gif-screen-fab.gif" width="280" align="right">

When user presses the Nows post button, the application\
initializes a multi-stage process of creating a Nowcard.\
This posting process consists of:
 - Displaying a Camera Viewport
 - Requesting to input Nowcard title
 - Requesting to input Nowcard description text

Only then can the user upload the Nowcard form.\
After the process is complete, the new marker will\
appear on the map display. This marker will be\
visible to all other users within the local area.

<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
 

### Attribution button <img src="https://i.ibb.co/Wx6VhGh/Screenshot-20221204-143330.jpg" width="280" align="right">
The attribution button holds web-links\
to an array of different resources,\
used to develop the Map Screen of the application.

<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>

## Data and File Handling
### User Account Data<img src="https://i.ibb.co/7CmmH5v/Screenshot-2022-12-04-191909.jpg" align="right" width="280">
User account data is handled by the "Firebase Authentication Service".

Each of the text form fields are checked for correctness\
and duplication by the application client-side\
and the "Firebase Authentication Service".
<br/><br/>

The user's username is stored separately<img src="https://i.ibb.co/D999D6n/Screenshot-2022-12-04-192133.jpg" align="right" width="280">\
in "Firebase Realtime Database" and retreived\
when requested by the application.
<br/><br/>

The avatar image file is stored in "Firebase Storage" as JPEG\
and is given a unique filename that links that file to the user.
<br/><br/>

After the account creation process is complete the user\
is then automatically authenticated and is now\
able to upload a Nowcard to the map.\
To view the map and existing Nowcards the user\
of the appllication does not need to sign in or create an account.
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>

### Nowcard Data<img src="https://i.ibb.co/qBrsfjb/Screenshot-2022-12-04-192408.jpg" align="right" width="280">
Each of the "Nowscards" contains a simple set of data:
 - User's unique autogenerated ID
 - Latitude and longitude of user at the time of posting
 - URL of the image, taken by the user using device's camera
 - A String containing the title of the Nowcard\
 no longer than 25 characters<img src="https://i.ibb.co/dMV0hTy/Screenshot-2022-12-04-192226.jpg" align="right" width="280">
 - A String containing the description of the event on the Nowcard
 - Timestamp of when the Nowcard was published

The data is then stored in Firebase Realtime Database"\
as a set of key-value pairs.
<br/><br/>

The Nowpost image file is stored in "Firebase Storage" as JPEG\
and is the title of the Nowpost is assigned as the filename.\
Additional metadata links that file to\
the user who has posted the Nowcard.
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>

## Design Decisions
### Map Marker Animation<img src="https://i.ibb.co/9TftkYH/gif-anim.gif" align="right" width="280"><img src="https://i.ibb.co/0rDvnXK/empty.png" align="right" width="40" height="800">
The process of displaying the Nowcard markers involves\
creating a dimanic List(array) of custom objects containing\
Latiture and Longitude data of each marker.
<br/><br/>

When the location data is fetched from the database each\
marker is assigned an imbedded "pop-up" animation with\
specific duration and randomised delay. The resulting\
staggered appearance effect is, therefore, randomised\
every time the user pans the map view.
<br/><br/>

~~~dart
// Define a bool variable
bool _drawMarker = drawMarker();
~~~
~~~dart
// A function which returns "true" after a random delay
Future<bool> drawMarker() async {
  await Future.delayed(
    Duration(milliseconds: Random().nextInt(600)));
  return true;
}
~~~
~~~dart
...
// Every time a marker is displayed on the map screen
// the FutureBuilder only "builds" the marker after
// the randomised delay function is completed.
FutureBuilder(
    ...
    future: _drawMarker,
    builder: ((context, snapshot) {
      return AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: snapshot.data! ? 2.0 : 0.0,
        child: ... // Interactive Marker Icon here
~~~
<br/><br/>

### Transition Animations<img src="https://i.ibb.co/HxFCT26/transition-gif.gif" align="right" width="280"><img src="https://i.ibb.co/0rDvnXK/empty.png" align="right" width="40" height="1100">
Almost every interaction with the application's\
elemements has a combination of 2 transition animations.
 - Hero animation
 - Fade animation

Hero animation is an integrated feature of the\
Flutter Framework, allowing to give both the parent\
and the child with their dedicated HeroTags. If these tags\
match, then during a transition from one window to another\
the framework builds a smooth animation blending the child\
and the parent elements together.
<br/><br/>
~~~dart
// A HeroTag assigned to the Avatar button
// which transitions to the Account Window
Hero(
  tag: 'avatarTag',
  child: // Account Window Navigator
~~~
~~~dart
// Inside the account window the avatar image is
// wrapped with the Hero widget and given the same tag
Hero(
  tag: 'avatarTag',
  child: Container(
    ...
    child: CircleAvatar(
      backgroundImage: // Fetched Avatar Image
...
~~~
<br/><br/>
The second animation is also a feature of the Flutter Framework\
called Fade Transition. When the user interacts with\
the element, the Fade Transition creates a List of "snippets"\
of the Window that is requested. Each "snippet" has a gradually\
increasing opacity value from 0% to 100%.
<br/><br/>
~~~dart
Navigator.push(context, PageRouteBuilder(
  barrierColor: Colors.black.withOpacity(0.4),
  opaque: false,
  pageBuilder: (context, anim, secondaryAnimation) {
    return FadeTransition(
      opacity: anim,
      child: // Account Window
...
~~~
<br/><br/>
The result of combining these two animations\
can be seen on the GIF attached.
<br/><br/>
<br/><br/>
### Client-side Database Requests<img src="https://i.ibb.co/W5BqgC2/Screenshot-2022-12-06-012902.jpg" align="right" width="280">
Because each NowCard holds the data of both the post image\
and the avatar image of the user who published the post,\
and because the application might load hundreds of map markers\
when the user is viewing the map screen, the application requests\
the data only when the specific marker is clicked.
<br/><br/>
For the application to be able to draw markers on the map without\
fetching the Nowcard data, the location of each marker is stored in\
a separate bucket of the database. This allows to decrease the "depth"\
of each database request.
<br/><br/>
## Setup and Security
If you want to test or co-develop you would have to go through a short setup process. Due to the nature of this application the setup requires you to input your own API keys and Access Tokens to allow for full functionality of Firebase Authentication and Data storage services and Mapbox map tile services.
<br/><br/>
Please create your own .env file and input your API keys.\
The .gitignore already has this .env file as "ignored".
See [.env.example](lib/env/.env.example) for example:
~~~env
# firebase Options api keys located in autogenerated firebase_options.dart
WEB_KEY=# input your key here
ANDROID_KEY=# input your key here
IOS_KEY=# input your key here
MACOS_KEY=# input your key here

# Mapbox maptiles access token located in flutter_map_screen.dart
MAP_TOKEN=# input your access token here
~~~
<br/><br/>
After you have added your API keys and access tokens, please run the command below to generate your "env.g.dart" file
which will contain your newly encrypted environment variables:
~~~
$ flutter pub run build_runner build
~~~
The .gitignore already has this generated .env.g.dart file as "ignored".
<br/><br/>
for more information on using .env files to store your sensitive data, please see:
 - [flutter api keys dart define env files](https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/)

[Thank you Andrea!](https://codewithandrea.com/)
<br/><br/>

## Moving Forward
There are still plenty of features to be implemented and potential bugs to be fixed for the application to be worthy of publication.\
Here is a short list of features and issues that have to be addressed in the near future:
- [ ] Database-side automated timer to delete NowCards.
- [ ] Interactive animations to signify popularity of each Nowcard
- [ ] Cluster map markers together when they overlap. If the clustered marker is clicked,\
the user sees a LIST of clickable Nowcards with basic information about each.
- [ ] Add an attendance "counter" key-value pair for each NowCard\
(not implemented as of yet due to lack of users)
- [ ] Automated testing to simulate hundreds or thousands of users creating NowCards simultaneously.
- [ ] Database load testing.
- [ ] General application bug testing.
- [ ] MapTile fetching optimisation. Minimize use of MapBox tiles by saving previously loaded tiles\
on the device, or database.
<br/><br/>

## Flutter Package Dependencies
- [camera](https://pub.dev/packages/camera)
- [path_provider1](https://pub.dev/packages/path_provider)
- [path](https://pub.dev/packages/path)
- [flutter_spinkit](https://pub.dev/packages/flutter_spinkit)
- [firebase_core](https://pub.dev/packages/firebase_core)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [firebase_database](https://pub.dev/packages/firebase_database)
- [firebase_storage](https://pub.dev/packages/firebase_storage)
- [email_validator](https://pub.dev/packages/email_validator)
- [random_string_generator](https://pub.dev/packages/random_string_generator)
- [image_picker](https://pub.dev/packages/image_picker)
- [flutter_map](https://pub.dev/packages/flutter_map)
- [flutter_map_location_marker](https://pub.dev/packages/flutter_map_location_marker)
- [latlong2](https://pub.dev/packages/latlong2/install)
- [geolocator](https://pub.dev/packages/geolocator)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [envied](https://pub.dev/packages/envied/install)
- [build_runner](https://pub.dev/packages/build_runner)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)

## Attributions
### Thanks to:
[© Microsoft Visual Studio Code](https://code.visualstudio.com/)\
[© Flutter Application Framework](https://flutter.dev/)\
[© Google Firebase Development Platform](https://firebase.google.com/)\
[© Mapbox](https://www.mapbox.com/)\
[© Flutter_maps](https://github.com/fleaflet/flutter_map)

### List of helpful learning material:
 - [Flutter camera plugin: A deep dive with examples](https://blog.logrocket.com/flutter-camera-plugin-deep-dive-with-examples/)
 - [Flutter Map documentation](https://docs.fleaflet.dev/)
 - [Complete Flutter 3 framework course](https://www.udemy.com/share/106vTo3@ooQtlyugT4V_QZAFBMWsFLbGuU7t5egoRCPRvOUMSJX3Qz1M0pRyiHFh44FPMdLZvg==/)
 - [Dart language course](https://www.udemy.com/share/1058nE3@GG9xrToi7poY7J1qhkQdXx3eQiP9I_4Dbd5mKS55N5w1cH_BdF7JVeEwYM1JbmfPlQ==/)
 - [Firebase development documentation](https://firebase.google.com/docs)
 - ENDLESS Stackoverflow browsing (!)
