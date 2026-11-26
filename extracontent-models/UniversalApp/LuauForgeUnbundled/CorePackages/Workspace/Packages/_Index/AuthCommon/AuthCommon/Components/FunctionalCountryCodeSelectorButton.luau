local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize

local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").Colors
local white = colors.White
local gray2 = colors.Gray2
Roact.PureComponent:extend("CountryCodeSelectorButton")
local GetFFlagCountryCodeBoldPrefixEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/GetFFlagCountryCodeBoldPrefixEnabled")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox").Core.Style.useStyle
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/Types")

local function CountryCodeSelectorButton(props)
	local localizedName = props.CountryCode.localizedName or ""
	local v5 = "+" .. (props.CountryCode.prefix or "")
	local textSize = props.ListButtonProps.TextSize
	local boldPrefixEnabled = GetFFlagCountryCodeBoldPrefixEnabled() and props.BoldPrefixEnabled
	local v6 = Foundation.Hooks.useTokens()

	local x = getTextSize(v5, textSize, v6.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X
	local v7 = string.format("%s (%s)", localizedName, v5)
	local size = props.Size
	local layoutOrder = props.LayoutOrder
	local selectionCallback = props.ListButtonProps.SelectionCallback or function(p2) end
	local v8 = useStyle()
	local v9

	if boldPrefixEnabled then
		v9 = {
			FullText = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Text = v7,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v6.Typography.BodySmall.Font),
				TextColor3 = v8.Tokens.Color.Shift.Shift_400.Color3,
				TextSize = textSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		}
	else
		v9 = {
			CountryName = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, -x, 1, 0),
				Text = localizedName,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v6.Typography.BodySmall.Font),
				TextColor3 = white,
				TextSize = textSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			CountryPrefix = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Text = v5,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v6.Typography.BodySmall.Font),
				TextColor3 = gray2,
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
	}, v9)
end

return CountryCodeSelectorButton
