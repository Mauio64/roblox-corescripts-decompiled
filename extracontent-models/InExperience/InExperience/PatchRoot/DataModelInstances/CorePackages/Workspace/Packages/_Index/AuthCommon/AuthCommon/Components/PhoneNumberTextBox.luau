local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local CoreGui = game:GetService("CoreGui")
local Roact = require(AuthCommonParent.Roact)
local UIBlox = require(AuthCommonParent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Text = require(AuthCommonParent.AppCommonLib).Text
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(AuthCommonParent.RobloxAppAssets).GetImageData
local CountryCodeSelector = require(AuthCommon.Components.CountryCodeSelector)
local v11 = Roact.Component:extend("PhoneNumberTextBox")

v11.defaultProps = {
	CountryCodeSize = 70,
	InnerPadding = 12
}

function v11.init(p1) -- line: 26
	p1:setState({
		CountryCodeHover = false,
		CountryCodeSearchVisible = false
	})

	function p1.CountryCodeMouseEnter() -- line: 32
		-- upvalues: p1 (copy)
		p1:setState({
			CountryCodeHover = true
		})
	end
	function p1.CountryCodeMouseLeave() -- line: 38
		-- upvalues: p1 (copy)
		p1:setState({
			CountryCodeHover = false
		})
	end
	function p1.OpenCountryCode() -- line: 44
		-- upvalues: p1 (copy)
		p1:setState({
			CountryCodeSearchVisible = true
		})

		if p1.props.phoneCountryCodeSelectorCallback then
			p1.props.phoneCountryCodeSelectorCallback(true)
		end
	end
	function p1.CloseCountryCode() -- line: 54
		-- upvalues: p1 (copy)
		p1:setState({
			CountryCodeSearchVisible = false
		})

		if p1.props.phoneCountryCodeSelectorCallback then
			p1.props.phoneCountryCodeSelectorCallback(false)
		end
	end
	function p1.SelectCountryCode(p2) -- line: 64
		-- upvalues: p1 (copy)
		if p1.props.SetCountryCode then
			p1.props.SetCountryCode(p2)
		end

		p1.CloseCountryCode()
	end
end
function v11.render(p3) -- line: 72
	-- upvalues: withStyle (copy), Text (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy), CoreGui (copy), CountryCodeSelector (copy)
	return withStyle(function(p4) -- line: 73
		-- upvalues: p3 (copy), Text (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy), CoreGui (copy), CountryCodeSelector (copy)
		local propsColor = p3.props.Color
		local BackgroundMutedColor = p4.Theme.BackgroundMuted.Color
		local propsTransparency = p3.props.Transparency
		local BodyFont = p4.Font.Body.Font
		local v20 = p4.Font.BaseSize * p4.Font.Body.RelativeSize
		local TextDefaultColor = p4.Theme.TextDefault.Color
		local TextDefaultTransparency = p4.Theme.TextDefault.Transparency
		local UIDefaultColor = p4.Theme.UIDefault.Color
		local _ = p3.props.PlaceholderText or ""
		local v25 = p3.props.Text or ""
		local v26 = p3.props.TextInputTypeOverride or Enum.TextInputType.Phone
		local v27 = " +" .. p3.props.CountryCode.prefix
		local v28 = math.max(Text.GetTextWidth(v27, BodyFont, v20) + p3.props.InnerPadding * 2, p3.props.CountryCodeSize)

		return Roact.createElement("TextButton", {
			Size = p3.props.Size,
			Position = p3.props.Position,
			AnchorPoint = p3.props.AnchorPoint,
			LayoutOrder = p3.props.LayoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.MouseEnter] = p3.props.onMouseEnter,
			[Roact.Event.MouseLeave] = p3.props.onMouseLeave
		}, {
			InputWrapper = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = UDim2.new(1, -v28 - 2, 1, 0),
				Position = UDim2.new(0, v28 + 2, 0, 0)
			}, {
				Background = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 18, 1, 0),
					Position = UDim2.new(0, -18, 0, 0),
					Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = propsColor,
					ImageTransparency = propsTransparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}),
				InputField = Roact.createElement("TextBox", {
					BackgroundTransparency = 1,
					ZIndex = 2,
					Size = UDim2.new(1, -p3.props.InnerPadding * 2, 1, 0),
					Position = UDim2.new(0, p3.props.InnerPadding, 0, 0),
					PlaceholderColor3 = UIDefaultColor,
					PlaceholderText = p3.props.PlaceholderText,
					Text = v25,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = TextDefaultColor,
					TextSize = v20,
					TextInputType = v26,
					Font = BodyFont,
					ClearTextOnFocus = false,
					[Roact.Event.Focused] = p3.props.onFocused,
					[Roact.Event.FocusLost] = p3.props.onFocusLost,
					[Roact.Change.Text] = p3.props.onChangeText
				})
			}),
			CountryCodeButton = Roact.createElement("TextButton", {
				Size = UDim2.new(0, v28, 1, 0),
				ZIndex = 2,
				Text = "",
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Roact.Event.MouseEnter] = p3.CountryCodeMouseEnter,
				[Roact.Event.MouseLeave] = p3.CountryCodeMouseLeave,
				[Roact.Event.Activated] = p3.OpenCountryCode
			}, {
				Background = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 18, 1, 0),
					Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
					ImageColor3 = p3.state.CountryCodeHover and BackgroundMutedColor or propsColor,
					ImageTransparency = propsTransparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}),
				Prefix = Roact.createElement("TextLabel", {
					ZIndex = 2,
					BackgroundTransparency = 1,
					RichText = true,
					Size = UDim2.new(1, -p3.props.InnerPadding, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Right,
					Font = BodyFont,
					Text = "<u>" .. v27 .. "</u>",
					TextSize = v20,
					TextColor3 = TextDefaultColor,
					TextTransparency = TextDefaultTransparency
				})
			}),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				BackgroundColor3 = BackgroundMutedColor,
				Size = UDim2.new(0, 2, 1, 0),
				Position = UDim2.new(0, v28, 0, 0),
				BackgroundTransparency = propsTransparency
			}),
			CountryCodePortal = Roact.createElement(Roact.Portal, {
				target = CoreGui
			}, {
				CountryCodeSelectionGui = Roact.createElement("ScreenGui", {
					Enabled = true,
					DisplayOrder = 13,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				}, {
					CountryCodeSelector = Roact.createElement(CountryCodeSelector, {
						WidgetVisible = p3.state.CountryCodeSearchVisible,
						CloseCallback = p3.CloseCountryCode,
						SelectionCallback = p3.SelectCountryCode
					})
				})
			})
		})
	end)
end

return v11
