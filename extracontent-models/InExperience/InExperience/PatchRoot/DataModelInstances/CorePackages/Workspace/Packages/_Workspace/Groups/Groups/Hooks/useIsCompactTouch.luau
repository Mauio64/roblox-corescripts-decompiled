local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local SignalsReact = require(parent.SignalsReact)
local CommunityListRouting = require(Groups.CommunityListRouting)

local function useIsCompactTouch()
	return SignalsReact.useSignalState(CommunityListRouting.getIsCompactTouch)
end

return useIsCompactTouch
