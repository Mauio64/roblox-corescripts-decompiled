local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Coachmark = Foundation.Coachmark
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation

local function AbuseReportTooltip(t1: {[any]: any}, p1) -- line: 32
	-- upvalues: useArTranslation (copy), React (copy), Coachmark (copy), PopoverAlign (copy), PopoverSide (copy), ButtonVariant (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v14 = React.useCallback(function() -- line: 35
		-- upvalues: t1 (copy)
		t1.onClose()
	end, { t1.onClose })

	return React.createElement(Coachmark, {
		title = translateIntoString(t1.tooltipTitle),
		text = translateIntoString(t1.tooltipText),
		isOpen = t1.isOpen,
		align = PopoverAlign.End,
		side = PopoverSide.Bottom,
		onClose = t1.onClose,
		actions = if not t1.buttonLabel then nil else {{
			text = translateIntoString(t1.buttonLabel),
			onActivated = v14,
			variant = ButtonVariant.Emphasis
		}},
		LayoutOrder = t1.layoutOrder,
		ref = p1
	}, t1.children)
end

return React.memo(React.forwardRef(AbuseReportTooltip))
