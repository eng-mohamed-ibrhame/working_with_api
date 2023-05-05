import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:working_with_api/model/user_model.dart';
import 'package:working_with_api/view/pages/details.dart';
import 'package:working_with_api/view/pages/profile.dart';
import '../../controller/provider/fetch_data_provider.dart';
import '../../core/constants/app_color_constants.dart';

class Home extends ConsumerWidget {
  final UserModel user;
  const Home({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<dynamic>> dataFromJson = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  Profile(user:user),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Hero(
              tag: 'profile_image',
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatar),
              ),
            ),
          ),
        ),
        title: Text(user.firstName),
      ),
      body: dataFromJson.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent),
                    child: Text(
                      '${data[index]['id']}',
                    ),
                  ),
                  splashColor: Colors.blue,
                  minVerticalPadding: 5,
                  title: Text(
                    '${data[index]['title']}',
                    style: const TextStyle(
                        fontSize: AppsizeConstants.listTileTitleSize),
                  ),
                  subtitle: Text(
                    data[index]['body'],
                    style: const TextStyle(
                        fontSize: AppsizeConstants.listTileBodySize),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(index: index),
                        ));
                  },
                ),
              );
            },
            itemCount: data.length,
            padding: const EdgeInsets.all(10),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
