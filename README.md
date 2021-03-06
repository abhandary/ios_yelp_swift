# Project 2 - *Yelper*

**Yelper** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
- [x] Table rows should be dynamic height according to the content height.
- [x] Custom cells should have the proper Auto Layout constraints.
- [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
- [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
- [x] The filters table should be organized into sections as in the mock.
- [x] You can use the default UISwitch for on/off states.
- [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
- [x] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [x] Search results page
- [x] Infinite scroll for restaurant results.
- [x] Implement map view of restaurant results.
- [x] Filter page
- [x] Implement a custom switch instead of the default UISwitch.
- [x] Distance filter should expand as in the real Yelp app
- [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [x] Implement the restaurant detail page.

The following **additional** features are implemented:

- [x] Details page shows a small map view to show the restaurant's location
- [x] Use of blur effect for the background image shown in the details page 
- [x] Ability to place a call to the restraunt from the details page 
- [x] Use of animation in toggling the custom UISwitch
- [x] Use of transition+animation to transition from the list view to the map view and back for the search results


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Ways to improve the functionality of the app to be as practical and useful as possible for day to day use
2. Other useful features that can be included in the details page

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/abhandary/ios_yelp_swift/blob/master/yelper_demo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


GIF created with [LiceCap](http://www.cockos.com/licecap/).



## License

Copyright 2017 Akshay Bhandary

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
