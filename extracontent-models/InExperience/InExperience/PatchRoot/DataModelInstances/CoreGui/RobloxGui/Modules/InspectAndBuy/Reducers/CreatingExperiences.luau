local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetExperienceInfo = require(ParentParent.Actions.SetExperienceInfo)

return Rodux.createReducer({}, {
	[SetExperienceInfo.name] = function(p1, p2) -- line: 12
		-- upvalues: Cryo (copy)
		local experienceInfo = p2.experienceInfo
		local universeId = experienceInfo.universeId

		assert(universeId ~= nil, "Expected a universe id when setting an experiences's information.")

		local v10 = p1[universeId] or {}
		local v11 = Cryo.Dictionary.join(v10, experienceInfo)

		return Cryo.Dictionary.join(p1, {
			[universeId] = v11
		})
	end
})
