local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.ExperienceService).GameProtocol.default
local ExperienceJoinDataHelper = require(script.Parent.Parent.Utils.ExperienceJoinDataHelper)

require(script.Parent.Types)

local ShareLinkTypes = require(script.Parent.ShareLinkTypes)

return function(p1, p2) -- line: 9
	-- upvalues: ExperienceJoinDataHelper (copy), ShareLinkTypes (copy), default (copy)
	local v7 = p1 and (not not p1.responseBody and p1.responseBody.experienceEventData) or {}

	if not v7 or (not v7.universeId or not v7.placeId) then
		return
	end

	local t1 = {}
	local joinData = v7.joinData

	if joinData then
		t1 = ExperienceJoinDataHelper.mergeExperienceJoinData(t1, joinData)
	end

	p2.launchGame(v7.placeId, ShareLinkTypes.ExperienceEvent, t1.experienceJoinData, default, "ExperienceEventShareLink")
end
