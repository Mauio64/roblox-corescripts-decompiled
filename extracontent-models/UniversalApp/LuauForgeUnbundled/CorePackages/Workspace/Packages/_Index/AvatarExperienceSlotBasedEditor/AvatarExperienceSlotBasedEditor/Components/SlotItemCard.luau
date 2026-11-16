local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local axTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceCommon").Components.AXTooltip
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceUIKit")
local itemCard = AvatarExperienceUIKit.ItemCardComponents.ItemCard
local itemCardHeader = AvatarExperienceUIKit.ItemCardComponents.ItemCardHeader
local SlotItemCardFooter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/SlotItemCardFooter")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/ReactOtter")

local fFlagAXSlotBasedEditorCategoryTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXSlotBasedEditorCategoryTooltip

local defineFastString = game:DefineFastString(
	"AXSlotBasedEditorCategoryTooltipKey",
	"SlotEditorSecondCategory"
)

local v5 = { dampingRatio = 1, frequency = 1 }

return (React.forwardRef(function(props, ref)
	local v6 = useTokens()
	local v7, v8 = ReactOtter.useAnimatedBinding(1)
	local state, setState = React.useState(false)

	local v9 = React.useCallback(function(p2)
		if p2 == Foundation.Enums.ControlState.Default then
			setState(false)
		elseif p2 == Foundation.Enums.ControlState.Hover then
			setState(true)
		end
	end, {})

	React.useEffect(function()
		local v10 = not state and 1 or v6.Color.Stroke.Emphasis.Transparency
		v8(ReactOtter.spring(v10, v5))
	end, { state })
	local ref2, v10

	if fFlagAXSlotBasedEditorCategoryTooltip then
		ref2 = React.createRef()

		v10 = React.useCallback(function()
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
		Size = props.Size or UDim2.fromOffset(v6.Size.Size_2500, 0),
		LayoutOrder = props.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		onActivated = 0,
		ref = 0,
		headerSlot = 0,
		footerSlot = 0
	}
	local v12 = if fFlagAXSlotBasedEditorCategoryTooltip then v10 else props.onActivated
	children.onActivated = v12
	children.ref = ref
	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v16 = {
		onStateChanged = v9,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		onActivated = 0,
		Size = 0,
		backgroundStyle = 0,
		selection = 0,
		padding = 0
	}

	if not fFlagAXSlotBasedEditorCategoryTooltip then
		v10 = props.onActivated
	end

	v16.onActivated = v10

	v16.Size = UDim2.fromScale(1, 1)
	v16.backgroundStyle = { Transparency = 1 }

	v16.selection = { Selectable = false }

	v16.padding = {
		top = UDim.new(0, v6.Padding.XXSmall),
		bottom = UDim.new(0, v6.Padding.XXSmall),
		left = UDim.new(0, v6.Padding.XXSmall),
		right = UDim.new(0, v6.Padding.XXSmall)
	}

	local v17 = {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v6.Radius.Medium)
		}),
		HeaderSlot = props.renderHeaderSlot(),
		HoverFrame = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), ZIndex = 2, BackgroundTransparency = v7 },
			{
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v6.Radius.Medium)
				})
			}
		),
		BorderFrame = 0,
		AXTooltip = 0
	}

	local createElement4 = React.createElement
	local v19 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v6.Color.Surface.Surface_200.Color3,
		BackgroundTransparency = props.BackgroundTransparency or 0
	}
	local v20 = {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v6.Radius.Medium)
		}),
		Stroke = 0
	}

	local createElement5 = React.createElement
	local v22 = {
		Color = v6.Color.Stroke.Default.Color3,
		Transparency = 0,
		Thickness = 0
	}
	local v23 = if props.isActive then v6.Color.Selection.End.Transparency else v6.Color.State.Press.Transparency
	v22.Transparency = v23

	v22.Thickness = v6.Stroke.Thick
	v20.Stroke = createElement5("UIStroke", v22)
	v17.BorderFrame = createElement4("Frame", v19, v20)

	v17.AXTooltip = fFlagAXSlotBasedEditorCategoryTooltip and React.createElement(axTooltip, {
		popoverSide = "Top",
		tooltipLocalizationKey = "Feature.Avatar.Tooltip.CustomizeOverhaulSubcategories",
		tooltipStorageKey = defineFastString,
		dismissTooltipRef = ref2,
		showTooltip = props.showSecondCategoryTooltip
	})
	children.headerSlot = createElement2(
		itemCardHeader,
		{ LayoutOrder = 1, BackgroundTransparency = 1 },
		createElement3(view, v16, v17)
	)

	children.footerSlot = React.createElement(SlotItemCardFooter, {
		LayoutOrder = 2,
		title = props.title,
		TextXAlignment = Enum.TextXAlignment.Center
	})
	return createElement(itemCard, children)
end))
