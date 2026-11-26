local module = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/EventManager")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Communication")

require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")

return {
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Constants"),
	Actions = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions"),
	Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Analytics"),
	Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Utils"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Reducers"),
	Models = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Models"),
	Middlewares = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Middlewares"),
	EventManager = module,
	Communication = module2,
	PartyAudioPlayer = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Modules/PartyAudioPlayer")
}
