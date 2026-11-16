local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local appFonts = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").AppFonts
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize

local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").Colors
local white = colors.White
local gray2 = colors.Gray2
Roact.PureComponent:extend("CountryCodeSelectorButton")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Text
local GetFFlagCountryCodeBoldPrefixEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/GetFFlagCountryCodeBoldPrefixEnabled")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox").Core.Style.useStyle
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/Types")

local function CountryCodeSelectorButton(props)
	local localizedName = props.CountryCode.localizedName or ""
	local v5 = "+" .. (props.CountryCode.prefix or "")
	local textSize = props.ListButtonProps.TextSize
	local boldPrefixEnabled = GetFFlagCountryCodeBoldPrefixEnabled() and props.BoldPrefixEnabled
	local v6 = if foundationFontFaceMigration then Foundation.Hooks.useTokens() else nil
	local v7

	if foundationFontFaceMigration then
		v7 = getTextSize(v5, textSize, v6.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X
	else
		v7 = text.GetTextWidth(v5, appFonts.default:getDefault(), textSize)
	end

	local v8 = string.format("%s (%s)", localizedName, v5)
	local size = props.Size
	local layoutOrder = props.LayoutOrder
	local selectionCallback = props.ListButtonProps.SelectionCallback or function(p2) end
	local v9 = useStyle()
	local children

	if boldPrefixEnabled then
		children = { FullText = 0 }
		local createElement = Roact.createElement
		local v11 = {
			Size = UDim2.new(1, 0, 1, 0),
			Text = v8,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextTruncate = 0
		}

		local v12 = if not foundationFontFaceMigration then v9.Tokens.Typography.BodySmall.Font else nil
		v11.Font = v12

		local v13 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodySmall.Font) else nil
		v11.FontFace = v13

		v11.TextColor3 = v9.Tokens.Color.Shift.Shift_400.Color3
		v11.TextSize = textSize
		v11.TextXAlignment = Enum.TextXAlignment.Left
		v11.TextTruncate = Enum.TextTruncate.AtEnd
		children.FullText = createElement("TextLabel", v11)
	else
		children = { CountryName = 0, CountryPrefix = 0 }
		local createElement = Roact.createElement
		local v11 = {
			Size = UDim2.new(1, -v7, 1, 0),
			Text = localizedName,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextTruncate = 0
		}

		local v12 = if not foundationFontFaceMigration then appFonts.default:getDefault() else nil
		v11.Font = v12

		local v13 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodySmall.Font) else nil
		v11.FontFace = v13

		v11.TextColor3 = white
		v11.TextSize = textSize
		v11.TextXAlignment = Enum.TextXAlignment.Left
		v11.TextTruncate = Enum.TextTruncate.AtEnd
		children.CountryName = createElement("TextLabel", v11)

		local createElement2 = Roact.createElement
		local v15 = {
			Size = UDim2.new(1, 0, 1, 0),
			Text = v5,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextTruncate = 0
		}

		local v16 = if not foundationFontFaceMigration then appFonts.default:getDefault() else nil
		v15.Font = v16

		local v17 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodySmall.Font) else nil
		v15.FontFace = v17

		v15.TextColor3 = gray2
		v15.TextSize = textSize
		v15.TextXAlignment = Enum.TextXAlignment.Right
		v15.TextTruncate = Enum.TextTruncate.AtEnd
		children.CountryPrefix = createElement2("TextLabel", v15)
	end

	return Roact.createElement("TextButton", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Text = "",
		[Roact.Event.Activated] = function()
			selectionCallback(props.CountryCode)
		end
	}, children)
end

return CountryCodeSelectorButton
