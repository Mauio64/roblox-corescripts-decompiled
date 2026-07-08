local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local ConversationExitType = require(AppChat.Analytics.Enums.ConversationExitType)
local PendingStateIndicator = require(script.Parent.PendingStateIndicator)
local PendingStateModalContainer = require(script.Parent.PendingStateModalContainer)
local t1 = {
	topBarHeight = 0,
	networkErrorText = "PLACEHOLDER There was a network error, please try again later",
	shouldShowPhoneVerificationUpsell = false,
	shouldShowIneligibleModal = false,
	onConversationUnmount = function(_) -- line: 46
	end,
	navigateToToast = function(_) -- line: 47
	end,
	navigateBack = function() -- line: 48
	end
}

local function PendingStateConversationPage(t2: {[any]: any}) -- line: 56
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useState (copy), useCallback (copy), useRef (copy), ConversationExitType (copy), useEffect (copy), React (copy), PendingStateIndicator (copy), PendingStateModalContainer (copy)
	local v19 = Cryo.Dictionary.join(t1, t2)
	local v20 = useStyle()
	local v21 = v19.style or v20
	local v22, v23 = useState(0)
	local v24 = useCallback(function(p3) -- line: 62
		-- upvalues: v23 (copy)
		v23(p3)
	end, { v23 })
	local v25 = useCallback(function() -- line: 66
		-- upvalues: v19 (copy)
		v19.navigateToToast({
			toastProps = {
				toastContent = {
					toastTitle = v19.networkErrorText
				}
			}
		})
	end, {
		v19.navigateToToast,
		v19.networkErrorText
	})
	local v26 = useRef(ConversationExitType.Default)
	local v27 = useCallback(function(_, p5, p6) -- line: 78
		-- upvalues: v19 (copy), v26 (copy), ConversationExitType (copy)
		if not v19.wideMode and (p5 == Enum.SwipeDirection.Right and p6 == 1) then
			v26.current = ConversationExitType.SwipedRight
			v19.navigateBack()
		end
	end, {
		v19.wideMode,
		v19.navigateBack
	})

	useEffect(function() -- line: 85
		-- upvalues: v19 (copy), v26 (copy), ConversationExitType (copy)
		return function() -- line: 86
			-- upvalues: v19 (copy), v26 (copy), ConversationExitType (copy)
			v19.onConversationUnmount(v26.current)
			v26.current = ConversationExitType.Default
		end
	end, {})

	return React.createElement("TextButton", {
		BackgroundColor3 = v21.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Transparency = v21.Tokens.Color.None.Transparency,
		Text = "",
		LayoutOrder = v19.layoutOrder,
		[React.Event.TouchSwipe] = v27
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PendingStateIndicator = React.createElement(PendingStateIndicator, {
			layoutOrder = 1,
			size = UDim2.new(1, 0, 1, -v22)
		}),
		ConversationBottomModal = React.createElement(PendingStateModalContainer, {
			layoutOrder = 2,
			conversationId = v19.conversationId,
			showNetworkErrorToast = v25,
			onHeightChanged = v24
		})
	})
end

return memo(PendingStateConversationPage)
