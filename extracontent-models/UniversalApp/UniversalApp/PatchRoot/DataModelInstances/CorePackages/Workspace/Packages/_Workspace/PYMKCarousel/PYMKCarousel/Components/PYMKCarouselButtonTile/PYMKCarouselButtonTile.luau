local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local useLocalization = dependencies.Hooks.useLocalization
local TextKeys = require(ParentParent.Common.TextKeys)
local Analytics = require(ParentParent.Analytics)
local EventNames = Analytics.EventNames
local BtnValues = Analytics.BtnValues
local CarouselGenericSquareTile = dependencies.SocialCommon.Components.CarouselGenericSquareTile
local UIBlox = dependencies.UIBlox
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local v13 = Images["icons/graphic/findfriends_large"]
local v14 = Images["icons/navigation/pushRight"]

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), TextKeys (copy), EventNames (copy), BtnValues (copy), React (copy), CarouselGenericSquareTile (copy), v13 (copy), v14 (copy), IconSize (copy)
	local v16 = useLocalization({
		findFriendsLabel = TextKeys.FindFriendsLabel,
		seeAllLabel = TextKeys.SeeAllLabel,
		newTextBadge = TextKeys.NewText
	})

	if t1.id == BtnValues.FindFriends.rawValue() then
		local createElement = React.createElement
		local v18 = CarouselGenericSquareTile
		local t2 = {
			borderThickness = 1,
			badgeValue = if not t1.shouldShowContactImporterBadge then nil else v16.newTextBadge,
			icon = v13,
			labelText = v16.findFriendsLabel
		}
		local v20 = BtnValues.FindFriends.rawValue()
		local v21 = true

		function t2.onActivated() -- line: 35
			-- upvalues: t1 (copy), EventNames (copy), v20 (copy), v21 (copy)
			t1.fireAnalyticsEvent(EventNames.CarouselGenericTileClicked, {
				btn = v20
			})
			t1.goToAddFriendsPage(v21)
		end

		t2.tileSize = t1.tileWidth
		t2.LayoutOrder = t1.LayoutOrder

		return createElement(v18, t2)
	end

	if t1.id == BtnValues.SeeAll.rawValue() then
		local createElement = React.createElement
		local v23 = CarouselGenericSquareTile
		local t3 = {
			icon = v14,
			iconSize = IconSize.Medium,
			labelText = v16.seeAllLabel
		}
		local v25, v26 = BtnValues.SeeAll.rawValue()

		function t3.onActivated() -- line: 35
			-- upvalues: t1 (copy), EventNames (copy), v25 (copy), v26 (copy)
			t1.fireAnalyticsEvent(EventNames.CarouselGenericTileClicked, {
				btn = v25
			})
			t1.goToAddFriendsPage(v26)
		end

		t3.tileSize = t1.tileWidth
		t3.LayoutOrder = t1.LayoutOrder

		return createElement(v23, t3)
	end

	return nil
end
