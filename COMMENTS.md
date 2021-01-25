# Comments

## Main architecture decisions 

For this project, I decide to segment the app on four main layers.

- **View**: This is the layer created for the view and UI matters. On this group we can find the Storyboards, View Controller and one helper created to handle som alerts.
  - I use two view controllers one for the list of TVShows and other for the Detail, the first one us used for both the full list and the list of favourites, because almost all the code works equal for both features.
  - One important matter to point at, is the use of protocols to define the interface to communicate with the services, in order to decouple the layers, and avoid hard references within the components.
- **Resolver**: This component is used to access the Helpers and services on the view objects. The main porpouse of his inclusion is to have a way to orchestrate the dependency injection of services and helpers to the other components.
- **Helpers**: There are two helpers, made for get the data for the app.
  - **RemoteDataHelper**: that works as a HTTPClient.
  - **LocalDataHelper**: used to acces to CoreDataFramework and handle all persisten data for the favourite shows.
  - **BrowserHelper**: only handle the simple task to open the IMDB url on the device's browser.
- **Services**: Provide the data to the view controller and process it from the diferent data sources.

I'm sorry if I do not use a standar design pattern for this project. I realize that my time available to do the test was short and maybe, it was like trying to kill flies with a cannon. Finnaly, I went for the basics to solve this challenge.

## Dependencies

At the beginning of the project, I had the intention to use Alamofire, that's why I do install the cocoapod tool, but when I was implementing the HTTPClient, I realize that doesn't was necessary.

So, for this project, doesn't was necessary to include thirt party dependencies.

## Mention anything that was asked but not delivered

I haven't many things to add, maybe two things:
- I add a process to optimize the performance of the list, by processing the resize of the TVShow's thumbnail on an async thread to avoid the resizing by the UIImageView that usualy do this process on the main thread, causing lag while scrolling on the list.
- And finally, I use some unit test to prove if my helpers work fine. When I had time, usually use unit testing to improve my quality.

And one final comment, I had the intention to add comments to my components and his methods, but at the end, I ran out of time for this weekend, so only a few files has usefull comments.



