local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local SlotItemCard = AvatarExperienceSlotBasedEditor.Components.SlotItemCard
local ScrollingArrowsAndGradient = require(Modules.AvatarExperience.SlotBasedEditor.Components.ScrollingArrowsAndGradient)
local useTokens = Foundation.Hooks.useTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local ItemCard = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCard
local SlotItemCardFooter = AvatarExperienceSlotBasedEditor.Components.SlotItemCardFooter
local SlotType = AvatarExperienceSlotBasedEditor.Enums.SlotType
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXSlotBasedEditorCategoryTooltip = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotBasedEditorCategoryTooltip
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local v18 = FFlagAXCustomizeMakeupSupport and function(t1: {[any]: any}, n1: number, p1) -- line: 80
	-- upvalues: React (copy), ItemCard (copy), Foundation (copy), SlotItemCardFooter (copy)
	return React.createElement(ItemCard, {
		Size = UDim2.fromOffset(1, if not t1.Size then p1.Size.Size_2500 else t1.Size.Y.Offset),
		LayoutOrder = n1,
		headerSlot = React.createElement(Foundation.Divider, {
			orientation = Foundation.Enums.Orientation.Vertical
		}),
		footerSlot = React.createElement(SlotItemCardFooter, {
			title = nil,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	})
end or nil

return function(t2: {[any]: any}) -- line: 102
	-- upvalues: useTokens (copy), FFlagAXRootSlotBasedEditorFlag (copy), useSelector (copy), React (copy), Signal (copy), FFlagAXCustomizeMakeupSupport (copy), SlotType (copy), v18 (copy), SlotItemCard (copy), FFlagAXSlotBasedEditorCategoryTooltip (copy), Foundation (copy), ScrollingArrowsAndGradient (copy)
	local v25 = useTokens()
	local u26 = nil

	if FFlagAXRootSlotBasedEditorFlag then
		local v27 = useSelector(function(p2) -- line: 107
			return p2.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
		end)

		u26 = React.useMemo(function() -- line: 111
			-- upvalues: Signal (copy)
			return Signal.new()
		end, {})
		React.useEffect(function() -- line: 115
			-- upvalues: u26 (ref)
			if u26 then
				u26:fire()
			end
		end, {
			v27,
			u26
		})
	end

	local v28 = React.useCallback(function(p3) -- line: 123
		-- upvalues: FFlagAXCustomizeMakeupSupport (copy), t2 (copy), SlotType (copy), v18 (copy), v25 (copy), React (copy), SlotItemCard (copy), FFlagAXSlotBasedEditorCategoryTooltip (copy), Foundation (copy)
		local t3 = {}
		local getScrollingFrameItemRef = p3.getScrollingFrameItemRef
		local v33 = not FFlagAXCustomizeMakeupSupport and nil
		local v34 = if not FFlagAXCustomizeMakeupSupport then nil else 0

		for v35, v36 in t2.slots do
			if not FFlagAXCustomizeMakeupSupport or not v36.hide then
				if FFlagAXCustomizeMakeupSupport then
					v34 += 1

					if v36.slotType == SlotType.LayeredSlot and v33 and t2.slots[v35 - 1].slotType ~= SlotType.LayeredSlot then
						table.insert(t3, v18(v36, v34, v25))
						v34 += 1
					end

					v33 = true
				end

				table.insert(t3, (React.createElement(SlotItemCard, {
					Size = v36.Size,
					renderHeaderSlot = v36.renderHeaderSlot,
					BackgroundTransparency = v36.BackgroundTransparency,
					onActivated = v36.onActivated,
					title = v36.title,
					LayoutOrder = if not FFlagAXCustomizeMakeupSupport then v35 else v34,
					ref = getScrollingFrameItemRef(v35 .. "_" .. t2.slotCategory),
					isActive = v36.isActive,
					showSecondCategoryTooltip = if not FFlagAXSlotBasedEditorCategoryTooltip then nil else not not t2.canShowTooltip and (v35 == 2 or false)
				})))

				if FFlagAXCustomizeMakeupSupport and v36.slotType == SlotType.LayeredSlot and v35 < #t2.slots and t2.slots[v35 + 1].slotType ~= SlotType.LayeredSlot then
					v34 += 1
					table.insert(t3, v18(v36, v34, v25))
				end
			end
		end

		if t2.clearAllButton then
			table.insert(t3, (React.createElement(SlotItemCard, {
				BackgroundTransparency = 1,
				renderHeaderSlot = t2.clearAllButton.renderHeaderSlot,
				onActivated = t2.clearAllButton.onActivated,
				LayoutOrder = if not FFlagAXCustomizeMakeupSupport then #t2.slots + 1 else v34 + 1,
				ref = getScrollingFrameItemRef(#t2.slots + 1),
				Size = t2.clearAllButton.Size,
				title = t2.clearAllButton.text
			})))
		end

		table.insert(t3, { React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, v25.Padding.Large),
			PaddingTop = UDim.new(0, v25.Padding.Medium),
			PaddingBottom = UDim.new(0, v25.Padding.Medium),
			PaddingLeft = UDim.new(0, v25.Padding.Large)
		}) })

		return React.createElement(Foundation.View, {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v25.Gap.Small)
			},
			onAbsoluteSizeChanged = function(p4) -- line: 210
				-- upvalues: p3 (copy)
				p3.onNavFrameSizeChanged(p4)
			end
		}, t3)
	end, {
		t2.slots,
		t2.clearAllButton,
		t2.contentPadding,
		t2.margin
	})

	return React.createElement(ScrollingArrowsAndGradient, {
		LayoutOrder = t2.LayoutOrder,
		ZIndex = t2.ZIndex,
		buttonPadding = t2.buttonPadding,
		enableIntroScroll = t2.enableIntroScroll,
		selectedItemKey = t2.slotIndex .. "_" .. t2.slotCategory,
		enableSnapToSelectedItem = t2.enableSnapToSelectedItem,
		index = t2.index,
		resetPositionSignal = u26,
		navHeight = t2.slotSubNavigationFrameHeight,
		renderScrollingListContent = v28
	})
end
