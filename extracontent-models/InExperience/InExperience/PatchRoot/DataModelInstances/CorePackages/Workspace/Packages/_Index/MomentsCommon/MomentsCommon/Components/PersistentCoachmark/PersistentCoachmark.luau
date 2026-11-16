local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Foundation = require(parent3.Foundation)
local React = require(parent3.React)

require(parent2.Utils.createCoachmarkImpressionCache)
local usePersistentCoachmarkViewModel = require(parent.usePersistentCoachmarkViewModel)

local EducationalTooltip = Foundation.EducationalTooltip

local function PersistentCoachmark(props)
	local v = usePersistentCoachmarkViewModel({
		impressionCache = props.impressionCache,
		maxImpressions = props.maxImpressions,
		autoDismissSeconds = props.autoDismissSeconds,
		isSessionHandled = props.isSessionHandled,
		onSessionHandled = props.onSessionHandled,
		onImpression = props.onImpression,
		onDismissed = props.onDismissed
	})

	return React.createElement(EducationalTooltip, {
		LayoutOrder = props.layoutOrder,
		isOpen = v.isOpen and not props.hidden,
		onClose = v.onClose,
		side = props.side or Foundation.Enums.PopoverSide.Bottom,
		align = props.align or Foundation.Enums.PopoverAlign.End,
		title = props.title,
		text = props.text
	}, props.children)
end

return PersistentCoachmark
