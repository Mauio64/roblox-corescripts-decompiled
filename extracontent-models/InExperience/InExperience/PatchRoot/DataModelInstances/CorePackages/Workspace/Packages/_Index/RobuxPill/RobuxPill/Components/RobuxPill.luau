local robuxPill = script:FindFirstAncestor("RobuxPill")
local parent = robuxPill.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Icon = Foundation.Icon
local Button = Foundation.Button
local Skeleton = Foundation.Skeleton
local FillBehavior = Foundation.Enums.FillBehavior
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local Radius = Foundation.Enums.Radius

local FFlagRobuxPillSingleFocusTarget = require(robuxPill.Flags.FFlagRobuxPillSingleFocusTarget)

local function numWithCommas(robuxBalance: number) -- 1 equivalent call inferred from this helper
	return tostring(robuxBalance):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function RobuxPill(props, ref)
	local v = useTokens()
	local v2 = props.showBorder == nil or props.showBorder
	local selectable

	if FFlagRobuxPillSingleFocusTarget then
		selectable = false
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v3 = {
		tag = {
			["size-full-1400 padding-medium"] = props.isCompact == true,
			["size-full-0 auto-y"] = props.isCompact ~= true,
			["padding-xlarge"] = not props.isCompact and v2,
			["padding-x-medium padding-y-xlarge"] = not (props.isCompact or v2)
		},
		onActivated = props.onBuyActivated,
		LayoutOrder = props.layoutOrder,
		ref = ref,
		testId = "robux-pill",
		stroke = v2 and {
			Color = v.Color.Stroke.Default.Color3,
			Transparency = v.Color.Stroke.Default.Transparency,
			Thickness = v.Stroke.Standard
		} or nil,
		cornerRadius = 0
	}
	local cornerRadius

	if v2 then
		cornerRadius = UDim.new(0, v.Radius.Medium)
	end

	v3.cornerRadius = cornerRadius

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v4 = {
		tag = {
			["row align-y-center position-center-left anchor-center-left auto-xy"] = true,
			["gap-medium"] = props.isCompact == true,
			["gap-small"] = props.isCompact ~= true
		},
		testId = "robux-container"
	}

	local createElement3 = React.createElement
	local v5 = { name = IconName.Robux, size = 0, LayoutOrder = 1, testId = "robux-icon" }
	local size

	if props.isCompact then
		size = IconSize.Large
	else
		size = IconSize.Medium
	end

	v5.size = size
	local v7 = { RobuxIcon = createElement3(Icon, v5), RobuxAmount = 0 }
	local robuxAmount

	if props.robuxBalance == nil then
		robuxAmount = React.createElement(Foundation.View, {
			tag = "size-2500-800",
			LayoutOrder = 2
		}, {
			Skeleton = React.createElement(Skeleton, {
				radius = Radius.Medium,
				testId = "robux-balance-skeleton"
			})
		})
	else
		robuxAmount = React.createElement(Text, {
			Size = UDim2.new(0.5, 0, 0, 0),
			tag = {
				["auto-y text-align-x-left text-truncate-end content-emphasis"] = true,
				["text-heading-small"] = props.isCompact == true,
				["text-title-large"] = props.isCompact ~= true
			},
			Text = numWithCommas(props.robuxBalance), -- inferred equivalent call
			LayoutOrder = 2
		})
	end

	v7.RobuxAmount = robuxAmount
	local v6 = { RobuxContainer = createElement2(view2, v4, v7), BuyRobuxButton = 0 }
	local buyRobuxButton

	if props.isCompact then
		buyRobuxButton = React.createElement(Foundation.View, {
			Position = UDim2.new(1, 0, 0.5, 0),
			tag = "anchor-center-right auto-xy",
			sizeConstraint = { MinSize = Vector2.new(84, 0) },
			testId = "buy-robux-button-container"
		}, {
			Button = React.createElement(Button, {
				text = props.buyButtonText,
				size = InputSize.Small,
				Selectable = selectable,
				onActivated = props.onBuyActivated,
				fillBehavior = FillBehavior.Fill
			})
		})
	else
		buyRobuxButton = React.createElement(Button, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			text = props.buyButtonText,
			size = InputSize.Small,
			Selectable = selectable,
			onActivated = props.onBuyActivated
		})
	end

	v6.BuyRobuxButton = buyRobuxButton
	return createElement(view, v3, v6)
end

return React.memo(React.forwardRef(RobuxPill))
