local Components = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components")

return {
	openPlayerContextualMenu = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/openPlayerContextualMenu"),
	Component = Components.PlayerContextualMenu,
	installReducer = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Reducers/installReducer")
}
