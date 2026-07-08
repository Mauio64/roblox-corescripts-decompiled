local SocialCommon = script:FindFirstAncestor("SocialCommon")
local SocialCommonParent = SocialCommon.Parent
local React = require(SocialCommonParent.React)
local UIBlox = require(SocialCommonParent.UIBlox)
local RoactUtils = require(SocialCommonParent.RoactUtils)
local Localization = require(SocialCommonParent.Localization)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = Localization.Hooks.useLocalization
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local getPageMargin = UIBlox.App.Container.getPageMargin
local useIsWideMode = require(SocialCommon.Hooks.useIsWideMode)
local UserSearchBar = require(SocialCommon.Components.UserSearchBar.UserSearchBar)
local FFlagCreateConnectionsHub = require(SocialCommonParent.SharedFlags).FFlagCreateConnectionsHub

return function(p1) -- line: 31
	-- upvalues: useIsWideMode (copy), useSelector (copy), getPageMargin (copy), useLocalization (copy), React (copy), ImageSetButton (copy), FFlagCreateConnectionsHub (copy), UserSearchBar (copy)
	local v15 = useIsWideMode()
	local v16 = useSelector(function(p2) -- line: 35
		return p2.ScreenSize
	end)
	local v17 = getPageMargin(v16.X)
	local v18 = useLocalization({
		searchPlaceholderText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeople"
	})

	return React.createElement(ImageSetButton, {
		BackgroundTransparency = 1,
		Size = if not v15 then UDim2.new(1, if not FFlagCreateConnectionsHub then -2 * v17 else 0, 0, 48) else UDim2.fromOffset(400, 48),
		Position = UDim2.new(0, if not FFlagCreateConnectionsHub then v17 else 0, 0, 0),
		[React.Event.Activated] = p1.onActivated
	}, {
		SearchBar = React.createElement(UserSearchBar, {
			isDisabled = true,
			searchPlaceholderText = v18.searchPlaceholderText
		})
	})
end
