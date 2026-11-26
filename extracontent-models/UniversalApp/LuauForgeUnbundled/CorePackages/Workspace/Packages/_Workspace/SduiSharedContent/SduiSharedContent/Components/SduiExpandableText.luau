local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local reportUnifiedLoggingAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem").reportUnifiedLoggingAction

local expandableText = AppBlox.ExpandableText
local view = Foundation.View

local function SduiExpandableText(props)
	local layoutOrder = props.layoutOrder

	local v5 = React.useCallback(function(p2)
		if props.onExpandChanged then
			props.onExpandChanged(p2)
		end

		reportUnifiedLoggingAction(props.sduiContext, {
			actionType = "ExpandableTextToggle",
			actionParams = { isExpanded = p2 }
		}, props.analyticsContext)
	end, { props.onExpandChanged, props.analyticsContext, props.sduiContext })

	local v6 = {
		text = props.text,
		LayoutOrder = props.headerComponent and props.text and props.text ~= "" and 2 or layoutOrder,
		compactNumberOfLines = props.compactNumberOfLines,
		fontStyle = props.fontStyle,
		textStyle = props.textStyle,
		pressedTextStyle = props.pressedTextStyle,
		expandedInitially = props.expandedInitially,
		avoidBlankLineClip = props.avoidBlankLineClip,
		onExpandChanged = v5,
		selectable = props.selectable
	}

	if props.headerComponent and props.text and props.text ~= "" then
		return React.createElement(
			view,
			{ tag = "size-full-0 auto-y col gap-large", LayoutOrder = layoutOrder },
			{
				Header = React.cloneElement(props.headerComponent, { layoutOrder = 1 }),
				Content = React.createElement(expandableText, v6)
			}
		)
	end

	return React.createElement(expandableText, v6)
end

return React.memo(SduiExpandableText)
