require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle

local ConversationExitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/ConversationExitType")

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PendingState/PendingStateIndicator")
local PendingStateModalContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PendingState/PendingStateModalContainer")

local v5 = {
	topBarHeight = 0,
	networkErrorText = "PLACEHOLDER There was a network error, please try again later",
	onConversationUnmount = function(p2) end,
	navigateToToast = function(p2) end,
	navigateBack = function() end,
	shouldShowPhoneVerificationUpsell = false,
	shouldShowIneligibleModal = false
}

local function PendingStateConversationPage(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6

	local state, setState = useState(0)
	local v7 = useCallback(function(p3)
		setState(p3)
	end, { setState })

	local v8 = useCallback(function()
		joined.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = joined.networkErrorText }
			}
		})
	end, { joined.navigateToToast, joined.networkErrorText })

	local v9 = useRef(ConversationExitType.Default)

	local v10 = useCallback(function(p3, p4, p5)
		if not joined.wideMode and p4 == Enum.SwipeDirection.Right and p5 == 1 then
			v9.current = ConversationExitType.SwipedRight
			joined.navigateBack()
		end
	end, { joined.wideMode, joined.navigateBack })

	useEffect(function()
		return function()
			joined.onConversationUnmount(v9.current)

			v9.current = ConversationExitType.Default
		end
	end, {})

	return React.createElement("TextButton", {
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Transparency = style.Tokens.Color.None.Transparency,
		Text = "",
		LayoutOrder = joined.layoutOrder,
		[React.Event.TouchSwipe] = v10
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PendingStateIndicator = React.createElement(module4, {
			layoutOrder = 1,
			size = UDim2.new(1, 0, 1, -state)
		}),
		ConversationBottomModal = React.createElement(PendingStateModalContainer, {
			conversationId = joined.conversationId,
			showNetworkErrorToast = v8,
			layoutOrder = 2,
			onHeightChanged = v7
		})
	})
end

return memo(PendingStateConversationPage)
