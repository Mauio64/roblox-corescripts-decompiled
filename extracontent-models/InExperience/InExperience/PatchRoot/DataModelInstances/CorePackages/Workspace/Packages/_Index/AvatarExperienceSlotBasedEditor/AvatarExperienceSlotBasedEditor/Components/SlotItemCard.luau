local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local AXCommon = require(parent.AXCommon)
local AXTooltip = AXCommon.Components.AXTooltip
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCard = AvatarExperienceUIKit.ItemCardComponents.ItemCard
local ItemCardHeader = AvatarExperienceUIKit.ItemCardComponents.ItemCardHeader
local SlotItemCardFooter = require(script.Parent.SlotItemCardFooter)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ReactOtter = require(parent.ReactOtter)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSlotBasedEditorCategoryTooltip = AvatarExperienceFlags.FFlagAXSlotBasedEditorCategoryTooltip

local defineFastString = game:DefineFastString("AXSlotBasedEditorCategoryTooltipKey", "SlotEditorSecondCategory")

local v = { dampingRatio = 1, frequency = 1 }

return (React.forwardRef(function(props, ref)
	local v2 = useTokens()
	local backgroundTransparency, v3 = ReactOtter.useAnimatedBinding(1)
	local state, setState = React.useState(false)

	local onStateChanged = React.useCallback(function(p)
		if p == Foundation.Enums.ControlState.Default then
			setState(false)
		elseif p == Foundation.Enums.ControlState.Hover then
			setState(true)
		end
	end, {})

	React.useEffect(function()
		local v4 = not state and 1 or v2.Color.Stroke.Emphasis.Transparency
		v3(ReactOtter.spring(v4, v))
	end, { state })
	local ref2, onActivated

	if FFlagAXSlotBasedEditorCategoryTooltip then
		ref2 = React.createRef()

		onActivated = React.useCallback(function()
			if ref2.current then
				ref2.current()
			end

			if props.onActivated then
				props.onActivated()
			end
		end, { props.onActivated })
	else
		ref2 = nil
	end

	local createElement = React.createElement
	local children = {
		Size = props.Size or UDim2.fromOffset(v2.Size.Size_2500, 0),
		LayoutOrder = props.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		onActivated = 0,
		ref = 0,
		headerSlot = 0,
		footerSlot = 0
	}
	local onActivated2

	if FFlagAXSlotBasedEditorCategoryTooltip then
		onActivated2 = onActivated
	else
		onActivated2 = props.onActivated
	end

	children.onActivated = onActivated2
	children.ref = ref
	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v4 = {
		onStateChanged = onStateChanged,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		onActivated = 0,
		Size = 0,
		backgroundStyle = 0,
		selection = 0,
		padding = 0
	}

	if not FFlagAXSlotBasedEditorCategoryTooltip then
		onActivated = props.onActivated
	end

	v4.onActivated = onActivated

	v4.Size = UDim2.fromScale(1, 1)
	v4.backgroundStyle = { Transparency = 1 }

	v4.selection = { Selectable = false }

	v4.padding = {
		top = UDim.new(0, v2.Padding.XXSmall),
		bottom = UDim.new(0, v2.Padding.XXSmall),
		left = UDim.new(0, v2.Padding.XXSmall),
		right = UDim.new(0, v2.Padding.XXSmall)
	}

	local v5 = {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v2.Radius.Medium)
		}),
		HeaderSlot = props.renderHeaderSlot(),
		HoverFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
				BackgroundTransparency = backgroundTransparency
			},
			{
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v2.Radius.Medium)
				})
			}
		),
		BorderFrame = 0,
		AXTooltip = 0
	}

	local createElement4 = React.createElement
	local v6 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v2.Color.Surface.Surface_200.Color3,
		BackgroundTransparency = props.BackgroundTransparency or 0
	}
	local v7 = {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v2.Radius.Medium)
		}),
		Stroke = 0
	}

	local createElement5 = React.createElement
	local v8 = { Color = v2.Color.Stroke.Default.Color3, Transparency = 0, Thickness = 0 }
	local transparency

	if props.isActive then
		transparency = v2.Color.Selection.End.Transparency
	else
		transparency = v2.Color.State.Press.Transparency
	end

	v8.Transparency = transparency

	v8.Thickness = v2.Stroke.Thick
	v7.Stroke = createElement5("UIStroke", v8)
	v5.BorderFrame = createElement4("Frame", v6, v7)

	v5.AXTooltip = FFlagAXSlotBasedEditorCategoryTooltip and React.createElement(AXTooltip, {
		popoverSide = "Top",
		tooltipLocalizationKey = "Feature.Avatar.Tooltip.CustomizeOverhaulSubcategories",
		tooltipStorageKey = defineFastString,
		dismissTooltipRef = ref2,
		showTooltip = props.showSecondCategoryTooltip
	})
	children.headerSlot = createElement2(
		ItemCardHeader,
		{ LayoutOrder = 1, BackgroundTransparency = 1 },
		createElement3(View, v4, v5)
	)

	children.footerSlot = React.createElement(SlotItemCardFooter, {
		LayoutOrder = 2,
		title = props.title,
		TextXAlignment = Enum.TextXAlignment.Center
	})
	return createElement(ItemCard, children)
end))
