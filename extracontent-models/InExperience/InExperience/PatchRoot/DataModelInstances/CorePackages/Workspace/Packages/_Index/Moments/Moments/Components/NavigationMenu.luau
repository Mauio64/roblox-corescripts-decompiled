local Parent = script:FindFirstAncestor("Moments").Parent
local BuilderIcons = require(Parent.BuilderIcons)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local MomentsCommon = require(Parent.MomentsCommon)
local React = require(Parent.React)
local ThreeDotsHorizontal = BuilderIcons.Icon.ThreeDotsHorizontal
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState
local t1 = {
	trending = "Feature.Moments.Label.FeedTrending",
	myMoments = "Feature.Moments.Label.FeedMyMoments"
}

local function NavigationMenu(t2: {[any]: any}) -- line: 32
	-- upvalues: useLocalization (copy), t1 (copy), useToggleState (copy), React (copy), Menu (copy), Foundation (copy), IconButton (copy), ThreeDotsHorizontal (copy), ButtonVariant (copy), InputSize (copy)
	local v17 = useLocalization(t1)
	local v18 = useToggleState()
	local v19 = React.useCallback(function() -- line: 39
		-- upvalues: v18 (copy)
		if v18.enabled then
			v18.disable()

			return
		end

		v18.enable()
	end, {
		v18.enabled,
		v18.enable,
		v18.disable
	})
	local v20 = React.useCallback(function() -- line: 47
		-- upvalues: v18 (copy), t2 (copy)
		v18.disable()
		t2.onNavigateToTrending()
	end, {
		v18.disable,
		t2.onNavigateToTrending
	})
	local v21 = React.useCallback(function() -- line: 52
		-- upvalues: v18 (copy), t2 (copy)
		v18.disable()
		t2.onNavigateToMyMoments()
	end, {
		v18.disable,
		t2.onNavigateToMyMoments
	})
	local v22 = React.useMemo(function() -- line: 57
		-- upvalues: v17 (copy), v20 (copy), v21 (copy)
		return {
			{
				id = "trending",
				text = v17.trending,
				onActivated = v20
			},
			{
				id = "myMoments",
				text = v17.myMoments,
				onActivated = v21
			}
		}
	end, {
		v20,
		v21,
		v17
	})

	return React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = v18.enabled,
		items = v22,
		LayoutOrder = t2.layoutOrder,
		onPressedOutside = v18.disable,
		side = Foundation.Enums.PopoverSide.Bottom
	}, {
		MoreMenuButton = React.createElement(IconButton, {
			isCircular = true,
			Selectable = true,
			testId = "--moments-navigation-menu-button",
			LayoutOrder = t2.layoutOrder,
			icon = ThreeDotsHorizontal,
			onActivated = v19,
			variant = ButtonVariant.OverMedia,
			size = InputSize.Medium
		})
	})
end

return NavigationMenu
