BlogReaderv2
============

This is an improved BlogReader application that I have created for the programming mobile
devices course at my university. :stuck_out_tongue_winking_eye:

I have introduced some new iOS elements to this improved BlogReader such as:
- UITabViewController 
  - Instead of using a simple UITableViewController, I have opted for a UITabViewController
  that directs navigation between two tabs; the posts that are created by the professor of
  the class, and the posts generated by students.
- Asynchronous Network Requests
- Caching of information on the device to optimize the user experience
- Use of BlogSpot RESTful API to retrieve professor posts.


Dependencies
============

There are two external dependencies that I have used

- [Objective-C-HTML-Parser 0.0.1][1] :+1:
  - The parser was necessary because the professor's blog links in the student's posts, and using
    the RESTful API provided no help in retrieving this information, as the Blogspot API only returned
    the posts that were created and posted by the professor
- [SAMCache][2] :+1:
  - Once the user's thumbnail and posts were downloaded, a caching mechanism was necessary in order 
    to avoid unnecessary network requests to get data that has been retrieved. The small library
    allows for the store of objects or values using a `key` -> `value` storage mechanism.
  
These dependencies were installed using `CocoaPods`. 
The Podfile is the following:

```
pod 'Objective-C-HMTL-Parser'
pod 'SAMCache'
```

and the installation is done with the following command:

```sh
pod
```


[1]:https://github.com/zootreeves/Objective-C-HMTL-Parser
[2]:https://github.com/soffes/SAMCache
