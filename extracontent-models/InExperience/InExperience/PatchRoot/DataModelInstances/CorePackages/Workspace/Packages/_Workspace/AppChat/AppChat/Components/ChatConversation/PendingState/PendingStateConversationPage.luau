local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local ConversationExitType = require(AppChat.Analytics.Enums.ConversationExitType)

local PendingStateIndicator = require(script.Parent.PendingStateIndicator)
local PendingStateModalContainer = require(script.Parent.PendingStateModalContainer)

local v = {
	topBarHeight = 0,
	networkErrorText = "PLACEHOLDER There was a network error, please try again later",
	onConversationUnmount = function(_) end,
	navigateToToast = function(_) end,
	navigateBack = function() end,
	shouldShowPhoneVerificationUpsell = false,
	shouldShowIneligibleModal = false
}

local function PendingStateConversationPage(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2

	local state, setState = useState(0)
	local onHeightChanged = useCallback(function(p2)
		setState(p2)
	end, { setState })

	local showNetworkErrorToast = useCallback(function()
		joined.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = joined.networkErrorText }
			}
		})
	end, { joined.navigateToToast, joined.networkErrorText })

	local v3 = useRef(ConversationExitType.Default)

	local v4 = useCallback(function(_, p2, p3)
		if not joined.wideMode and p2 == Enum.SwipeDirection.Right and p3 == 1 then
			v3.current = ConversationExitType.SwipedRight
			joined.navigateBack()
		end
	end, { joined.wideMode, joined.navigateBack })

	useEffect(function()
		return function()
			joined.onConversationUnmount(v3.current)

			v3.current = ConversationExitType.Default
		end
	end, {})

	return React.createElement("TextButton", {
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Transparency = style.Tokens.Color.None.Transparency,
		Text = "",
		LayoutOrder = joined.layoutOrder,
		[React.Event.TouchSwipe] = v4
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PendingStateIndicator = React.createElement(PendingStateIndicator, {
			layoutOrder = 1,
			size = UDim2.new(1, 0, 1, -state)
		}),
		ConversationBottomModal = React.createElement(PendingStateModalContainer, {
			conversationId = joined.conversationId,
			showNetworkErrorToast = showNetworkErrorToast,
			layoutOrder = 2,
			onHeightChanged = onHeightChanged
		})
	})
end

return memo(PendingStateConversationPage)
