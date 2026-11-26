local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module3 = require("@luauforge/bundled/ciE")
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = module3.Utils.Constants
require("@luauforge/bundled/dPs")
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

require("@luauforge/deferred/hjx")

local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

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

return function(data)
	local v5 = React.useMemo(function(): boolean
		return Cryo.List.find(data.selectedOutfits, data.itemId) ~= nil
	end, { data.selectedOutfits, data.itemId })

	local v10 = useTableWrappedCallbackRef((useFocusNavigationBindings(React.useMemo(function()
		local buttonA = Enum.KeyCode.ButtonA
		local v8 = if v5 then focusNavigationEventNameEnum.UnselectOutfit else focusNavigationEventNameEnum.SelectOutfit
		return { [buttonA] = v8 }
	end, { v5 }), nil, React.useCallback(function()
		if not data.itemId then
			return
		end

		if data.multiSelect then
			local joined = Cryo.List.join(data.selectedOutfits, { data.itemId })
			data.setSelectedOutfits(joined)
		else
			data.setSelectedOutfits({ data.itemId })

			if data.onToggleOutfitCard then
				data.onToggleOutfitCard(true, data.itemId)
			end
		end
	end, {
		data.multiSelect,
		data.selectedOutfits,
		data.itemId,
		data.setSelectedOutfits,
		data.onToggleOutfitCard
	}), React.useCallback(function()
		if not data.itemId then
			return
		end

		if data.multiSelect then
			local v9 = Cryo.List.removeValue(data.selectedOutfits, data.itemId)
			data.setSelectedOutfits(v9)
		else
			data.setSelectedOutfits({})

			if data.onToggleOutfitCard then
				data.onToggleOutfitCard(false)
			end
		end
	end, {
		data.multiSelect,
		data.selectedOutfits,
		data.itemId,
		data.setSelectedOutfits,
		data.onToggleOutfitCard
	}))))

	local name = nil
	local v11

	if data.itemId then
		local outfit = constants.RbxthumbTypes.Outfit
		v11 = getRbxthumbWithTypeSizeAndOptions(data.itemId, outfit, 150)
	end

	if data.outfitInfo then
		name = data.outfitInfo.name

		if v11 then
			v11 ..= "&filters=" .. data.outfitInfo.updateCounter
		end
	end

	local v12 = {
		isSelected = v5,
		onActivated = React.useCallback(function()
			if not data.itemId then
				return
			end

			if data.multiSelect then
				local v13 = if v5 then Cryo.List.removeValue(data.selectedOutfits, data.itemId) else Cryo.List.join(data.selectedOutfits, { data.itemId })

				data.setSelectedOutfits(v13)
			elseif v5 then
				data.setSelectedOutfits({})

				if data.onToggleOutfitCard then
					data.onToggleOutfitCard(false)
				end
			else
				data.setSelectedOutfits({ data.itemId })

				if data.onToggleOutfitCard then
					data.onToggleOutfitCard(true, data.itemId)
				end
			end
		end, {
			data.multiSelect,
			data.selectedOutfits,
			data.itemId,
			data.setSelectedOutfits,
			data.onToggleOutfitCard,
			v5
		}),
		title = 0,
		focusNavigationRef = 0,
		thumbnail = 0
	}

	if not useAppPolicy(function(p2)
		return p2.getCustomOutfitNames()
	end) then
		name = nil
	end

	v12.title = name
	v12.focusNavigationRef = v10
	v12.thumbnail = v11
	return v12
end
