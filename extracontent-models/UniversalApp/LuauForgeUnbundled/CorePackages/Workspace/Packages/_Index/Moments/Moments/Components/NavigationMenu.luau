local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local FFlagMomentsFollowingFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFollowingFeed")
local useTrendingFeedLabel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useTrendingFeedLabel")

local threeDotsHorizontal = BuilderIcons.Icon.ThreeDotsHorizontal

local iconButton = Foundation.IconButton
local menu = Foundation.Menu

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState

local v5 = {
	trending = "Feature.Moments.Label.FeedTrending",
	myMoments = "Feature.Moments.Label.FeedMyMoments"
}

local function NavigationMenu(props)
	local v6 = useLocalization(v5)
	local v7 = v6.trending

	if FFlagMomentsFollowingFeed then
		v7 = useTrendingFeedLabel()
	end

	local v8 = useToggleState()

	local v9 = React.useCallback(function()
		if v8.enabled then
			v8.disable()
		else
			v8.enable()
		end
	end, { v8.enabled, v8.enable, v8.disable })

	local v10 = React.useCallback(function()
		v8.disable()
		props.onNavigateToTrending()
	end, { v8.disable, props.onNavigateToTrending })

	local v11 = React.useCallback(function()
		v8.disable()
		props.onNavigateToMyMoments()
	end, { v8.disable, props.onNavigateToMyMoments })

	local v12 = React.useMemo(function()
		return {
			{ id = "trending", text = v7, onActivated = v10 },
			{ id = "myMoments", text = v6.myMoments, onActivated = v11 }
		}
	end, { v10, v11, v6, v7 })

	local element = React.createElement(iconButton, {
		LayoutOrder = props.layoutOrder,
		icon = threeDotsHorizontal,
		onActivated = v9,
		variant = props.buttonVariant or buttonVariant.OverMedia,
		size = inputSize.Medium,
		isCircular = true,
		Selectable = true,
		testId = props.buttonTestId or "--moments-navigation-menu-button"
	})

	return React.createElement(menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v8.enabled,
		items = v12,
		LayoutOrder = props.layoutOrder,
		onPressedOutside = v8.disable,
		side = Foundation.Enums.PopoverSide.Bottom
	}, { MoreMenuButton = element })
end

return NavigationMenu
