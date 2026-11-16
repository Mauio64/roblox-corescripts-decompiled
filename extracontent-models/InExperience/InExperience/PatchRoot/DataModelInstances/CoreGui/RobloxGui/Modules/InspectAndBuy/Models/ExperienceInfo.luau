local CorePackages = game:GetService("CorePackages")

local MockId = require(script.Parent.Parent.MockId)
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
local ExperienceInfo = {}

function ExperienceInfo.mock()
	return {
		["universeId"] = MockId(),
		name = "",
		rootPlaceId = MockId(),
		isPlayable = true,
		playabilityStatus = PlayabilityStatusEnum.Playable
	}
end

function ExperienceInfo.fromGetPlayabilityStatus(data)
	return {
		["universeId"] = tostring(data.universeId),
		isPlayable = data.isPlayable,
		playabilityStatus = data.playabilityStatus
	}
end

function ExperienceInfo.fromGetExperienceInfo(data)
	return {
		["universeId"] = tostring(data.id),
		rootPlaceId = tostring(data.rootPlaceId),
		name = data.name
	}
end

return ExperienceInfo
