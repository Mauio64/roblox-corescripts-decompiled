local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local Rodux = require(Parent.Rodux)
local Cryo = require(Parent.Cryo)

require(script.Parent.Parent.Models.CommunityInfo)

local SetExperienceCommunityLink = require(script.Parent.Parent.Actions.SetExperienceCommunityLink)

return Rodux.createReducer({}, {
	[SetExperienceCommunityLink.name] = function(p1, p2) -- line: 14
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.universeId] = p2.communityLink
		})
	end
})
