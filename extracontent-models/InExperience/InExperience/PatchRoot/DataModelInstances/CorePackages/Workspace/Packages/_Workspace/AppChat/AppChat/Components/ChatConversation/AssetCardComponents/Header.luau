local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local v7 = Roact.PureComponent:extend("AssetCard_Header")

v7.defaultProps = {
	cardTitle = nil
}

function v7.render(p1) -- line: 19
	-- upvalues: UIBlox (copy), Roact (copy), Skeleton (copy), EnumsRadius (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 20
		-- upvalues: Roact (copy), p1 (copy), Skeleton (copy), EnumsRadius (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20)
		}, {
			padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 2)
			}),
			title = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -6, 1, 0)
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				label = not p1.props.isLoading and Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 23,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Size = UDim2.new(1, 0, 1, 0),
					Text = p1.props.cardTitle,
					TextColor3 = p2.Theme.TextEmphasis.Color,
					Font = p2.Font.CaptionHeader.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				}) or Roact.createElement(Skeleton, {
					Size = UDim2.fromScale(0.5, 1),
					radius = EnumsRadius.Small
				})
			})
		})
	end)
end

return v7
