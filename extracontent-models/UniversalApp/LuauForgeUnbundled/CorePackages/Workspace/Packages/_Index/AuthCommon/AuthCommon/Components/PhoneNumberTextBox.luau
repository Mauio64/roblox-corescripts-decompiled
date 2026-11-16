local CoreGui = game:GetService("CoreGui")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle

local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Text
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/CountryCodeSelector")

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

	function self.SelectCountryCode(p2)
		if self.props.SetCountryCode then
			self.props.SetCountryCode(p2)
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
		local v5 = props.Font.BaseSize * props.Font.Body.RelativeSize
		local color3 = props.Theme.TextDefault.Color
		local transparency2 = props.Theme.TextDefault.Transparency
		local color4 = props.Theme.UIDefault.Color
		local placeholderText = data.props.PlaceholderText or ""
		local text2 = data.props.Text or ""
		local textInputTypeOverride = data.props.TextInputTypeOverride or Enum.TextInputType.Phone

		local v6 = " +" .. data.props.CountryCode.prefix
		local v7

		if foundationFontFaceMigration then
			v7 = getTextSize(v6, v5, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).X + data.props.InnerPadding * 2
		else
			v7 = text.GetTextWidth(v6, font, v5) + data.props.InnerPadding * 2
		end

		local v8 = math.max(v7, data.props.CountryCodeSize)

		local createElement = Roact.createElement
		local v10 = {
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
		local v12 = {
			Size = UDim2.new(1, -v8 - 2, 1, 0),
			Position = UDim2.new(0, v8 + 2, 0, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		}

		local v13 = {
			Background = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(1, 18, 1, 0),
				Position = UDim2.new(0, -18, 0, 0),
				BackgroundTransparency = 1,
				Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = color,
				ImageTransparency = transparency,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9)
			}),
			InputField = 0
		}

		local createElement3 = Roact.createElement
		local v15 = {
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
			Text = text2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = color3,
			TextSize = v5,
			TextInputType = textInputTypeOverride,
			Font = if not foundationFontFaceMigration then font else nil
		}

		local v17 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v15.FontFace = v17

		v15.ClearTextOnFocus = false
		v15[Roact.Event.Focused] = data.props.onFocused
		v15[Roact.Event.FocusLost] = data.props.onFocusLost
		v15[Roact.Change.Text] = data.props.onChangeText
		v13.InputField = createElement3("TextBox", v15)
		local children = {
			InputWrapper = createElement2("Frame", v12, v13),
			CountryCodeButton = 0,
			Divider = 0,
			CountryCodePortal = 0
		}

		local createElement4 = Roact.createElement
		local v19 = {
			Size = UDim2.new(0, v8, 1, 0),
			ZIndex = 2,
			Text = "",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			[Roact.Event.MouseEnter] = data.CountryCodeMouseEnter,
			[Roact.Event.MouseLeave] = data.CountryCodeMouseLeave,
			[Roact.Event.Activated] = data.OpenCountryCode
		}
		local v20 = {
			Background = Roact.createElement(imageSetLabel, {
				Size = UDim2.new(1, 18, 1, 0),
				BackgroundTransparency = 1,
				Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = data.state.CountryCodeHover and color2 or color,
				ImageTransparency = transparency,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9)
			}),
			Prefix = 0
		}

		local createElement5 = Roact.createElement
		local v22 = {
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

		if foundationFontFaceMigration then
			font = nil
		end

		v22.Font = font

		local v23 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v22.FontFace = v23

		v22.Text = "<u>" .. v6 .. "</u>"
		v22.TextSize = v5
		v22.TextColor3 = color3
		v22.TextTransparency = transparency2
		v20.Prefix = createElement5("TextLabel", v22)
		children.CountryCodeButton = createElement4("TextButton", v19, v20)

		children.Divider = Roact.createElement("Frame", {
			BackgroundColor3 = color2,
			Size = UDim2.new(0, 2, 1, 0),
			Position = UDim2.new(0, v8, 0, 0),
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		})

		children.CountryCodePortal = Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			CountryCodeSelectionGui = Roact.createElement(
				"ScreenGui",
				{
					Enabled = true,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = 13
				},
				{
					CountryCodeSelector = Roact.createElement(module4, {
						WidgetVisible = data.state.CountryCodeSearchVisible,
						CloseCallback = data.CloseCountryCode,
						SelectionCallback = data.SelectCountryCode
					})
				}
			)
		})
		return createElement("TextButton", v10, children)
	end)
end

return extended
