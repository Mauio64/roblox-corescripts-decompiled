local InlineRichText = script:FindFirstAncestor("InlineRichText")
require(InlineRichText.Types)
local parent = InlineRichText.Parent
local Cryo = require(parent.Cryo)

local tokenize = require(script.Parent.tokenize)
local buildTree = require(script.Parent.buildTree)
local DefaultParserOptions = require(script.Parent.DefaultParserOptions)

local function parseXml(p: string, p2)
	return pcall(function()
		return buildTree(tokenize(p), {
			TagConfigurations = Cryo.Dictionary.join(
				DefaultParserOptions.TagConfigurations,
				p2 and p2.TagConfigurations or {}
			),
			TagAliases = Cryo.Dictionary.join(DefaultParserOptions.TagAliases, p2 and p2.TagAliases or {})
		})
	end)
end

return parseXml
