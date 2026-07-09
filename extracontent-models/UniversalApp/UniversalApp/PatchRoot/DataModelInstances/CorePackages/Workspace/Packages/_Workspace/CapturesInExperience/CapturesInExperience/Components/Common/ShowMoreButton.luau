local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local useLocalization = Localization.Hooks.useLocalization
local EventNames = require(ParentParent.Analytics.EventNames)
local MenuButton = require(ParentParent.Components.Common.MenuButton)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useAnalytics (copy), useLocalization (copy), React (copy), EventNames (copy), MenuButton (copy)
	local v10 = useAnalytics()
	local v11 = useLocalization({
		showMore = "Feature.Avatar.Action.ShowMore"
	})
	local v12 = React.useCallback(function() -- line: 25
		-- upvalues: v10 (copy), EventNames (copy), t1 (copy)
		v10.fireEvent(EventNames.CapturesShowMoreInGameMenu)
		t1.onActivated()
	end, { t1.onActivated })

	return React.createElement(MenuButton, {
		buttonHeight = t1.buttonHeight,
		LayoutOrder = t1.LayoutOrder,
		onActivated = v12,
		text = v11.showMore
	})
end
