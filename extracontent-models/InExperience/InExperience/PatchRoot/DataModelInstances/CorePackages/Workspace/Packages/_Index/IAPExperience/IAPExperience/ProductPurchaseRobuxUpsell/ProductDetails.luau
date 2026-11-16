local parent = script.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)

local RoactFitComponents = require(parent2.RoactFitComponents)
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel

local UIBlox = require(parent2.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle

local ModelViewport = require(parent.Generic.ModelViewport)
local Constants = require(parent.Generic.Constants)

local getEnableCondenseRobuxUpsell = require(parent.Flags.getEnableCondenseRobuxUpsell)

local iconscommonrobux = Images["icons/common/robux"]
local iconsstatusimageunavailable = Images["icons/status/imageunavailable"]

local extended = Roact.Component:extend(script.Name)

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0) }

	function self.changeContentSize(p)
		if self.state.contentSize ~= p.AbsoluteSize then
			self:setState({ contentSize = p.AbsoluteSize })
		end
	end
end

function extended.render(data)
	local props = data.props

	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font

		local v = props.itemIcon ~= nil and Constants.NORMAL_ICON_SIZE or IconSize.Large

		if props.model ~= nil then
			v = Constants.NORMAL_ICON_SIZE
		end

		local v2

		if getEnableCondenseRobuxUpsell() then
			v2 = props.itemIconWidth == nil and v or props.itemIconWidth
			v = props.itemIconHeight == nil and v or props.itemIconHeight
		else
			v2 = v
		end

		local itemIcon

		if props.itemIcon then
			itemIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, v2, 0, v),
				ScaleType = Enum.ScaleType.Stretch,
				Image = props.itemIcon,
				ImageTransparency = 0
			})
		else
			itemIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, v2, 0, v),
				ScaleType = Enum.ScaleType.Stretch,
				Image = iconsstatusimageunavailable,
				ImageColor3 = theme.UIDefault.Color,
				ImageTransparency = theme.UIDefault.Transparency
			})
		end

		if props.model ~= nil then
			itemIcon = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(v2, v)
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
			[Roact.Ref] = data.contentRef,
			[Roact.Change.AbsoluteSize] = data.changeContentSize
		}, {
			ItemIconFrame = Roact.createElement(FitFrameVertical, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				width = UDim.new(0.45, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				margin = { top = 0, bottom = 0, left = 0, right = 20 }
			}, { ItemIcon = itemIcon }),
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
					width = FitTextLabel.Width.FitToText,
					maximumWidth = data.state.contentSize.X * 0.55,
					Font = font.Header2.Font,
					Text = props.itemName,
					TextSize = font.BaseSize * font.Header2.RelativeSize,
					TextColor3 = theme.TextEmphasis.Color,
					TextWrapped = true,
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
						Image = iconscommonrobux,
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = theme.IconEmphasis.Transparency
					}),
					ItemCost = Roact.createElement(FitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = FitTextLabel.Width.FitToText,
						maximumWidth = data.state.contentSize.X,
						Font = font.Header2.Font,
						Text = tostring(props.itemRobuxCost),
						TextSize = font.BaseSize * font.Header2.RelativeSize,
						TextColor3 = theme.TextEmphasis.Color
					})
				})
			})
		})
	end)
end

return extended
