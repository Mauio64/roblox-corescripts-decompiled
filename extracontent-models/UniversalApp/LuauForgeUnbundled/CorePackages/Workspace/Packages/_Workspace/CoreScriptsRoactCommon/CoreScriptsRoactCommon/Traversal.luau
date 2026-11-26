local module = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/Constants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/Flags")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TraversalExperienceCard")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/HistoryMenu")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/HistoryPage")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/LocalTraversalHistory")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TeleportBackButton")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TeleportLeaveConfirmation")
return {
	Constants = module,
	Flags = module2,
	TraversalExperienceCard = module3,
	HistoryMenu = module4,
	HistoryPage = module5,
	LocalTraversalHistory = module6,
	TraversalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TraversalTelemetry"),
	TeleportBackButton = module7,
	TeleportLeaveConfirmation = module8,
	useHistoryItems = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Hooks/useHistoryItems")
}
