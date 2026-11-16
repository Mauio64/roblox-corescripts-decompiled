local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local AppBlox = require(parent.AppBlox)
local Foundation = require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local reportUnifiedLoggingAction = SduiCoreSystem.reportUnifiedLoggingAction

local ExpandableText = AppBlox.ExpandableText
local View = Foundation.View

local function SduiExpandableText(props)
	local layoutOrder = props.layoutOrder

	local onExpandChanged = React.useCallback(function(isExpanded: boolean)
		if props.onExpandChanged then
			props.onExpandChanged(isExpanded)
		end

		reportUnifiedLoggingAction(props.sduiContext, {
			actionType = "ExpandableTextToggle",
			actionParams = { isExpanded = isExpanded }
		}, props.analyticsContext)
	end, { props.onExpandChanged, props.analyticsContext, props.sduiContext })

	local v = {
		text = props.text,
		LayoutOrder = props.headerComponent and props.text and props.text ~= "" and 2 or layoutOrder,
		compactNumberOfLines = props.compactNumberOfLines,
		fontStyle = props.fontStyle,
		textStyle = props.textStyle,
		pressedTextStyle = props.pressedTextStyle,
		expandedInitially = props.expandedInitially,
		avoidBlankLineClip = props.avoidBlankLineClip,
		onExpandChanged = onExpandChanged,
		selectable = props.selectable
	}

	if props.headerComponent and props.text and props.text ~= "" then
		return React.createElement(View, {
			tag = "size-full-0 auto-y col gap-large",
			LayoutOrder = layoutOrder
		}, {
			Header = React.cloneElement(props.headerComponent, { layoutOrder = 1 }),
			Content = React.createElement(ExpandableText, v)
		})
	end

	return React.createElement(ExpandableText, v)
end

return React.memo(SduiExpandableText)
