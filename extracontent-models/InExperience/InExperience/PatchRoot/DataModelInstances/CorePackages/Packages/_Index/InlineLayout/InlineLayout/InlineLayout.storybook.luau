local parent = script.Parent

local parent2 = parent.Parent
local MarkdownCore = require(parent2.MarkdownCore)
return {
	name = "InlineLayout",
	exclude = { "_Index" },
	storyRoots = { parent },
	mapStory = MarkdownCore.StoryMiddleware,
	roact = require(parent2.Dev.Roact)
}
