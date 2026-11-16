local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ButtonVariant = Foundation.Enums.ButtonVariant
local Coachmark = Foundation.Coachmark
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local function AbuseReportTooltip(props, ref)
	local translateIntoString = useArTranslation().translateIntoString

	local onActivated = React.useCallback(function()
		props.onClose()
	end, { props.onClose })

	return React.createElement(Coachmark, {
		title = translateIntoString(props.tooltipTitle),
		text = translateIntoString(props.tooltipText),
		isOpen = props.isOpen,
		align = PopoverAlign.End,
		side = PopoverSide.Bottom,
		onClose = props.onClose,
		actions = props.buttonLabel and {
			{
				text = translateIntoString(props.buttonLabel),
				onActivated = onActivated,
				variant = ButtonVariant.Emphasis
			}
		} or nil,
		LayoutOrder = props.layoutOrder,
		ref = ref
	}, props.children)
end

return React.memo(React.forwardRef(AbuseReportTooltip))
