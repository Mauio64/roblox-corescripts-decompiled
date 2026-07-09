local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local Common = Modules.Common
local Roact = require(Common.Roact)
local v5 = Roact.PureComponent:extend("OnScreenKeyboardWindow")

function v5.init(p1) -- line: 11
	p1.state = {
		onScreenKeyboardHeight = 0
	}
end
function v5.didMount(p2) -- line: 17
	-- upvalues: UserInputService (copy)
	p2.keyboardVisibleChanged = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):connect(function() -- line: 19
		-- upvalues: UserInputService (copy), p2 (copy)
		local v10 = UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0

		p2:setState({
			onScreenKeyboardHeight = v10
		})
	end)
end
function v5.willUnmount(p3) -- line: 29
	if p3.keyboardVisibleChanged then
		p3.keyboardVisibleChanged:disconnect()
		p3.keyboardVisibleChanged = nil
	end
end
function v5.render(p4) -- line: 36
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 1, -p4.state.onScreenKeyboardHeight),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0)
	}, p4.props.Contents)
end

return v5
