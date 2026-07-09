local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local React = require(PurchasePromptParent.React)
local ReactRoblox = require(PurchasePromptParent.ReactRoblox)
local StoryMiddleware = require(PurchasePrompt.Stories.StoryMiddleware)

return {
	name = PurchasePrompt.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { PurchasePrompt },
	mapStory = StoryMiddleware
}
