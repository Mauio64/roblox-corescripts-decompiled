local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Impressions = require(parent.Impressions)
local ViewportVisibilityImpressionsDetector = Impressions.ViewportVisibilityImpressionsDetector

local SystemBanner = Foundation.SystemBanner

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags.FFlagAppChatConversationTrustedFriendUpsellBanner

local function SduiSystemBanner(props)
	local ref, flag

	if FFlagAppChatConversationTrustedFriendUpsellBanner then
		ref = React.useRef(nil)
		flag = not (props.onView == nil)
	end

	local createElement = React.createElement
	local v = {
		severity = props.severity,
		variant = props.variant,
		title = props.title,
		description = props.description,
		actions = props.actions,
		onClose = props.onClose,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Visible = props.visible,
		ZIndex = props.zIndex,
		testId = props.testId,
		ref = 0
	}
	local ref2

	if flag then
		ref2 = ref
	end

	v.ref = ref2
	local element = createElement(SystemBanner, v)

	if flag then
		return React.createElement(React.Fragment, nil, {
			Banner = element,
			OnViewDetector = React.createElement(ViewportVisibilityImpressionsDetector, {
				targetRef = ref,
				onImpression = props.onView
			})
		})
	end

	return element
end

return React.memo(SduiSystemBanner)
