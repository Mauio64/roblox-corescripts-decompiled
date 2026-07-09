local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local Rodux = require(Parent.Rodux)
local ExperienceCommunityLinks = require(script.Parent.ExperienceCommunityLinks)

return function() -- line: 10
	-- upvalues: Rodux (copy), ExperienceCommunityLinks (copy)
	return Rodux.combineReducers({
		ExperienceCommunityLinks = ExperienceCommunityLinks
	})
end
