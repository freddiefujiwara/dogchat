import 'package:fluro/fluro.dart' as f;
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'chat/chat.dart';

class Routes {
  static void configureRoutes(f.Router router) {
    router.notFoundHandler = f.Handler(handlerFunc: (context, params) {
      debugPrint("ROUTE WAS NOT FOUND !!!");
      return RouteNotFound();
    });
    router.define(
      '/',
      handler: f.Handler(handlerFunc: (_, params) => Home()),
    );
    router.define(
      '/chat/:id',
      transitionType: f.TransitionType.materialFullScreenDialog,
      handler: f.Handler(handlerFunc: (_, params) {
        String id = params["id"]?.first ?? 'wQC5CvsRRoSyQmX8j7KJabDziToSR33c';
        return Chat(identifier: id);
      }),
    );
  }
}

class RouteNotFound extends StatelessWidget {
  const RouteNotFound({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          child: Text(
            '404',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
