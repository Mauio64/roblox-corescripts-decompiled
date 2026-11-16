local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local cryo = dependencies.Cryo
local roact = dependencies.Roact
local text = dependencies.Text

local TestStyle = require(SocialLibraries.Components.Style.TestStyle)
local CallbackInputBox = require(script.Parent.CallbackInputBox)
local foundationFontFaceMigration = dependencies.Foundation.Utility.Flags.FoundationFontFaceMigration
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

	if foundationFontFaceMigration then
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
end

function extended:didMount()
	if foundationFontFaceMigration then
		self.isMounted = true
		self.measureText()
	end
end

function extended.didUpdate(p)
	if foundationFontFaceMigration then
		p.measureText()
	end
end

function extended:willUnmount()
	if foundationFontFaceMigration then
		self.isMounted = false
		self.measurementId += 1
	end
end

function extended.render(props)
	local style = props.props.style

	local count = #props.state.inputText
	local text2 = count .. "/" .. props.props.characterLimit
	local font = style.Font.CaptionSubHeader.Font
	local textSize = style.Font.BaseSize * style.Font.CaptionSubHeader.RelativeSize
	local v

	if foundationFontFaceMigration then
		local textBounds = props.state.textBounds or Vector2.new(0, textSize)
		local _ = textBounds.X
		v = textBounds.Y
	else
		local textWidth = text.GetTextWidth(text2, font, textSize)
		v = text.GetTextHeight(text2, font, textSize, textWidth)
	end

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

	local createElement = roact.createElement
	local v2 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }
	local v3 = {
		layout = roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		inputBoxContainer = roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -v),
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
		characterCounter = 0
	}

	local createElement2 = roact.createElement
	local v4 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, v), LayoutOrder = 2 }

	local v5 = {
		layout = roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		}),
		padding = roact.createElement("UIPadding", {
			PaddingRight = UDim.new(0, props.props.counterTextPadding)
		}),
		characterCountLabel = 0
	}

	local createElement3 = roact.createElement
	local v6 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = text2,
		TextColor3 = textColor,
		TextTransparency = textTransparency,
		TextSize = textSize,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Top,
		Font = 0,
		FontFace = 0
	}
	local font2

	if not foundationFontFaceMigration then
		font2 = font
	end

	v6.Font = font2
	local fontFace

	if foundationFontFaceMigration then
		fontFace = normalizeFontFace(font)
	end

	v6.FontFace = fontFace
	v5.characterCountLabel = createElement3("TextLabel", v6)
	v3.characterCounter = createElement2("Frame", v4, v5)
	return createElement("Frame", v2, v3)
end

return extended
