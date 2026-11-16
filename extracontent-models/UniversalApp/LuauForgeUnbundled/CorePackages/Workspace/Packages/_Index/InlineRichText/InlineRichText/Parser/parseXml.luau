require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")

local tokenize = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Parser/tokenize")
local buildTree = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Parser/buildTree")
local DefaultParserOptions = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Parser/DefaultParserOptions")

local function parseXml(p2, p3)
	return pcall(function()
		return buildTree(tokenize(p2), {
			TagConfigurations = Cryo.Dictionary.join(
				DefaultParserOptions.TagConfigurations,
				p3 and p3.TagConfigurations or {}
			),
			TagAliases = Cryo.Dictionary.join(DefaultParserOptions.TagAliases, p3 and p3.TagAliases or {})
		})
	end)
end

return parseXml
