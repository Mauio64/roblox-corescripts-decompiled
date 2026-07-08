local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local v6 = Roact.Component:extend("ScrollingTextBox")

function v6.init(p1, p2) -- line: 12
	-- upvalues: TextService (copy), Roact (copy)
	local TextSize = TextService:GetTextSize("A", p2.TextSize, p2.Font, Vector2.new(0, 0))

	function p1.adjustOffset() -- line: 15
		-- upvalues: p1 (copy)
		if p1.clipBox.current and p1.textboxRef.current then
			local fontDims = p1.state.fontDims
			local v27 = p1.textboxRef.current.CursorPosition - 1
			local v28 = v27 - math.ceil(p1.state.innerXOffset / fontDims.X)
			local v29 = math.floor(p1.clipBox.current.AbsoluteSize.X * 0.9 / fontDims.X)

			if v29 < v28 then
				local v30 = (v27 - v29) * fontDims.X

				p1:setState({
					innerXOffset = v30
				})

				return
			end

			if v28 < 0 then
				local v31 = v27 * fontDims.X

				p1:setState({
					innerXOffset = v31
				})
			end
		end
	end

	p1.clipBox = Roact.createRef()
	p1.textboxRef = p1.props.forwardRef or Roact.createRef()
	p1.state = {
		innerXOffset = 0,
		fontDims = TextSize
	}
end
function v6.didMount(p3) -- line: 49
	-- upvalues: UserInputService (copy)
	if not p3.onFocusConnection then
		p3.onFocusConnection = UserInputService.InputBegan:Connect(function(input) -- line: 51
			-- upvalues: p3 (copy)
			if p3.textboxRef.current and p3.textboxRef.current:IsFocused() then
				if input.KeyCode == Enum.KeyCode.Home then
					p3.textboxRef.current.CursorPosition = 0

					return
				end

				if input.KeyCode == Enum.KeyCode.End then
					p3.textboxRef.current.CursorPosition = #p3.textboxRef.current.text + 1

					return
				end

				p3.adjustOffset()
			end
		end)
	end
end
function v6.willUnmount(p4) -- line: 66
	if p4.onFocusConnection then
		p4.onFocusConnection:Disconnect()
		p4.onFocusConnection = nil
	end
end
function v6.render(p5) -- line: 73
	-- upvalues: Roact (copy)
	local propsPosition = p5.props.Position
	local propsSize = p5.props.Size
	local PlaceholderText = p5.props.PlaceholderText
	local propsTextColor3 = p5.props.TextColor3
	local propsTextSize = p5.props.TextSize
	local propsFont = p5.props.Font
	local propsText = p5.props.Text
	local ClearTextOnFocus = p5.props.ClearTextOnFocus
	local ShowNativeInput = p5.props.ShowNativeInput
	local TextBoxFocusLost = p5.props.TextBoxFocusLost
	local innerXOffset = p5.state.innerXOffset

	return Roact.createElement("Frame", {
		Position = propsPosition,
		Size = propsSize,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		[Roact.Ref] = p5.clipBox
	}, {
		TextBox = Roact.createElement("TextBox", {
			Position = UDim2.new(0, -innerXOffset, 0, 0),
			Size = UDim2.new(1, innerXOffset, 1, 0),
			BackgroundTransparency = 1,
			ShowNativeInput = ShowNativeInput,
			ClearTextOnFocus = ClearTextOnFocus,
			TextColor3 = propsTextColor3,
			TextXAlignment = 0,
			TextSize = propsTextSize,
			Text = propsText,
			Font = propsFont,
			PlaceholderText = PlaceholderText,
			[Roact.Ref] = p5.textboxRef,
			[Roact.Change.CursorPosition] = p5.adjustOffset,
			[Roact.Event.FocusLost] = TextBoxFocusLost
		})
	})
end

return Roact.forwardRef(function(p6, p7) -- line: 119
	-- upvalues: Roact (copy), v6 (copy), Cryo (copy)
	return Roact.createElement(v6, Cryo.Dictionary.join(p6, {
		forwardRef = p7
	}))
end)
