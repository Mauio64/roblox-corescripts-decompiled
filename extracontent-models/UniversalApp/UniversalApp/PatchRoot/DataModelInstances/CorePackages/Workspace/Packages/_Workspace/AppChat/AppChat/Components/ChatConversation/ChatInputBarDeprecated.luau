local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)
local Roact = require(AppChatParent.Roact)
local Text = require(AppChatParent.AppCommonLib).Text
local UIBlox = require(AppChatParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Interactable = UIBlox.Core.Control.Interactable
local withStyle = UIBlox.Style.withStyle
local isMessageValid = require(script.Parent.isMessageValid)
local isKeyCodePressed = require(AppChat.Components.ChatConversation.Utils.isKeyCodePressed)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local default = require(AppChatParent.LoggingProtocol).default
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local withChatPagePadding = require(AppChat.Contexts.ChatPagePadding.withChatPagePadding)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(AppChatParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local CallbackInputBox = SocialLibraries.Components.CallbackInputBox
local ChatInputBoxDisabled = require(AppChat.Components.ChatConversation.ChatInputBoxDisabled)
local SendButtonClickActionResult = require(AppChat.Analytics.Enums.SendButtonClickActionResult)
local getAppFeaturePolicies = require(AppChatParent.UniversalAppPolicy).getAppFeaturePolicies
local IsVRAppBuild = require(AppChatParent.AppCommonLib).IsVRAppBuild
local getFIntAppChatBehaviorCollectionEnabledPercentage = require(AppChat.Flags.getFIntAppChatBehaviorCollectionEnabledPercentage)
local FFlagAppChatGamepadSendButtonNav = require(AppChat.Flags.FFlagAppChatGamepadSendButtonNav)
local v29 = Roact.PureComponent:extend("ChatInputBarDeprecated")
local KeystrokeEvent = require(AppChat.Analytics.KeystrokeEvent)

v29.defaultProps = {
	initialInputText = "",
	placeholderText = "Say something",
	inputBarDisabledText = "Chat Disabled",
	sendButtonContainerSize = 45,
	LayoutOrder = 0,
	maxCharacterLength = 160,
	maxKeystrokeDataLength = 200,
	messageListRef = nil,
	isDisabled = false,
	disabledEndTimestampDisplay = nil,
	moreMenuEnabled = false,
	onSendBtnClicked = nil,
	onSendChat = nil,
	inputBoxRef = nil,
	inputBarRef = nil,
	textChangedFallback = false,
	userInputService = UserInputService,
	onDisabledInputBarActivated = function() -- line: 49
	end,
	onHeightChanged = function() -- line: 55
	end,
	onPositionChanged = function() -- line: 56
	end,
	onFocusLost = function() -- line: 57
	end,
	onTextChanged = function() -- line: 64
	end,
	eventLoggingFunc = default.logRobloxTelemetryEvent
}

function v29.init(p1) -- line: 73
	-- upvalues: Roact (copy), UserInputService (copy), Text (copy), getAppFeaturePolicies (copy), getFIntAppChatBehaviorCollectionEnabledPercentage (copy), Players (copy), isMessageValid (copy), isKeyCodePressed (copy), SendButtonClickActionResult (copy)
	p1.isMounted = false
	p1.state = {
		showSendChat = false,
		chatBarWidth = 0,
		frameHeight = 0,
		inputText = p1.props.initialInputText
	}
	p1.inputBoxRef = p1.props.inputBoxRef or Roact.createRef()
	p1.messageListRef = p1.props.messageListRef
	p1.inputBoxFocusLossKeyCodeRef = Roact.createRef()
	p1.inputBoxFocusLossKeyCodeRef.current = Enum.KeyCode.Unknown
	p1.inputBarRef = p1.props.inputBarRef or Roact.createRef()
	p1.sendButtonRef = Roact.createRef()
	p1.eventHandlerRegistration = nil
	p1.textChangedFallback = p1.props.textChangedFallback or not UserInputService.KeyboardEnabled

	function p1.heightOfFourLines(p2, p3, p4) -- line: 92
		-- upvalues: Text (copy)
		return Text.GetTextHeight("A\nB\nC\nD", p2, p3, p4)
	end
	function p1.isMoreMenuEnabled() -- line: 96
		-- upvalues: p1 (copy)
		return p1.props.moreMenuEnabled
	end
	function p1.calculateInputBoxHeight(p5, p6, p7, p8) -- line: 100
		-- upvalues: Text (copy), p1 (copy)
		local v55 = Text.GetTextHeight(p5, p6, p7, p8)
		local v56 = p1.heightOfFourLines(p6, p7, p8)
		local v57 = if not p1.isMoreMenuEnabled() then p7 + math.min(v55, v56) + 16 else p7 + math.min(v55, v56)

		if p1.props.onHeightChanged then
			p1.props.onHeightChanged(v57)
		end

		return v57
	end

	p1.inputConnectionActive = false
	p1.inputBeganConnection = nil
	p1.inputEndedConnection = nil
	p1.keyPressedData = {}
	p1.eventTypeData = {}
	p1.timestampData = {}
	p1.shouldCollectKeystrokes = false

	local v32 = getAppFeaturePolicies().getKeystrokeCollectionEnabled()
	local v33 = getFIntAppChatBehaviorCollectionEnabledPercentage()

	if v33 > 0 and (Players.LocalPlayer and v32) then
		p1.shouldCollectKeystrokes = v33 > Players.LocalPlayer.UserId % 100
	end

	function p1.onTextChanged(p9, p10, p11, p12) -- line: 131
		-- upvalues: p1 (copy), isMessageValid (copy)
		if not p1.isMounted then
			return
		end

		local v62 = false

		if p9 and isMessageValid(p9, p1.props.maxCharacterLength) then
			v62 = true
		end

		local v63 = p1.calculateInputBoxHeight(p9, p10, p11, p12)

		p1:setState({
			inputText = p9,
			showSendChat = v62,
			frameHeight = v63
		})
		p1.props.onTextChanged(p9)

		if p1.shouldCollectKeystrokes and p1.textChangedFallback then
			p1:recordTextChange(p9)
		end
	end
	function p1.onInputBeganEvent(p13) -- line: 158
		-- upvalues: p1 (copy), isKeyCodePressed (copy)
		if p1.shouldCollectKeystrokes and (not p1.textChangedFallback and p13.UserInputType == Enum.UserInputType.Keyboard) then
			p1:recordKeystroke(true, p13.KeyCode)
		end

		if isKeyCodePressed({ p13 }, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter) and not isKeyCodePressed(p1.props.userInputService:GetKeysPressed(), Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift) then
			p1.onSendActivated()
		end
	end
	function p1.onInputEndedEvent(p14) -- line: 177
		-- upvalues: p1 (copy)
		if p1.shouldCollectKeystrokes and (not p1.textChangedFallback and p14.UserInputType == Enum.UserInputType.Keyboard) then
			p1:recordKeystroke(false, p14.KeyCode)
		end
	end
	function p1.focusChanged(p15) -- line: 185
		-- upvalues: p1 (copy)
		if p15 and not p1.inputConnectionActive then
			p1.inputBeganConnection = p1.props.userInputService.InputBegan:Connect(p1.onInputBeganEvent)
			p1.inputEndedConnection = p1.props.userInputService.InputEnded:Connect(p1.onInputEndedEvent)
			p1.inputConnectionActive = true

			return
		end

		if not p15 and p1.inputConnectionActive then
			p1:disconnectInputConnection()
			p1.props.onFocusLost()
		end
	end
	function p1.onSendActivated() -- line: 196
		-- upvalues: Text (copy), p1 (copy), SendButtonClickActionResult (copy), isMessageValid (copy)
		local v67 = Text.Trim(p1.state.inputText)
		local None = SendButtonClickActionResult.None

		if p1.state.showSendChat and isMessageValid(v67, p1.props.maxCharacterLength) then
			p1.inputBoxRef:getValue().Text = ""

			if p1.focusNavigationService and p1.focusNavigationService.focusedGuiObject:getValue() == p1.sendButtonRef:getValue() then
				p1.focusNavigationService:focusGuiObject(p1.inputBarRef:getValue(), false)
			end

			p1:setState({
				inputText = "",
				showSendChat = false
			})

			if p1.props.onSendChat then
				if v67 == "/shrug" then
					p1.props.onSendChat("¯\\_(ツ)_/¯")
				else
					p1.props.onSendChat(v67)
				end

				None = SendButtonClickActionResult.WillSend
			end

			local v69 = p1.messageListRef and (p1.messageListRef.current and p1.messageListRef.current._listRef)

			if v69 then
				v69:scrollToOffset({
					offset = 0
				})
			end
		else
			None = if p1.state.showSendChat then SendButtonClickActionResult.MessageInvalid else SendButtonClickActionResult.ButtonInactive
		end

		if p1.props.onSendBtnClicked then
			p1.props.onSendBtnClicked(None)
		end

		if p1.shouldCollectKeystrokes then
			p1:sendKeystrokeEvent("UASendPressed")
		end
	end
	function p1.chatBoxSizeChanged(p16, p17, p18, p19) -- line: 250
		-- upvalues: p1 (copy)
		local v74 = p1.calculateInputBoxHeight(p17, p18, p19, p16.AbsoluteSize.X)

		p1:setState({
			chatBarWidth = p16.AbsoluteSize.X,
			frameHeight = v74
		})
	end
	function p1.onDisabledInputBarActivated() -- line: 258
		-- upvalues: p1 (copy)
		p1.props.onDisabledInputBarActivated()
	end
	function p1.focusChatInputBox() -- line: 262
		-- upvalues: p1 (copy)
		if p1.inputBoxRef and p1.inputBoxRef.current then
			p1.inputBoxRef.current:CaptureFocus()
		end
	end
	function p1.focusNavigationEventHandler(p20) -- line: 268
		-- upvalues: p1 (copy)
		if p20.eventData and p1.inputBoxFocusLossKeyCodeRef.current == p20.eventData.KeyCode then
			p20:cancel()
			p1.inputBoxFocusLossKeyCodeRef.current = Enum.KeyCode.Unknown
		end
	end
end
function v29.render(p21) -- line: 276
	-- upvalues: Roact (copy), ReactFocusNavigation (copy)
	local isDisabled = p21.props.isDisabled

	return Roact.createElement(ReactFocusNavigation.FocusNavigationContext.Consumer, {
		render = function(p22) -- line: 279
			-- upvalues: p21 (copy), isDisabled (copy)
			p21.focusNavigationService = p22

			return p21:renderContent(isDisabled)
		end
	})
end
function v29.renderContent(p23, p24) -- line: 286
	-- upvalues: withStyle (copy), withChatPagePadding (copy), withSelectionCursorProvider (copy), Roact (copy), ImageSetLabel (copy), Images (copy), Interactable (copy), CursorKind (copy), FFlagAppChatGamepadSendButtonNav (copy), ChatInputBoxDisabled (copy), CallbackInputBox (copy), IsVRAppBuild (copy), IconSize (copy)
	return withStyle(function(p25) -- line: 287
		-- upvalues: withChatPagePadding (copy), withSelectionCursorProvider (copy), p23 (copy), p24 (copy), Roact (copy), ImageSetLabel (copy), Images (copy), Interactable (copy), CursorKind (copy), FFlagAppChatGamepadSendButtonNav (copy), ChatInputBoxDisabled (copy), CallbackInputBox (copy), IsVRAppBuild (copy), IconSize (copy)
		return withChatPagePadding(function(p26) -- line: 288
			-- upvalues: withSelectionCursorProvider (copy), p25 (copy), p23 (copy), p24 (copy), Roact (copy), ImageSetLabel (copy), Images (copy), Interactable (copy), CursorKind (copy), FFlagAppChatGamepadSendButtonNav (copy), ChatInputBoxDisabled (copy), CallbackInputBox (copy), IsVRAppBuild (copy), IconSize (copy)
			return withSelectionCursorProvider(function(p27) -- line: 289
				-- upvalues: p25 (copy), p23 (copy), p26 (copy), p24 (copy), Roact (copy), ImageSetLabel (copy), Images (copy), Interactable (copy), CursorKind (copy), FFlagAppChatGamepadSendButtonNav (copy), ChatInputBoxDisabled (copy), CallbackInputBox (copy), IsVRAppBuild (copy), withSelectionCursorProvider (copy), IconSize (copy)
				local p25Font = p25.Font
				local BodyFont = p25Font.Body.Font
				local v84 = p25Font.BaseSize * p25Font.Body.RelativeSize
				local frameHeight = p23.state.frameHeight

				if frameHeight == 0 then
					frameHeight = p23.calculateInputBoxHeight(p23.state.inputText, BodyFont, v84, p23.state.chatBarWidth)
				end

				local uDim = UDim.new(0, (math.max(p26.right - 6, 0)))

				if p24 then
					uDim = UDim.new(0, p26.right)
				end

				return Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = p23.props.LayoutOrder,
					Size = UDim2.new(1, 0, 0, frameHeight),
					[Roact.Change.AbsolutePosition] = p23.props.onPositionChanged
				}, {
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					flex = if not p23.isMoreMenuEnabled() then nil else Roact.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Fill
					}),
					padding = if not p23.isMoreMenuEnabled() then Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, p26.left),
						PaddingRight = uDim,
						PaddingBottom = UDim.new(0, 13),
						PaddingTop = UDim.new(0, 8)
					}) else nil,
					inputBorder = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, if not p24 then -p23.props.sendButtonContainerSize else 0, 1, 0),
						Image = Images["component_assets/circle_21_stroke_1"],
						ImageColor3 = if not p23.props.isDisabled then p25.Theme.Divider.Color else p25.Tokens.Color.System.Alert.Color3,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9)
					}, {
						inputImage = Roact.createElement(Interactable, {
							Name = "inputBar",
							SelectionImageObject = p27(CursorKind.RoundedRectNoInset),
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Selectable = true,
							NextSelectionRight = if not FFlagAppChatGamepadSendButtonNav then nil else p23.sendButtonRef,
							onActivated = p23.focusChatInputBox,
							[Roact.Ref] = p23.inputBarRef
						}, { Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 1, 0),
							Image = Images["component_assets/circle_21"],
							ImageColor3 = p25.Theme.UIMuted.Color,
							ImageTransparency = p25.Theme.UIMuted.Transparency,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(8, 8, 9, 9)
						}, {
							padding = Roact.createElement("UIPadding", {
								PaddingTop = if not p23.isMoreMenuEnabled() then UDim.new(0, v84 / 2.5) else nil,
								PaddingLeft = UDim.new(0.02, 0),
								PaddingRight = UDim.new(0.02, 0)
							}),
							inputBox = if not p24 then Roact.createElement(CallbackInputBox, {
								initialInputText = p23.props.initialInputText,
								inputTextFont = BodyFont,
								inputTextColor3 = p25.Theme.TextEmphasis.Color,
								inputTextSize = v84,
								inputTextXAlignment = Enum.TextXAlignment.Left,
								inputTextYAlignment = if not p23.isMoreMenuEnabled() then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center,
								placeholderText = p23.props.placeholderText,
								placeholderTextColor3 = p25.Theme.TextMuted.Color,
								placeholderTextTransparency = p25.Theme.TextMuted.Transparency,
								clipsDescendants = false,
								multiLine = not IsVRAppBuild(),
								manualFocusRelease = true,
								textWrapped = true,
								focusChangedCallback = p23.focusChanged,
								clearButtonDisabled = true,
								clearButtonSize = 0,
								textChangedCallback = function(p28) -- line: 409
									-- upvalues: p23 (copy), BodyFont (copy), v84 (copy)
									p23.onTextChanged(p28, BodyFont, v84, p23.state.chatBarWidth)
								end,
								[Roact.Change.AbsoluteSize] = function(p29) -- line: 412
									-- upvalues: p23 (copy), BodyFont (copy), v84 (copy)
									p23.chatBoxSizeChanged(p29, p23.state.inputText, BodyFont, v84)
								end,
								inputBoxRef = p23.inputBoxRef,
								returnPressedFromOnScreenKeyboardCallback = if not IsVRAppBuild() then nil else p23.onSendActivated
							}) else Roact.createElement(ChatInputBoxDisabled, {
								bodyText = p23.props.inputBarDisabledText,
								contentSize = v84,
								endTimestamp = p23.props.disabledEndTimestampDisplay,
								font = BodyFont,
								onActivated = p23.onDisabledInputBarActivated
							})
						}) })
					}),
					sendButton = if p24 then nil else withSelectionCursorProvider(function(p30) -- line: 424
						-- upvalues: Roact (copy), p23 (copy), CursorKind (copy), ImageSetLabel (copy), IconSize (copy), p25 (copy), Images (copy)
						return Roact.createElement("TextButton", {
							Name = "sendButton",
							Size = UDim2.new(0, p23.props.sendButtonContainerSize, 1, 0),
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Text = "",
							SelectionImageObject = p30(CursorKind.RoundedRectNoInset),
							Selectable = true,
							NextSelectionLeft = p23.inputBarRef,
							[Roact.Event.Activated] = p23.onSendActivated,
							[Roact.Ref] = p23.sendButtonRef
						}, {
							layout = Roact.createElement("UIListLayout", {
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Right
							}),
							sendIcon = Roact.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
								ImageColor3 = if not p23.state.showSendChat then p25.Tokens.Color.Content.Default.Color3 else p25.Tokens.Color.Content.Emphasis.Color3,
								ImageTransparency = not p23.state.showSendChat and 0.5 or 0,
								Image = Images["icons/actions/send"]
							})
						})
					end)
				})
			end)
		end)
	end)
end
function v29.didMount(p31) -- line: 460
	-- upvalues: FocusNavigationEventNameEnum (copy)
	p31.isMounted = true

	if p31.inputBoxRef and p31.inputBoxRef.current then
		p31.inputBoxRef.current.Selectable = false
		p31.focusLostConnection = p31.inputBoxRef.current.FocusLost:Connect(function(_: boolean, p32) -- line: 465
			-- upvalues: p31 (copy)
			p31.inputBoxFocusLossKeyCodeRef.current = if not p32 then Enum.KeyCode.Unknown else p32.KeyCode
		end)
	end

	if p31.focusNavigationService and p31.inputBarRef.current then
		p31.eventHandlerRegistration = p31.focusNavigationService:registerEventHandler(p31.inputBarRef.current, FocusNavigationEventNameEnum.NavigateBack, p31.focusNavigationEventHandler)
	end
end
function v29.willUnmount(p33) -- line: 483
	p33.isMounted = false

	if p33.inputConnectionActive then
		p33:disconnectInputConnection()
	end

	if p33.props.onHeightChanged then
		p33.props.onHeightChanged(0)
	end

	if p33.focusLostConnection then
		p33.focusLostConnection:Disconnect()
	end

	if p33.eventHandlerRegistration then
		p33.eventHandlerRegistration:Disconnect()
	end
end
function v29.recordKeystroke(p34, p35, p36) -- line: 503
	if p35 then
		table.insert(p34.keyPressedData, p36.Name)
		table.insert(p34.eventTypeData, 0)
		table.insert(p34.timestampData, DateTime.now().UnixTimestampMillis)
	elseif p36 ~= Enum.KeyCode.Return and p36 ~= Enum.KeyCode.KeypadEnter or #p34.keyPressedData ~= 0 then
		table.insert(p34.keyPressedData, p36.Name)
		table.insert(p34.eventTypeData, 1)
		table.insert(p34.timestampData, DateTime.now().UnixTimestampMillis)
	end

	if #p34.keyPressedData >= p34.props.maxKeystrokeDataLength then
		p34:sendKeystrokeEvent("UAMaxLengthReached")
	end
end
function v29.recordTextChange(p37, p38) -- line: 523
	table.insert(p37.keyPressedData, p38:sub(-1))
	table.insert(p37.timestampData, DateTime.now().UnixTimestampMillis)

	if #p37.keyPressedData >= p37.props.maxKeystrokeDataLength then
		p37:sendKeystrokeEvent("UAMaxLengthReached")
	end
end
function v29.sendKeystrokeEvent(p39, p40) -- line: 533
	-- upvalues: default (copy), KeystrokeEvent (copy)
	if #p39.keyPressedData >= 0 then
		p39.props.eventLoggingFunc(default, KeystrokeEvent, {}, {
			chatContext = p40,
			keyPressedData = table.concat(p39.keyPressedData, ","),
			eventTypeData = table.concat(p39.eventTypeData, ","),
			timestampData = table.concat(p39.timestampData, ",")
		})
		p39.keyPressedData = {}
		p39.eventTypeData = {}
		p39.timestampData = {}
	end
end
function v29.disconnectInputConnection(p41) -- line: 547
	if p41.inputBeganConnection then
		p41.inputBeganConnection:Disconnect()
		p41.inputBeganConnection = nil
	end

	if p41.inputEndedConnection then
		p41.inputEndedConnection:Disconnect()
		p41.inputEndedConnection = nil
	end

	p41.inputConnectionActive = false
end

return v29
