const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const driversPageDisplayName = "Checker";
const driversPageRoute = "/drivers";

const clientsPageDisplayName = "Clients";
const clientsPageRoute = "/clients";

const notificationsPageDisplayName = "Notifications";
const notificationsPageRoute = "/notifications";

const transactionsPageDisplayName = "Transactions";
const transactionsPageRoute = "/transactions";

const chatPageDisplayName = "Chat";
const chatPageRoute = "/chat";

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
  MenuItem(transactionsPageDisplayName, transactionsPageRoute),
  MenuItem(chatPageDisplayName, chatPageRoute),
  MenuItem(controlPageDisplayName, controlPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
