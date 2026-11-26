local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function ItemCardStatus(p2)
	local v5 = useTokens()
	return React.createElement(text, {
		textStyle = v5.Inverse.Content.Emphasis,
		fontStyle = v5.Typography.LabelSmall,
		LayoutOrder = p2.LayoutOrder,
		Text = p2.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = v5.Color.System.Contrast,
		padding = v5.Padding.Small,
		cornerRadius = UDim.new(0.5, 0)
	})
end

return ItemCardStatus
