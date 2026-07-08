local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Cryo = dependencies.Cryo
local Roact = dependencies.Roact
local dependenciesText = dependencies.Text
local TestStyle = require(SocialLibraries.Components.Style.TestStyle)
local CallbackInputBox = require(script.Parent.CallbackInputBox)
local v8 = Roact.PureComponent:extend("InputBoxWithCharacterCounter")

v8.defaultProps = {
	initialInputText = "",
	validInputTextTransparency = 0,
	invalidInputTextTransparency = 0,
	counterTextPadding = 0,
	characterLimit = 150,
	validInputTextColor3 = Color3.fromRGB(0, 255, 0),
	invalidInputTextColor3 = Color3.fromRGB(255, 0, 0),
	style = TestStyle
}

function v8.init(p1) -- line: 26
	p1.state = {
		inputText = p1.props.initialInputText
	}

	function p1.textChangedCallback(p2) -- line: 31
		-- upvalues: p1 (copy)
		p1:setState({
			inputText = p2
		})
	end
end
function v8.render(p3) -- line: 38
	-- upvalues: dependenciesText (copy), Cryo (copy), Roact (copy), CallbackInputBox (copy)
	local style = p3.props.style
	local v12 = #p3.state.inputText
	local v13 = v12 .. "/" .. p3.props.characterLimit
	local CaptionSubHeaderFont = style.Font.CaptionSubHeader.Font
	local v15 = style.Font.BaseSize * style.Font.CaptionSubHeader.RelativeSize
	local v16 = dependenciesText.GetTextWidth(v13, CaptionSubHeaderFont, v15)
	local v17 = dependenciesText.GetTextHeight(v13, CaptionSubHeaderFont, v15, v16)
	local validInputTextColor3, validInputTextTransparency

	if v12 <= p3.props.characterLimit then
		validInputTextColor3 = p3.props.validInputTextColor3
		validInputTextTransparency = p3.props.validInputTextTransparency
	else
		validInputTextColor3 = p3.props.invalidInputTextColor3
		validInputTextTransparency = p3.props.invalidInputTextTransparency
	end

	local v20 = Cryo.Dictionary.join(p3.props, {
		inputText = p3.state.inputText,
		textChangedCallback = p3.textChangedCallback
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		inputBoxContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 1, -v17)
		}, {
			border = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaChat/9-slice/input-default.png",
				Size = UDim2.new(1, 0, 1, 0),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(3, 3, 4, 4)
			}),
			inputBox = Roact.createElement(CallbackInputBox, v20)
		}),
		characterCounter = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v17)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			}),
			padding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, p3.props.counterTextPadding)
			}),
			characterCountLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = v13,
				TextColor3 = validInputTextColor3,
				TextTransparency = validInputTextTransparency,
				TextSize = v15,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Top,
				Font = CaptionSubHeaderFont
			})
		})
	})
end

return v8
