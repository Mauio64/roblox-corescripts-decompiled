local module = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/installReducer")
require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/types")
return {
	RoduxKey = "VirtualEvents",
	installReducer = module,
	enums = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/enums"),
	network = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/network"),
	ExperienceDetailsModel = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Models/ExperienceDetailsModel"),
	ExperienceMediaModel = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Models/ExperienceMediaModel")
}
