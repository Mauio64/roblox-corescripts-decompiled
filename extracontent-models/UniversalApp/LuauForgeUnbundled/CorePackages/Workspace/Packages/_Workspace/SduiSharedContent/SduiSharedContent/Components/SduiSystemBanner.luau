local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local viewportVisibilityImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Impressions").ViewportVisibilityImpressionsDetector

local systemBanner = Foundation.SystemBanner

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner

local function SduiSystemBanner(props)
	local ref, flag

	if fFlagAppChatConversationTrustedFriendUpsellBanner then
		ref = React.useRef(nil)
		flag = not (props.onView == nil)
	end

	local element = React.createElement(systemBanner, {
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
		ref = if flag then ref else nil
	})

	if flag then
		return React.createElement(React.Fragment, nil, {
			Banner = element,
			OnViewDetector = React.createElement(viewportVisibilityImpressionsDetector, {
				targetRef = ref,
				onImpression = props.onView
			})
		})
	end

	return element
end

return React.memo(SduiSystemBanner)
