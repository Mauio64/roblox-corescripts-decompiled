return {
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Constants"),
	DrawerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Components/DrawerContainer"),
	Hooks = {
		useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useDrawerVisible"),
		useSetDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useSetDrawerVisible"),
		useDrawerShouldMount = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useDrawerShouldMount"),
		useDrawerAnimating = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useDrawerAnimating"),
		useSetDrawerAnimating = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Hooks/useSetDrawerAnimating")
	},
	Stores = { GetDrawerVisibleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Drawer/Drawer/Stores/GetDrawerVisibleStore") }
}
