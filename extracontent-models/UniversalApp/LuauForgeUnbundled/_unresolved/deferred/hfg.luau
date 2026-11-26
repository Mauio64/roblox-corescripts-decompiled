local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/bundled/fCn")
require("@luauforge/bundled/dPt")
local slotItemCard = module.Components.SlotItemCard

local module2 = require("@luauforge/deferred/hfh")
local useTokens = Foundation.Hooks.useTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal

local itemCard = require("@luauforge/deferred/gPt").ItemCardComponents.ItemCard
local slotItemCardFooter = module.Components.SlotItemCardFooter
local slotType = module.Enums.SlotType

local fFlagAXSlotBasedEditorCategoryTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotBasedEditorCategoryTooltip

local function fn(slot, layoutOrder, p2)
	local createElement = React.createElement
	local fromOffset = UDim2.fromOffset
	local v7 = if slot.Size then slot.Size.Y.Offset else p2.Size.Size_2500
	return createElement(itemCard, {
		Size = fromOffset(1, v7),
		LayoutOrder = layoutOrder,
		headerSlot = React.createElement(Foundation.Divider, {
			orientation = Foundation.Enums.Orientation.Vertical
		}),
		footerSlot = React.createElement(slotItemCardFooter, {
			title = nil,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	})
end

return function(props)
	local v5 = useTokens()

	local v6 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	end)

	local v7 = React.useMemo(function()
		return signal.new()
	end, {})

	React.useEffect(function()
		if v7 then
			v7:fire()
		end
	end, { v6, v7 })

	local v8 = React.useCallback(function(p2)
		local getScrollingFrameItemRef = p2.getScrollingFrameItemRef
		local count = 0
		local v9 = false
		local children = {}

		for k, slot in props.slots do
			if slot.hide then
				continue
			end

			count += 1

			if
				slot.slotType == slotType.LayeredSlot
				and v9
				and props.slots[k - 1].slotType ~= slotType.LayeredSlot
			then
				table.insert(children, fn(slot, count, v5))
				count += 1
			end

			v9 = true
			local createElement = React.createElement
			local v11 = {
				Size = slot.Size,
				renderHeaderSlot = slot.renderHeaderSlot,
				BackgroundTransparency = slot.BackgroundTransparency,
				onActivated = slot.onActivated,
				title = slot.title,
				LayoutOrder = count,
				ref = getScrollingFrameItemRef(k .. "_" .. props.slotCategory),
				isActive = slot.isActive,
				showSecondCategoryTooltip = 0
			}

			local v12 = if fFlagAXSlotBasedEditorCategoryTooltip then props.canShowTooltip and k == 2 and true or false else nil
			v11.showSecondCategoryTooltip = v12
			table.insert(children, (createElement(slotItemCard, v11)))

			if not (slot.slotType == slotType.LayeredSlot and k < #props.slots and props.slots[k + 1].slotType ~= slotType.LayeredSlot) then
				continue
			end

			count += 1
			table.insert(children, fn(slot, count, v5))
		end

		if props.clearAllButton then
			table.insert(children, (React.createElement(slotItemCard, {
				renderHeaderSlot = props.clearAllButton.renderHeaderSlot,
				BackgroundTransparency = 1,
				onActivated = props.clearAllButton.onActivated,
				LayoutOrder = count + 1,
				ref = getScrollingFrameItemRef(#props.slots + 1),
				Size = props.clearAllButton.Size,
				title = props.clearAllButton.text
			})))
		end

		table.insert(children, {
			React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v5.Padding.Large),
				PaddingTop = UDim.new(0, v5.Padding.Medium),
				PaddingBottom = UDim.new(0, v5.Padding.Medium),
				PaddingLeft = UDim.new(0, v5.Padding.Large)
			})
		})

		return React.createElement(Foundation.View, {
			AutomaticSize = Enum.AutomaticSize.XY,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v5.Gap.Small)
			},
			BackgroundTransparency = 1,
			onAbsoluteSizeChanged = function(p3)
				p2.onNavFrameSizeChanged(p3)
			end
		}, children)
	end, { props.slots, props.clearAllButton, props.contentPadding, props.margin })
	return React.createElement(module2, {
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		buttonPadding = props.buttonPadding,
		enableIntroScroll = props.enableIntroScroll,
		selectedItemKey = props.slotIndex .. "_" .. props.slotCategory,
		enableSnapToSelectedItem = props.enableSnapToSelectedItem,
		index = props.index,
		resetPositionSignal = v7,
		navHeight = props.slotSubNavigationFrameHeight,
		renderScrollingListContent = v8
	})
end
