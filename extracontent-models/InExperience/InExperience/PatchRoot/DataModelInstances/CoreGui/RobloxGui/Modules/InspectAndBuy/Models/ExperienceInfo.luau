local CorePackages = game:GetService("CorePackages")
local MockId = require(script.Parent.Parent.MockId)
local PlayabilityStatusEnum = require(CorePackages.Workspace.Packages.DiscoveryTypes).PlayabilityStatusEnum

return {
	mock = function() -- line: 26
		-- upvalues: MockId (copy), PlayabilityStatusEnum (copy)
		return {
			universeId = MockId(),
			name = "",
			rootPlaceId = MockId(),
			isPlayable = true,
			playabilityStatus = PlayabilityStatusEnum.Playable
		}
	end,
	fromGetPlayabilityStatus = function(p1) -- line: 38
		return {
			universeId = tostring(p1.universeId),
			isPlayable = p1.isPlayable,
			playabilityStatus = p1.playabilityStatus
		}
	end,
	fromGetExperienceInfo = function(p2) -- line: 48
		return {
			universeId = tostring(p2.id),
			rootPlaceId = tostring(p2.rootPlaceId),
			name = p2.name
		}
	end
}
