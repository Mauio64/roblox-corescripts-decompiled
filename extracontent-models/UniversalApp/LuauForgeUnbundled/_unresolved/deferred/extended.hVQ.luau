local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/ego")

local extended = module.PureComponent:extend("OnScreenKeyboardWindow")

function extended:init()
	self.state = { onScreenKeyboardHeight = 0 }
end

function extended:didMount()
	self.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function()
		local y = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		self:setState({ onScreenKeyboardHeight = y })
	end)
end

function extended:willUnmount()
	if self.keyboardVisibleChanged then
		self.keyboardVisibleChanged:disconnect()
		self.keyboardVisibleChanged = nil
	end
end

function extended.render(p2)
	return module.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, -p2.state.onScreenKeyboardHeight),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 1
	}, p2.props.Contents)
end

return extended
