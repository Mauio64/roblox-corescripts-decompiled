local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
local Dash = require(parent.Dash)

local BuildTree = require(script.BuildTree)
local PostProcessTree = require(script.PostProcessTree)
local Tokenize = require(script.Tokenize)
require(Markdown.Types)
local UnindentTags = require(script.Parent.UnindentTags)
local IndexTree = require(script.Parent.IndexTree)
local DefaultParserOptions = require(script.Parent.DefaultParserOptions)

local WikiMarkdownParser = {}

function WikiMarkdownParser.safeParse(p: string, p2)
	local success, result = xpcall(function()
		return WikiMarkdownParser.parse(p, p2)
	end, function(p3)
		return `{p3}\n{debug.traceback()}`
	end)

	return success, result
end

function WikiMarkdownParser.parse(p: string, options)
	local joinDeep = Dash.joinDeep(DefaultParserOptions, options or {})
	local tree = BuildTree(Tokenize((UnindentTags(p))), joinDeep)
	tree.children = PostProcessTree(tree, joinDeep)
	return IndexTree(tree)
end

return WikiMarkdownParser
