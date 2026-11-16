local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local TextService = game:GetService("TextService")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").GetTextSize
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

return function(props)
	local x

	if foundationFontFaceMigration then
		x = getTextSize(props.text, props.fontSize, props.font, Vector2.new(1e999, props.fontSize), {
			addTemporaryPadding = false
		}).X
	else
		x = TextService:GetTextSize(
			props.text,
			props.fontSize,
			props.font,
			Vector2.new(1e999, props.fontSize)
		).X
	end

	local createElement = React.createElement

	local v6 = { LayoutOrder = props.layoutOrder, Size = 0, BackgroundTransparency = 1 }
	local v7 = if props.size then props.size else UDim2.new(0, props.width, 0, props.height)
	v6.Size = v7

	local element = React.createElement("Frame", {
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0.5, -x / 2 - props.padding, 0, 1),
		BackgroundTransparency = props.transparency,
		BackgroundColor3 = props.color3
	})

	local element2 = React.createElement("Frame", {
		Position = UDim2.new(0.5, x / 2 + props.padding, 0.5, 0),
		Size = UDim2.new(0.5, -x / 2 - props.padding, 0, 1),
		BackgroundTransparency = props.transparency,
		BackgroundColor3 = props.color3
	})

	local createElement2 = React.createElement
	local v9 = {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Text = props.text,
		TextSize = props.fontSize,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextTransparency = 0,
		TextColor3 = 0,
		BackgroundTransparency = 1
	}
	local v10 = if not foundationFontFaceMigration then props.font else nil
	v9.Font = v10
	local v11 = if foundationFontFaceMigration then normalizeFontFace(props.font) else nil
	v9.FontFace = v11
	v9.TextXAlignment = Enum.TextXAlignment.Center
	v9.TextYAlignment = Enum.TextYAlignment.Center
	v9.TextTransparency = props.transparency
	v9.TextColor3 = props.color3
	return createElement("Frame", v6, element, element2, createElement2("TextLabel", v9))
end
