local module = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/TextKeys")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/resolveJoinCardActions")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/buildJoinCardActionsComponent")
return {
	factories = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/actionFactories"),
	resolveJoinCardActions = module3,
	buildJoinCardActionsComponent = module4,
	TextKeys = module2,
	Types = module
}
