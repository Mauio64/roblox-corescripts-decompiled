local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local UserInputService = game:GetService("UserInputService")

local SocialLibraries = require(AppChat.SocialLibraries)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local UIBlox = require(parent.UIBlox)
local BuilderIcons = require(parent.BuilderIcons)
local useStyle = UIBlox.Core.Style.useStyle
local isKeyCodePressed = require(AppChat.Components.ChatConversation.Utils.isKeyCodePressed)
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local Cryo = require(parent.Cryo)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local CallbackInputBox = SocialLibraries.Components.CallbackInputBox
local ChatInputBoxDisabled = require(script.Parent.ChatInputBoxDisabled)
local isMessageValid = require(script.Parent.isMessageValid)
local MessageCharacterLimit = require(script.Parent.MessageCharacterLimit)
local useKeystrokeCollection = require(script.Parent.Hooks.useKeystrokeCollection)
local useInputConnections = require(script.Parent.Hooks.useInputConnections)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial

local SendButtonClickActionResult = require(AppChat.Analytics.Enums.SendButtonClickActionResult)
require(AppChat.types)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local useChatWideModeFocus = require(AppChat.Contexts.ChatWideModeFocus.useChatWideModeFocus)

local v = {
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
	onHeightChanged = function(_) end,
	onPositionChanged = function(_) end,
	onFocusLost = function() end,
	isDisabled = false,
	disabledEndTimestampDisplay = nil,
	onSendBtnClicked = function(_) end,
	onSendChat = function(_) end,
	onTextChanged = function(_) end,
	eventLoggingFunc = default.logRobloxTelemetryEvent,
	textChangedFallback = false,
	moreMenuEnabled = false
}

local function heightOfNLines(count: number, font, p, value: number?)
	if FoundationFontFaceMigration then
		return GetTextSize(string.rep("A\n", count - 1), p, font, Vector2.new(value or 10000, 10000)).Y
	end

	return Text.GetTextHeight(string.rep("A\n", count - 1), font, p, value)
end

local function ChatInputBar(p)
	local union = Cryo.Dictionary.union(v, p)

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(false)

	local inputBoxRef = React.useRef(nil)

	if union.inputBoxRef then
		inputBoxRef = union.inputBoxRef
	end

	local nextSelectionLeft = React.useRef(nil)
	local ref = React.useRef(nil)

	if union.inputBarRef then
		nextSelectionLeft = union.inputBarRef
	end

	local ref2 = React.useRef(Enum.KeyCode.None)
	local ref6 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, function(object)
		if object.eventData and ref2.current == object.eventData.KeyCode then
			object:cancel()
			ref2.current = Enum.KeyCode.None
		end
	end, "Bubble", nextSelectionLeft)

	local ref3 = React.useRef(union.initialInputText or "")
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(union.textChangedFallback or not UserInputService.KeyboardEnabled)

	local visible, v2 = React.useBinding(ref3.current ~= "")

	useChatPagePadding()
	local v3

	if FFlagAppChatConsoleFocusFixes then
		v3 = useChatWideModeFocus()
	end

	local v4 = Foundation.Hooks.useTokens()
	local v5 = useStyle()
	local font

	if FoundationFontFaceMigration then
		font = v4.Typography.BodyLarge.Font
	else
		font = v5.Font.Body.Font
	end

	local v6 = v5.Font.BaseSize * v5.Font.Body.RelativeSize

	local v7 = React.useMemo(function()
		return heightOfNLines(4, font, v6, state)
	end, { font, v6, state })
	local v8 = React.useMemo(function()
		return heightOfNLines(1, font, v6)
	end, { font, v6 })

	local v9 = useKeystrokeCollection({
		eventLoggingFunc = union.eventLoggingFunc,
		maxKeystrokeDataLength = union.maxKeystrokeDataLength
	})

	local v10 = React.useCallback(function()
		return ref3.current and isMessageValid(ref3.current, union.maxCharacterLength)
	end, { union.maxCharacterLength })

	local v11 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local onActivated = React.useCallback(function()
		local current = ref3.current
		local text = inputBoxRef.current and (inputBoxRef.current.Text or "") or current

		local trimmed = Text.Trim(text)

		local _none = SendButtonClickActionResult.None
		local v12

		if v10() and isMessageValid(trimmed, union.maxCharacterLength) then
			if inputBoxRef.current then
				inputBoxRef.current.Text = ""
			end

			if v11 and v11.focusedGuiObject:getValue() == ref.current then
				v11:focusGuiObject(nextSelectionLeft.current, false)
			end

			ref3.current = ""
			v2(false)

			if trimmed == "/shrug" then
				union.onSendChat("¯\\_(ツ)_/¯")
			else
				union.onSendChat(trimmed)
			end

			v12 = SendButtonClickActionResult.WillSend

			local listRef = union.messageListRef
				and union.messageListRef.current
				and union.messageListRef.current._listRef

			if listRef then
				listRef:scrollToOffset({ offset = 0 })
			end
		elseif v10() then
			v12 = SendButtonClickActionResult.MessageInvalid
		else
			v12 = SendButtonClickActionResult.ButtonInactive
		end

		union.onSendBtnClicked(v12)

		v9.sendKeystrokeEventOnSend()
	end, { v10, union.onSendChat, union.onSendBtnClicked, v9.sendKeystrokeEventOnSend, v11 })

	local onInputEnded = React.useCallback(function(p2, _)
		if v9 and not ref5.current and p2.UserInputType == Enum.UserInputType.Keyboard then
			v9.recordKeystroke(false, p2.KeyCode)
		end
	end, { v9.recordKeystroke })

	local onInputBegan = React.useCallback(function(p2, _)
		if v9 and not ref5.current and p2.UserInputType == Enum.UserInputType.Keyboard then
			v9.recordKeystroke(true, p2.KeyCode)
		end

		if
			isKeyCodePressed({ p2 }, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter)
			and not isKeyCodePressed(
				union.userInputService:GetKeysPressed(),
				Enum.KeyCode.LeftShift,
				Enum.KeyCode.RightShift
			)
		then
			onActivated()
		end
	end, { union.userInputService, v9.recordKeystroke, v9.sendKeystrokeEventOnSend, onActivated })

	local v12 = useInputConnections({
		userInputService = union.userInputService,
		onInputBegan = onInputBegan,
		onInputEnded = onInputEnded,
		onFocusLost = union.onFocusLost
	})

	local v13 = React.useCallback(function(p2: string, p3: number)
		local v13

		if FoundationFontFaceMigration then
			v13 = GetTextSize(p2, v6, v4.Typography.BodyLarge.Font, Vector2.new(p3, 10000)).Y
		else
			v13 = Text.GetTextHeight(p2, font, v6, p3)
		end

		local v14 = v6 + math.min(v13, v7)

		if union.onHeightChanged then
			union.onHeightChanged(v14)
		end

		return v14
	end, { v4, v7, union.onHeightChanged, font, v6 })

	local textChangedCallback = React.useCallback(function(current: string)
		if not ref4.current then
			return
		end

		ref3.current = current
		v2(current ~= "")
		setState3(v10())

		if v9 and ref5.current then
			v9.recordTextChange(current)
		end

		setState2((v13(current, state)))

		if union.onTextChanged then
			union.onTextChanged(current)
		end
	end, { v9.recordTextChange, v13, union.onTextChanged, state })

	local v14 = React.useCallback(function(p2)
		local v14 = v13(ref3.current, p2.AbsoluteSize.X)
		setState(p2.AbsoluteSize.X)
		setState2(v14)
	end, { v13 })

	local onActivated2 = React.useCallback(function()
		if inputBoxRef.current then
			inputBoxRef.current:CaptureFocus()
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

		if inputBoxRef and inputBoxRef.current then
			inputBoxRef.current.Selectable = false
			focusLostConnection = inputBoxRef.current.FocusLost:Connect(function(_: boolean, p2)
				local current

				if p2 then
					current = p2.KeyCode
				else
					current = Enum.KeyCode.None
				end

				ref2.current = current
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
	local v15 = useIsSpatial()

	if state2 == 0 then
		state2 = v13(ref3.current, state)
	end

	local v16 = v6 + v8
	local isDisabled = union.isDisabled
	local createElement = React.createElement
	local view = Foundation.View
	local v17 = {
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
	local v18 = {
		tag = {
			["row size-full"] = true,
			["stroke-emphasis stroke-thick"] = not isDisabled,
			["stroke-alert"] = isDisabled
		},
		onActivated = onActivated2,
		ref = ref6,
		cornerRadius = UDim.new(0, v16 / 2),
		selection = 0,
		cursor = 0,
		LayoutOrder = 1
	}
	local selection = { Selectable = true, NextSelectionRight = ref, NextSelectionLeft = 0 }
	local nextSelectionLeft2

	if FFlagAppChatConsoleFocusFixes and v3 then
		nextSelectionLeft2 = v3.conversationListRef
	end

	selection.NextSelectionLeft = nextSelectionLeft2
	v18.selection = selection

	v18.cursor = {
		radius = UDim.new(0, v16 / 2),
		offset = 0
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v19 = {
		tag = "size-0-full fill padding-left-large",
		padding = {
			top = UDim.new(0, v6 / 2),
			bottom = UDim.new(0, v6 / 2)
		},
		LayoutOrder = 1
	}
	local inputBox

	if isDisabled then
		inputBox = React.createElement(ChatInputBoxDisabled, {
			bodyText = union.inputBarDisabledText,
			font = font,
			contentSize = v6,
			endTimestamp = union.disabledEndTimestampDisplay,
			onActivated = union.onDisabledInputBarActivated
		})
	else
		local createElement4 = React.createElement
		local v20 = {
			initialInputText = union.initialInputText,
			inputTextFont = font,
			inputTextColor3 = v5.Theme.TextEmphasis.Color,
			inputTextSize = v6,
			inputTextXAlignment = Enum.TextXAlignment.Left,
			inputTextYAlignment = Enum.TextYAlignment.Center,
			placeholderText = union.placeholderText,
			placeholderTextColor3 = v5.Theme.TextMuted.Color,
			placeholderTextTransparency = v5.Theme.TextMuted.Transparency,
			clipsDescendants = false,
			multiLine = not v15,
			manualFocusRelease = true,
			textWrapped = true,
			focusChangedCallback = v12.focusChanged,
			clearButtonDisabled = true,
			clearButtonSize = 0,
			textChangedCallback = textChangedCallback,
			[React.Change.AbsoluteSize] = v14,
			inputBoxRef = inputBoxRef
		}
		local returnPressedFromOnScreenKeyboardCallback

		if v15 then
			returnPressedFromOnScreenKeyboardCallback = onActivated
		end

		v20.returnPressedFromOnScreenKeyboardCallback = returnPressedFromOnScreenKeyboardCallback
		inputBox = createElement4(CallbackInputBox, v20)
	end

	return createElement(view, v17, {
		inputBar = createElement2(view2, v18, {
			inputBoxWrapper = createElement3(view3, v19, { inputBox = inputBox }),
			sendButtonColumn = React.createElement(
				Foundation.View,
				{
					tag = "col size-0-full auto-x align-y-bottom",
					LayoutOrder = 2,
					Visible = visible
				},
				{
					sendButtonWrapper = React.createElement(
						Foundation.View,
						{ tag = "col flex-around padding-small", Size = UDim2.new(0, v16, 0, v16) },
						{
							sendButton = React.createElement(Foundation.View, {
								tag = {
									["col radius-circle flex-around"] = true,
									["bg-action-emphasis"] = state3,
									["bg-action-standard"] = not state3
								},
								Size = UDim2.new(0, v16 - v4.Padding.Small, 0, v16 - v4.Padding.Small),
								isDisabled = not state3,
								onActivated = onActivated,
								selection = {
									Selectable = true,
									NextSelectionLeft = nextSelectionLeft
								},
								cursor = {
									radius = UDim.new(0, v16 / 2),
									offset = v4.Padding.Small / 2
								},
								ref = ref
							}, {
								sendButtonIcon = React.createElement(Foundation.Icon, {
									style = v4.Color.ActionEmphasis.Foreground,
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
