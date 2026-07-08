local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local AppFonts = require(AuthCommonParent.Style).AppFonts
local Colors = require(AuthCommonParent.Style).Colors
local White = Colors.White
local Gray2 = Colors.Gray2

Roact.PureComponent:extend("CountryCodeSelectorButton")

local Text = require(AuthCommonParent.AppCommonLib).Text
local GetFFlagCountryCodeBoldPrefixEnabled = require(AuthCommon.Flags.GetFFlagCountryCodeBoldPrefixEnabled)
local useStyle = require(AuthCommonParent.UIBlox).Core.Style.useStyle

require(AuthCommon.Common.Types)

local function CountryCodeSelectorButton(t1: {[any]: any}) -- line: 28
	-- upvalues: GetFFlagCountryCodeBoldPrefixEnabled (copy), Text (copy), AppFonts (copy), useStyle (copy), Roact (copy), White (copy), Gray2 (copy)
	local v13 = t1.CountryCode.localizedName or ""
	local v14 = "+" .. (t1.CountryCode.prefix or "")
	local ListButtonPropsTextSize = t1.ListButtonProps.TextSize
	local v16 = GetFFlagCountryCodeBoldPrefixEnabled() and t1.BoldPrefixEnabled
	local v17 = Text.GetTextWidth(v14, AppFonts.default:getDefault(), ListButtonPropsTextSize)
	local v18 = string.format("%s (%s)", v13, v14)
	local t1Size = t1.Size
	local t1LayoutOrder = t1.LayoutOrder
	local v21 = t1.ListButtonProps.SelectionCallback or function(_) -- line: 37
	end
	local v22 = useStyle()
	local v23 = if not v16 then {
		CountryName = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -v17, 1, 0),
			Text = v13,
			Font = AppFonts.default:getDefault(),
			TextColor3 = White,
			TextSize = ListButtonPropsTextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		CountryPrefix = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = v14,
			Font = AppFonts.default:getDefault(),
			TextColor3 = Gray2,
			TextSize = ListButtonPropsTextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	} else {
		FullText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = v18,
			Font = v22.Tokens.Typography.BodySmall.Font,
			TextColor3 = v22.Tokens.Color.Shift.Shift_400.Color3,
			TextSize = ListButtonPropsTextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	}

	return Roact.createElement("TextButton", {
		Size = t1Size,
		BackgroundTransparency = 1,
		LayoutOrder = t1LayoutOrder,
		Text = "",
		[Roact.Event.Activated] = function() -- line: 82
			-- upvalues: v21 (copy), t1 (copy)
			v21(t1.CountryCode)
		end
	}, v23)
end

return CountryCodeSelectorButton
