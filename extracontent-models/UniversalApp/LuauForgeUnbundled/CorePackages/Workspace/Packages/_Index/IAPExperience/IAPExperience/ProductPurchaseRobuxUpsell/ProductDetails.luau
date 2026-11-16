local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local FitFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/FitFrame")
local fitFrameVertical = FitFrame.FitFrameVertical
local fitTextLabel = FitFrame.FitTextLabel

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local withStyle = UIBlox.Core.Style.withStyle

local ModelViewport = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ModelViewport")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Constants")

local getEnableCondenseRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/getEnableCondenseRobuxUpsell")

local iconscommonrobux = images["icons/common/robux"]
local iconsstatusimageunavailable = images["icons/status/imageunavailable"]

local extended = Roact.Component:extend("ProductDetails")

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0) }

	function self.changeContentSize(p2)
		if self.state.contentSize ~= p2.AbsoluteSize then
			self:setState({ contentSize = p2.AbsoluteSize })
		end
	end
end

function extended.render(data)
	local props = data.props

	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local v5 = props.itemIcon ~= nil and Constants.NORMAL_ICON_SIZE or iconSize.Large

		if props.model ~= nil then
			v5 = Constants.NORMAL_ICON_SIZE
		end

		local v6

		if getEnableCondenseRobuxUpsell() then
			v6 = props.itemIconWidth == nil and v5 or props.itemIconWidth
			v5 = props.itemIconHeight == nil and v5 or props.itemIconHeight
		else
			v6 = v5
		end

		local v7

		if props.itemIcon then
			v7 = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, v6, 0, v5),
				ScaleType = Enum.ScaleType.Stretch,
				Image = props.itemIcon,
				ImageTransparency = 0
			})
		else
			v7 = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, v6, 0, v5),
				ScaleType = Enum.ScaleType.Stretch,
				Image = iconsstatusimageunavailable,
				ImageColor3 = theme.UIDefault.Color,
				ImageTransparency = theme.UIDefault.Transparency
			})
		end

		if props.model ~= nil then
			v7 = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(v6, v5)
			})
		end

		return Roact.createElement(fitFrameVertical, {
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
			ItemIconFrame = Roact.createElement(fitFrameVertical, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				width = UDim.new(0.45, 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				margin = { top = 0, bottom = 0, left = 0, right = 20 }
			}, { ItemIcon = v7 }),
			ItemDetailsFrame = Roact.createElement(fitFrameVertical, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				width = UDim.new(0.55, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				contentPadding = UDim.new(0, 5)
			}, {
				ItemName = Roact.createElement(fitTextLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					width = fitTextLabel.Width.FitToText,
					maximumWidth = data.state.contentSize.X * 0.55,
					Font = font.Header2.Font,
					Text = props.itemName,
					TextSize = font.BaseSize * font.Header2.RelativeSize,
					TextColor3 = theme.TextEmphasis.Color,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				ItemCostFrame = Roact.createElement(fitFrameVertical, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					width = UDim.new(0.5, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					contentPadding = UDim.new(0, 2)
				}, {
					RobuxIcon = Roact.createElement(imageSetLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 5, 0, 5),
						Size = UDim2.new(0, 24, 0, 24),
						ScaleType = Enum.ScaleType.Stretch,
						Image = iconscommonrobux,
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = theme.IconEmphasis.Transparency
					}),
					ItemCost = Roact.createElement(fitTextLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = fitTextLabel.Width.FitToText,
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
