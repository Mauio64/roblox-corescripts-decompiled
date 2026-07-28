local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local AXTooltip = require(Parent.AXCommon).Components.AXTooltip
local AvatarExperienceUIKit = require(Parent.AvatarExperienceUIKit)
local ItemCard = AvatarExperienceUIKit.ItemCardComponents.ItemCard
local ItemCardHeader = AvatarExperienceUIKit.ItemCardComponents.ItemCardHeader
local SlotItemCardFooter = require(script.Parent.SlotItemCardFooter)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ReactOtter = require(Parent.ReactOtter)
local FFlagAXSlotBasedEditorCategoryTooltip = require(Parent.AvatarExperienceFlags).FFlagAXSlotBasedEditorCategoryTooltip
local v13 = game:DefineFastString("AXSlotBasedEditorCategoryTooltipKey", "SlotEditorSecondCategory")
local t1 = {
	dampingRatio = 1,
	frequency = 1
}

return (React.forwardRef(function(t2: {[any]: any}, p1) -- line: 46
	-- upvalues: useTokens (copy), ReactOtter (copy), React (copy), Foundation (copy), t1 (copy), FFlagAXSlotBasedEditorCategoryTooltip (copy), ItemCard (copy), ItemCardHeader (copy), View (copy), AXTooltip (copy), v13 (copy), SlotItemCardFooter (copy)
	local v17 = useTokens()
	local v18, v19 = ReactOtter.useAnimatedBinding(1)
	local v20, v21 = React.useState(false)
	local v22 = React.useCallback(function(p2) -- line: 52
		-- upvalues: Foundation (copy), v21 (copy)
		if p2 == Foundation.Enums.ControlState.Default then
			v21(false)

			return
		end

		if p2 == Foundation.Enums.ControlState.Hover then
			v21(true)
		end
	end, {})

	React.useEffect(function() -- line: 62
		-- upvalues: v20 (copy), v17 (copy), v19 (copy), ReactOtter (copy), t1 (copy)
		local v26 = not v20 and 1 or v17.Color.Stroke.Emphasis.Transparency

		v19(ReactOtter.spring(v26, t1))
	end, { v20 })

	local u23 = nil
	local v24 = nil

	if FFlagAXSlotBasedEditorCategoryTooltip then
		u23 = React.createRef()
		v24 = React.useCallback(function() -- line: 71
			-- upvalues: u23 (ref), t2 (copy)
			if u23.current then
				u23.current()
			end

			if t2.onActivated then
				t2.onActivated()
			end
		end, { t2.onActivated })
	end

	return React.createElement(ItemCard, {
		Size = t2.Size or UDim2.fromOffset(v17.Size.Size_2500, 0),
		LayoutOrder = t2.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		onActivated = if not FFlagAXSlotBasedEditorCategoryTooltip then t2.onActivated else v24,
		ref = p1,
		headerSlot = React.createElement(ItemCardHeader, {
			LayoutOrder = 1,
			BackgroundTransparency = 1
		}, React.createElement(View, {
			onStateChanged = v22,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			onActivated = if not FFlagAXSlotBasedEditorCategoryTooltip then t2.onActivated else v24,
			Size = UDim2.fromScale(1, 1),
			backgroundStyle = {
				Transparency = 1
			},
			selection = {
				Selectable = false
			},
			padding = {
				top = UDim.new(0, v17.Padding.XXSmall),
				bottom = UDim.new(0, v17.Padding.XXSmall),
				left = UDim.new(0, v17.Padding.XXSmall),
				right = UDim.new(0, v17.Padding.XXSmall)
			}
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v17.Radius.Medium)
			}),
			HeaderSlot = t2.renderHeaderSlot(),
			HoverFrame = React.createElement("Frame", {
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = v18
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v17.Radius.Medium)
				})
			}),
			BorderFrame = React.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v17.Color.Surface.Surface_200.Color3,
				BackgroundTransparency = t2.BackgroundTransparency or 0
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v17.Radius.Medium)
				}),
				Stroke = React.createElement("UIStroke", {
					Color = v17.Color.Stroke.Default.Color3,
					Transparency = if not t2.isActive then v17.Color.State.Press.Transparency else v17.Color.Selection.End.Transparency,
					Thickness = v17.Stroke.Thick
				})
			}),
			AXTooltip = FFlagAXSlotBasedEditorCategoryTooltip and React.createElement(AXTooltip, {
				popoverSide = "Top",
				tooltipLocalizationKey = "Feature.Avatar.Tooltip.CustomizeOverhaulSubcategories",
				tooltipStorageKey = v13,
				dismissTooltipRef = u23,
				showTooltip = t2.showSecondCategoryTooltip
			})
		})),
		footerSlot = React.createElement(SlotItemCardFooter, {
			LayoutOrder = 2,
			title = t2.title,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	})
end))
