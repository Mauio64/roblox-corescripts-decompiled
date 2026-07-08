local scriptParent = script.Parent
local StoryMiddleware = require(scriptParent.StoryMiddleware)
local Roact = require(scriptParent.Parent.Dev.Roact)

return {
	name = "MarkdownCore",
	exclude = { "_Index" },
	storyRoots = { scriptParent },
	mapStory = StoryMiddleware,
	roact = Roact
}
