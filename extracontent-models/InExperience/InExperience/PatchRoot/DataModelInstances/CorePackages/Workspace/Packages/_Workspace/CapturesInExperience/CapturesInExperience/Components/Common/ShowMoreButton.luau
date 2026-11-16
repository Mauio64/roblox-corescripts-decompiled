local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Localization = require(parent2.Localization)
local React = require(parent2.React)

local useLocalization = Localization.Hooks.useLocalization

local EventNames = require(parent.Analytics.EventNames)
local MenuButton = require(parent.Components.Common.MenuButton)
local useAnalytics = require(parent.Analytics.useAnalytics)

return function(props)
	local v = useAnalytics()
	local v2 = useLocalization({ showMore = "Feature.Avatar.Action.ShowMore" })

	local onActivated = React.useCallback(function()
		v.fireEvent(EventNames.CapturesShowMoreInGameMenu)
		props.onActivated()
	end, { props.onActivated })

	return React.createElement(MenuButton, {
		buttonHeight = props.buttonHeight,
		LayoutOrder = props.LayoutOrder,
		onActivated = onActivated,
		text = v2.showMore
	})
end
