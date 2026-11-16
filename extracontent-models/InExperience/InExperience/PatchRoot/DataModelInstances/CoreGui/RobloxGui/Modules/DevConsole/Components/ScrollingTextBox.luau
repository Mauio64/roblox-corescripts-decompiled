local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("ScrollingTextBox")

function extended:init(p)
	local textSize = TextService:GetTextSize("A", p.TextSize, p.Font, Vector2.new(0, 0))

	function self.adjustOffset()
		if self.clipBox.current and self.textboxRef.current then
			local fontDims = self.state.fontDims
			local v = self.textboxRef.current.CursorPosition - 1
			local v2 = v - math.ceil(self.state.innerXOffset / fontDims.X)

			local v3 = math.floor(self.clipBox.current.AbsoluteSize.X * 0.9 / fontDims.X)

			if v3 < v2 then
				self:setState({
					innerXOffset = (v - v3) * fontDims.X
				})
			elseif v2 < 0 then
				self:setState({
					innerXOffset = v * fontDims.X
				})
			end
		end
	end

	self.clipBox = Roact.createRef()
	self.textboxRef = self.props.forwardRef or Roact.createRef()

	self.state = { fontDims = textSize, innerXOffset = 0 }
end

function extended:didMount()
	if not self.onFocusConnection then
		self.onFocusConnection = UserInputService.InputBegan:Connect(function(input)
			if self.textboxRef.current and self.textboxRef.current:IsFocused() then
				if input.KeyCode == Enum.KeyCode.Home then
					self.textboxRef.current.CursorPosition = 0
				elseif input.KeyCode == Enum.KeyCode.End then
					self.textboxRef.current.CursorPosition = #self.textboxRef.current.text + 1
				else
					self.adjustOffset()
				end
			end
		end)
	end
end

function extended:willUnmount()
	if self.onFocusConnection then
		self.onFocusConnection:Disconnect()
		self.onFocusConnection = nil
	end
end

function extended.render(props)
	local position = props.props.Position
	local size = props.props.Size
	local placeholderText = props.props.PlaceholderText

	local textColor3 = props.props.TextColor3
	local textSize = props.props.TextSize
	local font = props.props.Font
	local text = props.props.Text

	local clearTextOnFocus = props.props.ClearTextOnFocus
	local showNativeInput = props.props.ShowNativeInput

	local textBoxFocusLost = props.props.TextBoxFocusLost

	local innerXOffset = props.state.innerXOffset

	return Roact.createElement("Frame", {
		Position = position,
		Size = size,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		[Roact.Ref] = props.clipBox
	}, {
		TextBox = Roact.createElement("TextBox", {
			Position = UDim2.new(0, -innerXOffset, 0, 0),
			Size = UDim2.new(1, innerXOffset, 1, 0),
			BackgroundTransparency = 1,
			ShowNativeInput = showNativeInput,
			ClearTextOnFocus = clearTextOnFocus,
			TextColor3 = textColor3,
			TextXAlignment = 0,
			TextSize = textSize,
			Text = text,
			Font = font,
			PlaceholderText = placeholderText,
			[Roact.Ref] = props.textboxRef,
			[Roact.Change.CursorPosition] = props.adjustOffset,
			[Roact.Event.FocusLost] = textBoxFocusLost
		})
	})
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
