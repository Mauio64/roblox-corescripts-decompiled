local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local skeleton = dependencies.Foundation.Skeleton

local withStyle = uiBlox.Style.withStyle

local extended = roact.PureComponent:extend("ContactsGlimmer")

function extended.render(p2)
	local props = p2.props

	return withStyle(function(p3)
		return roact.createElement(
			"Frame",
			{
				LayoutOrder = props.layoutOrder,
				Size = UDim2.new(1, 0, 0, 72),
				BackgroundTransparency = 1
			},
			{
				entryContent = roact.createElement(
					"Frame",
					{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
					{
						Layout = roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Bottom,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 0)
						}),
						middleGroup = roact.createElement("Frame", {
							Size = UDim2.new(1, -68, 1, 0),
							BackgroundTransparency = 1,
							[roact.Event.Activated] = p2.openBlankProfileView,
							LayoutOrder = 2,
							BackgroundColor3 = Color3.fromRGB(222, 22, 222)
						}, {
							Layout = roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 10)
							}),
							Padding = roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 12)
							}),
							PlayerName = roact.createElement(skeleton, {
								LayoutOrder = 1,
								Size = UDim2.fromOffset(90, 14)
							}),
							ContextualInfo = roact.createElement(skeleton, {
								LayoutOrder = 2,
								Size = UDim2.fromOffset(160, 14)
							})
						})
					}
				),
				Divider = roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = p3.Theme.Divider.Color,
					BackgroundTransparency = p3.Theme.Divider.Transparency
				})
			}
		)
	end)
end

return extended
