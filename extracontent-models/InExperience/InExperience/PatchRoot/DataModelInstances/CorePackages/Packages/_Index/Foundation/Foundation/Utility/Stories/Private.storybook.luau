local scriptParent = script.Parent
local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local Roact = require(Parent.Roact)
local GetStories = require(scriptParent.GetStories)
local StoryMiddleware = require(scriptParent.StoryMiddleware)

return {
	name = "Private",
	group = "Foundation",
	roact = Roact,
	storyRoots = GetStories(false),
	mapStory = StoryMiddleware,
	packages = {
		React = React,
		ReactRoblox = ReactRoblox
	}
}
