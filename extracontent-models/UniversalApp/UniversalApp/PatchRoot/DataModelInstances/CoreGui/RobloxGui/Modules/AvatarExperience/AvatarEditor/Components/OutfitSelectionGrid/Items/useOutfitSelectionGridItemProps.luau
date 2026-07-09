local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants

require(Modules.AvatarExperience.Common.Types)

local InputHandlers = require(CorePackages.Packages.InputHandlers)
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef

require(script.Parent.OutfitSelectionGridItem)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function useFocusNavigationBindings(p1, p2, p3, p4) -- line: 26
	-- upvalues: ReactFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v19 = ReactFocusNavigation.useEventMap(p1, p2)
	local v20 = React.useMemo(function() -- line: 28
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p3 (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.SelectOutfit] = {
				handler = InputHandlers.onRelease(function(_) -- line: 31
					-- upvalues: p3 (copy)
					p3()
				end)
			},
			[FocusNavigationEventNameEnum.UnselectOutfit] = {
				handler = InputHandlers.onRelease(function(_) -- line: 36
					-- upvalues: p4 (copy)
					p4()
				end)
			}
		}
	end, {
		p3,
		p4
	})

	return ReactFocusNavigation.useEventHandlerMap(v20, v19)
end

return function(t1: {[any]: any}) -- line: 58
	-- upvalues: React (copy), Cryo (copy), FocusNavigationEventNameEnum (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), useAppPolicy (copy)
	local v22 = React.useMemo(function() -- line: 59
		-- upvalues: Cryo (copy), t1 (copy)
		return Cryo.List.find(t1.selectedOutfits, t1.itemId) ~= nil
	end, {
		t1.selectedOutfits,
		t1.itemId
	})
	local v23 = React.useMemo(function() -- line: 63
		-- upvalues: v22 (copy), FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonA] = if not v22 then FocusNavigationEventNameEnum.SelectOutfit else FocusNavigationEventNameEnum.UnselectOutfit
		}
	end, { v22 })
	local v24 = React.useCallback(function() -- line: 72
		-- upvalues: t1 (copy), Cryo (copy)
		if not t1.itemId then
			return
		end

		if t1.multiSelect then
			local v33 = Cryo.List.join(t1.selectedOutfits, { t1.itemId })

			t1.setSelectedOutfits(v33)

			return
		end

		t1.setSelectedOutfits({ t1.itemId })

		if t1.onToggleOutfitCard then
			t1.onToggleOutfitCard(true, t1.itemId)
		end
	end, {
		t1.multiSelect,
		t1.selectedOutfits,
		t1.itemId,
		t1.setSelectedOutfits,
		t1.onToggleOutfitCard
	})
	local v25 = React.useCallback(function() -- line: 90
		-- upvalues: t1 (copy), Cryo (copy)
		if not t1.itemId then
			return
		end

		if t1.multiSelect then
			local v34 = Cryo.List.removeValue(t1.selectedOutfits, t1.itemId)

			t1.setSelectedOutfits(v34)

			return
		end

		t1.setSelectedOutfits({})

		if t1.onToggleOutfitCard then
			t1.onToggleOutfitCard(false)
		end
	end, {
		t1.multiSelect,
		t1.selectedOutfits,
		t1.itemId,
		t1.setSelectedOutfits,
		t1.onToggleOutfitCard
	})
	local v26 = useFocusNavigationBindings(v23, nil, v24, v25)
	local v27 = useTableWrappedCallbackRef(v26)
	local name = nil
	local v29 = nil

	if t1.itemId then
		local Outfit = Constants.RbxthumbTypes.Outfit

		v29 = getRbxthumbWithTypeSizeAndOptions(t1.itemId, Outfit, 150)
	end

	if t1.outfitInfo then
		name = t1.outfitInfo.name

		if v29 then
			v29 ..= "&filters=" .. t1.outfitInfo.updateCounter
		end
	end

	local v31 = React.useCallback(function() -- line: 127
		-- upvalues: t1 (copy), v22 (copy), Cryo (copy)
		if not t1.itemId then
			return
		end

		if t1.multiSelect then
			local v35 = if not v22 then Cryo.List.join(t1.selectedOutfits, { t1.itemId }) else Cryo.List.removeValue(t1.selectedOutfits, t1.itemId)

			t1.setSelectedOutfits(v35)

			return
		end

		if v22 then
			t1.setSelectedOutfits({})

			if t1.onToggleOutfitCard then
				t1.onToggleOutfitCard(false)

				return
			end
		else
			t1.setSelectedOutfits({ t1.itemId })

			if t1.onToggleOutfitCard then
				t1.onToggleOutfitCard(true, t1.itemId)
			end
		end
	end, {
		t1.multiSelect,
		t1.selectedOutfits,
		t1.itemId,
		t1.setSelectedOutfits,
		t1.onToggleOutfitCard,
		v22
	})
	local v32 = useAppPolicy(function(p7) -- line: 163
		return p7.getCustomOutfitNames()
	end)

	return {
		isSelected = v22,
		onActivated = v31,
		title = if not v32 then nil else name,
		focusNavigationRef = v27,
		thumbnail = v29
	}
end
