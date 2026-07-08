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
local FFlagPopularFillIconEnabled = require(ParentParent.Flags.FFlagPopularFillIconEnabled)
local GetFStringPopularFillIconLocation = require(ParentParent.Flags.GetFStringPopularFillIconLocation)
local v19 = if not FFlagPopularFillIconEnabled then nil else Images[GetFStringPopularFillIconLocation()]
local v20 = if not FFlagPopularFillIconEnabled then UDim2.new(0, 0, 0, 0) else UDim2.new(0, 16, 0, 16)
local v21 = Roact.Component:extend(script.Name)

function v21.init(p1) -- line: 57
	-- upvalues: Roact (copy)
	p1.contentRef = Roact.createRef()
	p1.state = {
		contentSize = Vector2.new(0, 0)
	}

	function p1.changeContentSize(p2) -- line: 62
		-- upvalues: p1 (copy)
		if p1.state.contentSize ~= p2.AbsoluteSize then
			p1:setState({
				contentSize = p2.AbsoluteSize
			})
		end
	end
end

local function getPopularityThreshold(n1: number, n2: number) -- line: 91
	if n2 ~= 1 and n2 ~= 2 then
		return 0
	end

	if n1 <= 2 then
		return 0
	end

	if n1 <= 5 then
		return 1
	end

	if n1 <= 7 then
		if n2 == 1 then
			return 1
		end

		return 2
	end

	if n1 <= 9 then
		if n2 == 1 then
			return 2
		end

		if n1 <= 8 then
			return 2
		end

		return 3
	end

	if n1 <= 20 then
		if n2 == 1 then
			return 2
		end

		return 4
	end

	if n1 <= 50 then
		if n2 == 1 then
			return 3
		end

		return 5
	end

	if n1 <= 100 then
		if n2 == 1 then
			return 4
		end

		return 7
	end

	if n2 == 1 then
		return 7
	end

	return 12
end
local function createItemBadge(_, p4) -- line: 115
	-- upvalues: FFlagPopularFillIconEnabled (copy), Roact (copy), ImageSetLabel (copy), v20 (copy), v19 (copy)
	local v31 = nil

	if FFlagPopularFillIconEnabled and p4.isPopularItem then
		v31 = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = v20,
			Image = v19,
			ImageColor3 = Color3.fromRGB(0, 0, 0)
		})
	end

	local t1 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 1)
		}),
		TextLabel = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextSize = 12,
			LayoutOrder = 2,
			Text = p4.badgeText,
			Size = UDim2.new(0, 34, 0, 12),
			AutomaticSize = Enum.AutomaticSize.X,
			TextColor3 = Color3.fromRGB(25, 27, 29),
			Font = Enum.Font.BuilderSansBold,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2)
		}),
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(1, 8)
		}),
		UIStroke = Roact.createElement("UIStroke", {
			Thickness = 1,
			Color = Color3.fromRGB(206, 183, 115)
		})
	}

	if v31 then
		t1.PopularIcon = v31
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		LayoutOrder = 3,
		Size = UDim2.new(0, 44, 0, 20),
		BackgroundColor3 = Color3.fromRGB(239, 215, 109),
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(0, 1)
	}, t1)
end
local function createItemIconComponent(p5, p6, p7, p8, _) -- line: 177
	-- upvalues: Roact (copy), ImageSetLabel (copy), v16 (copy), FitFrameVertical (copy)
	local t2 = {
		ItemImage = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, p6, 0, p7),
			ScaleType = Enum.ScaleType.Stretch,
			Image = p5,
			ImageTransparency = p5 == v16 and p8.UIDefault.Transparency or 0,
			ImageColor3 = p5 == v16 and p8.UIDefault.Color or Color3.new(1, 1, 1)
		})
	}

	return Roact.createElement(FitFrameVertical, {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		width = UDim.new(1, 0),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top
	}, t2)
end
local function createItemDetailsComponent(t3: {[any]: any}, n3: number, p10, p11) -- line: 198
	-- upvalues: Roact (copy), FitTextLabel (copy), FitFrameVertical (copy), ImageSetLabel (copy), v15 (copy), getPopularityThreshold (copy), createItemBadge (copy)
	local t4 = {
		ItemName = Roact.createElement(FitTextLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			TextWrapped = true,
			width = FitTextLabel.Width.FitToText,
			maximumWidth = n3 * 0.55,
			Font = p11.Header2.Font,
			Text = t3.itemName,
			TextSize = p11.BaseSize * p11.Header2.RelativeSize,
			TextColor3 = p10.TextEmphasis.Color,
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
				Image = v15,
				ImageColor3 = p10.IconEmphasis.Color,
				ImageTransparency = p10.IconEmphasis.Transparency
			}),
			ItemCost = Roact.createElement(FitTextLabel, {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = true,
				width = FitTextLabel.Width.FitToText,
				maximumWidth = n3,
				Font = p11.Header2.Font,
				Text = tostring(t3.itemRobuxCost),
				TextSize = p11.BaseSize * p11.Header2.RelativeSize,
				TextColor3 = p10.TextEmphasis.Color
			})
		})
	}

	if t3.userVariant and t3.catalogSize and t3.salesRank and getPopularityThreshold(t3.catalogSize, t3.userVariant) >= t3.salesRank then
		t4.ItemBadge = createItemBadge(p11, t3)
	end

	return Roact.createElement(FitFrameVertical, {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		width = UDim.new(0.45, 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		contentPadding = UDim.new(0, 5)
	}, t4)
end

function v21.render(p12) -- line: 262
	-- upvalues: withStyle (copy), Constants (copy), IconSize (copy), getEnableCondenseRobuxUpsell (copy), Roact (copy), ModelViewport (copy), v16 (copy), createItemIconComponent (copy), createItemDetailsComponent (copy), FitFrameVertical (copy)
	local props = p12.props

	return withStyle(function(p13) -- line: 265
		-- upvalues: Constants (copy), props (copy), IconSize (copy), getEnableCondenseRobuxUpsell (copy), Roact (copy), ModelViewport (copy), v16 (copy), createItemIconComponent (copy), createItemDetailsComponent (copy), p12 (copy), FitFrameVertical (copy)
		local Theme = p13.Theme
		local p13Font = p13.Font
		local NORMAL_ICON_SIZE = Constants.NORMAL_ICON_SIZE

		if props.model == nil and props.itemIcon == nil then
			NORMAL_ICON_SIZE = IconSize.Large
		end

		local v51 = if not getEnableCondenseRobuxUpsell() then NORMAL_ICON_SIZE else props.itemIconWidth or NORMAL_ICON_SIZE
		local v52 = if not getEnableCondenseRobuxUpsell() then NORMAL_ICON_SIZE else props.itemIconHeight or NORMAL_ICON_SIZE
		local v53

		if props.model ~= nil then
			v53 = Roact.createElement(ModelViewport, {
				model = props.model,
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.fromOffset(v51, v52)
			})
		else
			local v54 = props.itemIcon or v16

			v53 = createItemIconComponent(v54, v51, v52, Theme, props)
		end

		local v55 = createItemDetailsComponent(props, p12.state.contentSize.X, Theme, p13Font)

		return Roact.createElement(FitFrameVertical, {
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			contentPadding = UDim.new(0, 6),
			[Roact.Ref] = p12.contentRef,
			[Roact.Change.AbsoluteSize] = p12.changeContentSize
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
				ItemIcon = v53
			}),
			ItemDetailsFrame = v55
		})
	end)
end

return v21
