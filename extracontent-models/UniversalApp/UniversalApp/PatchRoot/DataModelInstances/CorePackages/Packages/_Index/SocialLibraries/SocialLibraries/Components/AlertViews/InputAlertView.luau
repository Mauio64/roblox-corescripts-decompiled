local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local ButtonType = dependencies.UIBlox.App.Button.Enum.ButtonType
local Components = SocialLibraries.Components
local UserInputService = dependencies.UserInputService
local AlertViewBuilder = require(Components.AlertViewBuilder.AlertViewBuilder)
local v8 = Roact.Component:extend("InputAlertView")

v8.defaultProps = {
	titleText = "TestTitle",
	cancelText = "TestCancel",
	confirmText = "TestConfirm",
	warningText = nil,
	inputText = "TestInput",
	maxCharacters = 150,
	soakAreaTransparency = 0.9,
	shouldAdjustForKeyboard = true,
	onActivated = function() -- line: 23
	end,
	onModalClose = function() -- line: 25
	end,
	screenSize = Vector2.new(0, 0),
	soakAreaColor3 = Color3.fromRGB(0, 0, 255)
}

function v8.init(p1) -- line: 34
	-- upvalues: Roact (copy), UserInputService (copy)
	p1.ref = Roact.createRef()

	function p1.onTextChanged(p2) -- line: 36
		-- upvalues: p1 (copy)
		p1:setState({
			inputText = p2,
			inputLengthExceeded = #p2 > p1.props.maxCharacters
		})
	end
	function p1.onButtonActivated() -- line: 43
		-- upvalues: p1 (copy)
		p1.closing = true
	end
	function p1.updateModalPosition() -- line: 47
		-- upvalues: p1 (copy), UserInputService (copy)
		p1:setState({
			keyboardOffset = UserInputService.OnScreenKeyboardVisible and p1.state.yPosition + p1.ref:getValue().AbsoluteSize.Y - UserInputService.OnScreenKeyboardPosition.Y or 0
		})
	end
	function p1.onModalStayOpen() -- line: 57
		-- upvalues: p1 (copy)
		p1.closing = false

		if p1.props.shouldAdjustForKeyboard then
			p1.updateModalPosition()
		end
	end

	if p1.props.shouldAdjustForKeyboard then
		p1.keyboardConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function() -- line: 69
			-- upvalues: p1 (copy)
			spawn(function() -- line: 71
				-- upvalues: p1 (copy)
				if not p1.isMounted or p1.closing then
					return
				end

				p1.updateModalPosition()
			end)
		end)
	end

	function p1.onPositionChanged(p3) -- line: 82
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		if p3.AbsolutePosition.Y ~= p1.state.yPosition then
			p1:setState({
				yPosition = p3.AbsolutePosition.Y
			})
		end
	end

	p1.closing = false
	p1.state = {
		inputLengthExceeded = false,
		keyboardOffset = 0,
		yPosition = 0,
		inputText = p1.props.inputText
	}
end
function v8.render(p4) -- line: 102
	-- upvalues: ButtonType (copy), Roact (copy), AlertViewBuilder (copy)
	local props = p4.props
	local maxCharacters = props.maxCharacters
	local v13 = if props.displayFailed then {{
		buttonType = ButtonType.Alert,
		props = {
			text = props.failedText,
			onActivated = props.onActivated
		}
	}} else {
		{
			buttonType = ButtonType.Secondary,
			props = {
				text = props.cancelText,
				onActivated = function() -- line: 113
				end
			}
		},
		{
			buttonType = ButtonType.PrimarySystem,
			props = {
				text = props.confirmText,
				isDisabled = p4.state.inputLengthExceeded,
				onActivated = props.onActivated
			}
		}
	}

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, -p4.state.keyboardOffset),
		Transparency = 1,
		[Roact.Change.AbsolutePosition] = p4.onPositionChanged,
		[Roact.Ref] = p4.ref
	}, {
		AlertView = Roact.createElement(AlertViewBuilder, {
			buttons = v13,
			inputLengthExceeded = p4.state.inputLengthExceeded,
			onActivated = p4.onButtonActivated,
			onModalClose = props.onModalClose,
			onModalStayOpen = p4.onModalStayOpen,
			soakAreaColor3 = p4.props.soakAreaColor3,
			soakAreaTransparency = p4.props.soakAreaTransparency,
			textboxes = {
				InputBox = {
					LayoutOrder = 1,
					belowText = maxCharacters and #p4.state.inputText .. "/" .. maxCharacters,
					belowTextAlignment = Enum.TextXAlignment.Right,
					onTextChanged = p4.onTextChanged,
					PlaceholderText = props.placeholderText,
					Text = props.inputText,
					warningText = p4.props.warningText
				}
			},
			title = props.titleText,
			screenSize = props.screenSize
		})
	})
end
function v8.didMount(p5) -- line: 168
	p5.isMounted = true
end
function v8.willUnmount(p6) -- line: 172
	p6.isMounted = false

	if p6.keyboardConnection then
		p6.keyboardConnection:Disconnect()
		p6.keyboardConnection = nil
	end
end

return v8
