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

local FFlagPopularFillIconEnabled = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagPopularFillIconEnabled")
local GetFStringPopularFillIconLocation = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFStringPopularFillIconLocation")

local v5 = if FFlagPopularFillIconEnabled then images[GetFStringPopularFillIconLocation()] else nil

local udim = if FFlagPopularFillIconEnabled then UDim2.new(0, 16, 0, 16) else UDim2.new(0, 0, 0, 0)

local extended = Roact.Component:extend("ProductDetailsNew")

function extended:init()
	self.contentRef = Roact.createRef()
	self.state = { contentSize = Vector2.new(0, 0) }

	function self.changeContentSize(p2)
		if self.state.contentSize ~= p2.AbsoluteSize then
			self:setState({ contentSize = p2.AbsoluteSize })
		end
	end
end

local function getPopularityThreshold(catalogSize, userVariant): number
	if userVariant ~= 1 and userVariant ~= 2 or catalogSize <= 2 then
		return 0
	end

	if catalogSize <= 5 then
		return 1
	end

	if catalogSize <= 7 then
		if userVariant == 1 then
			return 1
		end

		return 2
	elseif catalogSize <= 9 then
		if userVariant == 1 or catalogSize <= 8 then
			return 2
		end

		return 3
	elseif catalogSize <= 20 then
		if userVariant == 1 then
			return 2
		end

		return 4
	elseif catalogSize <= 50 then
		if userVariant == 1 then
			return 3
		end

		return 5
	elseif catalogSize <= 100 then
		if userVariant == 1 then
			return 4
		end

		return 7
	elseif userVariant == 1 then
		return 7
	else
		return 12
	end
end

local function createItemBadge(p2, props)
	local v6

	if FFlagPopularFillIconEnabled and props.isPopularItem then
		v6 = Roact.createElement(imageSetLabel, {
			Size = udim,
			BackgroundTransparency = 1,
			Image = v5,
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			LayoutOrder = 1
		})
	end

	local v7 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		}),
		TextLabel = Roact.createElement("TextLabel", {
			Text = props.badgeText,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 34, 0, 12),
			AutomaticSize = Enum.AutomaticSize.X,
			TextColor3 = Color3.fromRGB(25, 27, 29),
			Font = Enum.Font.BuilderSansBold,
			TextSize = 12,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2)
		}),
		UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(1, 8) }),
		UIStroke = Roact.createElement("UIStroke", {
			Color = Color3.fromRGB(206, 183, 115),
			Thickness = 1
		})
	}

	if v6 then
		v7.PopularIcon = v6
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 44, 0, 20),
		BackgroundColor3 = Color3.fromRGB(239, 215, 109),
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 3,
		AnchorPoint = Vector2.new(0, 1)
	}, v7)
end

local function createItemIconComponent(itemIcon, p2, p3, theme, props)
	local v6 = {
		ItemImage = Roact.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, p2, 0, p3),
			ScaleType = Enum.ScaleType.Stretch,
			Image = itemIcon,
			ImageTransparency = itemIcon == iconsstatusimageunavailable and theme.UIDefault.Transparency or 0,
			ImageColor3 = itemIcon == iconsstatusimageunavailable and theme.UIDefault.Color or Color3.new(1, 1, 1)
		})
	}

	return Roact.createElement(fitFrameVertical, {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		LayoutOrder = 1
	}, v6)
end

local function createItemDetailsComponent(props, x, theme, font)
	local v6 = {
		ItemName = Roact.createElement(fitTextLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			width = fitTextLabel.Width.FitToText,
			maximumWidth = x * 0.55,
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
				maximumWidth = x,
				Font = font.Header2.Font,
				Text = tostring(props.itemRobuxCost),
				TextSize = font.BaseSize * font.Header2.RelativeSize,
				TextColor3 = theme.TextEmphasis.Color
			})
		})
	}

	if
		props.userVariant
		and props.catalogSize
		and props.salesRank
		and getPopularityThreshold(props.catalogSize, props.userVariant) >= props.salesRank
	then
		v6.ItemBadge = createItemBadge(font, props)
	end

	return Roact.createElement(fitFrameVertical, {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		width = UDim.new(0.45, 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		contentPadding = UDim.new(0, 5)
	}, v6)
end

function extended.render(data)
	local props = data.props

	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local v6 = Constants.NORMAL_ICON_SIZE

		if props.model == nil and props.itemIcon == nil then
			v6 = iconSize.Large
		end

		local v7 = if getEnableCondenseRobuxUpsell() then props.itemIconWidth or v6 else v6

		v6 = getEnableCondenseRobuxUpsell() and props.itemIconHeight or v6
		local v8

		if props.model == nil then
			local itemIcon = props.itemIcon or iconsstatusimageunavailable
			v8 = createItemIconComponent(itemIcon, v7, v6, theme, props)
		else
			v8 = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(v7, v6)
			})
		end

		local itemDetailsComponent = createItemDetailsComponent(
			props,
			data.state.contentSize.X,
			theme,
			font
		)

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
			}, { ItemIcon = v8 }),
			ItemDetailsFrame = itemDetailsComponent
		})
	end)
end

return extended
