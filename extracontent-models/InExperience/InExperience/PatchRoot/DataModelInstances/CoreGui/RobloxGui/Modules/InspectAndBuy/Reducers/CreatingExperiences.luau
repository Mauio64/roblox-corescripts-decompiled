local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetExperienceInfo = require(parent.Actions.SetExperienceInfo)

return Rodux.createReducer({}, {
	[SetExperienceInfo.name] = function(p, p2)
		local experienceInfo = p2.experienceInfo
		local universeId = experienceInfo.universeId
		assert(universeId ~= nil, "Expected a universe id when setting an experiences's information.")

		local v = p[universeId] or {}
		local joined = Cryo.Dictionary.join(v, experienceInfo)
		return Cryo.Dictionary.join(p, { [universeId] = joined })
	end
})
