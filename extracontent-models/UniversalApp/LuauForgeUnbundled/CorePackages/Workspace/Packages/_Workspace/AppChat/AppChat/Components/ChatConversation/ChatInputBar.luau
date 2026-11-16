local UserInputService = game:GetService("UserInputService")

local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Text
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/BuilderIcons")
local useStyle = UIBlox.Core.Style.useStyle
local isKeyCodePressed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/isKeyCodePressed")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LoggingProtocol").default
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils").FocusNavigationEventNameEnum

local callbackInputBox = SocialLibraries.Components.CallbackInputBox
local ChatInputBoxDisabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatInputBoxDisabled")
local isMessageValid = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/isMessageValid")
local MessageCharacterLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageCharacterLimit")
local useKeystrokeCollection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Hooks/useKeystrokeCollection")
local useInputConnections = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Hooks/useInputConnections")
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive").useIsSpatial

local SendButtonClickActionResult = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/SendButtonClickActionResult")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local useChatWideModeFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatWideModeFocus/useChatWideModeFocus")

local v5 = {
	userInputService = UserInputService,
	initialInputText = "",
	placeholderText = "Write a message",
	inputBarDisabledText = "Chat Disabled",
	inputBarRef = nil,
	inputBoxRef = nil,
	onDisabledInputBarActivated = function() end,
	LayoutOrder = 0,
	maxCharacterLength = MessageCharacterLimit,
	maxKeystrokeDataLength = 200,
	messageListRef = nil,
	onHeightChanged = function(p2) end,
	onPositionChanged = function(p2) end,
	onFocusLost = function() end,
	isDisabled = false,
	disabledEndTimestampDisplay = nil,
	onSendBtnClicked = function(p2) end,
	onSendChat = function(p2) end,
	onTextChanged = function(p2) end,
	eventLoggingFunc = default.logRobloxTelemetryEvent,
	textChangedFallback = false,
	moreMenuEnabled = false
}

local function heightOfNLines(count, font, p2, value)
	if foundationFontFaceMigration then
		return getTextSize(string.rep("A\n", count - 1), p2, font, Vector2.new(value or 10000, 10000)).Y
	end

	return text.GetTextHeight(string.rep("A\n", count - 1), font, p2, value)
end

local function ChatInputBar(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(false)

	local v6 = React.useRef(nil)

	if union.inputBoxRef then
		v6 = union.inputBoxRef
	end

	local v7 = React.useRef(nil)
	local ref = React.useRef(nil)

	if union.inputBarRef then
		v7 = union.inputBarRef
	end

	local ref2 = React.useRef(Enum.KeyCode.None)
	local v8 = ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, function(object)
		if object.eventData and ref2.current == object.eventData.KeyCode then
			object:cancel()
			ref2.current = Enum.KeyCode.None
		end
	end, "Bubble", v7)

	local ref3 = React.useRef(union.initialInputText or "")
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(union.textChangedFallback or not UserInputService.KeyboardEnabled)

	local v9, v10 = React.useBinding(ref3.current ~= "")

	useChatPagePadding()
	local v11 = if FFlagAppChatConsoleFocusFixes then useChatWideModeFocus() else nil
	local v12 = Foundation.Hooks.useTokens()
	local v13 = useStyle()

	local font = if foundationFontFaceMigration then v12.Typography.BodyLarge.Font else v13.Font.Body.Font
	local v14 = v13.Font.BaseSize * v13.Font.Body.RelativeSize

	local v15 = React.useMemo(function()
		return heightOfNLines(4, font, v14, state)
	end, { font, v14, state })
	local v16 = React.useMemo(function()
		return heightOfNLines(1, font, v14)
	end, { font, v14 })

	local v17 = useKeystrokeCollection({
		eventLoggingFunc = union.eventLoggingFunc,
		maxKeystrokeDataLength = union.maxKeystrokeDataLength
	})

	local v18 = React.useCallback(function()
		return ref3.current and isMessageValid(ref3.current, union.maxCharacterLength)
	end, { union.maxCharacterLength })

	local v19 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v20 = React.useCallback(function()
		local current = ref3.current
		local text2 = v6.current and (v6.current.Text or "") or current

		local trimmed = text.Trim(text2)

		local none = SendButtonClickActionResult.None
		local v21

		if v18() and isMessageValid(trimmed, union.maxCharacterLength) then
			if v6.current then
				v6.current.Text = ""
			end

			if v19 and v19.focusedGuiObject:getValue() == ref.current then
				v19:focusGuiObject(v7.current, false)
			end

			ref3.current = ""
			v10(false)

			if trimmed == "/shrug" then
				union.onSendChat("¯\\_(ツ)_/¯")
			else
				union.onSendChat(trimmed)
			end

			v21 = SendButtonClickActionResult.WillSend

			local listRef = union.messageListRef
				and union.messageListRef.current
				and union.messageListRef.current._listRef

			if listRef then
				listRef:scrollToOffset({ offset = 0 })
			end
		else
			v21 = if v18() then SendButtonClickActionResult.MessageInvalid else SendButtonClickActionResult.ButtonInactive
		end

		union.onSendBtnClicked(v21)

		v17.sendKeystrokeEventOnSend()
	end, {
		v18,
		union.onSendChat,
		union.onSendBtnClicked,
		v17.sendKeystrokeEventOnSend,
		v19
	})

	local v21 = React.useCallback(function(p3, p4)
		if v17 and not ref5.current and p3.UserInputType == Enum.UserInputType.Keyboard then
			v17.recordKeystroke(false, p3.KeyCode)
		end
	end, { v17.recordKeystroke })

	local v22 = React.useCallback(function(p3, p4)
		if v17 and not ref5.current and p3.UserInputType == Enum.UserInputType.Keyboard then
			v17.recordKeystroke(true, p3.KeyCode)
		end

		if
			isKeyCodePressed({ p3 }, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter)
			and not isKeyCodePressed(
				union.userInputService:GetKeysPressed(),
				Enum.KeyCode.LeftShift,
				Enum.KeyCode.RightShift
			)
		then
			v20()
		end
	end, {
		union.userInputService,
		v17.recordKeystroke,
		v17.sendKeystrokeEventOnSend,
		v20
	})

	local v23 = useInputConnections({
		userInputService = union.userInputService,
		onInputBegan = v22,
		onInputEnded = v21,
		onFocusLost = union.onFocusLost
	})

	local v24 = React.useCallback(function(p3, p4)
		local v25

		if foundationFontFaceMigration then
			v25 = getTextSize(p3, v14, v12.Typography.BodyLarge.Font, Vector2.new(p4, 10000)).Y
		else
			v25 = text.GetTextHeight(p3, font, v14, p4)
		end

		local v26 = v14 + math.min(v25, v15)

		if union.onHeightChanged then
			union.onHeightChanged(v26)
		end

		return v26
	end, { v12, v15, union.onHeightChanged, font, v14 })

	local v25 = React.useCallback(function(current)
		if not ref4.current then
			return
		end

		ref3.current = current
		v10(current ~= "")
		setState3(v18())

		if v17 and ref5.current then
			v17.recordTextChange(current)
		end

		setState2((v24(current, state)))

		if union.onTextChanged then
			union.onTextChanged(current)
		end
	end, { v17.recordTextChange, v24, union.onTextChanged, state })

	local v26 = React.useCallback(function(p3)
		local v27 = v24(ref3.current, p3.AbsoluteSize.X)
		setState(p3.AbsoluteSize.X)
		setState2(v27)
	end, { v24 })

	local v27 = React.useCallback(function()
		if v6.current then
			v6.current:CaptureFocus()
		end
	end, {})

	React.useEffect(function()
		ref4.current = true
		return function()
			ref4.current = false

			if union.onHeightChanged then
				union.onHeightChanged(0)
			end
		end
	end, { union.onHeightChanged })

	React.useEffect(function()
		local focusLostConnection

		if v6 and v6.current then
			v6.current.Selectable = false
			focusLostConnection = v6.current.FocusLost:Connect(function(p3, p4)
				local v28 = ref2
				local v29 = if p4 then p4.KeyCode else Enum.KeyCode.None
				v28.current = v29
			end)
		else
			focusLostConnection = nil
		end

		return function()
			if focusLostConnection then
				focusLostConnection:Disconnect()
			end
		end
	end, {})

	local moreMenuEnabled = union.moreMenuEnabled
	local v28 = useIsSpatial()

	if state2 == 0 then
		state2 = v24(ref3.current, state)
	end

	local v29 = v14 + v16
	local isDisabled = union.isDisabled
	local createElement = React.createElement
	local view = Foundation.View
	local v30 = {
		tag = {
			["padding-x-xlarge"] = not moreMenuEnabled,
			fill = moreMenuEnabled
		},
		Size = UDim2.new(moreMenuEnabled and 0 or 1, 0, 0, state2),
		LayoutOrder = union.LayoutOrder,
		onAbsolutePositionChanged = union.onPositionChanged
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v32 = {
		tag = {
			["row size-full"] = true,
			["stroke-emphasis stroke-thick"] = not isDisabled,
			["stroke-alert"] = isDisabled
		},
		onActivated = v27,
		ref = v8,
		cornerRadius = UDim.new(0, v29 / 2),
		selection = 0,
		cursor = 0,
		LayoutOrder = 1
	}
	local v33 = { Selectable = true, NextSelectionRight = ref, NextSelectionLeft = 0 }

	local v34 = if FFlagAppChatConsoleFocusFixes and v11 then v11.conversationListRef else nil
	v33.NextSelectionLeft = v34
	v32.selection = v33

	v32.cursor = {
		radius = UDim.new(0, v29 / 2),
		offset = 0
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v35 = {
		tag = "size-0-full fill padding-left-large",
		padding = {
			top = UDim.new(0, v14 / 2),
			bottom = UDim.new(0, v14 / 2)
		},
		LayoutOrder = 1
	}
	local v37

	if isDisabled then
		v37 = React.createElement(ChatInputBoxDisabled, {
			bodyText = union.inputBarDisabledText,
			font = font,
			contentSize = v14,
			endTimestamp = union.disabledEndTimestampDisplay,
			onActivated = union.onDisabledInputBarActivated
		})
	else
		v37 = React.createElement(callbackInputBox, {
			initialInputText = union.initialInputText,
			inputTextFont = font,
			inputTextColor3 = v13.Theme.TextEmphasis.Color,
			inputTextSize = v14,
			inputTextXAlignment = Enum.TextXAlignment.Left,
			inputTextYAlignment = Enum.TextYAlignment.Center,
			placeholderText = union.placeholderText,
			placeholderTextColor3 = v13.Theme.TextMuted.Color,
			placeholderTextTransparency = v13.Theme.TextMuted.Transparency,
			clipsDescendants = false,
			multiLine = not v28,
			manualFocusRelease = true,
			textWrapped = true,
			focusChangedCallback = v23.focusChanged,
			clearButtonDisabled = true,
			clearButtonSize = 0,
			textChangedCallback = v25,
			[React.Change.AbsoluteSize] = v26,
			inputBoxRef = v6,
			returnPressedFromOnScreenKeyboardCallback = if v28 then v20 else nil
		})
	end

	return createElement(view, v30, {
		inputBar = createElement2(view2, v32, {
			inputBoxWrapper = createElement3(view3, v35, { inputBox = v37 }),
			sendButtonColumn = React.createElement(
				Foundation.View,
				{
					tag = "col size-0-full auto-x align-y-bottom",
					LayoutOrder = 2,
					Visible = v9
				},
				{
					sendButtonWrapper = React.createElement(
						Foundation.View,
						{
							tag = "col flex-around padding-small",
							Size = UDim2.new(0, v29, 0, v29)
						},
						{
							sendButton = React.createElement(Foundation.View, {
								tag = {
									["col radius-circle flex-around"] = true,
									["bg-action-emphasis"] = state3,
									["bg-action-standard"] = not state3
								},
								Size = UDim2.new(0, v29 - v12.Padding.Small, 0, v29 - v12.Padding.Small),
								isDisabled = not state3,
								onActivated = v20,
								selection = {
									Selectable = true,
									NextSelectionLeft = v7
								},
								cursor = {
									radius = UDim.new(0, v29 / 2),
									offset = v12.Padding.Small / 2
								},
								ref = ref
							}, {
								sendButtonIcon = React.createElement(Foundation.Icon, {
									style = v12.Color.ActionEmphasis.Foreground,
									size = Foundation.Enums.IconSize.Small,
									name = BuilderIcons.Icon.ArrowLargeUp
								})
							})
						}
					)
				}
			)
		})
	})
end

return React.memo(ChatInputBar)
