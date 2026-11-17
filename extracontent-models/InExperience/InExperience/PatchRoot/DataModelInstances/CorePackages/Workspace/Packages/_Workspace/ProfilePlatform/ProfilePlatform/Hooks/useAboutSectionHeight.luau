local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
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
		local y = GetTextSize(
			string.gsub(value or "", "[\r\n]+", " "),
			bodyMedium.FontSize,
			bodyMedium.Font,
			Vector2.new(1e999, 1e999),
			{ addTemporaryPadding = false }
		).Y

		local v5 = (v4 and 1.3 or 1) * bodyMedium.LineHeight
		local selected

		if FFlagProfilePlatformFixBioTruncation then
			selected = bodyMedium.FontSize * v5 * 2
		else
			selected = y * v5 + y
		end

		if not value or value == "" then
			return 0, selected
		end

		local textSize = GetTextSize(value, bodyMedium.FontSize, bodyMedium.Font, Vector2.new(p, 1e999), {
			addTemporaryPadding = false
		})
		local v6

		if selected < textSize.Y then
			v6 = selected + y + v.Gap.XSmall
		else
			v6 = textSize.Y
		end

		return v6, selected
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
