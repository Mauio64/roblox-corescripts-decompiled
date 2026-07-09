local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Roact = require(ExpChatParent.Roact)
local storyMiddleware = require(script.storyMiddleware)

return {
	roact = Roact,
	mapStory = storyMiddleware,
	storyRoots = { ExpChat }
}
