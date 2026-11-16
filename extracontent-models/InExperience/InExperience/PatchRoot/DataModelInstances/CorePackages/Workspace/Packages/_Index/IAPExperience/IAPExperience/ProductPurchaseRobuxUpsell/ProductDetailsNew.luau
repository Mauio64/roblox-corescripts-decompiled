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

local FFlagPopularFillIconEnabled = require(parent.Flags.FFlagPopularFillIconEnabled)
local GetFStringPopularFillIconLocation = require(parent.Flags.GetFStringPopularFillIconLocation)
local image

if FFlagPopularFillIconEnabled then
	image = Images[GetFStringPopularFillIconLocation()]
else
	image = nil
end

local udim

if FFlagPopularFillIconEnabled then
	udim = UDim2.new(0, 16, 0, 16)
else
	udim = UDim2.new(0, 0, 0, 0)
end

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

local function getPopularityThreshold(catalogSize: number, userVariant: number): number
	if userVariant ~= 1 and userVariant ~= 2 or catalogSize <= 2 then
		return 0
	end

	if catalogSize <= 5 then
		return 1
	end

	if catalogSize <= 7 then
		return if userVariant == 1 then 1 else 2
	elseif catalogSize <= 9 then
		return if userVariant == 1 or catalogSize <= 8 then 2 else 3
	elseif catalogSize <= 20 then
		return if userVariant == 1 then 2 else 4
	elseif catalogSize <= 50 then
		return if userVariant == 1 then 3 else 5
	elseif catalogSize <= 100 then
		return if userVariant == 1 then 4 else 7
	else
		return if userVariant == 1 then 7 else 12
	end
end

local function createItemBadge(_, props)
	local popularIcon

	if FFlagPopularFillIconEnabled and props.isPopularItem then
		popularIcon = Roact.createElement(ImageSetLabel, {
			Size = udim,
			BackgroundTransparency = 1,
			Image = image,
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			LayoutOrder = 1
		})
	end

	local v = {
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

	if popularIcon then
		v.PopularIcon = popularIcon
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 44, 0, 20),
		BackgroundColor3 = Color3.fromRGB(239, 215, 109),
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 3,
		AnchorPoint = Vector2.new(0, 1)
	}, v)
end

local function createItemIconComponent(itemIcon, p, p2, theme, _)
	local v = {
		ItemImage = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, p, 0, p2),
			ScaleType = Enum.ScaleType.Stretch,
			Image = itemIcon,
			ImageTransparency = itemIcon == iconsstatusimageunavailable and theme.UIDefault.Transparency or 0,
			ImageColor3 = itemIcon == iconsstatusimageunavailable and theme.UIDefault.Color or Color3.new(1, 1, 1)
		})
	}

	return Roact.createElement(FitFrameVertical, {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		LayoutOrder = 1
	}, v)
end

local function createItemDetailsComponent(props, x: number, theme, font)
	local v = {
		ItemName = Roact.createElement(FitTextLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			width = FitTextLabel.Width.FitToText,
			maximumWidth = x * 0.55,
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
		v.ItemBadge = createItemBadge(font, props)
	end

	return Roact.createElement(FitFrameVertical, {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		width = UDim.new(0.45, 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		contentPadding = UDim.new(0, 5)
	}, v)
end

function extended.render(data)
	local props = data.props

	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font

		local v = Constants.NORMAL_ICON_SIZE

		if props.model == nil and props.itemIcon == nil then
			v = IconSize.Large
		end

		local v2

		if getEnableCondenseRobuxUpsell() then
			v2 = props.itemIconWidth or v
		else
			v2 = v
		end

		v = getEnableCondenseRobuxUpsell() and props.itemIconHeight or v
		local itemIcon

		if props.model == nil then
			itemIcon = createItemIconComponent(props.itemIcon or iconsstatusimageunavailable, v2, v, theme, props)
		else
			itemIcon = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(v2, v)
			})
		end

		local itemDetailsComponent = createItemDetailsComponent(props, data.state.contentSize.X, theme, font)

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
			ItemDetailsFrame = itemDetailsComponent
		})
	end)
end

return extended
