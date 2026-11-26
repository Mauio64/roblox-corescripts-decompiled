local appFonts = require("@game/CorePackages/Workspace/Packages/Style").AppFonts
require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

return function(p2, data)
	local v5 = data.Size.Size_400
	local v6 = data.Size.Size_2000
	local v7 = data.Size.Size_500
	local v8 = data.Size.Size_2400
	local v9 = { Font = appFonts.default:getMedium(), FontSize = 24 }

	local v10 = data.Typography.LabelLarge
	local v11 = { Font = appFonts.default:getMedium(), FontSize = 24 }

	local v12 = { Font = appFonts.default:getDefault(), FontSize = 19 }

	local v13 = {
		Font = appFonts.default:getDefault(),
		FontSize = data.FontSize.FontSize_400
	}

	local v14 = data.Size.Size_300 * 2
	local emphasis = data.Color.Content.Emphasis
	local emphasis2 = data.Color.Content.Emphasis
	local v15 = data.Color.Content.Emphasis
	local v16 = { Font = appFonts.default:getDefault(), FontSize = 14 }

	local alert = data.Color.System.Alert

	local v17 = Enum.VerticalAlignment.Bottom
	local v18, v19

	if p2.uiMode == uiMode.TenFoot then
		v5 = data.Size.Size_1600
		v6 = data.Size.Size_1600
		v7 = data.Size.Size_600 + data.Size.Size_400
		v8 = data.Size.Size_1600 * 2
		v11 = data.Typography.HeadingSmall
		v9 = data.Typography.TitleLarge
		v10 = data.Typography.TitleLarge
		v12 = data.Typography.BodyLarge
		v13 = data.Typography.LabelMedium
		v14 = data.Size.Size_500 * 2
		v15 = data.Color.Content.Default
		v16 = data.Typography.BodySmall
		v18 = data.Size.Size_200
		v17 = Enum.VerticalAlignment.Center
		v19 = 0.5
	else
		v18 = 0
		v19 = 1
	end

	return {
		verticalPadding = v7,
		iconSize = v8,
		layoutHeaderFont = v11,
		headerFont = v9,
		headerTypography = v10,
		bodyFont = v12,
		continueButtonFont = v13,
		continueButtonHorizontalPad = v14,
		layoutTextColor = emphasis,
		headerTextColor = emphasis2,
		bodyTextColor = v15,
		textAlertFont = v16,
		textAlertColor = alert,
		headerPadding = v18,
		warningTextVerticalAlignment = v17,
		buttonFrameWidth = v19,
		getDevicePadding = function(p3)
			if p3 then
				return v6
			end

			return v5
		end
	}
end
