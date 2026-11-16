local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobuxPill/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobuxPill/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local icon = Foundation.Icon
local button = Foundation.Button
local skeleton = Foundation.Skeleton
local fillBehavior = Foundation.Enums.FillBehavior
local iconSize = Foundation.Enums.IconSize
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius

local FFlagRobuxPillSingleFocusTarget = require("@game/CorePackages/Workspace/Packages/_Index/RobuxPill/RobuxPill/Flags/FFlagRobuxPillSingleFocusTarget")

local function numWithCommas(p2)
	return tostring(p2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function RobuxPill(props, p2)
	local v5 = useTokens()
	local v6 = props.showBorder == nil or props.showBorder
	local v7 = if FFlagRobuxPillSingleFocusTarget then false else nil
	local createElement = React.createElement
	local view = Foundation.View
	local v8 = {
		tag = {
			["size-full-1400 padding-medium"] = props.isCompact == true,
			["size-full-0 auto-y"] = props.isCompact ~= true,
			["padding-xlarge"] = not props.isCompact and v6,
			["padding-x-medium padding-y-xlarge"] = not (props.isCompact or v6)
		},
		onActivated = props.onBuyActivated,
		LayoutOrder = props.layoutOrder,
		ref = p2,
		testId = "robux-pill",
		stroke = v6 and {
			Color = v5.Color.Stroke.Default.Color3,
			Transparency = v5.Color.Stroke.Default.Transparency,
			Thickness = v5.Stroke.Standard
		} or nil,
		cornerRadius = 0
	}

	local v9 = if v6 then UDim.new(0, v5.Radius.Medium) else nil
	v8.cornerRadius = v9

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v11 = {
		tag = {
			["row align-y-center position-center-left anchor-center-left auto-xy"] = true,
			["gap-medium"] = props.isCompact == true,
			["gap-small"] = props.isCompact ~= true
		},
		testId = "robux-container"
	}

	local createElement3 = React.createElement
	local v14 = {
		name = iconName.Robux,
		size = 0,
		LayoutOrder = 1,
		testId = "robux-icon"
	}

	local v15 = if props.isCompact then iconSize.Large else iconSize.Medium
	v14.size = v15
	local v12 = { RobuxIcon = createElement3(icon, v14), RobuxAmount = 0 }
	local v16 = if props.robuxBalance == nil then React.createElement(
		Foundation.View,
		{ tag = "size-2500-800", LayoutOrder = 2 },
		{
			Skeleton = React.createElement(skeleton, {
				radius = radius.Medium,
				testId = "robux-balance-skeleton"
			})
		}
	) else React.createElement(text, {
		Size = UDim2.new(0.5, 0, 0, 0),
		tag = {
			["auto-y text-align-x-left text-truncate-end content-emphasis"] = true,
			["text-heading-small"] = props.isCompact == true,
			["text-title-large"] = props.isCompact ~= true
		},
		Text = tostring(props.robuxBalance):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""),
		LayoutOrder = 2
	})
	v12.RobuxAmount = v16
	local v10 = {
		RobuxContainer = createElement2(view2, v11, v12),
		BuyRobuxButton = 0
	}
	local v17

	if props.isCompact then
		v17 = React.createElement(Foundation.View, {
			Position = UDim2.new(1, 0, 0.5, 0),
			tag = "anchor-center-right auto-xy",
			sizeConstraint = { MinSize = Vector2.new(84, 0) },
			testId = "buy-robux-button-container"
		}, {
			Button = React.createElement(button, {
				text = props.buyButtonText,
				size = inputSize.Small,
				Selectable = v7,
				onActivated = props.onBuyActivated,
				fillBehavior = fillBehavior.Fill
			})
		})
	else
		v17 = React.createElement(button, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			text = props.buyButtonText,
			size = inputSize.Small,
			Selectable = v7,
			onActivated = props.onBuyActivated
		})
	end

	v10.BuyRobuxButton = v17
	return createElement(view, v8, v10)
end

return React.memo(React.forwardRef(RobuxPill))
