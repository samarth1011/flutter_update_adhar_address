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



- Link to video : https://drive.google.com/file/d/1vti-XlqPUIJgOw9onqIINMqVpncvXzRj/view
- Link to apk: https://drive.google.com/file/d/1Zk0jCSqTBpom6NDc6EggVo6MNzecUS0F/view?usp=sharing

Note - plese let me know by which mail the app is going to be tested so that I can add it in test mail list. App will not sign in / register if that mail is not added to test mails list on firestore. As we are sending mail through gmail so app need to be accepted by google then only anyone can signIn even if that mail is not regitred on test mail list.

### Main Workflow
 - After Authentication when landlord clicks "send Address" the ekyc encoded file string is encrypted and added to address requester database with password given by landlord (In encrypted form).
 - The eKYC file is not downloaded or stored in landlord device.
 - After this in address requester app it would be shown that address is received, edit address button would be shown.
 - when address requester clicks on edit and submit address button the encoded and encrypted eKYC file is decoded and downloaded in address requetser device its accessd with passcode given by landlord through code and then the address is retrievd from file and formatted and then immediately eKKYC file is deleted from his device and then he can edit address
 - then edited address is matched with google geocoding package(free/open source) if both address are of same location then only he can submit address.
 - edited address is stored in database(on google firestore - highly secure).

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










