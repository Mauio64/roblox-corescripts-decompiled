local Parent = script:FindFirstAncestor("TenFootUiGlobalNav").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local v6 = game:DefineFastFlag("TenFootUiGlobalNavFixOptionText", false)

local function GlobalNavOptionTooltip(t1: {[any]: any}) -- line: 17
	-- upvalues: useStyle (copy), React (copy), StyledTextLabel (copy), v6 (copy)
	local v9 = useStyle()

	return React.createElement("Frame", {
		[React.Tag] = "data-testid=GlobalNavOptionTooltip",
		Transparency = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 300, 1, 0),
		AnchorPoint = Vector2.new(0.5, -1),
		Position = UDim2.new(0, t1.xOffset, 0, t1.yOffset)
	}, React.createElement(StyledTextLabel, {
		size = UDim2.new(1, 0, 1, 0),
		text = t1.label,
		textXAlignment = Enum.TextXAlignment.Center,
		colorStyle = {
			Transparency = 0,
			Color = v9.Theme.TextDefault.Color
		},
		fontStyle = if not v6 then v9.Font.Header2 else v9.Tokens.Typography.BodyLarge
	}))
end

return GlobalNavOptionTooltip
