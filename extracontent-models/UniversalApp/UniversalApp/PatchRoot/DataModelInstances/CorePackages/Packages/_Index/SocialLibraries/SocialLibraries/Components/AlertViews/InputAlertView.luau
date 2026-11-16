local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local buttonType = dependencies.UIBlox.App.Button.Enum.ButtonType
local Components = SocialLibraries.Components

local userInputService = dependencies.UserInputService

local AlertViewBuilder = require(Components.AlertViewBuilder.AlertViewBuilder)

local extended = roact.Component:extend("InputAlertView")
extended.defaultProps = {
	titleText = "TestTitle",
	cancelText = "TestCancel",
	confirmText = "TestConfirm",
	warningText = nil,
	inputText = "TestInput",
	maxCharacters = 150,
	onActivated = function() end,
	onModalClose = function() end,
	screenSize = Vector2.new(0, 0),
	soakAreaColor3 = Color3.fromRGB(0, 0, 255),
	soakAreaTransparency = 0.9,
	shouldAdjustForKeyboard = true
}

function extended:init()
	self.ref = roact.createRef()
	function self.onTextChanged(inputText)
		self:setState({
			inputText = inputText,
			inputLengthExceeded = #inputText > self.props.maxCharacters
		})
	end

	function self.onButtonActivated()
		self.closing = true
	end

	function self.updateModalPosition()
		self:setState({
			keyboardOffset = userInputService.OnScreenKeyboardVisible and self.state.yPosition + self.ref:getValue().AbsoluteSize.Y - userInputService.OnScreenKeyboardPosition.Y or 0
		})
	end

	function self.onModalStayOpen()
		self.closing = false

		if self.props.shouldAdjustForKeyboard then
			self.updateModalPosition()
		end
	end

	if self.props.shouldAdjustForKeyboard then
		self.keyboardConnection = userInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function()
			spawn(function()
				if self.isMounted and not self.closing then
					self.updateModalPosition()
				end
			end)
		end)
	end

	function self.onPositionChanged(p)
		if not self.isMounted then
			return
		end

		if p.AbsolutePosition.Y ~= self.state.yPosition then
			self:setState({ yPosition = p.AbsolutePosition.Y })
		end
	end

	self.closing = false

	self.state = {
		inputText = self.props.inputText,
		inputLengthExceeded = false,
		keyboardOffset = 0,
		yPosition = 0
	}
end

function extended.render(props)
	local props2 = props.props

	local maxCharacters = props2.maxCharacters
	local buttons

	if props2.displayFailed then
		buttons = {
			{
				buttonType = buttonType.Alert,
				props = { text = props2.failedText, onActivated = props2.onActivated }
			}
		}
	else
		buttons = {
			{
				buttonType = buttonType.Secondary,
				props = {
					text = props2.cancelText,
					onActivated = function() end
				}
			},
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					text = props2.confirmText,
					isDisabled = props.state.inputLengthExceeded,
					onActivated = props2.onActivated
				}
			}
		}
	end

	return roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, -props.state.keyboardOffset),
		Transparency = 1,
		[roact.Change.AbsolutePosition] = props.onPositionChanged,
		[roact.Ref] = props.ref
	}, {
		AlertView = roact.createElement(AlertViewBuilder, {
			buttons = buttons,
			inputLengthExceeded = props.state.inputLengthExceeded,
			onActivated = props.onButtonActivated,
			onModalClose = props2.onModalClose,
			onModalStayOpen = props.onModalStayOpen,
			soakAreaColor3 = props.props.soakAreaColor3,
			soakAreaTransparency = props.props.soakAreaTransparency,
			textboxes = {
				InputBox = {
					belowText = maxCharacters and #props.state.inputText .. "/" .. maxCharacters,
					belowTextAlignment = Enum.TextXAlignment.Right,
					LayoutOrder = 1,
					onTextChanged = props.onTextChanged,
					PlaceholderText = props2.placeholderText,
					Text = props2.inputText,
					warningText = props.props.warningText
				}
			},
			title = props2.titleText,
			screenSize = props2.screenSize
		})
	})
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false

	if self.keyboardConnection then
		self.keyboardConnection:Disconnect()
		self.keyboardConnection = nil
	end
end

return extended
