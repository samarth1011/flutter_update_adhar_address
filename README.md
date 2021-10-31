<div id="top"></div>



<!-- PROJECT LOGO -->
<br />
<div align="center">
  

  <h3 align="center">Aadhaar address update Problem statement 1</h3>

  <p align="center">
    Team Name: Team Aadhaar
    Reference code: FwAjNj8f0p

  
   
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">Work Completed</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
   
   
  </ol>
</details>




<!-- ABOUT THE PROJECT -->
## Work Completed



Link to video : https://drive.google.com/file/d/1vti-XlqPUIJgOw9onqIINMqVpncvXzRj/view

### Security

- The 2 way authentication for aadhaar as well as google is used for both Landlord and user.
- Password for eKYC is first encoded and then stored to cloud databse i:e firestore by Google.
- when adderess is (address sent by landlord) is retrived by user then that address encoded string and password that as stored in databse is deleted.
- No eKYC file is parmanently stored on device its deleted once address is retrived from file.


### Why its not required for user to access zip file with passcode
- its not required for user to access zip file with passcode beacuse we are accesssing file content form app/backend, first we are unzipping the file with passcode given by landlord and then retriving address form it. The xml file address is then properly formatted according to normal address and shown to user.
After this process the zip file is deleted from  users phone.


### Work Yet to be done

Show Admin logs on UI currently it is seen on firebase.













<p align="right">(<a href="#top">back to top</a>)</p>



### Built With



* Flutter
* Google geocoding package
* Aadhaar - Offline eKYC API


<p align="right">(<a href="#top">back to top</a>)</p>









[frontPage-screenshot]: https://drive.google.com/file/d/1vti-XlqPUIJgOw9onqIINMqVpncvXzRj/view










