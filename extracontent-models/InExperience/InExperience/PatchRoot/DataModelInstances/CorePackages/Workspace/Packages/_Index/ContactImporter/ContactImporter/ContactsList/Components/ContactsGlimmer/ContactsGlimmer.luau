local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Skeleton = dependencies.Foundation.Skeleton
local withStyle = UIBlox.Style.withStyle
local v7 = Roact.PureComponent:extend("ContactsGlimmer")

function v7.render(p1) -- line: 25
	-- upvalues: withStyle (copy), Roact (copy), Skeleton (copy)
	local props = p1.props

	return withStyle(function(p2) -- line: 28
		-- upvalues: Roact (copy), props (copy), p1 (copy), Skeleton (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder,
			Size = UDim2.new(1, 0, 0, 72)
		}, {
			entryContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 0)
				}),
				middleGroup = Roact.createElement("Frame", {
					Size = UDim2.new(1, -68, 1, 0),
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = p1.openBlankProfileView,
					LayoutOrder = 2,
					BackgroundColor3 = Color3.fromRGB(222, 22, 222)
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10)
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 12)
					}),
					PlayerName = Roact.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.fromOffset(90, 14)
					}),
					ContextualInfo = Roact.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromOffset(160, 14)
					})
				})
			}),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = p2.Theme.Divider.Color,
				BackgroundTransparency = p2.Theme.Divider.Transparency
			})
		})
	end)
end

return v7
