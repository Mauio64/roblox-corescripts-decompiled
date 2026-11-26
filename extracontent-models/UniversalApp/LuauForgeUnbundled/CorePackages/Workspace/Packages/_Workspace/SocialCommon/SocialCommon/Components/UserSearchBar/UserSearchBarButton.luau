local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/RoactUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Localization")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = Localization.Hooks.useLocalization
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local getPageMargin = UIBlox.App.Container.getPageMargin
local useIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Hooks/useIsWideMode")
local UserSearchBar = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/UserSearchBar/UserSearchBar")

local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags").FFlagCreateConnectionsHub

return function(p2)
	local v5 = useIsWideMode()
	local pageMargin = getPageMargin(useSelector(function(p3)
		return p3.ScreenSize
	end).X)
	local v7 = useLocalization({
		searchPlaceholderText = "Feature.AddFriends.Label.InputPlaceholder.SearchForPeopleAltCapitalization"
	})

	local createElement = React.createElement

	local v9 = if v5 then UDim2.fromOffset(400, 48) else UDim2.new(
		1,
		fFlagCreateConnectionsHub and 0 or -2 * pageMargin,
		0,
		48
	)
	return createElement(imageSetButton, {
		BackgroundTransparency = 1,
		Size = v9,
		Position = UDim2.new(0, fFlagCreateConnectionsHub and 0 or pageMargin, 0, 0),
		[React.Event.Activated] = p2.onActivated
	}, {
		SearchBar = React.createElement(UserSearchBar, {
			isDisabled = true,
			searchPlaceholderText = v7.searchPlaceholderText
		})
	})
end
