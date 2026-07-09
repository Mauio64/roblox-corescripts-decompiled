local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local AXTooltip = require(Parent.AXCommon).Components.AXTooltip
local AvatarExperienceUIKit = require(Parent.AvatarExperienceUIKit)
local ItemCard = AvatarExperienceUIKit.ItemCardComponents.ItemCard
local ItemCardHeader = AvatarExperienceUIKit.ItemCardComponents.ItemCardHeader
local SlotItemCardFooter = require(script.Parent.SlotItemCardFooter)
local Foundation = require(Parent.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local ReactOtter = require(Parent.ReactOtter)
local FFlagAXSlotBasedEditorCategoryTooltip = require(Parent.AvatarExperienceFlags).FFlagAXSlotBasedEditorCategoryTooltip
local v14 = game:DefineFastString("AXSlotBasedEditorCategoryTooltipKey", "SlotEditorSecondCategory")
local t1 = {
	dampingRatio = 1,
	frequency = 1
}

return (React.forwardRef(function(t2: {[any]: any}, p1) -- line: 48
	-- upvalues: useTokens (copy), ReactOtter (copy), React (copy), Foundation (copy), t1 (copy), FFlagAXSlotBasedEditorCategoryTooltip (copy), ItemCard (copy), ItemCardHeader (copy), View (copy), FFlagRenameDeprecatedUIBloxTokens (copy), AXTooltip (copy), v14 (copy), SlotItemCardFooter (copy)
	local v18 = useTokens()
	local v19, v20 = ReactOtter.useAnimatedBinding(1)
	local v21, v22 = React.useState(false)
	local v23 = React.useCallback(function(p2) -- line: 54
		-- upvalues: Foundation (copy), v22 (copy)
		if p2 == Foundation.Enums.ControlState.Default then
			v22(false)

			return
		end

		if p2 == Foundation.Enums.ControlState.Hover then
			v22(true)
		end
	end, {})

	React.useEffect(function() -- line: 64
		-- upvalues: v21 (copy), v18 (copy), v20 (copy), ReactOtter (copy), t1 (copy)
		local v27 = not v21 and 1 or v18.Color.Stroke.Emphasis.Transparency

		v20(ReactOtter.spring(v27, t1))
	end, { v21 })

	local u24 = nil
	local v25 = nil

	if FFlagAXSlotBasedEditorCategoryTooltip then
		u24 = React.createRef()
		v25 = React.useCallback(function() -- line: 73
			-- upvalues: u24 (ref), t2 (copy)
			if u24.current then
				u24.current()
			end

			if t2.onActivated then
				t2.onActivated()
			end
		end, { t2.onActivated })
	end

	return React.createElement(ItemCard, {
		Size = t2.Size or UDim2.fromOffset(v18.Size.Size_2500, 0),
		LayoutOrder = t2.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		onActivated = if not FFlagAXSlotBasedEditorCategoryTooltip then t2.onActivated else v25,
		ref = p1,
		headerSlot = React.createElement(ItemCardHeader, {
			LayoutOrder = 1,
			BackgroundTransparency = 1
		}, React.createElement(View, {
			onStateChanged = v23,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			onActivated = if not FFlagAXSlotBasedEditorCategoryTooltip then t2.onActivated else v25,
			Size = UDim2.fromScale(1, 1),
			backgroundStyle = {
				Transparency = 1
			},
			selection = {
				Selectable = false
			},
			padding = {
				top = UDim.new(0, v18.Padding.XXSmall),
				bottom = UDim.new(0, v18.Padding.XXSmall),
				left = UDim.new(0, v18.Padding.XXSmall),
				right = UDim.new(0, v18.Padding.XXSmall)
			}
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v18.Semantic.Radius.Medium else v18.Radius.Medium)
			}),
			HeaderSlot = t2.renderHeaderSlot(),
			HoverFrame = React.createElement("Frame", {
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = v19
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v18.Semantic.Radius.Medium else v18.Radius.Medium)
				})
			}),
			BorderFrame = React.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v18.Color.Surface.Surface_200.Color3,
				BackgroundTransparency = t2.BackgroundTransparency or 0
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v18.Semantic.Radius.Medium else v18.Radius.Medium)
				}),
				Stroke = React.createElement("UIStroke", {
					Color = v18.Color.Stroke.Default.Color3,
					Transparency = if not t2.isActive then v18.Color.State.Press.Transparency else v18.Color.Selection.End.Transparency,
					Thickness = v18.Stroke.Thick
				})
			}),
			AXTooltip = FFlagAXSlotBasedEditorCategoryTooltip and React.createElement(AXTooltip, {
				popoverSide = "Top",
				tooltipLocalizationKey = "Feature.Avatar.Tooltip.CustomizeOverhaulSubcategories",
				tooltipStorageKey = v14,
				dismissTooltipRef = u24,
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
