local TextService = game:GetService("TextService")

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Responsive = require(parent.Responsive)
local useTokens = Foundation.Hooks.useTokens
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local FFlagProfilePlatformFixBioTruncation = require(ProfilePlatform.Flags.FFlagProfilePlatformFixBioTruncation)

return function(value: string?, p: number, p2: number)
	local v = useTokens()
	local bodyMedium = v.Typography.BodyMedium
	local v2 = useIsSpatial()
	local v3 = usePreferredInput() == Responsive.Input.Directional
	local v4 = v2 or v3

	local useMemo = React.useMemo
	local function fn()
		local v5 = string.gsub(value or "", "[\r\n]+", " ")
		local y

		if FoundationFontFaceMigration then
			y = GetTextSize(v5, bodyMedium.FontSize, bodyMedium.Font, Vector2.new(1e999, 1e999), {
				addTemporaryPadding = false
			}).Y
		else
			y = TextService:GetTextSize(v5, bodyMedium.FontSize, bodyMedium.Font, Vector2.new(1e999, 1e999)).Y
		end

		local v6 = (v4 and 1.3 or 1) * bodyMedium.LineHeight
		local v7

		if FFlagProfilePlatformFixBioTruncation then
			v7 = bodyMedium.FontSize * v6 * 2
		else
			v7 = y * v6 + y
		end

		if not value or value == "" then
			return 0, v7
		end

		local v8

		if FoundationFontFaceMigration then
			v8 = GetTextSize(value, bodyMedium.FontSize, bodyMedium.Font, Vector2.new(p, 1e999), {
				addTemporaryPadding = false
			})
		else
			v8 = TextService:GetTextSize(value, bodyMedium.FontSize, bodyMedium.Font, Vector2.new(p, 1e999))
		end

		local v9

		if v7 < v8.Y then
			v9 = v7 + y + v.Gap.XSmall
		else
			v9 = v8.Y
		end

		return v9, v7
	end

	local fontSize = bodyMedium.FontSize
	local font = bodyMedium.Font
	local v5

	if FFlagProfilePlatformFixBioTruncation then
		v5 = bodyMedium.LineHeight
	end

	local v6, v7 = useMemo(fn, { value, fontSize, font, v5, p, p2, v4, v.Gap.XSmall })

	return v6, v7
end
