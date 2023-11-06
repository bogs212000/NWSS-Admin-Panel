const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const driversPageDisplayName = "Riders";
const driversPageRoute = "/drivers";

const clientsPageDisplayName = "Clients";
const clientsPageRoute = "/clients";

const notificationsPageDisplayName = "Notifications";
const notificationsPageRoute = "/notifications";

const controlPageDisplayName = "Control";
const controlPageRoute = "/control";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(overviewPageDisplayName, overviewPageRoute),
  MenuItem(driversPageDisplayName, driversPageRoute),
  MenuItem(clientsPageDisplayName, clientsPageRoute),
  MenuItem(notificationsPageDisplayName, notificationsPageRoute),
  MenuItem(controlPageDisplayName, controlPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
