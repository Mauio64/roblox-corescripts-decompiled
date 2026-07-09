local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode

local function makeFriendsLandingTokenMapper(p1, p2) -- line: 10
	-- upvalues: UiMode (copy)
	local t1 = {
		AddFriendsPage = {},
		FriendsLandingPage = {},
		ShowMore = {}
	}

	if p1.uiMode == UiMode.TenFoot then
		t1.AddFriendsPage.GridViewItemMetrics = {
			minimumItemsPerRow = 6,
			minimumItemWidth = 258
		}
		t1.AddFriendsPage.ItemMargin = p2.Size.Size_600
		t1.AddFriendsPage.PagePaddingTop = p2.Size.Size_400
		t1.ShowMore.ButtonWidth = 960
		t1.ShowMore.ButtonHeight = p2.Size.Size_1200
		t1.FriendsLandingPage.GridViewItemMetrics = {
			minimumItemsPerRow = 6,
			minimumItemWidth = 258
		}
		t1.FriendsLandingPage.GridHorizontalSpacing = p2.Size.Size_600
		t1.FriendsLandingPage.GridVerticalSpacing = p2.Size.Size_600
	end

	return t1
end

return makeFriendsLandingTokenMapper
