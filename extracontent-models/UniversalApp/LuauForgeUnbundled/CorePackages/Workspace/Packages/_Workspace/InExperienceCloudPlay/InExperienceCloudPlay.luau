local UnsuccessfulJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/UnsuccessfulJoin")

return {
	markUnsuccessfulJoin = UnsuccessfulJoin.markUnsuccessfulJoin,
	consumeUnsuccessfulJoin = UnsuccessfulJoin.consumeUnsuccessfulJoin,
	mountCloudPlayUIOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/mountCloudPlayUIOverlay")
}
