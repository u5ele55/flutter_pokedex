part of 'navigation_menu.dart';

class NavigationMenuEntry<Routes> extends PopupMenuItem<Routes> {
  NavigationMenuEntry(this.route, {Key? key})
      : super(
          key: key,
          child: Text(PokeballPageMenu.routes[route]!),
          value: route,
          enabled: AppNavigator.currentRoute != route,
          onTap: () => print(AppNavigator.currentRoute),
        );
  final Routes route;
}
