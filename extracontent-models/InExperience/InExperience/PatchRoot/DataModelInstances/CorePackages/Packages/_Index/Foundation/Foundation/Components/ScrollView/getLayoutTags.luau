local Foundation = script:FindFirstAncestor("Foundation")
local Tokens = require(Foundation.Providers.Style.Tokens)
local attributeRules = require(Foundation.StyleSheet.Rules.attributeRules)
local formatTokens = require(Foundation.StyleSheet.formatTokens)

local function getLayoutTags() -- line: 8
	-- upvalues: Tokens (copy), formatTokens (copy), attributeRules (copy)
	local t1 = {}
	local defaultTokens = Tokens.defaultTokens
	local v8 = formatTokens(defaultTokens)
	local _, v10 = attributeRules.rulesGenerator(defaultTokens, v8)

	for _, v12 in v10 do
		if v12.pseudo == "UIListLayout" and v12.tag then
			t1[v12.tag] = true
		end
	end

	return t1
end

return getLayoutTags
