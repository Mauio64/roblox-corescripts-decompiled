local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local v6 = Roact.PureComponent:extend(script.Name)

function v6.render(p1) -- line: 12
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy)
	local helpText = p1.props.helpText
	local iconImage = p1.props.iconImage

	return withStyle(function(p2) -- line: 16
		-- upvalues: Roact (copy), ImageSetLabel (copy), iconImage (copy), helpText (copy)
		local v11 = p2.Font.CaptionBody.RelativeSize * p2.Font.BaseSize

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Icon = Roact.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = iconImage,
				ImageColor3 = p2.Theme.SystemPrimaryDefault.Color,
				Size = UDim2.fromOffset(v11, v11)
			}),
			Text = Roact.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = p2.Font.CaptionBody.Font,
				Size = UDim2.new(1, -v11, 0, 0),
				Text = helpText,
				TextColor3 = p2.Theme.SystemPrimaryDefault.Color,
				TextSize = p2.Font.CaptionBody.RelativeSize * p2.Font.BaseSize,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 2)
				})
			})
		})
	end)
end

return v6
