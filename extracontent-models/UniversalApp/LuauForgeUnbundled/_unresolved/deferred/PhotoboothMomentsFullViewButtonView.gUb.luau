local module = require("@luauforge/deferred/gTR")
local module2 = require("@luauforge/deferred/gTT")
local fFlagAXPhotoboothMomentsLogging = require("@luauforge/deferred/gTV").FFlagAXPhotoboothMomentsLogging

local function PhotoboothMomentsFullViewButtonView(props)
	local createElement = module.createElement
	local view = module2.View
	local v5 = {
		tag = "auto-xy row align-y-center gap-small padding-x-large padding-y-medium radius-medium",
		backgroundStyle = props.backgroundStyle,
		onActivated = props.onActivated,
		LayoutOrder = props.LayoutOrder,
		ref = 0,
		testId = "PhotoboothMomentsFullViewButtonView"
	}
	local v6 = if fFlagAXPhotoboothMomentsLogging then props.buttonRef else nil
	v5.ref = v6
	return createElement(view, v5, {
		Icon = module.createElement(module2.Icon, {
			name = props.iconName,
			size = props.iconSize,
			style = props.contentStyle,
			LayoutOrder = 1
		}),
		Text = module.createElement(module2.Text, {
			tag = "auto-xy text-title-medium",
			Text = props.text,
			textStyle = props.contentStyle,
			LayoutOrder = 2
		})
	})
end

return PhotoboothMomentsFullViewButtonView
