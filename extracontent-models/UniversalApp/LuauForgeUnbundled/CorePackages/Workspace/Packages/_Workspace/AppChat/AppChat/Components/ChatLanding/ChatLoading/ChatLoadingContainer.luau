local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Style.withStyle
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLoading/ChatLoadingIndicator")

local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppIaScrollAway
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")

local extended = Roact.PureComponent:extend("ChatLoadingContainer")

extended.defaultProps = {
	topBarHeight = 0,
	cellHeight = 64,
	cellWidth = 375,
	topPadding = fFlagAppIaScrollAway and 0 or nil
}

function extended.render(p2)
	local pageBackgroundTransparency = p2.props.pageBackgroundTransparency
	return withStyle(function(p3)
		local createElement = Roact.createElement
		local v6 = {
			Name = FFlagAppThemeHalloween2026ChatBackground and "ChatLoadingContainer" or nil,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ClipsDescendants = true
		}
		local v7 = if pageBackgroundTransparency == nil then p3.Tokens.Color.None.Transparency else pageBackgroundTransparency
		v6.BackgroundTransparency = v7

		local v8 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical
			}),
			UIPadding = 0,
			ChatLoadingFrame = 0
		}

		local v9 = if fFlagAppIaScrollAway and p2.props.topPadding > 0 then Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, p2.props.topPadding)
		}) else nil
		v8.UIPadding = v9

		v8.ChatLoadingFrame = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 2
			},
			{
				ChatLoadingIndicator = Roact.createElement(module2, {
					cellHeight = p2.props.cellHeight,
					cellWidth = p2.props.cellWidth,
					pageBackgroundTransparency = pageBackgroundTransparency
				})
			}
		)
		return createElement("Frame", v6, v8)
	end)
end

return extended
