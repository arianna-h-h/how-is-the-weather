# README

### Specs
* Accept an address as input
* Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
* Display the requested forecast details to the user
* Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.

### Process
1. I first researched weather APIs that could geocode from an address as well as didn't have an API key. I couldn't find a weather API that could take an address so I used a geocoding API prior before the call to the weather API. I used OpenMeteo so that I could have an API without signup.
2. I drew a diagram of the logical outline of the application.
3. I used `rails new` to bootstrap the application.
4. I began coding. I started with the routes, controller, and basic erb forms. From there, I created the `ForecastService` and APIs. Finally, I implemented the caching mechanism.
    * I chose to use basic rails Net::HTTP and rails caching. I could have installed a gem like HttpParty or redis to help manage the http requests and caching. However, built in rails tools work for this small of an application.
    * I used services to abstract the logic from the controller. The functionality of the services did not quite fit into the traditional rails folders.
5. After manually testing in the browser, I wrote tests. I could have written the tests first using TDD methodology. However, this application was simple enough that writing rspec tests post manual testing is sufficient.

### How to use
* Rename `.env.example` to `.env`. Add `MAPBOX_TOKEN` by creating an account and access token at https://account.mapbox.com/auth/signup/ or contact me for an API key.
* Run `rails s` in the command line.
* Navigate to [localhost:3000/forecasts](http://localhost:3000/forecasts) in the browser.
* Enter address or landmark and click "Get Forecast" button.
* You can refresh the page or go back to the index and run "Get Forecast" again to pull the data from the cache.
* Run `rspec` in the command line to run tests.

### Future applications
* If given more time, I could add more styling in the `.erb` files or use a modern front end language like React.js.
* I could add more fields from the Mapbox API like hourly forecast or UV index.
* I don't quite like the way it is caching. I'd like to find a way to use the cache without passing back a flag indicating the result is coming from the cache. However, due to limited time, I was not able to implement that.
