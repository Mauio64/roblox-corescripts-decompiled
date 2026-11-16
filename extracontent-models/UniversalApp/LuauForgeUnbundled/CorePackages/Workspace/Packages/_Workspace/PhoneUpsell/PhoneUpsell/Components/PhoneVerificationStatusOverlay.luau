local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local colors = UIBlox.App.Style.Colors

local function PhoneVerificationStatusOverlay(p2)
	local v5 = useStyle()
	local createElement = React.createElement
	local v7 = {
		BackgroundTransparency = 0.3,
		BackgroundColor3 = colors.Black,
		Size = UDim2.new(1, 0, 1, 0)
	}

	local createElement2 = React.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local v11 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 24)
		}),
		Image = p2.image,
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v5.Tokens.Size.Size_600),
			PaddingRight = UDim.new(0, v5.Tokens.Size.Size_600)
		}),
		VerifyingText = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		TextSize = v5.Font.BaseSize * v5.Font.Header1.RelativeSize,
		TextColor3 = colors.White,
		Text = p2.text,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		TextWrapped = true
	}
	local v14 = if not foundationFontFaceMigration then v5.Font.Header1.Font else nil
	v13.Font = v14

	local v15 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.HeadingSmall.Font) else nil
	v13.FontFace = v15
	v11.VerifyingText = createElement3("TextLabel", v13)
	return createElement("Frame", v7, {
		MiddleContent = createElement2("Frame", v10, v11)
	})
end

return PhoneVerificationStatusOverlay
