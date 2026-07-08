local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local RbxDesignFoundations = require(FoundationParent.RbxDesignFoundations)
local Device = require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
local Theme = require(Foundation.Enums.Theme)
local TokenProcessingUtilities = require(script.TokenProcessingUtilities)

require(Foundation.Components.Types)

local function getPlatformScale(p1, n1: number?) -- line: 20
	-- upvalues: Flags (copy), Device (copy)
	if Flags.FoundationDisableTokenScaling then
		return 1
	end

	if n1 == nil then
		n1 = 1
	end

	local v14 = math.clamp(n1, 0, 1e999)

	return (p1 ~= Device.Console and 1 or 1.5) * v14
end
local function applyTokenOverrides(p2, t1: {[any]: any}) -- line: 35
	-- upvalues: Flags (copy), TokenProcessingUtilities (copy)
	if not Flags.FoundationTokenOverrides then
		return p2
	end

	for v17, v18 in t1 do
		local v19 = TokenProcessingUtilities.resolveTokenOverride(p2, v17, v18)

		if v19 ~= nil then
			TokenProcessingUtilities.setTokenValue(p2, v17, v19)
		end
	end

	return p2
end
local function getTokens(p3, p4, n2: number?, t2: {[any]: any}?) -- line: 50
	-- upvalues: RbxDesignFoundations (copy), Device (copy), Flags (copy), Theme (copy), applyTokenOverrides (copy)
	local Tokens = RbxDesignFoundations.Tokens
	local v25 = p4 or Device.Desktop
	local n3

	if Flags.FoundationDisableTokenScaling then
		n3 = 1
	else
		if n2 == nil then
			n2 = 1
		end

		local v27 = math.clamp(n2, 0, 1e999)

		n3 = (v25 ~= Device.Console and 1 or 1.5) * v27
	end

	local v28 = ((if p3 ~= Theme.Dark then Tokens.Light else Tokens.Dark))(n3)
	local t3 = {
		Color = v28.Color,
		Config = v28.Config,
		DarkMode = v28.DarkMode,
		Ease = v28.Ease,
		LightMode = v28.LightMode,
		Inverse = v28.Inverse,
		Semantic = v28.Semantic,
		Size = v28.Size,
		Padding = v28.Padding,
		Margin = v28.Margin,
		Gap = v28.Gap,
		Gutter = v28.Gutter,
		Radius = v28.Radius,
		Stroke = v28.Stroke,
		LineHeight = v28.LineHeight,
		FontSize = v28.FontSize,
		FontWeight = v28.FontWeight,
		Time = v28.Time,
		Typography = v28.Typography
	}

	if t2 then
		applyTokenOverrides(t3, t2)
	end

	return t3
end

local v11 = getTokens(Theme.Dark, Device.Desktop)

return {
	getTokens = getTokens,
	defaultTokens = v11
}
