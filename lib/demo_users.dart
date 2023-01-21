import 'package:messaging_app/Widgets/Helpers.dart';

var users = [userOne, userTwo, userThree, userFour, userFive];
DemoUsers userOne =
    DemoUsers(id: 'Alan', name: "Alan Hu", image: Helpers.randomPictureUrl());
DemoUsers userTwo = DemoUsers(
    id: 'Anton', name: "Anton Soto", image: Helpers.randomPictureUrl());
DemoUsers userThree = DemoUsers(
    id: "Willard", name: "Willard Conner", image: Helpers.randomPictureUrl());
DemoUsers userFour = DemoUsers(
    id: "Eliana", name: "Elania Rush", image: Helpers.randomPictureUrl());
DemoUsers userFive = DemoUsers(
    id: "Saira", name: "Saira Brock", image: Helpers.randomPictureUrl());

class DemoUsers {
  final String id;
  final String name;
  final String image;

  const DemoUsers({required this.id, required this.name, required this.image});
}
