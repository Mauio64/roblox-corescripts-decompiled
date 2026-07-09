local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Constants = require(ParentParent.Constants)
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)

require(ParentParent.Enums.TouchControlsEnum)

local FoundationText = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), View (copy), FoundationText (copy), Constants (copy), Icon (copy)
	local v13 = useTokens()
	local v14 = useLocalization({
		action = t1.action
	})
	local v15 = React.createElement(View, {
		tag = "auto-xy padding-x-large padding-y-xsmall radius-large",
		LayoutOrder = 1,
		backgroundStyle = v13.Color.Extended.Gray.Gray_600
	}, {
		InnerAction = React.createElement(FoundationText, {
			tag = "auto-xy text-align-x-center text-title-small",
			textStyle = v13.Color.Extended.White.White_100,
			Text = v14.action
		})
	})
	local v16 = Constants.HELP_PAGE.TOUCH_ENUM_TO_ICON[t1.touchInput]
	local v17 = v16 and React.createElement(Icon, {
		name = v16,
		size = v13.Size.Size_1200
	})
	local v18 = v16 and React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = 2
	}, {
		InnerIcon = v17
	}) or nil

	return React.createElement(View, {
		tag = "align-x-center auto-xy col gap-small",
		LayoutOrder = t1.layoutOrder
	}, {
		actionComponent = v15,
		iconComponent = v18
	})
end
