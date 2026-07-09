local InlineRichText = script:FindFirstAncestor("InlineRichText")

require(InlineRichText.Types)

local InlineRichTextParent = InlineRichText.Parent
local Cryo = require(InlineRichTextParent.Cryo)
local tokenize = require(script.Parent.tokenize)
local buildTree = require(script.Parent.buildTree)
local DefaultParserOptions = require(script.Parent.DefaultParserOptions)

local function parseXml(s1: string, p1) -- line: 10
	-- upvalues: tokenize (copy), buildTree (copy), Cryo (copy), DefaultParserOptions (copy)
	return pcall(function() -- line: 11
		-- upvalues: tokenize (copy), s1 (copy), buildTree (copy), Cryo (copy), DefaultParserOptions (copy), p1 (copy)
		local v10 = tokenize(s1)

		return buildTree(v10, {
			TagConfigurations = Cryo.Dictionary.join(DefaultParserOptions.TagConfigurations, p1 and p1.TagConfigurations or {}),
			TagAliases = Cryo.Dictionary.join(DefaultParserOptions.TagAliases, p1 and p1.TagAliases or {})
		})
	end)
end

return parseXml
