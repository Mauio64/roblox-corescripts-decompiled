local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local StoryMiddleware = require(scriptParentParent.MarkdownCore).StoryMiddleware
local Roact = require(scriptParentParent.Dev.Roact)

return {
	name = "InlineLayout",
	exclude = { "_Index" },
	storyRoots = { scriptParent },
	mapStory = StoryMiddleware,
	roact = Roact
}
