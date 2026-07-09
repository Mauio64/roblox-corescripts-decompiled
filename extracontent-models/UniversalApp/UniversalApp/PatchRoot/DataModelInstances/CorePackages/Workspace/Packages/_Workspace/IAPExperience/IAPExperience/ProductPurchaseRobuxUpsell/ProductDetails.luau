local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local RoactFitComponents = require(ParentParentParent.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local UIBlox = require(ParentParentParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle
local ModelViewport = require(ParentParent.Generic.ModelViewport)
local Constants = require(ParentParent.Generic.Constants)
local getEnableCondenseRobuxUpsell = require(ParentParent.Flags.getEnableCondenseRobuxUpsell)
local v15 = Images["icons/common/robux"]
local v16 = Images["icons/status/imageunavailable"]
local v17 = Roact.Component:extend(script.Name)

function v17.init(p1) -- line: 39
	-- upvalues: Roact (copy)
	p1.contentRef = Roact.createRef()
	p1.state = {
		contentSize = Vector2.new(0, 0)
	}

	function p1.changeContentSize(p2) -- line: 45
		-- upvalues: p1 (copy)
		if p1.state.contentSize ~= p2.AbsoluteSize then
			p1:setState({
				contentSize = p2.AbsoluteSize
			})
		end
	end
end
function v17.render(p3) -- line: 54
	-- upvalues: withStyle (copy), Constants (copy), IconSize (copy), getEnableCondenseRobuxUpsell (copy), Roact (copy), ImageSetLabel (copy), v16 (copy), ModelViewport (copy), FitFrameVertical (copy), FitTextLabel (copy), v15 (copy)
	local props = p3.props

	return withStyle(function(p4) -- line: 57
		-- upvalues: props (copy), Constants (copy), IconSize (copy), getEnableCondenseRobuxUpsell (copy), Roact (copy), ImageSetLabel (copy), v16 (copy), ModelViewport (copy), FitFrameVertical (copy), p3 (copy), FitTextLabel (copy), v15 (copy)
		local Theme = p4.Theme
		local p4Font = p4.Font
		local v25 = props.itemIcon ~= nil and Constants.NORMAL_ICON_SIZE or IconSize.Large

		if props.model ~= nil then
			v25 = Constants.NORMAL_ICON_SIZE
		end

		local v26 = v25

		if getEnableCondenseRobuxUpsell() then
			v26 = props.itemIconWidth == nil and v25 or props.itemIconWidth
			v25 = props.itemIconHeight == nil and v25 or props.itemIconHeight
		end

		local v27 = if not props.itemIcon then Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, v26, 0, v25),
			ScaleType = Enum.ScaleType.Stretch,
			Image = v16,
			ImageColor3 = Theme.UIDefault.Color,
			ImageTransparency = Theme.UIDefault.Transparency
		}) else Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ImageTransparency = 0,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, v26, 0, v25),
			ScaleType = Enum.ScaleType.Stretch,
			Image = props.itemIcon
		})

		if props.model ~= nil then
			v27 = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(v26, v25)
			})
		end

		return Roact.createElement(FitFrameVertical, {
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			contentPadding = UDim.new(0, 6),
			[Roact.Ref] = p3.contentRef,
			[Roact.Change.AbsoluteSize] = p3.changeContentSize
		}, {
			ItemIconFrame = Roact.createElement(FitFrameVertical, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				width = UDim.new(0.45, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				margin = {
					top = 0,
					bottom = 0,
					left = 0,
					right = 20
				}
			}, {
				ItemIcon = v27
			}),
			ItemDetailsFrame = Roact.createElement(FitFrameVertical, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				width = UDim.new(0.55, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				contentPadding = UDim.new(0, 5)
			}, {
				ItemName = Roact.createElement(FitTextLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					TextWrapped = true,
					width = FitTextLabel.Width.FitToText,
					maximumWidth = p3.state.contentSize.X * 0.55,
					Font = p4Font.Header2.Font,
					Text = props.itemName,
					TextSize = p4Font.BaseSize * p4Font.Header2.RelativeSize,
					TextColor3 = Theme.TextEmphasis.Color,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				ItemCostFrame = Roact.createElement(FitFrameVertical, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					width = UDim.new(0.5, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					contentPadding = UDim.new(0, 2)
				}, {
					RobuxIcon = Roact.createElement(ImageSetLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 5, 0, 5),
						Size = UDim2.new(0, 24, 0, 24),
						ScaleType = Enum.ScaleType.Stretch,
						Image = v15,
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = Theme.IconEmphasis.Transparency
					}),
					ItemCost = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = FitTextLabel.Width.FitToText,
						maximumWidth = p3.state.contentSize.X,
						Font = p4Font.Header2.Font,
						Text = tostring(props.itemRobuxCost),
						TextSize = p4Font.BaseSize * p4Font.Header2.RelativeSize,
						TextColor3 = Theme.TextEmphasis.Color
					})
				})
			})
		})
	end)
end

return v17
