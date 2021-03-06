import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_gsg/Auth/helpers/auth_helper.dart';
import 'package:firebase_gsg/Auth/helpers/firestorage_helper.dart';
import 'package:firebase_gsg/Auth/helpers/firestore_helper.dart';
import 'package:firebase_gsg/Auth/models/country_model.dart';
import 'package:firebase_gsg/Auth/models/register_request.dart';
import 'package:firebase_gsg/Auth/models/user_model.dart';
import 'package:firebase_gsg/Auth/ui/auth_main_page.dart';
import 'package:firebase_gsg/chats/home_page.dart';
import 'package:firebase_gsg/services/routes_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    getCountriesFromFirestore();
  }
  TabController tabController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cituController = TextEditingController();

  UserModel user;
  getUserFromFirestore() async {
    String userId = AuthHelper.authHelper.getUserId();
    user = await FirestoreHelper.firestoreHelper.getUserFromFirestore(userId);
    notifyListeners();
  }

  resetControllers() {
    emailController.clear();
    passwordController.clear();
  }

  List<CountryModel> countries;
  List<dynamic> cities = [];
  CountryModel selectedCountry;
  String selectedCity;
  selectCountry(CountryModel countryModel) {
    this.selectedCountry = countryModel;
    this.cities = countryModel.cities;
    selectCity(cities.first.toString());
    notifyListeners();
  }

  selectCity(dynamic city) {
    this.selectedCity = city;
    notifyListeners();
  }

  getCountriesFromFirestore() async {
    List<CountryModel> countries =
        await FirestoreHelper.firestoreHelper.getAllCountries();
    this.countries = countries;
    selectCountry(countries.first);
    notifyListeners();
  }

///////////////////////////////////////////////////
  ///upload Image
  File file;
  selectFile() async {
    XFile imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    this.file = File(imageFile.path);
    notifyListeners();
  }

///////////////////////////////////////////////////
  register() async {
    try {
      UserCredential userCredential = await AuthHelper.authHelper
          .signup(emailController.text, passwordController.text);
      String imageUrl =
          await FirebaseStorageHelper.firebaseStorageHelper.uploadImage(file);
      RegisterRequest registerRequest = RegisterRequest(
          imageUrl: imageUrl,
          id: userCredential.user.uid,
          city: selectedCity,
          country: selectedCountry.name,
          email: emailController.text,
          fName: firstNameController.text,
          lName: lastNameController.text,
          password: passwordController.text);
      await FirestoreHelper.firestoreHelper.addUserToFirestore(registerRequest);
      await AuthHelper.authHelper.verifyEmail();
      await AuthHelper.authHelper.logout();
      tabController.animateTo(1);
    } on Exception catch (e) {
      // TODO
    }
// navigate to login

    resetControllers();
  }

  logout() async {
    await AuthHelper.authHelper.logout();
    RouteHelper.routeHelper.goToPageWithReplacement(AuthMainPage.routeName);
  }

  login() async {
    UserCredential userCredinial = await AuthHelper.authHelper
        .signin(emailController.text, passwordController.text);
    FirestoreHelper.firestoreHelper
        .getUserFromFirestore(userCredinial.user.uid);
    // bool isVerifiedEmail = AuthHelper.authHelper.checkEmailVerification();
    // if (isVerifiedEmail) {
    RouteHelper.routeHelper.goToPageWithReplacement(HomePage.routeName);
    // } else {
    //   CustomDialoug.customDialoug.showCustomDialoug(
    //       'You have to verify your email, press ok to send another email',
    //       sendVericiafion);
    // }
    resetControllers();
  }

  sendVericiafion() {
    AuthHelper.authHelper.verifyEmail();
    AuthHelper.authHelper.logout();
  }

  resetPassword() async {
    AuthHelper.authHelper.resetPassword(emailController.text);
    resetControllers();
  }

  checkLogin() {
    bool isLoggedIn = AuthHelper.authHelper.checkUserLoging();
    print(FirebaseAuth.instance.currentUser);
    if (isLoggedIn) {
      RouteHelper.routeHelper.goToPageWithReplacement(HomePage.routeName);
    } else {
      RouteHelper.routeHelper.goToPageWithReplacement(AuthMainPage.routeName);
    }
  }

  fillControllers() {
    emailController.text = user.email;
    firstNameController.text = user.fName;
    lastNameController.text = user.lName;
    countryController.text = user.country;
    cituController.text = user.city;
  }

  File updatedFile;
  captureUpdateProfileImage() async {
    XFile file = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.updatedFile = File(file.path);
    notifyListeners();
  }

  updateProfile() async {
    String imageUrl;
    if (updatedFile != null) {
      imageUrl = await FirebaseStorageHelper.firebaseStorageHelper
          .uploadImage(updatedFile);
    }
    UserModel userModel = imageUrl == null
        ? UserModel(
            city: cituController.text,
            country: countryController.text,
            fName: firstNameController.text,
            lName: lastNameController.text,
            id: user.id)
        : UserModel(
            city: cituController.text,
            country: countryController.text,
            fName: firstNameController.text,
            lName: lastNameController.text,
            id: user.id,
            imageUrl: imageUrl);

    await FirestoreHelper.firestoreHelper.updateProfile(userModel);
    getUserFromFirestore();
    Navigator.of(RouteHelper.routeHelper.navKey.currentContext).pop();
  }
}
