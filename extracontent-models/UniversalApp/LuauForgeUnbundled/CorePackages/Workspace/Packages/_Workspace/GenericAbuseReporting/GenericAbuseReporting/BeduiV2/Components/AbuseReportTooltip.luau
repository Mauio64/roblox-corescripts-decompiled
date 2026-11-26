local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local buttonVariant = Foundation.Enums.ButtonVariant
local coachmark = Foundation.Coachmark
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local function AbuseReportTooltip(props, p2)
	local translateIntoString = useArTranslation().translateIntoString

	local v5 = React.useCallback(function()
		props.onClose()
	end, { props.onClose })

	return React.createElement(coachmark, {
		title = translateIntoString(props.tooltipTitle),
		text = translateIntoString(props.tooltipText),
		isOpen = props.isOpen,
		align = popoverAlign.End,
		side = popoverSide.Bottom,
		onClose = props.onClose,
		actions = props.buttonLabel and {
			{
				text = translateIntoString(props.buttonLabel),
				onActivated = v5,
				variant = buttonVariant.Emphasis
			}
		} or nil,
		LayoutOrder = props.layoutOrder,
		ref = p2
	}, props.children)
end

return React.memo(React.forwardRef(AbuseReportTooltip))
