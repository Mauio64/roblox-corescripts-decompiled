local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local RoduxPresence = require(SocialTabsPage.Rodux.RoduxPresence)
local convertActions = require(SocialTabsPageParent.SocialReducerAdaptors).convertActions
local presenceActionAdaptor = require(SocialTabsPageParent.SocialReducerAdaptors).presenceActionAdaptor
local t1 = {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
}

return convertActions(RoduxPresence.installReducer(), presenceActionAdaptor(RoduxPresence), t1)
