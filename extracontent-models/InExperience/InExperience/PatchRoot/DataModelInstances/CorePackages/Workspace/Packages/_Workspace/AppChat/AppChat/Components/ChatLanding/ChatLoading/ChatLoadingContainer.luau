local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Roact = require(parent.Roact)

local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ChatLoadingIndicator = require(script.Parent.ChatLoadingIndicator)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)

local extended = Roact.PureComponent:extend("ChatLoadingContainer")

extended.defaultProps = {
	topBarHeight = 0,
	cellHeight = 64,
	cellWidth = 375,
	topPadding = FFlagAppIaScrollAway and 0 or nil
}

function extended.render(p)
	local pageBackgroundTransparency = p.props.pageBackgroundTransparency
	return withStyle(function(p2)
		local createElement = Roact.createElement
		local v = {
			Name = FFlagAppThemeHalloween2026ChatBackground and "ChatLoadingContainer" or nil,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			ClipsDescendants = true
		}
		local backgroundTransparency

		if pageBackgroundTransparency == nil then
			backgroundTransparency = p2.Tokens.Color.None.Transparency
		else
			backgroundTransparency = pageBackgroundTransparency
		end

		v.BackgroundTransparency = backgroundTransparency

		local v2 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical
			}),
			UIPadding = 0,
			ChatLoadingFrame = 0
		}
		local uiPadding

		if FFlagAppIaScrollAway and p.props.topPadding > 0 then
			uiPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, p.props.topPadding)
			})
		end

		v2.UIPadding = uiPadding

		v2.ChatLoadingFrame = Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, LayoutOrder = 2 },
			{
				ChatLoadingIndicator = Roact.createElement(ChatLoadingIndicator, {
					cellHeight = p.props.cellHeight,
					cellWidth = p.props.cellWidth,
					pageBackgroundTransparency = pageBackgroundTransparency
				})
			}
		)
		return createElement("Frame", v, v2)
	end)
end

return extended
