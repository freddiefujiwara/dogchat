import 'package:flutter/material.dart';
import 'package:dogchat/globals.dart';
import 'package:dogchat/model/google_log_in.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Widget _buildBody(BuildContext context) {
    return Consumer<GoogleLogIn>(builder: (context, model, child) {
      if (loginUser != null) {
        print("ID@home:$id");
        if (id != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed('/chat', arguments: id);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamed('/my');
          });
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("利用を開始するにはサインインが必要です"),
          FlatButton(
              onPressed: () async {
                model.handleGoogleSignIn();
              },
              padding: EdgeInsets.all(0.0),
              child: Image.network(
                  'https://developers.google.com/identity/images/btn_google_signin_dark_normal_web.png')),
          FlatButton(
              onPressed: () =>
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushNamed('/auth');
                  }),
              padding: EdgeInsets.all(0.0),
              child: Text("メールアドレスでサインイン")),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoogleLogIn>(
        create: (_) => GoogleLogIn(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('🐕 Dog Chat -ワンタイムチャット-'),
              centerTitle: true,
            ),
            body: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: _buildBody(context),
            )));
  }
}
