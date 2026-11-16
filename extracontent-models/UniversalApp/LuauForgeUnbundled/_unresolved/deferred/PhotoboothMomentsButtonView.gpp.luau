local module = require("@luauforge/deferred/gpo")
local module2 = require("@luauforge/deferred/gpq")
local axTooltip = require("@luauforge/deferred/gpr").Components.AXTooltip
local fFlagAXPhotoboothMomentsLogging = require("@luauforge/deferred/gps").FFlagAXPhotoboothMomentsLogging

local function PhotoboothMomentsButtonView(props)
	local tooltipProps = props.tooltipProps

	local createElement = module.createElement
	local view = module2.View
	local v5 = {
		tag = "row align-x-center align-y-center radius-medium",
		Size = props.size,
		backgroundStyle = props.backgroundStyle,
		onActivated = props.onActivated,
		LayoutOrder = 0,
		ref = 0,
		testId = "PhotoboothMomentsButtonView"
	}
	local v6 = if not tooltipProps then props.LayoutOrder else nil
	v5.LayoutOrder = v6
	local v7 = if fFlagAXPhotoboothMomentsLogging then props.buttonRef else nil
	v5.ref = v7
	local element = createElement(view, v5, {
		Icon = module.createElement(module2.Icon, {
			name = props.iconName,
			size = props.iconSize,
			style = props.iconStyle
		})
	})

	if tooltipProps == nil then
		return element
	end

	return module.createElement(module2.View, {
		tag = "auto-xy",
		LayoutOrder = props.LayoutOrder
	}, {
		Button = element,
		FtuxTooltip = module.createElement(axTooltip, tooltipProps)
	})
end

return PhotoboothMomentsButtonView
