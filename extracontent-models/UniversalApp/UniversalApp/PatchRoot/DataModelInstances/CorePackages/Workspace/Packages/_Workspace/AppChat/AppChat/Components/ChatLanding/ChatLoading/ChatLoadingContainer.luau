local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local withStyle = require(Parent.UIBlox).Style.withStyle
local ChatLoadingIndicator = require(script.Parent.ChatLoadingIndicator)
local FFlagAppIaScrollAway = require(Parent.SharedFlags).FFlagAppIaScrollAway
local v6 = Roact.PureComponent:extend("ChatLoadingContainer")

v6.defaultProps = {
	topBarHeight = 0,
	cellHeight = 64,
	cellWidth = 375,
	topPadding = if not FFlagAppIaScrollAway then nil else 0
}

function v6.render(p1) -- line: 21
	-- upvalues: withStyle (copy), Roact (copy), FFlagAppIaScrollAway (copy), ChatLoadingIndicator (copy)
	return withStyle(function(p2) -- line: 22
		-- upvalues: Roact (copy), FFlagAppIaScrollAway (copy), p1 (copy), ChatLoadingIndicator (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = p2.Tokens.Color.None.Transparency
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical
			}),
			UIPadding = if not FFlagAppIaScrollAway or not (p1.props.topPadding > 0) then nil else Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, p1.props.topPadding)
			}),
			ChatLoadingFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				ChatLoadingIndicator = Roact.createElement(ChatLoadingIndicator, {
					cellHeight = p1.props.cellHeight,
					cellWidth = p1.props.cellWidth
				})
			})
		})
	end)
end

return v6
