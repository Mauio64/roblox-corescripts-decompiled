local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local CoreGui = game:GetService("CoreGui")

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle

local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local CountryCodeSelector = require(AuthCommon.Components.CountryCodeSelector)

local extended = Roact.Component:extend("PhoneNumberTextBox")

extended.defaultProps = { CountryCodeSize = 70, InnerPadding = 12 }

function extended:init()
	self:setState({ CountryCodeHover = false, CountryCodeSearchVisible = false })

	function self.CountryCodeMouseEnter()
		self:setState({ CountryCodeHover = true })
	end

	function self.CountryCodeMouseLeave()
		self:setState({ CountryCodeHover = false })
	end

	function self.OpenCountryCode()
		self:setState({ CountryCodeSearchVisible = true })

		if self.props.phoneCountryCodeSelectorCallback then
			self.props.phoneCountryCodeSelectorCallback(true)
		end
	end

	function self.CloseCountryCode()
		self:setState({ CountryCodeSearchVisible = false })

		if self.props.phoneCountryCodeSelectorCallback then
			self.props.phoneCountryCodeSelectorCallback(false)
		end
	end

	function self.SelectCountryCode(p)
		if self.props.SetCountryCode then
			self.props.SetCountryCode(p)
		end

		self.CloseCountryCode()
	end
end

function extended.render(data)
	return withStyle(function(props)
		local color = data.props.Color
		local color2 = props.Theme.BackgroundMuted.Color
		local transparency = data.props.Transparency
		local font = props.Font.Body.Font
		local textSize = props.Font.BaseSize * props.Font.Body.RelativeSize
		local color3 = props.Theme.TextDefault.Color
		local transparency2 = props.Theme.TextDefault.Transparency
		local color4 = props.Theme.UIDefault.Color
		local _placeholderText = data.props.PlaceholderText or ""
		local text = data.props.Text or ""
		local textInputTypeOverride = data.props.TextInputTypeOverride or Enum.TextInputType.Phone

		local v = " +" .. data.props.CountryCode.prefix
		local v2

		if FoundationFontFaceMigration then
			v2 = GetTextSize(v, textSize, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).X + data.props.InnerPadding * 2
		else
			v2 = Text.GetTextWidth(v, font, textSize) + data.props.InnerPadding * 2
		end

		local v3 = math.max(v2, data.props.CountryCodeSize)

		local createElement = Roact.createElement
		local v4 = {
			Size = data.props.Size,
			Position = data.props.Position,
			AnchorPoint = data.props.AnchorPoint,
			LayoutOrder = data.props.LayoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.MouseEnter] = data.props.onMouseEnter,
			[Roact.Event.MouseLeave] = data.props.onMouseLeave
		}

		local createElement2 = Roact.createElement
		local v5 = {
			Size = UDim2.new(1, -v3 - 2, 1, 0),
			Position = UDim2.new(0, v3 + 2, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		}

		local v6 = {
			Background = Roact.createElement(ImageSetLabel, {
				Size = UDim2.new(1, 18, 1, 0),
				Position = UDim2.new(0, -18, 0, 0),
				BackgroundTransparency = 1,
				Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = color,
				ImageTransparency = transparency,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9)
			}),
			InputField = 0
		}

		local createElement3 = Roact.createElement
		local v7 = {
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, -data.props.InnerPadding * 2, 1, 0),
			Position = UDim2.new(0, data.props.InnerPadding, 0, 0),
			PlaceholderColor3 = color4,
			PlaceholderText = data.props.PlaceholderText,
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = color3,
			TextSize = textSize,
			TextInputType = textInputTypeOverride
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font
		end

		v7.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v7.FontFace = fontFace

		v7.ClearTextOnFocus = false
		v7[Roact.Event.Focused] = data.props.onFocused
		v7[Roact.Event.FocusLost] = data.props.onFocusLost
		v7[Roact.Change.Text] = data.props.onChangeText
		v6.InputField = createElement3("TextBox", v7)
		local children = {
			InputWrapper = createElement2("Frame", v5, v6),
			CountryCodeButton = 0,
			Divider = 0,
			CountryCodePortal = 0
		}

		local createElement4 = Roact.createElement
		local v8 = {
			Size = UDim2.new(0, v3, 1, 0),
			ZIndex = 2,
			Text = "",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			[Roact.Event.MouseEnter] = data.CountryCodeMouseEnter,
			[Roact.Event.MouseLeave] = data.CountryCodeMouseLeave,
			[Roact.Event.Activated] = data.OpenCountryCode
		}
		local v9 = {
			Background = Roact.createElement(ImageSetLabel, {
				Size = UDim2.new(1, 18, 1, 0),
				BackgroundTransparency = 1,
				Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = data.state.CountryCodeHover and color2 or color,
				ImageTransparency = transparency,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9)
			}),
			Prefix = 0
		}

		local createElement5 = Roact.createElement
		local v10 = {
			Size = UDim2.new(1, -data.props.InnerPadding, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 2,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			BackgroundTransparency = 1,
			RichText = true
		}

		if FoundationFontFaceMigration then
			font = nil
		end

		v10.Font = font
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v10.FontFace = fontFace2

		v10.Text = "<u>" .. v .. "</u>"
		v10.TextSize = textSize
		v10.TextColor3 = color3
		v10.TextTransparency = transparency2
		v9.Prefix = createElement5("TextLabel", v10)
		children.CountryCodeButton = createElement4("TextButton", v8, v9)

		children.Divider = Roact.createElement("Frame", {
			BackgroundColor3 = color2,
			Size = UDim2.new(0, 2, 1, 0),
			Position = UDim2.new(0, v3, 0, 0),
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		})

		children.CountryCodePortal = Roact.createElement(Roact.Portal, { target = CoreGui }, {
			CountryCodeSelectionGui = Roact.createElement(
				"ScreenGui",
				{ Enabled = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 13 },
				{
					CountryCodeSelector = Roact.createElement(CountryCodeSelector, {
						WidgetVisible = data.state.CountryCodeSearchVisible,
						CloseCallback = data.CloseCountryCode,
						SelectionCallback = data.SelectCountryCode
					})
				}
			)
		})
		return createElement("TextButton", v4, children)
	end)
end

return extended
