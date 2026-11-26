local CoreGui = game:GetService("CoreGui")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle

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
		local v5 = props.Font.BaseSize * props.Font.Body.RelativeSize
		local color3 = props.Theme.TextDefault.Color
		local transparency2 = props.Theme.TextDefault.Transparency
		local color4 = props.Theme.UIDefault.Color
		local placeholderText = data.props.PlaceholderText or ""
		local text = data.props.Text or ""
		local textInputTypeOverride = data.props.TextInputTypeOverride or Enum.TextInputType.Phone

		local v6 = " +" .. data.props.CountryCode.prefix
		local v7 = math.max(
			getTextSize(v6, v5, props.Tokens.Typography.BodyLarge.Font, Vector2.new(10000, 10000)).X + data.props.InnerPadding * 2,
			data.props.CountryCodeSize
		)

		return Roact.createElement("TextButton", {
			Size = data.props.Size,
			Position = data.props.Position,
			AnchorPoint = data.props.AnchorPoint,
			LayoutOrder = data.props.LayoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.MouseEnter] = data.props.onMouseEnter,
			[Roact.Event.MouseLeave] = data.props.onMouseLeave
		}, {
			InputWrapper = Roact.createElement("Frame", {
				Size = UDim2.new(1, -v7 - 2, 1, 0),
				Position = UDim2.new(0, v7 + 2, 0, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true
			}, {
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
				InputField = Roact.createElement("TextBox", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.new(1, -data.props.InnerPadding * 2, 1, 0),
					Position = UDim2.new(0, data.props.InnerPadding, 0, 0),
					PlaceholderColor3 = color4,
					PlaceholderText = data.props.PlaceholderText,
					Text = text,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = color3,
					TextSize = v5,
					TextInputType = textInputTypeOverride,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					ClearTextOnFocus = false,
					[Roact.Event.Focused] = data.props.onFocused,
					[Roact.Event.FocusLost] = data.props.onFocusLost,
					[Roact.Change.Text] = data.props.onChangeText
				})
			}),
			CountryCodeButton = Roact.createElement("TextButton", {
				Size = UDim2.new(0, v7, 1, 0),
				ZIndex = 2,
				Text = "",
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Roact.Event.MouseEnter] = data.CountryCodeMouseEnter,
				[Roact.Event.MouseLeave] = data.CountryCodeMouseLeave,
				[Roact.Event.Activated] = data.OpenCountryCode
			}, {
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
				Prefix = Roact.createElement("TextLabel", {
					Size = UDim2.new(1, -data.props.InnerPadding, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Right,
					ZIndex = 2,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					Text = "<u>" .. v6 .. "</u>",
					TextSize = v5,
					TextColor3 = color3,
					TextTransparency = transparency2,
					BackgroundTransparency = 1,
					RichText = true
				})
			}),
			Divider = Roact.createElement("Frame", {
				BackgroundColor3 = color2,
				Size = UDim2.new(0, 2, 1, 0),
				Position = UDim2.new(0, v7, 0, 0),
				BackgroundTransparency = transparency,
				BorderSizePixel = 0,
				ZIndex = 2
			}),
			CountryCodePortal = Roact.createElement(Roact.Portal, { target = CoreGui }, {
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
		})
	end)
end

return extended
