local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local itemTile = UIBlox.Tile.ItemTile

local module = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local fFlagAXManageOutfitsCatalogItemCard = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXManageOutfitsCatalogItemCard
local Foundation = require(CorePackages.Packages.Foundation)

local catalogItemCard = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CatalogItemCard.CatalogItemCard

local function useFocusNavigationBindings(p2, p3, callback, callback2)
	local v5 = ReactFocusNavigation.useEventMap(p2, p3)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SelectOutfit] = {
				handler = InputHandlers.onRelease(function(p4)
					callback()
				end)
			},
			[focusNavigationEventNameEnum.UnselectOutfit] = {
				handler = InputHandlers.onRelease(function(p4)
					callback2()
				end)
			}
		}
	end, { callback, callback2 })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

return function(props)
	local v5 = useTableWrappedCallbackRef((useFocusNavigationBindings(React.useMemo(function()
		local buttonA = Enum.KeyCode.ButtonA
		local v7 = if props.isSelected then focusNavigationEventNameEnum.UnselectOutfit else focusNavigationEventNameEnum.SelectOutfit
		return { [buttonA] = v7 }
	end, { props.isSelected }), nil, React.useCallback(function()
		if props.multiSelect then
			local joined = Cryo.List.join(props.selectedOutfits, { props.itemId })
			props.selectionUpdated(joined)
		else
			props.selectionUpdated({ props.itemId })

			if props.onToggleOutfitCard then
				props.onToggleOutfitCard(true, props.itemId)
			end
		end
	end, {
		props.multiSelect,
		props.selectedOutfits,
		props.itemId,
		props.selectionUpdated,
		props.onToggleOutfitCard
	}), React.useCallback(function()
		if props.multiSelect then
			local v6 = Cryo.List.removeValue(props.selectedOutfits, props.itemId)
			props.selectionUpdated(v6)
		else
			props.selectionUpdated({})

			if props.onToggleOutfitCard then
				props.onToggleOutfitCard(false)
			end
		end
	end, {
		props.multiSelect,
		props.selectedOutfits,
		props.itemId,
		props.selectionUpdated,
		props.onToggleOutfitCard
	}))))

	if not (fFlagAXManageOutfitsCatalogItemCard and props.useCatalogItemCard) then
		return React.createElement(itemTile, {
			Selectable = true,
			isSelected = props.isSelected,
			multiSelect = props.multiSelect,
			itemIconType = props.itemIconType,
			onActivated = props.toggleSelectOutfit,
			name = props.name,
			titleTextLineCount = props.titleTextLineCount,
			thumbnail = props.thumbnail,
			ref = v5
		})
	end

	local createElement = React.createElement
	local v7 = {
		title = props.name,
		presentationSlot = 0,
		isSelected = 0,
		onActivated = 0,
		itemStatus = 0,
		headerAspectRatio = 1,
		Size = 0,
		AutomaticSize = 0,
		ref = 0
	}
	local v8 = if props.thumbnail then React.createElement(Foundation.Image, {
		tag = "size-full radius-medium clip",
		Image = props.thumbnail,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Crop
	}) or nil else nil
	v7.presentationSlot = v8

	v7.isSelected = props.isSelected
	v7.onActivated = props.toggleSelectOutfit
	v7.itemStatus = props.itemStatus

	v7.Size = UDim2.new(1, 0, 0, 0)
	v7.AutomaticSize = Enum.AutomaticSize.Y
	v7.ref = v5
	return createElement(catalogItemCard, v7)
end
