local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Cryo = require(AvatarExperienceRoduxParent.Cryo)
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local AddAnalyticsMetadata = require(AvatarExperienceRodux.Actions.AddAnalyticsMetadata)

return Rodux.createReducer({}, {
	[AddAnalyticsMetadata.name] = function(t1: {[any]: any}, p1) -- line: 18
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t1, p1.metadata)
	end
})
