local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)

require(AppChat.types)

local Signal = require(AppChatParent.AppCommonLib).Signal
local DeviceType = require(AppChatParent.RobloxAppEnums).DeviceType
local Logger = require(script.Parent.Logger)
local EventNames = require(AppChat.Analytics.EventNames)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local UIBlox = require(AppChatParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local PeekView = require(AppChatParent.PeekView).PeekView
local PeekViewState = require(AppChatParent.PeekView).PeekViewState
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local default = require(AppChatParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local useStyle = UIBlox.Core.Style.useStyle
local useDeviceType = require(AppChatParent.RobloxAppHooks).useDeviceType
local useNavigation = require(AppChatParent.Navigation).useNavigation
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local useReplyingToMessageDispatch = require(AppChat.Components.ChatConversation.MessageInteraction.ReplyingContext.useReplyingToMessageDispatch)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local getFFlagAppChatEnableManualTranslation = require(AppChat.Flags.getFFlagAppChatEnableManualTranslation)
local t1 = {
	message = nil,
	userOwnsMessage = false,
	unitTestDeviceType = nil,
	unitTestScreenSize = nil,
	inputBoxRef = React.createRef()
}

if t1.unitTestDeviceType ~= nil then
	Logger:error("Default unit test device type must ALWAYS BE NIL!")
	error("Default unit test device type was not nil.")
end

if t1.unitTestScreenSize ~= nil then
	Logger:error("Default unit test screen size must ALWAYS BE NIL!")
	error("Default unit test screen size was not nil.")
end

function MessageContextMenu(t2: {[any]: any}) -- line: 86
	-- upvalues: Cryo (copy), t1 (copy), FFlagAppChatSignalsReplyStore (copy), GetReplyingToStore (copy), useReplyingToMessageDispatch (copy), useStyle (copy), React (copy), Signal (copy), useLayerCollector (copy), useNavigation (copy), useDeviceType (copy), useAnalytics (copy), useLocalization (copy), PeekViewState (copy), EventNames (copy), DeviceType (copy), default (copy), getFFlagAppChatEnableManualTranslation (copy), useDispatch (copy), AppChatNetworking (copy), Logger (copy), Images (copy), ContextualMenu (copy), MenuDirection (copy), PeekView (copy)
	local v30 = Cryo.Dictionary.union(t1, t2)
	local v31 = if not FFlagAppChatSignalsReplyStore then nil else GetReplyingToStore(false)
	local v32 = useReplyingToMessageDispatch()
	local Tokens = useStyle().Tokens
	local v34 = React.useRef(Signal.new())
	local v35 = v30.unitTestScreenSize or useLayerCollector().absoluteSize
	local v36 = useNavigation()
	local v37 = v30.unitTestDeviceType or useDeviceType()
	local v38 = useAnalytics()
	local v39 = useLocalization({
		replyText = "Feature.Chat.Action.Reply",
		copyText = "Feature.Chat.Action.Copy",
		editText = "Feature.Chat.Action.Edit",
		deleteText = "Feature.Chat.Action.Delete",
		reportText = "Feature.Chat.Action.Report",
		translateText = "Feature.Chat.Action.Translate"
	})
	local v40 = React.useCallback(function(p1) -- line: 112
		-- upvalues: v38 (copy), v30 (copy)
		if v38 then
			v38.fireAnalyticsEvent(p1, {
				conversationId = if not v30.message then nil else v30.message.conversationId,
				targetMessageSenderId = if not v30.message then nil else v30.message.senderTargetId,
				targetMessageId = if not v30.message then nil else v30.message.id,
				targetMessageSentAt = if not v30.message or not v30.message.sent then nil else tostring(v30.message.sent.dateTime),
				targetMessageLength = if not v30.message or not v30.message.content then nil else #v30.message.content
			})
		end
	end, { v30.message })
	local v41 = React.useRef(false)
	local v42 = React.useCallback(function() -- line: 132
		-- upvalues: v30 (copy)
		if v30.inputBoxRef and v30.inputBoxRef.current then
			v30.inputBoxRef.current:CaptureFocus()
		end
	end, { v30.inputBoxRef })
	local v43 = React.useCallback(function() -- line: 139
		-- upvalues: v36 (copy)
		v36.goBack()
	end, { v36 and v36.goBack })
	local v44 = React.useCallback(function() -- line: 144
		-- upvalues: v34 (copy)
		v34.current:fire()
	end, { v34.current })
	local v45 = React.useCallback(function(p2, _) -- line: 150
		-- upvalues: PeekViewState (copy), v43 (copy)
		if p2 == PeekViewState.Closed then
			v43()
		end
	end, { v43 })

	React.useEffect(function() -- line: 156
		-- upvalues: v40 (copy), EventNames (copy), v30 (copy), v41 (copy)
		v40(EventNames.ChatMessageMenuOpened)

		if v30.inputBoxRef and v30.inputBoxRef.current then
			v41.current = v30.inputBoxRef.current:IsFocused()
		end
	end, {})

	local v46 = React.useCallback(function() -- line: 165
		-- upvalues: v37 (copy), DeviceType (copy), v44 (copy), v43 (copy)
		if v37 == DeviceType.Phone then
			v44()

			return
		end

		v43()
	end, {
		v37,
		v44,
		v43
	})
	local v47 = React.useCallback(function() -- line: 173
		-- upvalues: v46 (copy), v41 (copy), v42 (copy)
		v46()

		if v41.current then
			v42()
		end
	end, {
		v46,
		v41.current,
		v42
	})
	local v48 = React.useCallback(function() -- line: 181
		-- upvalues: v40 (copy), EventNames (copy), v46 (copy), FFlagAppChatSignalsReplyStore (copy), v31 (copy), v30 (copy), v32 (copy), v42 (copy)
		v40(EventNames.ChatMessageMenuReplyBtnActivated)
		v46()

		if FFlagAppChatSignalsReplyStore and v31 then
			v31.setReplyingTo(v30.message.id)
		else
			v32(v30.message)
		end

		v42()
	end, {
		v40,
		v46,
		if not FFlagAppChatSignalsReplyStore then nil else v31,
		v32,
		v30.message,
		v42
	})
	local v49 = React.useCallback(function() -- line: 205
		-- upvalues: v40 (copy), EventNames (copy), v46 (copy), default (copy), v30 (copy)
		v40(EventNames.ChatMessageMenuCopyBtnActivated)
		v46()
		default:shareText({
			context = "AppChat-ChatConversation-MessageContextMenu",
			text = v30.message.content
		})
	end, {
		v40,
		v46,
		v30.message
	})
	local v50 = React.useCallback(function() -- line: 220
	end)
	local v51 = React.useCallback(function() -- line: 224
	end)
	local u52 = nil

	if getFFlagAppChatEnableManualTranslation() then
		local v53 = useDispatch()

		u52 = React.useCallback(function() -- line: 232
			-- upvalues: v46 (copy), v53 (copy), AppChatNetworking (copy), v30 (copy), Logger (copy)
			v46()
			v53(AppChatNetworking.rodux.TranslateUserMessage.API(v30.message.conversationId, v30.message.id)):catch(function(p4) -- line: 236
				-- upvalues: Logger (copy)
				Logger:error("Error translating message: ", p4)
			end)
		end, {
			v30.message,
			v46,
			v53
		})
	end

	local v54 = React.useCallback(function() -- line: 248
	end)
	local v55 = React.useMemo(function() -- line: 253
		-- upvalues: Images (copy), v39 (copy), v48 (copy), v49 (copy), v30 (copy), v50 (copy), Tokens (copy), v51 (copy), getFFlagAppChatEnableManualTranslation (copy), u52 (ref), v54 (copy)
		local t3 = {
			{
				icon = Images["icons/placeholder/placeholderOff"],
				text = v39.replyText,
				onActivated = v48
			},
			{
				icon = Images["icons/actions/edit/copy"],
				text = v39.copyText,
				onActivated = v49
			}
		}

		if v30.userOwnsMessage then
			table.insert(t3, {
				icon = Images["icons/actions/edit/edit"],
				text = v39.editText,
				onActivated = v50
			})
			table.insert(t3, {
				icon = Images["icons/actions/edit/delete"],
				iconColorOverride = Tokens.Color.System.Alert.Color3,
				text = v39.deleteText,
				textColorOverride = Tokens.Color.System.Alert.Color3,
				onActivated = v51
			})

			return t3
		end

		if getFFlagAppChatEnableManualTranslation() then
			table.insert(t3, {
				text = "Translate",
				icon = Images["icons/placeholder/placeholderOff"],
				onActivated = u52
			})
		end

		table.insert(t3, {
			icon = Images["icons/placeholder/placeholderOff"],
			iconColorOverride = Tokens.Color.System.Alert.Color3,
			text = v39.reportText,
			textColorOverride = Tokens.Color.System.Alert.Color3,
			onActivated = v54
		})

		return t3
	end, {
		v39.replyText,
		v39.copyText,
		v39.editText,
		v39.deleteText,
		v39.reportText,
		v39.translateText,
		v48,
		v49,
		v50,
		v51,
		if not getFFlagAppChatEnableManualTranslation() then nil else u52,
		v54,
		v30.userOwnsMessage
	})
	local v56 = #v55 * 56
	local n1, vector2, uDim, uDim2

	if v37 == DeviceType.Desktop or v37 == DeviceType.Tablet then
		n1 = 20
		vector2 = Vector2.new(0.5, 0.5)
		uDim = UDim.new(0.5, 0)
		uDim2 = UDim.new(0.5, 0)
	else
		n1 = 0
		v35 = Vector2.new(0, 0)
		vector2 = Vector2.new(0.5, 1)
		uDim = UDim.new(0, v56)
		uDim2 = UDim.new(1, 0)
	end

	local v61 = React.createElement(ContextualMenu, {
		isElementBackgroundVisible = true,
		isElementDividerVisible = true,
		open = true,
		screenSize = v35,
		menuDirection = MenuDirection.Up,
		openPositionY = uDim,
		anchorPointOverride = vector2,
		horizontalAlignment = Enum.HorizontalAlignment.Center,
		contextMenuWidthOverride = uDim2,
		borderCornerRadius = n1,
		buttonProps = v55,
		onDismiss = v47
	})
	local v62 = React.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[React.Event.Activated] = v47
	}, {
		PeekView = React.createElement(PeekView, {
			mountAsFullView = false,
			mountAnimation = true,
			showDraggerInClosedState = false,
			briefViewContentHeight = UDim.new(0, v56),
			fullViewContentHeight = UDim.new(1, -v56),
			closeSignal = v34.current,
			viewStateChanged = v45
		}, { v61 })
	})

	if v37 == DeviceType.Desktop or v37 == DeviceType.Tablet then
		return v61
	end

	return v62
end

return React.memo(MessageContextMenu)
