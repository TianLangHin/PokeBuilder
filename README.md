# PokéBuilder

This source code is accessible at [this GitHub repository link](https://github.com/TianLangHin/PokeBuilder).

**Team Members:**
* Tian Lang Hin (24766127), GitHub username `TianLangHin`
* Duong Anh Tran (24775456), GitHub username `DuongAnhTran`
* Isabella Watt (24843322), GitHub username `Payayaing`

## App Objective and Minimum Viable Product

PokéBuilder is a Pokémon team builder app,
allowing users to design and plan teams for use in competitive Pokémon battling.
This serves to be a kind of game utility app,
which assists players in planning and organising their gameplay strategies.
The goal of this app is to make up for the lack of convenient mobile app tooling
around Pokémon team building, since most solutions have been web applications instead.

The presented version of this application illustrates the minimum viable product,
with the following functionalities:
* Creating Pokémon Teams
* Adding Pokémon to Teams
* Viewing Basic Pokémon Information
* Customising Pokémon Builds
* Analysing Pokémon Team Strengths and Weaknesses

## Data Modelling

In our codebase, we utilised many custom structures to model and represent domain-specific data and logic
within our application, which are listed in the `Model` folder.

The models we utilise can be organised into two broad categories:
**API-facing models** which are designed to specifically parse and capture data being
retrieved from the third-party APIs we utilise,
and **app-specific models** which closely model the complex data that our app explicitly deals with.

Examples of **API-facing models** are the `PokemonData` and `TypeInfo` structures,
which directly capture the JSON data as returned by PokéAPI,
serving as a foundation to facilitate more complex and custom operations in the app.
Examples of **app-specific models** are the `Pokemon` and `StatSpread` structures,
which represent a Pokémon (a member in a user's Pokémon team) and Effort Value (EV) allocations in the app.
The customisation of these values constitute part of the main functionality of the app.

## Immutable Data and Idempotent Methods

To ensure that the application is able to run smoothly in a robust manner,
the type system has been utilised in various ways to minimise the number of code paths
that can lead to invalid app states.

For example, reading the response of every call to PokéAPI is always done via a custom `Decodable` structure
with the keys matching what the API is documented to output. This approach is chosen rather than
decoding JSON into a dictionary, so that conversion to each of the appropriate data types can be checked at once
without having to force unwraps or downcasts.

Additionally, custom `enum`s are frequently used throughout the codebase when dealing with values
that conceptually represent one of a finite set of known states, and that these states are unchanging
with respect to the app logic. One example of this is the `Stat` enum (in `StatSpread.swift`)
which represents each of the six possible Pokemon stats through the Swift type system,
rather than as an integer which would cause undefined behaviour for values below 0 and above 5.

## Functional Separation

Functional separation is utilised throughout the app firstly through the separation
of the app into the `Model`, `View` and `ViewModel` folders, forming the core of the MVVM design pattern.
This allows the user-facing interface to be developed independently of the backend model logic
such as parsing the JSON responses of PokéAPI.

Additionally, within these folders, different parts of the app logic are separated into different files.
For example, each page of the app that the user will navigate through is separated into its own file in the `View` folder,
and sub-views used in that page specifically is included in the same file (for ease of following logically).

Another example is the separation of the `Pokemon.swift` and `PokemonData.swift` files in the `Model` folder,
despite being related in terms of the app logic.
This is due to `PokemonData` being a structure that is designed to interact directly with the third-part API,
while `Pokemon` represents the Pokémon customised by the user directly in the app instead
(thus having more than just the base features).

A third example is the `FuzzyFinderViewModel.swift` carrying all the functionalities of looking up a Pokémon,
without needing to have all Pokémon data being loaded (since it only deals with query strings and Pokémon names).
It also does not deal with the Pokémon data directly (such as the sprite or typings),
instead serving as an entry point for users to find the Pokemon they are looking for by name.

## Loose Coupling

Through the separation into different files and utilising the MVVM structure,
different components of the app can be changed in isolation of one another.
Specifically, if the UI needed to be redesigned (while still having the same fundamental functionality),
the `ViewModel` and `Model` sections will not need to be changed, but instead the corresponding file
within the `View` folder is the only one that needs a revision.

This property was utilised heavily during the iterative development process of the application.
Specifically, after the first iteration of the backend model logic was implemented,
some `View`s were created to operate on this logic for demonstrating the correctness of the models.
These views had very simple layouts, without any special animations or colour schemes.
However, changing these views did not require the model to be re-written in any way,
and as the application progressed through development it was changed in parallel to the model being improved.

## Extensibility

One way new content could be added to the app by changing data without changing code would be
updating the `names.txt` file to include more Pokémon names, provided that this information is also reflected in PokeAPI.
Although this only set to happen once every year, the ability to change just a single text file rather than
changing a hard-coded array in the data makes this app extensible and future-proof for newer generations of Pokémon to be released.
This fits well with the purpose of this app, which includes helping its users keep up with the ever-changing competitive scene of Pokemon.

Within the realm of changing code to add more functionality,
there is also room for certain domain-specific logic to be relaxed or expanded upon.
For example, the maximum effort value (EV) allocation is currently set to 510,
the maximum number of Pokémon in a team is set to 6, and the maximum number of moves on a Pokémon is set to 4.
However, in case these values change in a future generation of Pokémon, these values can be changed in one place
(in the class/struct definition) for the entire app to be function according to these new settings.

## Error Handling

Error handling is used throughout the app, since there are many cases where fallible is executed.
While this may not initially seem ideal, this is unavoidable when needing to call a third-party API at multiple points
throughout the app's runtime. These are done on the fly rather than in a bulk at once,
since that instead results in exorbitant loading times and unnecessary API calls.

The most commonly used error handling pattern in this app is the use of `try?`,
where a throwable method is called, but rather than propagating the error up endlessly,
it is instead caught as an `Optional`. This way, the errors can be handled immediately and programmatically
without having to have large deviations in code structure to handle it.
This is most commonly used in conjunction with `guard` and `guard let` together with either
an early `return` (since an error often indicates that at certain operation cannot proceed further),
or as a `continue` (since an API loading error in one single entry of a list should not crash the entire app and instead be smoothed over).

This also links closely to utilisation of the type system,
since all foreseeable errors are handled explicitly as `Optional` types,
and are always unwrapped safely without forced unwraps (except in cases where a URL is guaranteed to be well-formed from a string).
