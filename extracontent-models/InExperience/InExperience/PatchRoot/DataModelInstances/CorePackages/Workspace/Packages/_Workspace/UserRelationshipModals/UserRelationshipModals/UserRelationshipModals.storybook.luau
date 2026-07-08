local UserRelationshipModals = script:FindFirstAncestor("UserRelationshipModals")
local UserRelationshipModalsParent = UserRelationshipModals.Parent
local React = require(UserRelationshipModalsParent.React)
local ReactRoblox = require(UserRelationshipModalsParent.ReactRoblox)

return {
	name = "UserRelationshipModals",
	storyRoots = { UserRelationshipModals.Stories },
	roact = React,
	reactRoblox = ReactRoblox
}
