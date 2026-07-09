local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local StoryMiddleware = require(ParentParent.Utility.StoryMiddleware)

return {
	group = "/IAPExperience",
	roact = Roact,
	mapStory = StoryMiddleware
}
