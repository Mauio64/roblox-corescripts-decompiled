local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local ItemTile = UIBlox.Tile.ItemTile
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXManageOutfitsCatalogItemCard = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXManageOutfitsCatalogItemCard
local Foundation = require(CorePackages.Packages.Foundation)
local CatalogItemCard = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.CatalogItemCard.CatalogItemCard

local function useFocusNavigationBindings(p1, p2, p3, p4) -- line: 29
	-- upvalues: ReactFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v21 = ReactFocusNavigation.useEventMap(p1, p2)
	local v22 = React.useMemo(function() -- line: 31
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p3 (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.SelectOutfit] = {
				handler = InputHandlers.onRelease(function(_) -- line: 34
					-- upvalues: p3 (copy)
					p3()
				end)
			},
			[FocusNavigationEventNameEnum.UnselectOutfit] = {
				handler = InputHandlers.onRelease(function(_) -- line: 39
					-- upvalues: p4 (copy)
					p4()
				end)
			}
		}
	end, {
		p3,
		p4
	})

	return ReactFocusNavigation.useEventHandlerMap(v22, v21)
end

return function(p7) -- line: 48
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), Cryo (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), FFlagAXManageOutfitsCatalogItemCard (copy), CatalogItemCard (copy), Foundation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), ItemTile (copy), Focusable (copy)
	local v24 = React.useMemo(function() -- line: 49
		-- upvalues: p7 (copy), FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonA] = if not p7.isSelected then FocusNavigationEventNameEnum.SelectOutfit else FocusNavigationEventNameEnum.UnselectOutfit
		}
	end, { p7.isSelected })
	local v25 = React.useCallback(function() -- line: 58
		-- upvalues: p7 (copy), Cryo (copy)
		if p7.multiSelect then
			local v29 = Cryo.List.join(p7.selectedOutfits, { p7.itemId })

			p7.selectionUpdated(v29)

			return
		end

		p7.selectionUpdated({ p7.itemId })

		if p7.onToggleOutfitCard then
			p7.onToggleOutfitCard(true, p7.itemId)
		end
	end, {
		p7.multiSelect,
		p7.selectedOutfits,
		p7.itemId,
		p7.selectionUpdated,
		p7.onToggleOutfitCard
	})
	local v26 = React.useCallback(function() -- line: 73
		-- upvalues: p7 (copy), Cryo (copy)
		if p7.multiSelect then
			local v30 = Cryo.List.removeValue(p7.selectedOutfits, p7.itemId)

			p7.selectionUpdated(v30)

			return
		end

		p7.selectionUpdated({})

		if p7.onToggleOutfitCard then
			p7.onToggleOutfitCard(false)
		end
	end, {
		p7.multiSelect,
		p7.selectedOutfits,
		p7.itemId,
		p7.selectionUpdated,
		p7.onToggleOutfitCard
	})
	local v27 = useFocusNavigationBindings(v24, nil, v25, v26)
	local v28 = useTableWrappedCallbackRef(v27)

	if FFlagAXManageOutfitsCatalogItemCard and p7.useCatalogItemCard then
		return React.createElement(CatalogItemCard, {
			headerAspectRatio = 1,
			title = p7.name,
			presentationSlot = p7.thumbnail and React.createElement(Foundation.Image, {
				tag = "size-full radius-medium clip",
				BackgroundTransparency = 1,
				Image = p7.thumbnail,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop
			}) or nil,
			isSelected = p7.isSelected,
			onActivated = p7.toggleSelectOutfit,
			itemStatus = p7.itemStatus,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ref = v28
		})
	end

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[ItemTile] else ItemTile, {
		Selectable = not not FFlagAXMigrateAXToGlobalAutofocus or nil,
		isSelected = p7.isSelected,
		multiSelect = p7.multiSelect,
		itemIconType = p7.itemIconType,
		onActivated = p7.toggleSelectOutfit,
		name = p7.name,
		titleTextLineCount = p7.titleTextLineCount,
		thumbnail = p7.thumbnail,
		ref = v28
	})
end
