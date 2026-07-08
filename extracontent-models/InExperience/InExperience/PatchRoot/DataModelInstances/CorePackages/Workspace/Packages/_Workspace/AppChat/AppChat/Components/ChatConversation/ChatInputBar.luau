local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local UserInputService = game:GetService("UserInputService")
local SocialLibraries = require(AppChat.SocialLibraries)
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local Text = require(AppChatParent.AppCommonLib).Text
local UIBlox = require(AppChatParent.UIBlox)
local BuilderIcons = require(AppChatParent.BuilderIcons)
local useStyle = UIBlox.Core.Style.useStyle
local isKeyCodePressed = require(AppChat.Components.ChatConversation.Utils.isKeyCodePressed)
local default = require(AppChatParent.LoggingProtocol).default
local Cryo = require(AppChatParent.Cryo)
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(AppChatParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local CallbackInputBox = SocialLibraries.Components.CallbackInputBox
local ChatInputBoxDisabled = require(script.Parent.ChatInputBoxDisabled)
local isMessageValid = require(script.Parent.isMessageValid)
local useKeystrokeCollection = require(script.Parent.Hooks.useKeystrokeCollection)
local useInputConnections = require(script.Parent.Hooks.useInputConnections)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local useIsSpatial = require(AppChatParent.Responsive).useIsSpatial
local SendButtonClickActionResult = require(AppChat.Analytics.Enums.SendButtonClickActionResult)

require(AppChat.types)

local FFlagAppChatReplyComposeBarContainer = require(AppChat.Flags.FFlagAppChatReplyComposeBarContainer)
local FFlagAppChatGamepadSendButtonNav = require(AppChat.Flags.FFlagAppChatGamepadSendButtonNav)
local t1 = {
	initialInputText = "",
	placeholderText = "Write a message",
	inputBarDisabledText = "Chat Disabled",
	inputBarRef = nil,
	inputBoxRef = nil,
	LayoutOrder = 0,
	maxCharacterLength = 160,
	maxKeystrokeDataLength = 200,
	messageListRef = nil,
	isDisabled = false,
	disabledEndTimestampDisplay = nil,
	textChangedFallback = false,
	moreMenuEnabled = false,
	userInputService = UserInputService,
	onDisabledInputBarActivated = function() -- line: 64
	end,
	onHeightChanged = function(_) -- line: 69
	end,
	onPositionChanged = function(_) -- line: 70
	end,
	onFocusLost = function() -- line: 71
	end,
	onSendBtnClicked = function(_) -- line: 74
	end,
	onSendChat = function(_) -- line: 75
	end,
	onTextChanged = function(_) -- line: 76
	end,
	eventLoggingFunc = default.logRobloxTelemetryEvent
}

local function heightOfNLines(n1: number, p6, p7, p8) -- line: 86
	-- upvalues: Text (copy)
	return Text.GetTextHeight(string.rep("A\n", n1 - 1), p6, p7, p8)
end
local function ChatInputBar(t2: {[any]: any}) -- line: 90
	-- upvalues: Cryo (copy), t1 (copy), React (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy), UserInputService (copy), useChatPagePadding (copy), Foundation (copy), useStyle (copy), heightOfNLines (copy), useKeystrokeCollection (copy), isMessageValid (copy), Text (copy), SendButtonClickActionResult (copy), isKeyCodePressed (copy), useInputConnections (copy), FFlagAppChatReplyComposeBarContainer (copy), useIsSpatial (copy), FFlagAppChatGamepadSendButtonNav (copy), ChatInputBoxDisabled (copy), CallbackInputBox (copy), BuilderIcons (copy)
	local v39 = Cryo.Dictionary.union(t1, t2)
	local v40, v41 = React.useState(0)
	local v42, v43 = React.useState(0)
	local v44, v45 = React.useState(false)
	local u46 = React.useRef(nil)

	if v39.inputBoxRef then
		u46 = v39.inputBoxRef
	end

	local u47 = React.useRef(nil)
	local v48 = React.useRef(nil)

	if v39.inputBarRef then
		u47 = v39.inputBarRef
	end

	local v49 = React.useRef(Enum.KeyCode.Unknown)
	local v50 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, function(p9) -- line: 109
		-- upvalues: v49 (copy)
		if p9.eventData and v49.current == p9.eventData.KeyCode then
			p9:cancel()
			v49.current = Enum.KeyCode.Unknown
		end
	end, "Bubble", u47)
	local v51 = React.useRef(v39.initialInputText or "")
	local v52 = React.useRef(false)
	local v53 = React.useRef(v39.textChangedFallback or not UserInputService.KeyboardEnabled)
	local v54, v55 = React.useBinding(v51.current ~= "")

	useChatPagePadding()

	local v56 = Foundation.Hooks.useTokens()
	local v57 = useStyle()
	local BodyFont = v57.Font.Body.Font
	local v59 = v57.Font.BaseSize * v57.Font.Body.RelativeSize
	local v60 = React.useMemo(function() -- line: 130
		-- upvalues: heightOfNLines (copy), BodyFont (copy), v59 (copy), v40 (copy)
		return heightOfNLines(4, BodyFont, v59, v40)
	end, {
		BodyFont,
		v59,
		v40
	})
	local v61 = React.useMemo(function() -- line: 133
		-- upvalues: heightOfNLines (copy), BodyFont (copy), v59 (copy)
		return heightOfNLines(1, BodyFont, v59)
	end, {
		BodyFont,
		v59
	})
	local v62 = useKeystrokeCollection({
		eventLoggingFunc = v39.eventLoggingFunc,
		maxKeystrokeDataLength = v39.maxKeystrokeDataLength
	})
	local v63 = React.useCallback(function() -- line: 142
		-- upvalues: v51 (copy), isMessageValid (copy), v39 (copy)
		return v51.current and isMessageValid(v51.current, v39.maxCharacterLength)
	end, { v39.maxCharacterLength })
	local v64 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v65 = React.useCallback(function() -- line: 148
		-- upvalues: v51 (copy), u46 (ref), Text (copy), SendButtonClickActionResult (copy), v63 (copy), isMessageValid (copy), v39 (copy), v64 (copy), v48 (copy), u47 (ref), v55 (copy), v62 (copy)
		local current = v51.current

		if u46.current then
			current = u46.current.Text or ""
		end

		local v80 = Text.Trim(current)
		local _ = SendButtonClickActionResult.None
		local WillSend

		if v63() and isMessageValid(v80, v39.maxCharacterLength) then
			if u46.current then
				u46.current.Text = ""
			end

			if v64 and v64.focusedGuiObject:getValue() == v48.current then
				v64:focusGuiObject(u47.current, false)
			end

			v51.current = ""
			v55(false)

			if v80 == "/shrug" then
				v39.onSendChat("¯\\_(ツ)_/¯")
			else
				v39.onSendChat(v80)
			end

			WillSend = SendButtonClickActionResult.WillSend

			local v83 = v39.messageListRef and (v39.messageListRef.current and v39.messageListRef.current._listRef)

			if v83 then
				v83:scrollToOffset({
					offset = 0
				})
			end
		else
			WillSend = if v63() then SendButtonClickActionResult.MessageInvalid else SendButtonClickActionResult.ButtonInactive
		end

		v39.onSendBtnClicked(WillSend)
		v62.sendKeystrokeEventOnSend()
	end, {
		v63,
		v39.onSendChat,
		v39.onSendBtnClicked,
		v62.sendKeystrokeEventOnSend,
		v64
	})
	local v66 = React.useCallback(function(p10, _) -- line: 211
		-- upvalues: v62 (copy), v53 (copy)
		if v62 and (not v53.current and p10.UserInputType == Enum.UserInputType.Keyboard) then
			v62.recordKeystroke(false, p10.KeyCode)
		end
	end, { v62.recordKeystroke })
	local v67 = React.useCallback(function(p12, _) -- line: 222
		-- upvalues: v62 (copy), v53 (copy), isKeyCodePressed (copy), v39 (copy), v65 (copy)
		if v62 and (not v53.current and p12.UserInputType == Enum.UserInputType.Keyboard) then
			v62.recordKeystroke(true, p12.KeyCode)
		end

		if isKeyCodePressed({ p12 }, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter) and not isKeyCodePressed(v39.userInputService:GetKeysPressed(), Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift) then
			v65()
		end
	end, {
		v39.userInputService,
		v62.recordKeystroke,
		v62.sendKeystrokeEventOnSend,
		v65
	})
	local v68 = useInputConnections({
		userInputService = v39.userInputService,
		onInputBegan = v67,
		onInputEnded = v66,
		onFocusLost = v39.onFocusLost
	})
	local v69 = React.useCallback(function(p14, p15) -- line: 257
		-- upvalues: Text (copy), BodyFont (copy), v59 (copy), v60 (copy), FFlagAppChatReplyComposeBarContainer (copy), v56 (copy), v39 (copy)
		local v90 = Text.GetTextHeight(p14, BodyFont, v59, p15)
		local v91 = v59 + math.min(v90, v60) + if not FFlagAppChatReplyComposeBarContainer then v56.Padding.Medium * 2 else 0

		if v39.onHeightChanged then
			v39.onHeightChanged(v91)
		end

		return v91
	end, {
		v56,
		v60,
		v39.onHeightChanged,
		BodyFont,
		v59
	})
	local v70 = React.useCallback(function(s1: string) -- line: 273
		-- upvalues: v52 (copy), v51 (copy), v55 (copy), v45 (copy), v63 (copy), v62 (copy), v53 (copy), v69 (copy), v40 (copy), v43 (copy), v39 (copy)
		if not v52.current then
			return
		end

		v51.current = s1
		v55(s1 ~= "")
		v45(v63())

		if v62 and v53.current then
			v62.recordTextChange(s1)
		end

		local v93 = v69(s1, v40)

		v43(v93)

		if v39.onTextChanged then
			v39.onTextChanged(s1)
		end
	end, {
		v62.recordTextChange,
		v69,
		v39.onTextChanged,
		v40
	})
	local v71 = React.useCallback(function(p16) -- line: 296
		-- upvalues: v69 (copy), v51 (copy), v41 (copy), v43 (copy)
		local v95 = v69(v51.current, p16.AbsoluteSize.X)

		v41(p16.AbsoluteSize.X)
		v43(v95)
	end, { v69 })
	local v72 = React.useCallback(function() -- line: 302
		-- upvalues: u46 (ref)
		if u46.current then
			u46.current:CaptureFocus()
		end
	end, {})

	React.useEffect(function() -- line: 308
		-- upvalues: v52 (copy), v39 (copy)
		v52.current = true

		return function() -- line: 310
			-- upvalues: v52 (copy), v39 (copy)
			v52.current = false

			if v39.onHeightChanged then
				v39.onHeightChanged(0)
			end
		end
	end, { v39.onHeightChanged })
	React.useEffect(function() -- line: 319
		-- upvalues: u46 (ref), v49 (copy)
		local connection = nil

		if u46 and u46.current then
			u46.current.Selectable = false
			connection = u46.current.FocusLost:Connect(function(_: boolean, p17) -- line: 324
				-- upvalues: v49 (copy)
				v49.current = if not p17 then Enum.KeyCode.Unknown else p17.KeyCode
			end)
		end

		return function() -- line: 331
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {})

	local moreMenuEnabled = v39.moreMenuEnabled
	local v74 = useIsSpatial()
	local v75 = if v42 == 0 then v69(v51.current, v40) else v42
	local v76 = v59 + v61
	local isDisabled = v39.isDisabled

	return React.createElement(Foundation.View, {
		tag = {
			["padding-y-medium"] = not FFlagAppChatReplyComposeBarContainer,
			["padding-x-xlarge"] = not moreMenuEnabled,
			fill = moreMenuEnabled
		},
		Size = UDim2.new(not moreMenuEnabled and 1 or 0, 0, 0, v75),
		LayoutOrder = v39.LayoutOrder,
		onAbsolutePositionChanged = v39.onPositionChanged
	}, {
		inputBar = React.createElement(Foundation.View, {
			LayoutOrder = 1,
			tag = {
				["row size-full"] = true,
				["stroke-emphasis stroke-thick"] = not isDisabled,
				["stroke-alert"] = isDisabled
			},
			onActivated = v72,
			ref = v50,
			cornerRadius = UDim.new(0, v76 / 2),
			selection = {
				Selectable = true,
				NextSelectionRight = if not FFlagAppChatGamepadSendButtonNav then nil else v48
			},
			cursor = {
				offset = 0,
				radius = UDim.new(0, v76 / 2)
			}
		}, {
			inputBoxWrapper = React.createElement(Foundation.View, {
				tag = "size-0-full fill padding-left-large",
				LayoutOrder = 1,
				padding = {
					top = UDim.new(0, v59 / 2),
					bottom = UDim.new(0, v59 / 2)
				}
			}, {
				inputBox = if not isDisabled then React.createElement(CallbackInputBox, {
					initialInputText = v39.initialInputText,
					inputTextFont = BodyFont,
					inputTextColor3 = v57.Theme.TextEmphasis.Color,
					inputTextSize = v59,
					inputTextXAlignment = Enum.TextXAlignment.Left,
					inputTextYAlignment = Enum.TextYAlignment.Center,
					placeholderText = v39.placeholderText,
					placeholderTextColor3 = v57.Theme.TextMuted.Color,
					placeholderTextTransparency = v57.Theme.TextMuted.Transparency,
					clipsDescendants = false,
					multiLine = not v74,
					manualFocusRelease = true,
					textWrapped = true,
					focusChangedCallback = v68.focusChanged,
					clearButtonDisabled = true,
					clearButtonSize = 0,
					textChangedCallback = v70,
					[React.Change.AbsoluteSize] = v71,
					inputBoxRef = u46,
					returnPressedFromOnScreenKeyboardCallback = if not v74 then nil else v65
				}) else React.createElement(ChatInputBoxDisabled, {
					bodyText = v39.inputBarDisabledText,
					font = BodyFont,
					contentSize = v59,
					endTimestamp = v39.disabledEndTimestampDisplay,
					onActivated = v39.onDisabledInputBarActivated
				})
			}),
			sendButtonColumn = React.createElement(Foundation.View, {
				tag = "col size-0-full auto-x align-y-bottom",
				LayoutOrder = 2,
				Visible = v54
			}, {
				sendButtonWrapper = React.createElement(Foundation.View, {
					tag = "col flex-around padding-small",
					Size = UDim2.new(0, v76, 0, v76)
				}, {
					sendButton = React.createElement(Foundation.View, {
						tag = {
							["col radius-circle flex-around"] = true,
							["bg-action-emphasis"] = v44,
							["bg-action-standard"] = not v44
						},
						Size = UDim2.new(0, v76 - v56.Padding.Small, 0, v76 - v56.Padding.Small),
						isDisabled = not v44,
						onActivated = v65,
						selection = {
							Selectable = true,
							NextSelectionLeft = u47
						},
						cursor = {
							radius = UDim.new(0, v76 / 2),
							offset = v56.Padding.Small / 2
						},
						ref = v48
					}, {
						sendButtonIcon = React.createElement(Foundation.Icon, {
							style = v56.Color.ActionEmphasis.Foreground,
							size = Foundation.Enums.IconSize.Small,
							name = BuilderIcons.Icon.ArrowLargeUp
						})
					})
				})
			})
		})
	})
end

return React.memo(ChatInputBar)
