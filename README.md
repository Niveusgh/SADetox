<!-- SADdetox -->

# SADdetox App
![Swift](https://img.shields.io/badge/swift-5.5-brightgreen.svg) ![Xcode 14.2+](https://img.shields.io/badge/xcode-13.2%2B-blue.svg) ![iOS 15.0+](https://img.shields.io/badge/iOS-15.0%2B-blue.svg) ![watchOS 8.0+](https://img.shields.io/badge/watchOS-8.0%2B-blue.svg) ![CareKit 2.1+](https://img.shields.io/badge/CareKit-2.1%2B-red.svg) ![ci](https://github.com/netreconlab/CareKitSample-ParseCareKit/workflows/ci/badge.svg?branch=main)

## Description

SADdetox App is a comprehensive solution for individuals interested in adopting a vegan, whole-food plant-based (WFPB) lifestyle. The app provides information about the benefits of a vegan, WFPB diet, tips for getting started, meal plans, recipes, and exercise tracking. Users can also log their dietary habits, water intake, and overall well-being through check-in surveys. The app features an "Insights" tab that displays graphs and statistics related to users' dietary habits and exercise.


## Designed for Users
SADdetox is an app specifically designed for individuals who are currently following a SAD diet and are interested in transitioning to a healthier, whole-food plant-based (WFPB) lifestyle. The app is suitable for users of all ages and backgrounds who want to improve their overall health and well-being by adopting a diet that is rich in whole, plant-based foods and low in processed and animal-based products.

The app is ideal for:
- Individuals who are concerned about the health risks associated with a standard American diet, such as obesity, heart disease, diabetes, and certain cancers.
- People who want to make more ethical and environmentally friendly food choices by reducing their consumption of animal products.
- Users who are looking for guidance, support, and resources to help them successfully transition to a WFPB diet.
- Those who want to discover delicious and nutritious plant-based recipes that align with their health goals.
- Individuals who are interested in tracking their dietary habits, physical activity, and health progress as they embark on their WFPB journey.


**Use at your own risk. There is no promise that this is HIPAA compliant and we are not responsible for any mishandling of your data**


## Application Demo
#### Startup & Onboarding Screens
<img width="175" alt="1" src="https://user-images.githubusercontent.com/112659162/207221043-51c4ded9-b01c-44f6-bd1e-8bedf654c209.png"><img width="175" alt="2" src="https://user-images.githubusercontent.com/112659162/207221216-fa347222-1679-4f11-9292-b28835ac7cc8.png"><img width="175" alt="3" src="https://user-images.githubusercontent.com/112659162/207221230-154ba3ad-53cd-4ed8-9425-087aac202af2.png">

#### Homescreen
<img width="175" alt="4" src="https://user-images.githubusercontent.com/112659162/207221259-4b5de7e9-0cee-43cb-bb06-92be3d83ed5c.png"><img width="175" alt="5" src="https://user-images.githubusercontent.com/112659162/207221266-3ee1b0b9-ecf3-42f6-a8f0-23aad41db7da.png"><img width="175" alt="6" src="https://user-images.githubusercontent.com/112659162/207221272-d6cbed7f-642a-400f-b509-f8e4f89aa335.png"><img width="175" alt="7" src="https://user-images.githubusercontent.com/112659162/207221278-c500a568-5ae2-4e99-8b88-44ab9d5ffc40.png">

#### Workout Setup Survey
<img width="175" alt="8" src="https://user-images.githubusercontent.com/112659162/207221306-65694fba-c822-4ce0-87cc-be0416cdb082.png"><img width="175" alt="9" src="https://user-images.githubusercontent.com/112659162/207221316-f52ad933-23fa-46ae-9d0f-6bf504f0a4d4.png">

#### Check In Survey
<img width="175" alt="10" src="https://user-images.githubusercontent.com/112659162/207221369-e772b37b-b0f1-4564-87c6-ae91ce8965a5.png">

#### Insights View
<img width="175" alt="11" src="https://user-images.githubusercontent.com/112659162/207221372-64ec0742-cb44-4bc8-b339-90451d76ef91.png">

#### Profile & Contact View
<img width="175" alt="12" src="https://user-images.githubusercontent.com/112659162/207221409-a96102cf-318e-4059-a2b2-1aad371d4d1f.png"><img width="175" alt="13" src="https://user-images.githubusercontent.com/112659162/207221416-33de707f-6260-42a8-99c5-bc0ffc2ec366.png">

#### Add Task View
<img width="175" alt="14" src="https://user-images.githubusercontent.com/112659162/207221431-0c9002ca-b67b-465b-9f93-524e8288b6a0.png">


### Developed by:
- Thea Francis(https://github.com/Niveusgh) - University of Kentucky, Computer Science

There is no promise that this is HIPAA compliant and we are not responsible for any mishandling of your data

### Contributions/Features:
- CustomFeaturedContentView that provides information about the benefits of a vegan, WFPB diet and tips for getting started.
- A check-in Research Kit survey that asks users about their dietary habits, energy levels, and overall well-being.
- OCKTask type of food displayed by OCKChecklistTaskViewController to remind users to have any necessary food categories.
- OCKTask diet displayed by OCKButtonLogTaskViewController to encourage users to stay hydrated throughout the day.
- OCKTask meal plan displayed by OCKGridTaskViewController to help users plan and track their meals according to WFPB guidelines.
- - Personalized Detox Plan: SADdetox creates a customized detox plan for each user based on their dietary preferences, health goals, and current eating habits. The plan includes meal recommendations, portion sizes, and a schedule to help users gradually reduce their intake of processed and unhealthy foods.
- LinkViews for easy access to vegan recipes, cooking tutorials, and meal plans.
- Progress Tracking: Users can track their progress throughout the detox process by logging their meals, physical activity, and health metrics such as weight, energy levels, and mood. The app provides visualizations and insights to help users understand the positive impact of their dietary changes.
- Improved styling and custom logo.
SADdetox is a holistic solution that empowers users to take control of their health and break free from the SAD diet. 

### Wishlist features:
- Integration of a grocery list feature that automatically generates shopping lists based on users' meal plans.
- A community forum where users can share recipes, tips, and experiences related to the vegan, WFPB lifestyle.
- Integration with health tracking devices (e.g., fitness trackers, smartwatches) to automatically log exercise and other health data.

### Challenges faced while developing:
Learning Swift and the MVVM architectural pattern was a significant challenge, as I had no prior experience with either. Understanding how to use CareKit and ResearchKit frameworks to create various health-related tasks and surveys also required a steep learning curve. Additionally, tailoring the app to focus on the vegan, WFPB diet and ensuring that the provided meal plans and recipes adhere to the principles of this diet was a complex task.

To overcome these challenges, I spent time studying Swift programming, the MVVM pattern, and the documentation for CareKit and ResearchKit. I also conducted research on the vegan, WFPB diet to ensure that the app's content is accurate and beneficial to users. Through trial and error, I was able to implement the desired features and create an app that provides a comprehensive solution for individuals interested in adopting a vegan, WFPB lifestyle.

### Demo Video
To learn more about this application, watch the video below:

<ahref="https://youtube.com/playlist?list=PLwt79iF545WRLaxgOCsLaAihGgVnorjak" target="_blank"><img src="http://img.youtube.com/vi/NEW_VIDEO_ID/0.jpg" 
alt="SADdetox Demo Video" width="240" height="180" border="10" /></a>

## CareKitSample+ParseCareKit

An example application of [CareKit](https://github.com/carekit-apple/CareKit)'s OCKSample synchronizing CareKit data to the Cloud via [ParseCareKit](https://github.com/netreconlab/ParseCareKit).

<img src="https://user-images.githubusercontent.com/8621344/101721031-06869500-3a75-11eb-9631-88927e9c8f00.png" width="300"> <img src="https://user-images.githubusercontent.com/8621344/101721111-33d34300-3a75-11eb-885e-4a6fc96dbd35.png" width="300"> <img src="https://user-images.githubusercontent.com/8621344/101721146-48afd680-3a75-11eb-955a-7848146a9d6f.png" width="300"><img src="https://user-images.githubusercontent.com/8621344/101721182-5cf3d380-3a75-11eb-99c9-bde40477acf3.png" width="300">


- [x] OCKTask <-> Task
- [x] OCKHealthKitTask <-> HealthKitTask 
- [x] OCKOutcome <-> Outcome
- [x] OCKRevisionRecord.KnowledgeVector <-> Clock
- [x] OCKPatient <-> Patient
- [x] OCKCarePlan <-> CarePlan
- [x] OCKContact <-> Contact

**Similar to the [What's New in CareKit](https://developer.apple.com/videos/play/wwdc2020/10151/) WWDC20 video, this app syncs between the AppleWatch (setting the flag `isSyncingWithCloud` in `Constants.swift` to  `isSyncingWithCloud = false`. Different from the video, setting `isSyncingWithCloud = true` (default behavior) in the aforementioned files syncs iOS and watchOS to a Parse Server.**

ParseCareKit synchronizes the following entities to Parse tables/classes using [Parse-Swift](https://github.com/netreconlab/Parse-Swift):

## Setup Your Parse Server

### Heroku
The easiest way to setup your server is using the [one-button-click](https://github.com/netreconlab/parse-hipaa#heroku) deployment method for [parse-hipaa](https://github.com/netreconlab/parse-hipaa).

### Docker
You can setup your [parse-hipaa](https://github.com/netreconlab/parse-hipaa) using Docker. Simply type the following to get parse-hipaa running with postgres locally:

1. Fork [parse-hipaa](https://github.com/netreconlab/parse-hipaa)
2. `cd parse-hipaa`
3.  `docker-compose up` - this will take a couple of minutes to setup as it needs to initialize postgres, but as soon as you see `parse-server running on port 1337.`, it's ready to go. See [here](https://github.com/netreconlab/parse-hipaa#getting-started) for details
4. If you would like to use mongo instead of postgres, in step 3, type `docker-compose -f docker-compose.mongo.yml up` instead of `docker-compose up`

## Fork this repo to get the modified OCKSample app

1. Fork [CareKitSample-ParseCareKit](https://github.com/netreconlab/ParseCareKit)
2. Open `OCKSample.xcodeproj` in Xcode
3. You may need to configure your "Team" and "Bundle Identifier" in "Signing and Capabilities"
4. Run the app and data will synchronize with parse-hipaa via http://localhost:1337/parse automatically
5. You can edit Parse server setup in the ParseCareKit.plist file under "Supporting Files" in the Xcode browser

## View your data in Parse Dashboard

### Heroku
The easiest way to setup your dashboard is using the [one-button-click](https://github.com/netreconlab/parse-hipaa-dashboard#heroku) deployment method for [parse-hipaa-dashboard](https://github.com/netreconlab/parse-hipaa-dashboard).

### Docker
Parse Dashboard is the easiest way to view your data in the Cloud (or local machine in this example) and comes with [parse-hipaa](https://github.com/netreconlab/parse-hipaa). To access:
1. Open your browser and go to http://localhost:4040/dashboard
2. Username: `parse`
3. Password: `1234`
4. Be sure to refresh your browser to see new changes synched from your CareKitSample app

Note that CareKit data is extremely sensitive and you are responsible for ensuring your parse-server meets HIPAA compliance.

## Transitioning the sample app to a production app
If you plan on using this app as a starting point for your produciton app. Once you have your parse-hipaa server in the Cloud behind ssl, you should open `ParseCareKit.plist` in Xcode and change the value for `Server` to point to your server(s) in the Cloud. You should also open `Info.plist` in Xcode and remove `App Transport Security Settings` and any key/value pairs under it as this was only in place to allow you to test the sample app to connect to a server setup on your local machine. iOS apps do not allow non-ssl connections in production, and even if you find a way to connect to non-ssl servers, it would not be HIPAA compliant.

### Extra scripts for optimized Cloud queries
You should run the extra scripts outlined on parse-hipaa [here](https://github.com/netreconlab/parse-hipaa#running-in-production-for-parsecarekit).
