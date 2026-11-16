local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

local AddAnalyticsMetadata = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AddAnalyticsMetadata")

return Rodux.createReducer({}, {
	[AddAnalyticsMetadata.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, p3.metadata)
	end
})
