local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)

local AddAnalyticsMetadata = require(AvatarExperienceRodux.Actions.AddAnalyticsMetadata)

return Rodux.createReducer({}, {
	[AddAnalyticsMetadata.name] = function(p, p2)
		return Cryo.Dictionary.join(p, p2.metadata)
	end
})
