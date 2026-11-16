local Foundation = script:FindFirstAncestor("Foundation")
require(Foundation.Enums.ColorMode)
require(Foundation.Enums.Device)
require(Foundation.Enums.ThemeName)
local TokenProcessingUtilities = require(Foundation.Providers.Style.Tokens.TokenProcessingUtilities)
local Tokens = require(Foundation.Providers.Style.Tokens)

local function tokenPathToAttributeBase(value: string) -- 1 equivalent call inferred from this helper
	return value:gsub("%.", ""):gsub("_", "")
end

local function emitLeafAttributes(overrideAttributes, p: string, tokenOverride)
	if type(tokenOverride) ~= "table" then
		overrideAttributes[p] = tokenOverride

		return
	end

	for k, item in tokenOverride do
		emitLeafAttributes(overrideAttributes, p .. tostring(k), item)
	end
end

local function getOverrideAttributes(p, p2, p3, items)
	local overrideAttributes = {}

	if not (items and next(items)) then
		return overrideAttributes
	end

	local tokens = Tokens.getTokens(p2, p3, 1, nil, p)

	for k, item in items do
		local tokenOverride = TokenProcessingUtilities.resolveTokenOverride(tokens, k, item)

		if tokenOverride ~= nil then
			emitLeafAttributes(overrideAttributes, tokenPathToAttributeBase(k), tokenOverride) -- inferred equivalent call
		end
	end

	return overrideAttributes
end

return getOverrideAttributes
