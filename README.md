#  Employee Directory
A sample project to show how I structure an iOS 13 project w/ UI, networking, JSON parsing, testing, etc.

Wrote this originally as an assesment for a job interview.

## Running
In order to test the 3 different versions of the endpoint (valid + simulated errors), switch the Xcode scheme

## Focus Areas
- Architecture - Straightforward MVC architecture making use of Swift enums to capture application state in View Controllers. View Controllers are small and easy to understand, with most of the heavy lifting performed in Additional Model Controller classes or in Swift extensions to Framework classes.
- Testing - Robust tests for class for EmployeeAPIController using URLProtocol for mocking responses. URL related code in an extension so that it's easier to test.
- Inclusive - Leverage out-of-the-box Dark Mode support by using System Colors. Used Text Styles to support Dynamic type. Universal app so that it can be used on an iPhone or iPad. Performs well with Voiceover without modifications.

## Dependencies
Didn't see a need to include any here, was able to accomplish everything using what ships with the SDK.

## Tablet/Phone focus
This is a Universal app so it should run on iPhone and iPad. Since it's just a simple table view, it works well on both devices. I would imagine adding a detail view would be a nice opportunity to take advantage of UISplitViewController on the iPad. An employee directory would be useful on an iPad, imagine a receptionist or office security needing quick access to a directory on a large device they're holding. I left in the Xcode-provided SceneDelegate but did not make any modifications to it

## Time Spent
I did it over the course of the whole week, and it took about five hours.
