local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
require(AppChat.types)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums.DeviceType

local Logger = require(script.Parent.Logger)
local EventNames = require(AppChat.Analytics.EventNames)

local AppChatNetworking = require(parent.AppChatNetworking)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local PeekView = require(parent.PeekView)
local peekView = PeekView.PeekView
local PeekView2 = require(parent.PeekView)
local PeekViewState = PeekView2.PeekViewState
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

local useStyle = UIBlox.Core.Style.useStyle
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)

local useReplyingToMessageDispatch = require(AppChat.Components.ChatConversation.MessageInteraction.ReplyingContext.useReplyingToMessageDispatch)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useAnalytics = require(AppChat.Analytics.useAnalytics)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local getFFlagAppChatEnableManualTranslation = require(AppChat.Flags.getFFlagAppChatEnableManualTranslation)

local v = {
	message = nil,
	userOwnsMessage = false,
	inputBoxRef = React.createRef(),
	unitTestDeviceType = nil,
	unitTestScreenSize = nil
}

if v.unitTestDeviceType ~= nil then
	Logger:error("Default unit test device type must ALWAYS BE NIL!")
	error("Default unit test device type was not nil.")
end

if v.unitTestScreenSize ~= nil then
	Logger:error("Default unit test screen size must ALWAYS BE NIL!")
	error("Default unit test screen size was not nil.")
end

function MessageContextMenu(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2

	if FFlagAppChatSignalsReplyStore then
		v2 = GetReplyingToStore(false)
	else
		v2 = nil
	end

	local v3 = useReplyingToMessageDispatch()

	local tokens = useStyle().Tokens

	local ref = React.useRef(Signal.new())

	local screenSize = union.unitTestScreenSize or useLayerCollector().absoluteSize
	local v4 = useNavigation()
	local unitTestDeviceType = union.unitTestDeviceType or useDeviceType()
	local v5 = useAnalytics()

	local v6 = useLocalization({
		replyText = "Feature.Chat.Action.Reply",
		copyText = "Feature.Chat.Action.Copy",
		editText = "Feature.Chat.Action.Edit",
		deleteText = "Feature.Chat.Action.Delete",
		reportText = "Feature.Chat.Action.Report",
		translateText = "Feature.Chat.Action.Translate"
	})

	local v7 = React.useCallback(function(p2)
		if v5 then
			local fireAnalyticsEvent = v5.fireAnalyticsEvent
			local conversationId

			if union.message then
				conversationId = union.message.conversationId
			end

			local targetMessageSenderId

			if union.message then
				targetMessageSenderId = union.message.senderTargetId
			end

			local targetMessageId

			if union.message then
				targetMessageId = union.message.id
			end

			local targetMessageSentAt

			if union.message and union.message.sent then
				targetMessageSentAt = tostring(union.message.sent.dateTime)
			end

			fireAnalyticsEvent(p2, {
				conversationId = conversationId,
				targetMessageSenderId = targetMessageSenderId,
				targetMessageId = targetMessageId,
				targetMessageSentAt = targetMessageSentAt,
				targetMessageLength = union.message and union.message.content and #union.message.content or nil
			})
		end
	end, { union.message })

	local ref2 = React.useRef(false)

	local v8 = React.useCallback(function()
		if union.inputBoxRef and union.inputBoxRef.current then
			union.inputBoxRef.current:CaptureFocus()
		end
	end, { union.inputBoxRef })

	local v9 = React.useCallback(function()
		v4.goBack()
	end, { v4 and v4.goBack })

	local v10 = React.useCallback(function()
		ref.current:fire()
	end, { ref.current })

	local viewStateChanged = React.useCallback(function(p2, _)
		if p2 == PeekViewState.Closed then
			v9()
		end
	end, { v9 })

	React.useEffect(function()
		v7(EventNames.ChatMessageMenuOpened)

		if union.inputBoxRef and union.inputBoxRef.current then
			ref2.current = union.inputBoxRef.current:IsFocused()
		end
	end, {})

	local v11 = React.useCallback(function()
		if unitTestDeviceType == DeviceType.Phone then
			v10()
		else
			v9()
		end
	end, { unitTestDeviceType, v10, v9 })

	local onDismiss = React.useCallback(function()
		v11()

		if ref2.current then
			v8()
		end
	end, { v11, ref2.current, v8 })

	local useCallback = React.useCallback
	local function fn()
		v7(EventNames.ChatMessageMenuReplyBtnActivated)
		v11()

		if FFlagAppChatSignalsReplyStore and v2 then
			v2.setReplyingTo(union.message.id)
		else
			v3(union.message)
		end

		v8()
	end

	local v12

	if FFlagAppChatSignalsReplyStore then
		v12 = v2
	end

	local onActivated = useCallback(fn, { v7, v11, v12, v3, union.message, v8 })

	local onActivated2 = React.useCallback(function()
		v7(EventNames.ChatMessageMenuCopyBtnActivated)
		v11()

		default:shareText({
			text = union.message.content,
			context = "AppChat-ChatConversation-MessageContextMenu"
		})
	end, { v7, v11, union.message })

	local onActivated3 = React.useCallback(function() end)

	local onActivated4 = React.useCallback(function() end)
	local onActivated5

	if getFFlagAppChatEnableManualTranslation() then
		local v13 = useDispatch()
		onActivated5 = React.useCallback(function()
			v11()
			v13(AppChatNetworking.rodux.TranslateUserMessage.API(union.message.conversationId, union.message.id)):catch(function(p2)
				Logger:error("Error translating message: ", p2)
			end)
		end, { union.message, v11, v13 })
	else
		onActivated5 = nil
	end

	local onActivated6 = React.useCallback(function() end)

	local useMemo = React.useMemo
	local function fn2()
		local v13 = {
			{
				icon = Images["icons/placeholder/placeholderOff"],
				text = v6.replyText,
				onActivated = onActivated
			},
			{
				icon = Images["icons/actions/edit/copy"],
				text = v6.copyText,
				onActivated = onActivated2
			}
		}

		if union.userOwnsMessage then
			table.insert(v13, {
				icon = Images["icons/actions/edit/edit"],
				text = v6.editText,
				onActivated = onActivated3
			})

			table.insert(v13, {
				icon = Images["icons/actions/edit/delete"],
				iconColorOverride = tokens.Color.System.Alert.Color3,
				text = v6.deleteText,
				textColorOverride = tokens.Color.System.Alert.Color3,
				onActivated = onActivated4
			})
		else
			if getFFlagAppChatEnableManualTranslation() then
				table.insert(v13, {
					icon = Images["icons/placeholder/placeholderOff"],
					text = "Translate",
					onActivated = onActivated5
				})
			end

			table.insert(v13, {
				icon = Images["icons/placeholder/placeholderOff"],
				iconColorOverride = tokens.Color.System.Alert.Color3,
				text = v6.reportText,
				textColorOverride = tokens.Color.System.Alert.Color3,
				onActivated = onActivated6
			})
		end

		return v13
	end

	local replyText = v6.replyText
	local copyText = v6.copyText
	local editText = v6.editText
	local deleteText = v6.deleteText
	local reportText = v6.reportText
	local translateText = v6.translateText
	local v13

	if getFFlagAppChatEnableManualTranslation() then
		v13 = onActivated5
	end

	local buttonProps = useMemo(fn2, {
		replyText,
		copyText,
		editText,
		deleteText,
		reportText,
		translateText,
		onActivated,
		onActivated2,
		onActivated3,
		onActivated4,
		v13,
		onActivated6,
		union.userOwnsMessage
	})

	local v14 = #buttonProps * 56
	local vector2, udim, udim2, borderCornerRadius

	if unitTestDeviceType == DeviceType.Desktop or unitTestDeviceType == DeviceType.Tablet then
		vector2 = Vector2.new(0.5, 0.5)
		udim = UDim.new(0.5, 0)
		udim2 = UDim.new(0.5, 0)
		borderCornerRadius = 20
	else
		screenSize = Vector2.new(0, 0)
		vector2 = Vector2.new(0.5, 1)

		udim = UDim.new(0, v14)
		udim2 = UDim.new(1, 0)
		borderCornerRadius = 0
	end

	local element = React.createElement(ContextualMenu, {
		screenSize = screenSize,
		menuDirection = MenuDirection.Up,
		openPositionY = udim,
		anchorPointOverride = vector2,
		horizontalAlignment = Enum.HorizontalAlignment.Center,
		contextMenuWidthOverride = udim2,
		borderCornerRadius = borderCornerRadius,
		buttonProps = buttonProps,
		isElementBackgroundVisible = true,
		isElementDividerVisible = true,
		open = true,
		onDismiss = onDismiss
	})

	local element2 = React.createElement(
		"ImageButton",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Event.Activated] = onDismiss
		},
		{
			PeekView = React.createElement(peekView, {
				briefViewContentHeight = UDim.new(0, v14),
				fullViewContentHeight = UDim.new(1, -v14),
				mountAsFullView = false,
				mountAnimation = true,
				showDraggerInClosedState = false,
				closeSignal = ref.current,
				viewStateChanged = viewStateChanged
			}, { element })
		}
	)

	if unitTestDeviceType == DeviceType.Desktop or unitTestDeviceType == DeviceType.Tablet then
		return element
	end

	return element2
end

return React.memo(MessageContextMenu)
