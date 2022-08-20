import 'package:flutter/material.dart';

class Navigation {
  static Future<Future<T?>> createRoute<T>(Widget destination, BuildContext context,
      [AnimationEnum animationEnum = AnimationEnum.fromRight, Object payload = true]) async {
    PageRouteBuilder<T> pageRoute;
    Widget _safeArea(Widget child) => Container(
          color: Color(0xFF0C2838),
          child: child,
        );
    switch (animationEnum) {
      case AnimationEnum.fadeIn:
        pageRoute = PageRouteBuilder<T>(
          settings: RouteSettings(arguments: payload),
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return FadeTransition(
              opacity: animation.drive(tween),
              child: _safeArea(child),
            );
          },
        );
        break;
      case AnimationEnum.pageAscend:
        pageRoute = PageRouteBuilder<T>(
          settings: RouteSettings(arguments: payload),
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: _safeArea(child),
            );
          },
        );

        break;
      case AnimationEnum.fromRight:
        pageRoute = PageRouteBuilder<T>(
          settings: RouteSettings(arguments: payload),
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: _safeArea(child),
            );
          },
        );
        break;
      case AnimationEnum.fromLeft:
        pageRoute = PageRouteBuilder<T>(
          settings: RouteSettings(arguments: payload),
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(-1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: _safeArea(child),
            );
          },
        );

        break;
      default:
        pageRoute = PageRouteBuilder<T>(
        settings: RouteSettings(arguments: payload),
        transitionDuration: Duration(milliseconds: 500),
        reverseTransitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = 0.0;
          var end = 1.0;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: _safeArea(child),
          );
        },
      );
    }

    return Navigator.of(context).push(pageRoute);
  }
}

enum AnimationEnum { pageAscend, fadeIn, fromRight, fromLeft }
