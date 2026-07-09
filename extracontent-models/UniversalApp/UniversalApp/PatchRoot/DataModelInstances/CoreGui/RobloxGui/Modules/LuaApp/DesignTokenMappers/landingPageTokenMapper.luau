local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local FIntScaleBrazilContentRatingBadge = require(CorePackages.Workspace.Packages.SharedFlags).FIntScaleBrazilContentRatingBadge

local function makeLandingViewTokenMapper(p1, p2) -- line: 13
	-- upvalues: FIntScaleBrazilContentRatingBadge (copy), UiMode (copy)
	local t1 = {
		buttonWidth = 360,
		buttonHeight = 48,
		contentPadding = 20,
		buttonTextSize = p2.FontSize.FontSize_500,
		brazilBadgeHeight = 1.3 * FIntScaleBrazilContentRatingBadge
	}

	if p1.uiMode == UiMode.TenFoot then
		t1.buttonWidth = 846
		t1.buttonHeight = p2.Size.Size_1200
		t1.contentPadding = p2.Size.Size_800
	end

	return t1
end

return makeLandingViewTokenMapper
