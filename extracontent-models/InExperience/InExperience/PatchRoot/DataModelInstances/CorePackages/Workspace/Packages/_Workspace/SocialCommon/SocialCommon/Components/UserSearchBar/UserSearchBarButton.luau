local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local RoactUtils = require(parent.RoactUtils)
local Localization = require(parent.Localization)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = Localization.Hooks.useLocalization
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local getPageMargin = UIBlox.App.Container.getPageMargin
local useIsWideMode = require(SocialCommon.Hooks.useIsWideMode)
local UserSearchBar = require(SocialCommon.Components.UserSearchBar.UserSearchBar)

local SharedFlags = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub

return function(p)
	local v = useIsWideMode()
	local pageMargin = getPageMargin(useSelector(function(p2)
		return p2.ScreenSize
	end).X)
	local v2 = useLocalization({
		searchPlaceholderText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeopleAltCapitalization"
	})

	local createElement = React.createElement
	local size

	if v then
		size = UDim2.fromOffset(400, 48)
	else
		size = UDim2.new(1, FFlagCreateConnectionsHub and 0 or -2 * pageMargin, 0, 48)
	end

	return createElement(ImageSetButton, {
		BackgroundTransparency = 1,
		Size = size,
		Position = UDim2.new(0, FFlagCreateConnectionsHub and 0 or pageMargin, 0, 0),
		[React.Event.Activated] = p.onActivated
	}, {
		SearchBar = React.createElement(UserSearchBar, {
			isDisabled = true,
			searchPlaceholderText = v2.searchPlaceholderText
		})
	})
end
