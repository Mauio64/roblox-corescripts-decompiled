require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local fIntScaleBrazilContentRatingBadge = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntScaleBrazilContentRatingBadge

local function makeLandingViewTokenMapper(p2, p3)
	local landingViewTokenMapper = {
		buttonTextSize = p3.FontSize.FontSize_500,
		buttonWidth = 360,
		buttonHeight = 48,
		contentPadding = 20,
		brazilBadgeHeight = 1.3 * fIntScaleBrazilContentRatingBadge
	}

	if p2.uiMode == uiMode.TenFoot then
		landingViewTokenMapper.buttonWidth = 846
		landingViewTokenMapper.buttonHeight = p3.Size.Size_1200
		landingViewTokenMapper.contentPadding = p3.Size.Size_800
	end

	return landingViewTokenMapper
end

return makeLandingViewTokenMapper
