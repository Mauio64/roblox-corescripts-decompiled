local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Signal
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").DeviceType

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/Logger")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local images = UIBlox.App.ImageSet.Images
local peekView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PeekView").PeekView
local peekViewState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PeekView").PeekViewState
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default

local useStyle = UIBlox.Core.Style.useStyle
local useDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useDeviceType
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local GetReplyingToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetReplyingToStore")

local useReplyingToMessageDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/useReplyingToMessageDispatch")
local FFlagAppChatSignalsReplyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsReplyStore")
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch

local getFFlagAppChatEnableManualTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatEnableManualTranslation")

local v5 = {
	message = nil,
	userOwnsMessage = false,
	inputBoxRef = React.createRef(),
	unitTestDeviceType = nil,
	unitTestScreenSize = nil
}

if v5.unitTestDeviceType ~= nil then
	Logger:error("Default unit test device type must ALWAYS BE NIL!")
	error("Default unit test device type was not nil.")
end

if v5.unitTestScreenSize ~= nil then
	Logger:error("Default unit test screen size must ALWAYS BE NIL!")
	error("Default unit test screen size was not nil.")
end

function LUAUFORGE_MODULE_GLOBALS_hps_MessageContextMenu(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = if FFlagAppChatSignalsReplyStore then GetReplyingToStore(false) else nil
	local v7 = useReplyingToMessageDispatch()

	local tokens = useStyle().Tokens

	local ref = React.useRef(signal.new())

	local v8 = union.unitTestScreenSize or useLayerCollector().absoluteSize
	local v9 = useNavigation()
	local unitTestDeviceType = union.unitTestDeviceType or useDeviceType()
	local v10 = useAnalytics()

	local v11 = useLocalization({
		replyText = "Feature.Chat.Action.Reply",
		copyText = "Feature.Chat.Action.Copy",
		editText = "Feature.Chat.Action.Edit",
		deleteText = "Feature.Chat.Action.Delete",
		reportText = "Feature.Chat.Action.Report",
		translateText = "Feature.Chat.Action.Translate"
	})

	local v12 = React.useCallback(function(p3)
		if v10 then
			local fireAnalyticsEvent = v10.fireAnalyticsEvent
			local v14 = if union.message then union.message.conversationId else nil
			local v15 = if union.message then union.message.senderTargetId else nil
			local v16 = if union.message then union.message.id else nil
			local v17 = if union.message and union.message.sent then tostring(union.message.sent.dateTime) else nil
			fireAnalyticsEvent(p3, {
				conversationId = v14,
				targetMessageSenderId = v15,
				targetMessageId = v16,
				targetMessageSentAt = v17,
				targetMessageLength = union.message and union.message.content and #union.message.content or nil
			})
		end
	end, { union.message })

	local ref2 = React.useRef(false)

	local v13 = React.useCallback(function()
		if union.inputBoxRef and union.inputBoxRef.current then
			union.inputBoxRef.current:CaptureFocus()
		end
	end, { union.inputBoxRef })

	local v14 = React.useCallback(function()
		v9.goBack()
	end, { v9 and v9.goBack })

	local v15 = React.useCallback(function()
		ref.current:fire()
	end, { ref.current })

	local v16 = React.useCallback(function(p3, p4)
		if p3 == peekViewState.Closed then
			v14()
		end
	end, { v14 })

	React.useEffect(function()
		v12(EventNames.ChatMessageMenuOpened)

		if union.inputBoxRef and union.inputBoxRef.current then
			ref2.current = union.inputBoxRef.current:IsFocused()
		end
	end, {})

	local v17 = React.useCallback(function()
		if unitTestDeviceType == deviceType.Phone then
			v15()
		else
			v14()
		end
	end, { unitTestDeviceType, v15, v14 })

	local v18 = React.useCallback(function()
		v17()

		if ref2.current then
			v13()
		end
	end, { v17, ref2.current, v13 })

	local function fn()
		v12(EventNames.ChatMessageMenuReplyBtnActivated)
		v17()

		if FFlagAppChatSignalsReplyStore and v6 then
			v6.setReplyingTo(union.message.id)
		else
			v7(union.message)
		end

		v13()
	end

	local v21 = React.useCallback(fn, {
		v12,
		v17,
		if FFlagAppChatSignalsReplyStore then v6 else nil,
		v7,
		union.message,
		v13
	})

	local v22 = React.useCallback(function()
		v12(EventNames.ChatMessageMenuCopyBtnActivated)
		v17()

		default:shareText({
			text = union.message.content,
			context = "AppChat-ChatConversation-MessageContextMenu"
		})
	end, { v12, v17, union.message })

	local v23 = React.useCallback(function() end)

	local v24 = React.useCallback(function() end)
	local v25

	if getFFlagAppChatEnableManualTranslation() then
		local v26 = useDispatch()
		v25 = React.useCallback(function()
			v17()
			v26(AppChatNetworking.rodux.TranslateUserMessage.API(union.message.conversationId, union.message.id)):catch(function(p3)
				Logger:error("Error translating message: ", p3)
			end)
		end, { union.message, v17, v26 })
	else
		v25 = nil
	end

	local v26 = React.useCallback(function() end)

	local useMemo = React.useMemo
	local function fn2()
		local v27 = {
			{
				icon = images["icons/placeholder/placeholderOff"],
				text = v11.replyText,
				onActivated = v21
			},
			{
				icon = images["icons/actions/edit/copy"],
				text = v11.copyText,
				onActivated = v22
			}
		}

		if union.userOwnsMessage then
			table.insert(v27, {
				icon = images["icons/actions/edit/edit"],
				text = v11.editText,
				onActivated = v23
			})

			table.insert(v27, {
				icon = images["icons/actions/edit/delete"],
				iconColorOverride = tokens.Color.System.Alert.Color3,
				text = v11.deleteText,
				textColorOverride = tokens.Color.System.Alert.Color3,
				onActivated = v24
			})
		else
			if getFFlagAppChatEnableManualTranslation() then
				table.insert(v27, {
					icon = images["icons/placeholder/placeholderOff"],
					text = "Translate",
					onActivated = v25
				})
			end

			table.insert(v27, {
				icon = images["icons/placeholder/placeholderOff"],
				iconColorOverride = tokens.Color.System.Alert.Color3,
				text = v11.reportText,
				textColorOverride = tokens.Color.System.Alert.Color3,
				onActivated = v26
			})
		end

		return v27
	end

	local replyText = v11.replyText
	local copyText = v11.copyText
	local editText = v11.editText
	local deleteText = v11.deleteText
	local reportText = v11.reportText
	local translateText = v11.translateText

	local v28 = if getFFlagAppChatEnableManualTranslation() then v25 else nil
	local v29 = useMemo(fn2, {
		replyText,
		copyText,
		editText,
		deleteText,
		reportText,
		translateText,
		v21,
		v22,
		v23,
		v24,
		v28,
		v26,
		union.userOwnsMessage
	})

	local v30 = #v29 * 56
	local vector2, udim, udim2, v31

	if unitTestDeviceType == deviceType.Desktop or unitTestDeviceType == deviceType.Tablet then
		vector2 = Vector2.new(0.5, 0.5)
		udim = UDim.new(0.5, 0)
		udim2 = UDim.new(0.5, 0)
		v31 = 20
	else
		v8 = Vector2.new(0, 0)
		vector2 = Vector2.new(0.5, 1)

		udim = UDim.new(0, v30)
		udim2 = UDim.new(1, 0)
		v31 = 0
	end

	local element = React.createElement(contextualMenu, {
		screenSize = v8,
		menuDirection = menuDirection.Up,
		openPositionY = udim,
		anchorPointOverride = vector2,
		horizontalAlignment = Enum.HorizontalAlignment.Center,
		contextMenuWidthOverride = udim2,
		borderCornerRadius = v31,
		buttonProps = v29,
		isElementBackgroundVisible = true,
		isElementDividerVisible = true,
		open = true,
		onDismiss = v18
	})

	local element2 = React.createElement(
		"ImageButton",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[React.Event.Activated] = v18
		},
		{
			PeekView = React.createElement(peekView, {
				briefViewContentHeight = UDim.new(0, v30),
				fullViewContentHeight = UDim.new(1, -v30),
				mountAsFullView = false,
				mountAnimation = true,
				showDraggerInClosedState = false,
				closeSignal = ref.current,
				viewStateChanged = v16
			}, { element })
		}
	)

	if unitTestDeviceType == deviceType.Desktop or unitTestDeviceType == deviceType.Tablet then
		return element
	end

	return element2
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hps_MessageContextMenu)
