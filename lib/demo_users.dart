var users = [userOne, userTwo, userThree, userFour, userFive];
DemoUsers userOne = const DemoUsers(
    id: 'Alan',
    name: "Alan Hu",
    image: 'https://picsum.photos/seed/772/300/300');
DemoUsers userTwo = const DemoUsers(
    id: 'Anton',
    name: "Anton Soto",
    image: 'https://picsum.photos/seed/785/300/300');
DemoUsers userThree = const DemoUsers(
    id: "Willard",
    name: "Willard Conner",
    image: 'https://picsum.photos/seed/676/300/300');
DemoUsers userFour = const DemoUsers(
    id: "Cecilia",
    name: "Cecilia Li",
    image: 'https://picsum.photos/seed/471/300/300');
DemoUsers userFive = const DemoUsers(
    id: "Saira",
    name: "Saira Brock",
    image: 'https://picsum.photos/seed/893/300/300');

class DemoUsers {
  final String id;
  final String name;
  final String image;

  const DemoUsers({required this.id, required this.name, required this.image});
}
