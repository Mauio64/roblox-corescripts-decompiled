local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize

local Style2 = require(parent.Style)
local Colors = Style2.Colors
local White = Colors.White
local Gray2 = Colors.Gray2
Roact.PureComponent:extend("CountryCodeSelectorButton")
local GetFFlagCountryCodeBoldPrefixEnabled = require(AuthCommon.Flags.GetFFlagCountryCodeBoldPrefixEnabled)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
require(AuthCommon.Common.Types)

local function CountryCodeSelectorButton(props)
	local localizedName = props.CountryCode.localizedName or ""
	local text = "+" .. (props.CountryCode.prefix or "")
	local textSize = props.ListButtonProps.TextSize
	local boldPrefixEnabled = GetFFlagCountryCodeBoldPrefixEnabled() and props.BoldPrefixEnabled
	local v = Foundation.Hooks.useTokens()

	local x = GetTextSize(text, textSize, v.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X
	local text2 = string.format("%s (%s)", localizedName, text)
	local size = props.Size
	local layoutOrder = props.LayoutOrder
	local selectionCallback = props.ListButtonProps.SelectionCallback or function(_) end
	local v2 = useStyle()
	local v3

	if boldPrefixEnabled then
		v3 = {
			FullText = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Text = text2,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v.Typography.BodySmall.Font),
				TextColor3 = v2.Tokens.Color.Shift.Shift_400.Color3,
				TextSize = textSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		}
	else
		v3 = {
			CountryName = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, -x, 1, 0),
				Text = localizedName,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v.Typography.BodySmall.Font),
				TextColor3 = White,
				TextSize = textSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			CountryPrefix = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Text = text,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v.Typography.BodySmall.Font),
				TextColor3 = Gray2,
				TextSize = textSize,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		}
	end

	return Roact.createElement("TextButton", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Text = "",
		[Roact.Event.Activated] = function()
			selectionCallback(props.CountryCode)
		end
	}, v3)
end

return CountryCodeSelectorButton
