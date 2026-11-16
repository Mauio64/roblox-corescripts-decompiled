local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
require(parent.RbxDesignFoundations)

local ColorMode = require(Foundation.Enums.ColorMode)
local DeprecatedTokenUtilities = require(script.DeprecatedTokenUtilities)
local Device = require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
local ThemeName = require(Foundation.Enums.ThemeName)
local TokenProcessingUtilities = require(script.TokenProcessingUtilities)
require(Foundation.Components.Types)
local themeGenerators = require(script.themeGenerators)

local function getPlatformScale(p, p2: number?) -- 2 equivalent calls inferred from this helper
	if Flags.FoundationDisableTokenScaling then
		return 1
	end

	local v = (math.clamp)(p2 == nil and 1 or p2, 0, 1e999)

	return (p == Device.Console and 1.5 or 1) * v
end

local function applyTokenOverrides(tokens, items)
	for k, item in items do
		local tokenOverride = TokenProcessingUtilities.resolveTokenOverride(tokens, k, item)

		if tokenOverride ~= nil then
			TokenProcessingUtilities.setTokenValue(tokens, k, tokenOverride)
		end
	end

	return tokens
end

local function buildTokens(callback, platformScale: number, p)
	local v = callback(platformScale)

	local tokens = {
		Color = v.Color,
		Config = v.Config,
		DarkMode = v.DarkMode,
		Ease = v.Ease,
		LightMode = v.LightMode,
		Inverse = v.Inverse,
		Size = v.Size,
		Padding = v.Padding,
		Margin = v.Margin,
		Gap = v.Gap,
		Gutter = v.Gutter,
		Radius = v.Radius,
		Stroke = v.Stroke,
		LineHeight = v.LineHeight,
		FontSize = v.FontSize,
		FontWeight = v.FontWeight,
		Time = v.Time,
		Typography = v.Typography
	}

	if p then
		applyTokenOverrides(tokens, p)
	end

	if Flags.FoundationRemoveDeprecatedSemanticTokens then
		tokens.Semantic = nil
		return tokens
	end

	tokens.Semantic = DeprecatedTokenUtilities.getDeprecatedSemanticTokens(tokens, platformScale)

	return tokens
end

local function getTokens(p, p2, p3: number?, p4, p5)
	local platformScale = getPlatformScale(p2 or Device.Desktop, p3) -- inferred equivalent call

	return buildTokens(themeGenerators.getGenerator(p5 or ThemeName.Default, p), platformScale, p4)
end

local Dark = ColorMode.Dark
local platformScale = getPlatformScale(Device.Desktop or Device.Desktop) -- inferred equivalent call
return {
	getTokens = getTokens,
	defaultTokens = buildTokens(themeGenerators.getGenerator(ThemeName.Default, Dark), platformScale, nil)
}
