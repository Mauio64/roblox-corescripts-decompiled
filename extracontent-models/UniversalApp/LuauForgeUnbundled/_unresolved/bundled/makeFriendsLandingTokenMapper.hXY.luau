require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local function makeFriendsLandingTokenMapper(p2, p3)
	local friendsLandingTokenMapper = {
		AddFriendsPage = {},
		FriendsLandingPage = {},
		ShowMore = {}
	}

	if p2.uiMode ~= uiMode.TenFoot then
		return friendsLandingTokenMapper
	end

	friendsLandingTokenMapper.AddFriendsPage.GridViewItemMetrics = {
		minimumItemsPerRow = 6,
		minimumItemWidth = 258
	}

	friendsLandingTokenMapper.AddFriendsPage.ItemMargin = p3.Size.Size_600
	friendsLandingTokenMapper.AddFriendsPage.PagePaddingTop = p3.Size.Size_400

	friendsLandingTokenMapper.ShowMore.ButtonWidth = 960
	friendsLandingTokenMapper.ShowMore.ButtonHeight = p3.Size.Size_1200

	friendsLandingTokenMapper.FriendsLandingPage.GridViewItemMetrics = {
		minimumItemsPerRow = 6,
		minimumItemWidth = 258
	}

	friendsLandingTokenMapper.FriendsLandingPage.GridHorizontalSpacing = p3.Size.Size_600
	friendsLandingTokenMapper.FriendsLandingPage.GridVerticalSpacing = p3.Size.Size_600

	return friendsLandingTokenMapper
end

return makeFriendsLandingTokenMapper
