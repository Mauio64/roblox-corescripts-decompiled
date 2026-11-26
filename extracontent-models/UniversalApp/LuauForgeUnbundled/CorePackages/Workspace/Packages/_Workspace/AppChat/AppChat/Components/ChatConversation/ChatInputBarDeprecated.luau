local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Text
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style").GetTextSize
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").isTenFootInterface
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.Constant.IconSize
local interactable = UIBlox.Core.Control.Interactable
local withStyle = UIBlox.Style.withStyle
local isMessageValid = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/isMessageValid")
local MessageCharacterLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageCharacterLimit")
local isKeyCodePressed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/isKeyCodePressed")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LoggingProtocol").default
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local withChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/withChatPagePadding")
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils").FocusNavigationEventNameEnum

local callbackInputBox = SocialLibraries.Components.CallbackInputBox
local ChatInputBoxDisabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatInputBoxDisabled")

local SendButtonClickActionResult = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/SendButtonClickActionResult")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").getAppFeaturePolicies

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").IsVRAppBuild

local getFIntAppChatBehaviorCollectionEnabledPercentage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFIntAppChatBehaviorCollectionEnabledPercentage")
local fFlagAppChatOnConsoles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatOnConsoles
local defineFastFlag = game:DefineFastFlag("AppChatUseTextBoxTextOnSend", false)

local extended = Roact.PureComponent:extend("ChatInputBarDeprecated")

local KeystrokeEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/KeystrokeEvent")

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

	function self.heightOfFourLines(p2, p3, p4)
		return getTextSize("A\nB\nC\nD", p3, p2, Vector2.new(p4, 10000)).Y
	end

	function self.isMoreMenuEnabled()
		return self.props.moreMenuEnabled
	end

	function self.calculateInputBoxHeight(p2, p3, p4, p5)
		local y = getTextSize(p2, p4, p3, Vector2.new(p5, 10000)).Y
		local heightOfFourLines = self.heightOfFourLines(p3, p4, p5)
		local v5

		if self.isMoreMenuEnabled() then
			v5 = p4 + math.min(y, heightOfFourLines)
		else
			v5 = p4 + math.min(y, heightOfFourLines) + 16
		end

		if self.props.onHeightChanged then
			self.props.onHeightChanged(v5)
		end

		return v5
	end

	self.inputConnectionActive = false
	self.inputBeganConnection = nil
	self.inputEndedConnection = nil
	self.keyPressedData = {}
	self.eventTypeData = {}
	self.timestampData = {}
	self.shouldCollectKeystrokes = false
	local keystrokeCollectionEnabled = getAppFeaturePolicies().getKeystrokeCollectionEnabled()
	local v5 = getFIntAppChatBehaviorCollectionEnabledPercentage()

	if v5 > 0 and Players.LocalPlayer and keystrokeCollectionEnabled then
		self.shouldCollectKeystrokes = Players.LocalPlayer.UserId % 100 < v5
	end

	function self.onTextChanged(p2, p3, p4, p5)
		if not self.isMounted then
			return
		end

		self:setState({
			inputText = p2,
			showSendChat = p2 and isMessageValid(p2, self.props.maxCharacterLength) and true or false,
			frameHeight = self.calculateInputBoxHeight(p2, p3, p4, p5)
		})

		self.props.onTextChanged(p2)

		if self.shouldCollectKeystrokes and self.textChangedFallback then
			self:recordTextChange(p2)
		end
	end

	function self.onInputBeganEvent(p2)
		if
			self.shouldCollectKeystrokes
			and not self.textChangedFallback
			and p2.UserInputType == Enum.UserInputType.Keyboard
		then
			self:recordKeystroke(true, p2.KeyCode)
		end

		if
			isKeyCodePressed({ p2 }, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter)
			and not isKeyCodePressed(
				self.props.userInputService:GetKeysPressed(),
				Enum.KeyCode.LeftShift,
				Enum.KeyCode.RightShift
			)
		then
			self.onSendActivated()
		end
	end

	function self.onInputEndedEvent(p2)
		if
			self.shouldCollectKeystrokes
			and not self.textChangedFallback
			and p2.UserInputType == Enum.UserInputType.Keyboard
		then
			self:recordKeystroke(false, p2.KeyCode)
		end
	end

	function self.focusChanged(p2)
		if p2 and not self.inputConnectionActive then
			self.inputBeganConnection = self.props.userInputService.InputBegan:Connect(self.onInputBeganEvent)
			self.inputEndedConnection = self.props.userInputService.InputEnded:Connect(self.onInputEndedEvent)
			self.inputConnectionActive = true
		elseif not p2 and self.inputConnectionActive then
			self:disconnectInputConnection()
			self.props.onFocusLost()
		end
	end

	function self.onSendActivated()
		local v6

		if defineFastFlag then
			v6 = not self.inputBoxRef.current and "" or self.inputBoxRef.current.Text
		else
			v6 = self.state.inputText
		end

		local v7

		if defineFastFlag then
			v7 = v6 and isMessageValid(v6, self.props.maxCharacterLength)
		else
			v7 = self.state.showSendChat
		end

		local trimmed = text.Trim(v6)
		local v8 = SendButtonClickActionResult.None

		if v7 and isMessageValid(trimmed, self.props.maxCharacterLength) then
			local value = self.inputBoxRef:getValue()
			value.Text = ""

			if
				self.focusNavigationService
				and self.focusNavigationService.focusedGuiObject:getValue() == self.sendButtonRef:getValue()
			then
				self.focusNavigationService:focusGuiObject(self.inputBarRef:getValue(), false)
			end

			local v9 = if fFlagAppChatOnConsoles then isTenFootInterface() else nil

			if fFlagAppChatOnConsoles and v9 then
				self.inputBoxRef.current:ReleaseFocus()
			end

			self:setState({ inputText = "", showSendChat = false })

			if self.props.onSendChat then
				if trimmed == "/shrug" then
					self.props.onSendChat("¯\\_(ツ)_/¯")
				else
					self.props.onSendChat(trimmed)
				end

				v8 = SendButtonClickActionResult.WillSend
			end

			local listRef = self.messageListRef
				and self.messageListRef.current
				and self.messageListRef.current._listRef

			if listRef then
				listRef:scrollToOffset({ offset = 0 })
			end
		else
			v8 = if v7 then SendButtonClickActionResult.MessageInvalid else SendButtonClickActionResult.ButtonInactive
		end

		if self.props.onSendBtnClicked then
			self.props.onSendBtnClicked(v8)
		end

		if self.shouldCollectKeystrokes then
			self:sendKeystrokeEvent("UASendPressed")
		end
	end

	function self.chatBoxSizeChanged(p2, p3, p4, p5)
		local inputBoxHeight = self.calculateInputBoxHeight(p3, p4, p5, p2.AbsoluteSize.X)
		self:setState({ chatBarWidth = p2.AbsoluteSize.X, frameHeight = inputBoxHeight })
	end

	function self.onDisabledInputBarActivated()
		self.props.onDisabledInputBarActivated()
	end

	function self.focusChatInputBox()
		if self.inputBoxRef and self.inputBoxRef.current then
			self.inputBoxRef.current:CaptureFocus()
		end
	end

	function self.focusNavigationEventHandler(object2)
		if object2.eventData and self.inputBoxFocusLossKeyCodeRef.current == object2.eventData.KeyCode then
			object2:cancel()
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

function extended.renderContent(data, p2)
	return withStyle(function(data2)
		return withChatPagePadding(function(p3)
			return withSelectionCursorProvider(function(callback)
				local font = data2.Font
				local font2 = data2.Tokens.Typography.BodyLarge.Font
				local v5 = font.BaseSize * font.Body.RelativeSize

				local v6 = if fFlagAppChatOnConsoles then isVRAppBuild() or isTenFootInterface() else nil

				local v7 = data.state.frameHeight

				if v7 == 0 then
					v7 = data.calculateInputBoxHeight(
						data.state.inputText,
						font2,
						v5,
						data.state.chatBarWidth
					)
				end

				local udim = UDim.new(0, (math.max(p3.right - 6, 0)))

				if p2 then
					udim = UDim.new(0, p3.right)
				end

				local createElement = Roact.createElement
				local onPositionChangedsByAbsolutePosition = {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = data.props.LayoutOrder,
					Size = UDim2.new(1, 0, 0, v7),
					[Roact.Change.AbsolutePosition] = data.props.onPositionChanged
				}
				local v9 = {
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

				local v10 = if data.isMoreMenuEnabled() then Roact.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}) else nil
				v9.flex = v10

				local v11 = if not data.isMoreMenuEnabled() then Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, p3.left),
					PaddingRight = udim,
					PaddingBottom = UDim.new(0, 13),
					PaddingTop = UDim.new(0, 8)
				}) else nil
				v9.padding = v11

				local createElement2 = Roact.createElement
				local v13 = {
					Size = UDim2.new(1, p2 and 0 or -data.props.sendButtonContainerSize, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = images["component_assets/circle_21_stroke_1"],
					ImageColor3 = 0,
					ScaleType = 0,
					SliceCenter = 0
				}
				local v14 = if data.props.isDisabled then data2.Tokens.Color.System.Alert.Color3 else data2.Theme.Divider.Color
				v13.ImageColor3 = v14

				v13.ScaleType = Enum.ScaleType.Slice
				v13.SliceCenter = Rect.new(8, 8, 9, 9)

				local createElement3 = Roact.createElement
				local inputBarRefsByRef = {
					Name = "inputBar",
					SelectionImageObject = callback(cursorKind.RoundedRectNoInset),
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Selectable = true,
					NextSelectionRight = data.sendButtonRef,
					onActivated = data.focusChatInputBox,
					[Roact.Ref] = data.inputBarRef
				}

				local createElement4 = Roact.createElement
				local v19 = {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = images["component_assets/circle_21"],
					ImageColor3 = data2.Theme.UIMuted.Color,
					ImageTransparency = data2.Theme.UIMuted.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}

				local createElement5 = Roact.createElement
				local v23 = if not data.isMoreMenuEnabled() then UDim.new(0, v5 / 2.5) else nil
				local v20 = {
					padding = createElement5("UIPadding", {
						PaddingTop = v23,
						PaddingLeft = UDim.new(0.02, 0),
						PaddingRight = UDim.new(0.02, 0)
					}),
					inputBox = 0
				}
				local v24

				if p2 then
					v24 = Roact.createElement(ChatInputBoxDisabled, {
						bodyText = data.props.inputBarDisabledText,
						contentSize = v5,
						endTimestamp = data.props.disabledEndTimestampDisplay,
						font = font2,
						onActivated = data.onDisabledInputBarActivated
					})
				else
					local createElement6 = Roact.createElement
					local v26 = {}
					v26.initialInputText = data.props.initialInputText
					v26.inputTextFont = font2
					v26.inputTextColor3 = data2.Theme.TextEmphasis.Color
					v26.inputTextSize = v5
					v26.inputTextXAlignment = Enum.TextXAlignment.Left

					local v27 = if data.isMoreMenuEnabled() then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top
					v26.inputTextYAlignment = v27

					v26.placeholderText = data.props.placeholderText
					v26.placeholderTextColor3 = data2.Theme.TextMuted.Color
					v26.placeholderTextTransparency = data2.Theme.TextMuted.Transparency

					v26.clipsDescendants = false
					v26.multiLine = not isVRAppBuild()
					v26.manualFocusRelease = true
					v26.textWrapped = true
					v26.focusChangedCallback = data.focusChanged

					v26.clearButtonDisabled = true
					v26.clearButtonSize = 0

					function v26.textChangedCallback(p4)
						data.onTextChanged(p4, font2, v5, data.state.chatBarWidth)
					end
					v26[Roact.Change.AbsoluteSize] = function(p4)
						data.chatBoxSizeChanged(p4, data.state.inputText, font2, v5)
					end
					v26.inputBoxRef = data.inputBoxRef
					local onSendActivated

					if fFlagAppChatOnConsoles then
						if v6 then
							onSendActivated = data.onSendActivated
						end
					elseif isVRAppBuild() then
						onSendActivated = data.onSendActivated
					end

					v26.returnPressedFromOnScreenKeyboardCallback = onSendActivated
					v24 = createElement6(callbackInputBox, v26)
				end

				v20.inputBox = v24
				v9.inputBorder = createElement2(imageSetLabel, v13, {
					inputImage = createElement3(interactable, inputBarRefsByRef, {
						createElement4(imageSetLabel, v19, v20)
					})
				})
				local v25

				if not p2 then
					v25 = withSelectionCursorProvider(function(callback2)
						local createElement6 = Roact.createElement
						local v27 = {
							Name = "sendButton",
							Size = UDim2.new(0, data.props.sendButtonContainerSize, 1, 0),
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Text = "",
							SelectionImageObject = callback2(cursorKind.RoundedRectNoInset),
							Selectable = true,
							NextSelectionLeft = data.inputBarRef,
							[Roact.Event.Activated] = data.onSendActivated,
							[Roact.Ref] = data.sendButtonRef
						}
						local v28 = {
							layout = Roact.createElement("UIListLayout", {
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Right
							}),
							sendIcon = 0
						}

						local createElement7 = Roact.createElement
						local v30 = {
							Size = UDim2.new(0, iconSize.Regular, 0, iconSize.Regular),
							BackgroundTransparency = 1,
							ImageColor3 = 0,
							ImageTransparency = 0,
							Image = 0
						}

						local v31 = if data.state.showSendChat then data2.Tokens.Color.Content.Emphasis.Color3 else data2.Tokens.Color.Content.Default.Color3
						v30.ImageColor3 = v31

						v30.ImageTransparency = data.state.showSendChat and 0 or 0.5
						v30.Image = images["icons/actions/send"]
						v28.sendIcon = createElement7(imageSetLabel, v30)
						return createElement6("TextButton", v27, v28)
					end)
				end

				v9.sendButton = v25
				return createElement("Frame", onPositionChangedsByAbsolutePosition, v9)
			end)
		end)
	end)
end

function extended:didMount()
	self.isMounted = true

	if self.inputBoxRef and self.inputBoxRef.current then
		self.inputBoxRef.current.Selectable = false
		self.focusLostConnection = self.inputBoxRef.current.FocusLost:Connect(function(p2, p3)
			local inputBoxFocusLossKeyCodeRef = self.inputBoxFocusLossKeyCodeRef
			local v5 = if p3 then p3.KeyCode else Enum.KeyCode.None
			inputBoxFocusLossKeyCodeRef.current = v5
		end)
	end

	if self.focusNavigationService and self.inputBarRef.current then
		self.eventHandlerRegistration = self.focusNavigationService:registerEventHandler(
			self.inputBarRef.current,
			focusNavigationEventNameEnum.NavigateBack,
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

function extended:recordKeystroke(p2, p3)
	if p2 then
		table.insert(self.keyPressedData, p3.Name)
		table.insert(self.eventTypeData, 0)
		table.insert(self.timestampData, DateTime.now().UnixTimestampMillis)
	elseif p3 ~= Enum.KeyCode.Return and p3 ~= Enum.KeyCode.KeypadEnter or #self.keyPressedData ~= 0 then
		table.insert(self.keyPressedData, p3.Name)
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

function extended:sendKeystrokeEvent(p2)
	if #self.keyPressedData >= 0 then
		self.props.eventLoggingFunc(default, KeystrokeEvent, {}, {
			chatContext = p2,
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
