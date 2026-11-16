local Foundation = script:FindFirstAncestor("Foundation")

local Tokens = require(Foundation.Providers.Style.Tokens)
local attributeRules = require(Foundation.StyleSheet.Rules.attributeRules)
local formatTokens = require(Foundation.StyleSheet.formatTokens)

local function getLayoutTags()
	local defaultTokens = Tokens.defaultTokens
	local v = formatTokens(defaultTokens)

	local _, v2 = attributeRules.rulesGenerator(defaultTokens, v)
	local tagSet = {}

	for _, v3 in v2 do
		if v3.pseudo == "UIListLayout" and v3.tag then
			tagSet[v3.tag] = true
		end
	end

	return tagSet
end

return getLayoutTags
