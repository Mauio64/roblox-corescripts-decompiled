local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local FFlagMomentsFollowingFeed = require(Moments.Flags.FFlagMomentsFollowingFeed)
local useTrendingFeedLabel = require(Moments.Hooks.useTrendingFeedLabel)

local ThreeDotsHorizontal = BuilderIcons.Icon.ThreeDotsHorizontal

local IconButton = Foundation.IconButton
local Menu = Foundation.Menu

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState

local v = {
	trending = "Feature.Moments.Label.FeedTrending",
	myMoments = "Feature.Moments.Label.FeedMyMoments"
}

local function NavigationMenu(props)
	local v2 = useLocalization(v)
	local text = v2.trending

	if FFlagMomentsFollowingFeed then
		text = useTrendingFeedLabel()
	end

	local v3 = useToggleState()

	local onActivated = React.useCallback(function()
		if v3.enabled then
			v3.disable()
		else
			v3.enable()
		end
	end, { v3.enabled, v3.enable, v3.disable })

	local onActivated2 = React.useCallback(function()
		v3.disable()
		props.onNavigateToTrending()
	end, { v3.disable, props.onNavigateToTrending })

	local onActivated3 = React.useCallback(function()
		v3.disable()
		props.onNavigateToMyMoments()
	end, { v3.disable, props.onNavigateToMyMoments })

	local items = React.useMemo(function()
		return {
			{ id = "trending", text = text, onActivated = onActivated2 },
			{ id = "myMoments", text = v2.myMoments, onActivated = onActivated3 }
		}
	end, { onActivated2, onActivated3, v2, text })

	local element = React.createElement(IconButton, {
		LayoutOrder = props.layoutOrder,
		icon = ThreeDotsHorizontal,
		onActivated = onActivated,
		variant = props.buttonVariant or ButtonVariant.OverMedia,
		size = InputSize.Medium,
		isCircular = true,
		Selectable = true,
		testId = props.buttonTestId or "--moments-navigation-menu-button"
	})

	return React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v3.enabled,
		items = items,
		LayoutOrder = props.layoutOrder,
		onPressedOutside = v3.disable,
		side = Foundation.Enums.PopoverSide.Bottom
	}, { MoreMenuButton = element })
end

return NavigationMenu
