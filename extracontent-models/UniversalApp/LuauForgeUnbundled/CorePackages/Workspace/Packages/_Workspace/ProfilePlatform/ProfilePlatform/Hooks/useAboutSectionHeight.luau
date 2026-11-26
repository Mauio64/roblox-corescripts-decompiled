local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Style").GetTextSize
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive")
local useTokens = Foundation.Hooks.useTokens
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local FFlagProfilePlatformFixBioTruncation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformFixBioTruncation")

return function(value, p2, p3)
	local v5 = useTokens()
	local bodyMedium = v5.Typography.BodyMedium
	local v6 = useIsSpatial()
	local v7 = usePreferredInput() == Responsive.Input.Directional
	local v8 = v6 or v7

	local useMemo = React.useMemo
	local function fn()
		local y = getTextSize(
			string.gsub(value or "", "[\r\n]+", " "),
			bodyMedium.FontSize,
			bodyMedium.Font,
			Vector2.new(1e999, 1e999),
			{ addTemporaryPadding = false }
		).Y

		local v10 = (v8 and 1.3 or 1) * bodyMedium.LineHeight

		local v11 = if FFlagProfilePlatformFixBioTruncation then bodyMedium.FontSize * v10 * 2 else y * v10 + y

		if not value or value == "" then
			return 0, v11
		end

		local textSize = getTextSize(value, bodyMedium.FontSize, bodyMedium.Font, Vector2.new(p2, 1e999), {
			addTemporaryPadding = false
		})

		return if v11 < textSize.Y then v11 + y + v5.Gap.XSmall else textSize.Y, v11
	end

	local fontSize = bodyMedium.FontSize
	local font = bodyMedium.Font
	local v10 = if FFlagProfilePlatformFixBioTruncation then bodyMedium.LineHeight else nil
	local v11, v12 = useMemo(fn, {
		value,
		fontSize,
		font,
		v10,
		p2,
		p3,
		v8,
		v5.Gap.XSmall
	})

	return v11, v12
end
