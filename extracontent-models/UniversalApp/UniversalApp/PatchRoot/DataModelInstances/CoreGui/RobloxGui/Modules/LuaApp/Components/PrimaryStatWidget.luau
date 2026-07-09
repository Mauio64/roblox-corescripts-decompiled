local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local Text = require(Modules.Common.Text)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local v7 = Roact.PureComponent:extend("PrimaryStatWidget")

v7.defaultProps = {
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0)
}

function v7.GetMinimumWidth(p1, p2, p3) -- line: 29
	-- upvalues: Text (copy)
	return math.max(Text.GetTextWidth(p1, p3, 42), (Text.GetTextWidth(p2, p3, 12))) + 74
end
function v7.GetMinimumWidthRethemed(p4, p5, p6) -- line: 38
	-- upvalues: Text (copy)
	return math.max(Text.GetTextWidth(p4, p6.Font.Title.Font, p6.Font.BaseSize * p6.Font.Title.RelativeSize), (Text.GetTextWidth(p5, p6.Font.CaptionHeader.Font, p6.Font.BaseSize * p6.Font.CaptionHeader.RelativeSize))) + 74
end
function v7.render(p7) -- line: 52
	-- upvalues: withStyle (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy)
	local icon = p7.props.icon
	local number = p7.props.number
	local label = p7.props.label
	local width = p7.props.width
	local propsLayoutOrder = p7.props.LayoutOrder
	local propsAnchorPoint = p7.props.AnchorPoint
	local propsPosition = p7.props.Position
	local v22 = width - 74

	return withStyle(function(p8) -- line: 63
		-- upvalues: Roact (copy), propsAnchorPoint (copy), propsPosition (copy), width (copy), propsLayoutOrder (copy), DEPRECATED_ImageSetLabel (copy), icon (copy), v22 (copy), number (copy), label (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = propsAnchorPoint,
			Position = propsPosition,
			Size = UDim2.new(0, width, 0, 44),
			LayoutOrder = propsLayoutOrder
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10)
			}),
			Icon = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(0, 44, 0, 44),
				Image = icon,
				ImageColor3 = p8.Theme.IconEmphasis.Color,
				ImageTransparency = p8.Theme.IconEmphasis.Transparency
			}),
			TextSection = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, v22, 1, 0)
			}, {
				Number = Roact.createElement("TextLabel", {
					TextScaled = true,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 42),
					Position = UDim2.new(0, 0, 0, -7),
					Text = number,
					Font = p8.Font.Title.Font,
					TextSize = p8.Font.BaseSize * p8.Font.Title.RelativeSize,
					TextColor3 = p8.Theme.TextEmphasis.Color,
					TextTransparency = p8.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Label = Roact.createElement("TextLabel", {
					TextScaled = true,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 12),
					Position = UDim2.new(0, 0, 0, 28),
					Text = label,
					Font = p8.Font.CaptionHeader.Font,
					TextSize = p8.Font.BaseSize * p8.Font.CaptionHeader.RelativeSize,
					TextColor3 = p8.Theme.TextEmphasis.Color,
					TextTransparency = p8.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})
		})
	end)
end

return v7
