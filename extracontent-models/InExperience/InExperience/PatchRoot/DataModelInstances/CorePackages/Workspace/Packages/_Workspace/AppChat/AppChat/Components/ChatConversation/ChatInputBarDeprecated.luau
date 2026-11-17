local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialLibraries = require(AppChat.SocialLibraries)
local Roact = require(parent.Roact)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local AppCommonLib2 = require(parent.AppCommonLib)
local isTenFootInterface = AppCommonLib2.isTenFootInterface
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Interactable = UIBlox.Core.Control.Interactable
local withStyle = UIBlox.Style.withStyle
local isMessageValid = require(script.Parent.isMessageValid)
local MessageCharacterLimit = require(script.Parent.MessageCharacterLimit)
local isKeyCodePressed = require(AppChat.Components.ChatConversation.Utils.isKeyCodePressed)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local withChatPagePadding = require(AppChat.Contexts.ChatPagePadding.withChatPagePadding)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local CallbackInputBox = SocialLibraries.Components.CallbackInputBox
local ChatInputBoxDisabled = require(AppChat.Components.ChatConversation.ChatInputBoxDisabled)

local SendButtonClickActionResult = require(AppChat.Analytics.Enums.SendButtonClickActionResult)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local AppCommonLib3 = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib3.IsVRAppBuild

local getFIntAppChatBehaviorCollectionEnabledPercentage = require(AppChat.Flags.getFIntAppChatBehaviorCollectionEnabledPercentage)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatOnConsoles = SharedFlags.FFlagAppChatOnConsoles
local defineFastFlag = game:DefineFastFlag("AppChatUseTextBoxTextOnSend", false)

local extended = Roact.PureComponent:extend("ChatInputBarDeprecated")

local KeystrokeEvent = require(AppChat.Analytics.KeystrokeEvent)

extended.defaultProps = {
	userInputService = UserInputService,
	initialInputText = "",
	placeholderText = "Say something",
	inputBarDisabledText = "Chat Disabled",
	onDisabledInputBarActivated = function() end,
	sendButtonContainerSize = 45,
	LayoutOrder = 0,
	maxCharacterLength = MessageCharacterLimit,
	maxKeystrokeDataLength = 200,
	messageListRef = nil,
	onHeightChanged = function() end,
	onPositionChanged = function() end,
	onFocusLost = function() end,
	isDisabled = false,
	disabledEndTimestampDisplay = nil,
	moreMenuEnabled = false,
	onSendBtnClicked = nil,
	onSendChat = nil,
	onTextChanged = function() end,
	inputBoxRef = nil,
	inputBarRef = nil,
	eventLoggingFunc = default.logRobloxTelemetryEvent,
	textChangedFallback = false
}

function extended:init()
	self.isMounted = false
	self.state = {
		inputText = self.props.initialInputText,
		showSendChat = false,
		chatBarWidth = 0,
		frameHeight = 0
	}

	self.inputBoxRef = self.props.inputBoxRef or Roact.createRef()
	self.messageListRef = self.props.messageListRef
	self.inputBoxFocusLossKeyCodeRef = Roact.createRef()
	self.inputBoxFocusLossKeyCodeRef.current = Enum.KeyCode.None
	self.inputBarRef = self.props.inputBarRef or Roact.createRef()
	self.sendButtonRef = Roact.createRef()
	self.eventHandlerRegistration = nil

	self.textChangedFallback = self.props.textChangedFallback or not UserInputService.KeyboardEnabled

	function self.heightOfFourLines(p, p2, p3)
		return GetTextSize("A\nB\nC\nD", p2, p, Vector2.new(p3, 10000)).Y
	end

	function self.isMoreMenuEnabled()
		return self.props.moreMenuEnabled
	end

	function self.calculateInputBoxHeight(p, p2, p3, p4)
		local y = GetTextSize(p, p3, p2, Vector2.new(p4, 10000)).Y
		local heightOfFourLines = self.heightOfFourLines(p2, p3, p4)
		local v

		if self.isMoreMenuEnabled() then
			v = p3 + math.min(y, heightOfFourLines)
		else
			v = p3 + math.min(y, heightOfFourLines) + 16
		end

		if self.props.onHeightChanged then
			self.props.onHeightChanged(v)
		end

		return v
	end

	self.inputConnectionActive = false
	self.inputBeganConnection = nil
	self.inputEndedConnection = nil
	self.keyPressedData = {}
	self.eventTypeData = {}
	self.timestampData = {}
	self.shouldCollectKeystrokes = false
	local keystrokeCollectionEnabled = getAppFeaturePolicies().getKeystrokeCollectionEnabled()
	local fIntAppChatBehaviorCollectionEnabledPercentage = getFIntAppChatBehaviorCollectionEnabledPercentage()

	if fIntAppChatBehaviorCollectionEnabledPercentage > 0 and Players.LocalPlayer and keystrokeCollectionEnabled then
		self.shouldCollectKeystrokes = Players.LocalPlayer.UserId % 100 < fIntAppChatBehaviorCollectionEnabledPercentage
	end

	function self.onTextChanged(inputText, p, p2, p3)
		if not self.isMounted then
			return
		end

		self:setState({
			inputText = inputText,
			showSendChat = inputText and isMessageValid(inputText, self.props.maxCharacterLength) and true or false,
			frameHeight = self.calculateInputBoxHeight(inputText, p, p2, p3)
		})

		self.props.onTextChanged(inputText)

		if self.shouldCollectKeystrokes and self.textChangedFallback then
			self:recordTextChange(inputText)
		end
	end

	function self.onInputBeganEvent(p)
		if
			self.shouldCollectKeystrokes
			and not self.textChangedFallback
			and p.UserInputType == Enum.UserInputType.Keyboard
		then
			self:recordKeystroke(true, p.KeyCode)
		end

		if
			isKeyCodePressed({ p }, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter)
			and not isKeyCodePressed(
				self.props.userInputService:GetKeysPressed(),
				Enum.KeyCode.LeftShift,
				Enum.KeyCode.RightShift
			)
		then
			self.onSendActivated()
		end
	end

	function self.onInputEndedEvent(p)
		if
			self.shouldCollectKeystrokes
			and not self.textChangedFallback
			and p.UserInputType == Enum.UserInputType.Keyboard
		then
			self:recordKeystroke(false, p.KeyCode)
		end
	end

	function self.focusChanged(p)
		if p and not self.inputConnectionActive then
			self.inputBeganConnection = self.props.userInputService.InputBegan:Connect(self.onInputBeganEvent)
			self.inputEndedConnection = self.props.userInputService.InputEnded:Connect(self.onInputEndedEvent)
			self.inputConnectionActive = true
		elseif not p and self.inputConnectionActive then
			self:disconnectInputConnection()
			self.props.onFocusLost()
		end
	end

	function self.onSendActivated()
		local v

		if defineFastFlag then
			v = not self.inputBoxRef.current and "" or self.inputBoxRef.current.Text
		else
			v = self.state.inputText
		end

		local v2

		if defineFastFlag then
			v2 = v and isMessageValid(v, self.props.maxCharacterLength)
		else
			v2 = self.state.showSendChat
		end

		local trimmed = Text.Trim(v)
		local v3 = SendButtonClickActionResult.None

		if v2 and isMessageValid(trimmed, self.props.maxCharacterLength) then
			local value = self.inputBoxRef:getValue()
			value.Text = ""

			if
				self.focusNavigationService
				and self.focusNavigationService.focusedGuiObject:getValue() == self.sendButtonRef:getValue()
			then
				self.focusNavigationService:focusGuiObject(self.inputBarRef:getValue(), false)
			end

			local v4

			if FFlagAppChatOnConsoles then
				v4 = isTenFootInterface()
			end

			if FFlagAppChatOnConsoles and v4 then
				self.inputBoxRef.current:ReleaseFocus()
			end

			self:setState({ inputText = "", showSendChat = false })

			if self.props.onSendChat then
				if trimmed == "/shrug" then
					self.props.onSendChat("¯\\_(ツ)_/¯")
				else
					self.props.onSendChat(trimmed)
				end

				v3 = SendButtonClickActionResult.WillSend
			end

			local listRef = self.messageListRef and self.messageListRef.current and self.messageListRef.current._listRef

			if listRef then
				listRef:scrollToOffset({ offset = 0 })
			end
		elseif v2 then
			v3 = SendButtonClickActionResult.MessageInvalid
		else
			v3 = SendButtonClickActionResult.ButtonInactive
		end

		if self.props.onSendBtnClicked then
			self.props.onSendBtnClicked(v3)
		end

		if self.shouldCollectKeystrokes then
			self:sendKeystrokeEvent("UASendPressed")
		end
	end

	function self.chatBoxSizeChanged(p, p2, p3, p4)
		local inputBoxHeight = self.calculateInputBoxHeight(p2, p3, p4, p.AbsoluteSize.X)
		self:setState({ chatBarWidth = p.AbsoluteSize.X, frameHeight = inputBoxHeight })
	end

	function self.onDisabledInputBarActivated()
		self.props.onDisabledInputBarActivated()
	end

	function self.focusChatInputBox()
		if self.inputBoxRef and self.inputBoxRef.current then
			self.inputBoxRef.current:CaptureFocus()
		end
	end

	function self.focusNavigationEventHandler(object)
		if object.eventData and self.inputBoxFocusLossKeyCodeRef.current == object.eventData.KeyCode then
			object:cancel()
			self.inputBoxFocusLossKeyCodeRef.current = Enum.KeyCode.None
		end
	end
end

function extended:render()
	local isDisabled = self.props.isDisabled
	return Roact.createElement(ReactFocusNavigation.FocusNavigationContext.Consumer, {
		render = function(focusNavigationService)
			self.focusNavigationService = focusNavigationService
			return self:renderContent(isDisabled)
		end
	})
end

function extended:renderContent(p)
	return withStyle(function(data)
		return withChatPagePadding(function(p2)
			return withSelectionCursorProvider(function(callback)
				local font = data.Font
				local font2 = data.Tokens.Typography.BodyLarge.Font
				local v = font.BaseSize * font.Body.RelativeSize
				local v2

				if FFlagAppChatOnConsoles then
					v2 = IsVRAppBuild() or isTenFootInterface()
				end

				local v3 = self.state.frameHeight

				if v3 == 0 then
					v3 = self.calculateInputBoxHeight(self.state.inputText, font2, v, self.state.chatBarWidth)
				end

				local udim = UDim.new(0, (math.max(p2.right - 6, 0)))

				if p then
					udim = UDim.new(0, p2.right)
				end

				local createElement = Roact.createElement
				local onPositionChangedsByAbsolutePosition = {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = self.props.LayoutOrder,
					Size = UDim2.new(1, 0, 0, v3),
					[Roact.Change.AbsolutePosition] = self.props.onPositionChanged
				}
				local v4 = {
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					flex = 0,
					padding = 0,
					inputBorder = 0,
					sendButton = 0
				}
				local flex

				if self.isMoreMenuEnabled() then
					flex = Roact.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
				end

				v4.flex = flex
				local padding

				if not self.isMoreMenuEnabled() then
					padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, p2.left),
						PaddingRight = udim,
						PaddingBottom = UDim.new(0, 13),
						PaddingTop = UDim.new(0, 8)
					})
				end

				v4.padding = padding

				local createElement2 = Roact.createElement
				local v5 = {
					Size = UDim2.new(1, p and 0 or -self.props.sendButtonContainerSize, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = Images["component_assets/circle_21_stroke_1"],
					ImageColor3 = 0,
					ScaleType = 0,
					SliceCenter = 0
				}
				local imageColor

				if self.props.isDisabled then
					imageColor = data.Tokens.Color.System.Alert.Color3
				else
					imageColor = data.Theme.Divider.Color
				end

				v5.ImageColor3 = imageColor

				v5.ScaleType = Enum.ScaleType.Slice
				v5.SliceCenter = Rect.new(8, 8, 9, 9)

				local createElement3 = Roact.createElement
				local inputBarRefsByRef = {
					Name = "inputBar",
					SelectionImageObject = callback(CursorKind.RoundedRectNoInset),
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Selectable = true,
					NextSelectionRight = self.sendButtonRef,
					onActivated = self.focusChatInputBox,
					[Roact.Ref] = self.inputBarRef
				}

				local createElement4 = Roact.createElement
				local v6 = {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = Images["component_assets/circle_21"],
					ImageColor3 = data.Theme.UIMuted.Color,
					ImageTransparency = data.Theme.UIMuted.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}

				local createElement5 = Roact.createElement
				local paddingTop

				if not self.isMoreMenuEnabled() then
					paddingTop = UDim.new(0, v / 2.5)
				end

				local v7 = {
					padding = createElement5("UIPadding", {
						PaddingTop = paddingTop,
						PaddingLeft = UDim.new(0.02, 0),
						PaddingRight = UDim.new(0.02, 0)
					}),
					inputBox = 0
				}
				local inputBox

				if p then
					inputBox = Roact.createElement(ChatInputBoxDisabled, {
						bodyText = self.props.inputBarDisabledText,
						contentSize = v,
						endTimestamp = self.props.disabledEndTimestampDisplay,
						font = font2,
						onActivated = self.onDisabledInputBarActivated
					})
				else
					local createElement6 = Roact.createElement
					local v8 = {}
					v8.initialInputText = self.props.initialInputText
					v8.inputTextFont = font2
					v8.inputTextColor3 = data.Theme.TextEmphasis.Color
					v8.inputTextSize = v
					v8.inputTextXAlignment = Enum.TextXAlignment.Left
					local inputTextYAlignment

					if self.isMoreMenuEnabled() then
						inputTextYAlignment = Enum.TextYAlignment.Center
					else
						inputTextYAlignment = Enum.TextYAlignment.Top
					end

					v8.inputTextYAlignment = inputTextYAlignment

					v8.placeholderText = self.props.placeholderText
					v8.placeholderTextColor3 = data.Theme.TextMuted.Color
					v8.placeholderTextTransparency = data.Theme.TextMuted.Transparency

					v8.clipsDescendants = false
					v8.multiLine = not IsVRAppBuild()
					v8.manualFocusRelease = true
					v8.textWrapped = true
					v8.focusChangedCallback = self.focusChanged

					v8.clearButtonDisabled = true
					v8.clearButtonSize = 0

					function v8.textChangedCallback(p3)
						self.onTextChanged(p3, font2, v, self.state.chatBarWidth)
					end
					v8[Roact.Change.AbsoluteSize] = function(p3)
						self.chatBoxSizeChanged(p3, self.state.inputText, font2, v)
					end
					v8.inputBoxRef = self.inputBoxRef
					local onSendActivated

					if FFlagAppChatOnConsoles then
						if v2 then
							onSendActivated = self.onSendActivated
						end
					elseif IsVRAppBuild() then
						onSendActivated = self.onSendActivated
					end

					v8.returnPressedFromOnScreenKeyboardCallback = onSendActivated
					inputBox = createElement6(CallbackInputBox, v8)
				end

				v7.inputBox = inputBox
				v4.inputBorder = createElement2(ImageSetLabel, v5, {
					inputImage = createElement3(Interactable, inputBarRefsByRef, {
						createElement4(ImageSetLabel, v6, v7)
					})
				})
				local sendButton

				if not p then
					sendButton = withSelectionCursorProvider(function(callback2)
						local createElement6 = Roact.createElement
						local v8 = {
							Name = "sendButton",
							Size = UDim2.new(0, self.props.sendButtonContainerSize, 1, 0),
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Text = "",
							SelectionImageObject = callback2(CursorKind.RoundedRectNoInset),
							Selectable = true,
							NextSelectionLeft = self.inputBarRef,
							[Roact.Event.Activated] = self.onSendActivated,
							[Roact.Ref] = self.sendButtonRef
						}
						local v9 = {
							layout = Roact.createElement("UIListLayout", {
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Right
							}),
							sendIcon = 0
						}

						local createElement7 = Roact.createElement
						local v10 = {
							Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
							BackgroundTransparency = 1,
							ImageColor3 = 0,
							ImageTransparency = 0,
							Image = 0
						}
						local imageColor2

						if self.state.showSendChat then
							imageColor2 = data.Tokens.Color.Content.Emphasis.Color3
						else
							imageColor2 = data.Tokens.Color.Content.Default.Color3
						end

						v10.ImageColor3 = imageColor2

						v10.ImageTransparency = self.state.showSendChat and 0 or 0.5
						v10.Image = Images["icons/actions/send"]
						v9.sendIcon = createElement7(ImageSetLabel, v10)
						return createElement6("TextButton", v8, v9)
					end)
				end

				v4.sendButton = sendButton
				return createElement("Frame", onPositionChangedsByAbsolutePosition, v4)
			end)
		end)
	end)
end

function extended:didMount()
	self.isMounted = true

	if self.inputBoxRef and self.inputBoxRef.current then
		self.inputBoxRef.current.Selectable = false
		self.focusLostConnection = self.inputBoxRef.current.FocusLost:Connect(function(_: boolean, p)
			local inputBoxFocusLossKeyCodeRef = self.inputBoxFocusLossKeyCodeRef
			local current = if p then p.KeyCode else Enum.KeyCode.None
			inputBoxFocusLossKeyCodeRef.current = current
		end)
	end

	if self.focusNavigationService and self.inputBarRef.current then
		self.eventHandlerRegistration = self.focusNavigationService:registerEventHandler(
			self.inputBarRef.current,
			FocusNavigationEventNameEnum.NavigateBack,
			self.focusNavigationEventHandler
		)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if self.inputConnectionActive then
		self:disconnectInputConnection()
	end

	if self.props.onHeightChanged then
		self.props.onHeightChanged(0)
	end

	if self.focusLostConnection then
		self.focusLostConnection:Disconnect()
	end

	if self.eventHandlerRegistration then
		self.eventHandlerRegistration:Disconnect()
	end
end

function extended:recordKeystroke(p, p2)
	if p then
		table.insert(self.keyPressedData, p2.Name)
		table.insert(self.eventTypeData, 0)
		table.insert(self.timestampData, DateTime.now().UnixTimestampMillis)
	elseif p2 ~= Enum.KeyCode.Return and p2 ~= Enum.KeyCode.KeypadEnter or #self.keyPressedData ~= 0 then
		table.insert(self.keyPressedData, p2.Name)
		table.insert(self.eventTypeData, 1)
		table.insert(self.timestampData, DateTime.now().UnixTimestampMillis)
	end

	if #self.keyPressedData >= self.props.maxKeystrokeDataLength then
		self:sendKeystrokeEvent("UAMaxLengthReached")
	end
end

function extended:recordTextChange(value)
	table.insert(self.keyPressedData, value:sub(-1))
	table.insert(self.timestampData, DateTime.now().UnixTimestampMillis)

	if #self.keyPressedData >= self.props.maxKeystrokeDataLength then
		self:sendKeystrokeEvent("UAMaxLengthReached")
	end
end

function extended:sendKeystrokeEvent(chatContext)
	if #self.keyPressedData >= 0 then
		self.props.eventLoggingFunc(default, KeystrokeEvent, {}, {
			chatContext = chatContext,
			keyPressedData = table.concat(self.keyPressedData, ","),
			eventTypeData = table.concat(self.eventTypeData, ","),
			timestampData = table.concat(self.timestampData, ",")
		})

		self.keyPressedData = {}
		self.eventTypeData = {}
		self.timestampData = {}
	end
end

function extended:disconnectInputConnection()
	if self.inputBeganConnection then
		self.inputBeganConnection:Disconnect()
		self.inputBeganConnection = nil
	end

	if self.inputEndedConnection then
		self.inputEndedConnection:Disconnect()
		self.inputEndedConnection = nil
	end

	self.inputConnectionActive = false
end

return extended
