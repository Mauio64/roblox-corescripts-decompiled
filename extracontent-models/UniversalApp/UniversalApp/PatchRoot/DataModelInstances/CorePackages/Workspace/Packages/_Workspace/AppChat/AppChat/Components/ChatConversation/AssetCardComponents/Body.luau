local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local v7 = Roact.PureComponent:extend("AssetCard_Coπtent")

v7.defaultProps = {
	cardIcon = nil,
	cardBodyText = nil,
	bodyActivated = nil,
	contentLoadedCallback = nil
}

function v7.init(p1) -- line: 21
	-- upvalues: Roact (copy)
	p1.iconRef = Roact.createRef()
end
function v7.render(p2) -- line: 25
	-- upvalues: UIBlox (copy), Roact (copy), Skeleton (copy), EnumsRadius (copy)
	return UIBlox.Style.withStyle(function(p3) -- line: 26
		-- upvalues: Roact (copy), p2 (copy), UIBlox (copy), Skeleton (copy), EnumsRadius (copy)
		return Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 0, 64),
			BackgroundTransparency = 1,
			[Roact.Event.Activated] = p2.props.bodyActivated
		}, {
			layout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Icon = Roact.createElement(UIBlox.App.Loading.LoadableImage, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				useShimmerAnimationWhileLoading = true,
				Size = UDim2.new(0, 64, 0, 64),
				Image = p2.props.cardIcon,
				cornerRadius = UDim.new(0, 4)
			}),
			Details = not p2.props.isLoading and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 17,
				TextWrapped = true,
				LayoutOrder = 2,
				Size = UDim2.new(1, -76, 0, 64),
				Text = p2.props.cardBodyText,
				TextColor3 = p3.Theme.TextEmphasis.Color,
				Font = p3.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}, p2.props[Roact.Children]) or Roact.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(1, -76, 0, 64),
				radius = EnumsRadius.Small
			})
		})
	end)
end

return v7
