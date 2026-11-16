local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local parent = UserRelationshipModals.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

return {
	name = "UserRelationshipModals",
	storyRoots = { UserRelationshipModals.Stories },
	roact = React,
	reactRoblox = ReactRoblox
}
