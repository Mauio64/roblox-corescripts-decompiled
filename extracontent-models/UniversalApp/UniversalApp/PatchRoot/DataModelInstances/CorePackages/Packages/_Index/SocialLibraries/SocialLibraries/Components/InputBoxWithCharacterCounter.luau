local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local cryo = dependencies.Cryo
local roact = dependencies.Roact

local TestStyle = require(SocialLibraries.Components.Style.TestStyle)
local CallbackInputBox = require(script.Parent.CallbackInputBox)
local getTextBoundsAsync = dependencies.Foundation.Utility.getTextBoundsAsync
local normalizeFontFace = dependencies.Foundation.Utility.normalizeFontFace

local extended = roact.PureComponent:extend("InputBoxWithCharacterCounter")
extended.defaultProps = {
	initialInputText = "",
	validInputTextColor3 = Color3.fromRGB(0, 255, 0),
	validInputTextTransparency = 0,
	invalidInputTextColor3 = Color3.fromRGB(255, 0, 0),
	invalidInputTextTransparency = 0,
	counterTextPadding = 0,
	characterLimit = 150,
	style = TestStyle
}

function extended:init()
	self.state = { inputText = self.props.initialInputText }

	function self.textChangedCallback(inputText: string)
		self:setState({ inputText = inputText })
	end

	self.isMounted = false
	self.measurementId = 0

	function self.measureText()
		local style = self.props.style
		local measuredText = #self.state.inputText .. "/" .. self.props.characterLimit
		local font = style.Font.CaptionSubHeader.Font
		local measuredFontSize = style.Font.BaseSize * style.Font.CaptionSubHeader.RelativeSize

		if
			self.measuredText == measuredText
			and self.measuredFont == font
			and self.measuredFontSize == measuredFontSize
		then
			return
		end

		self.measuredText = measuredText
		self.measuredFont = font
		self.measuredFontSize = measuredFontSize
		self.measurementId += 1
		local measurementId = self.measurementId

		task.spawn(function()
			local textBoundsAsync = getTextBoundsAsync(measuredText, font, measuredFontSize)

			if self.isMounted and self.measurementId == measurementId then
				self:setState({ textBounds = textBoundsAsync })
			end
		end)
	end
end

function extended:didMount()
	self.isMounted = true
	self.measureText()
end

function extended.didUpdate(p)
	p.measureText()
end

function extended:willUnmount()
	self.isMounted = false
	self.measurementId += 1
end

function extended.render(props)
	local style = props.props.style

	local count = #props.state.inputText
	local text = count .. "/" .. props.props.characterLimit
	local font = style.Font.CaptionSubHeader.Font
	local textSize = style.Font.BaseSize * style.Font.CaptionSubHeader.RelativeSize

	local y = (props.state.textBounds or Vector2.new(0, textSize)).Y
	local textColor, textTransparency

	if count <= props.props.characterLimit then
		textColor = props.props.validInputTextColor3
		textTransparency = props.props.validInputTextTransparency
	else
		textColor = props.props.invalidInputTextColor3
		textTransparency = props.props.invalidInputTextTransparency
	end

	local joined = cryo.Dictionary.join(props.props, {
		inputText = props.state.inputText,
		textChangedCallback = props.textChangedCallback
	})

	return roact.createElement("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }, {
		layout = roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		inputBoxContainer = roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -y),
			LayoutOrder = 1
		}, {
			border = roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(3, 3, 4, 4),
				Image = "rbxasset://textures/ui/LuaChat/9-slice/input-default.png"
			}),
			inputBox = roact.createElement(CallbackInputBox, joined)
		}),
		characterCounter = roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, y), LayoutOrder = 2 },
			{
				layout = roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Right
				}),
				padding = roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, props.props.counterTextPadding)
				}),
				characterCountLabel = roact.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = textColor,
					TextTransparency = textTransparency,
					TextSize = textSize,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextYAlignment = Enum.TextYAlignment.Top,
					FontFace = normalizeFontFace(font)
				})
			}
		)
	})
end

return extended
