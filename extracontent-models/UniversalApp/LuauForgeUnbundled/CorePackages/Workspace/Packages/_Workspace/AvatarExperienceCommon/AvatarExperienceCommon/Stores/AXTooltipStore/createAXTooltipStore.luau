local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")
local SafeAppStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Lib/SafeAppStorageService")

local defineFastString = game:DefineFastString("AXTooltipAllowedTooltips", "")

local defineFastFlag = game:DefineFastFlag("AXTooltipUseMemStorage", false)

local defineFastInt = game:DefineFastInt("AXTooltipMaxNumberOfTimesSeen", 2)

local function deserializeSeenTooltips(item)
	local parts = item:split(",")
	local result = {}

	for k, part in parts do
		result[part] = not result[part] and 1 or result[part] + 1
	end

	return result
end

local function serializeSeenTooltips(items)
	local v5 = {}

	for k, item in items do
		for i = 1, math.min(defineFastInt, item) do
			table.insert(v5, k)
		end
	end

	return table.concat(v5, ",")
end

local function createAXTooltipStore()
	local parts = defineFastString:split(",")

	local v5 = deserializeSeenTooltips(SafeAppStorageService.getItem(Constants.AX_TOOLTIP_STORAGE_KEY, defineFastFlag))

	local partSet = {}
	local v6 = {}

	for k, part in parts do
		local v7 = v5[part] or 0

		if v7 < defineFastInt then
			partSet[part] = true
		end

		v6[part] = v7
	end

	SafeAppStorageService.setItem(Constants.AX_TOOLTIP_STORAGE_KEY, serializeSeenTooltips(v6), defineFastFlag)

	SafeAppStorageService.flush()

	local signal, v7 = Signals.createSignal(partSet)
	local signal2, v8 = Signals.createSignal(v6)

	local v9 = {}

	local function getIsTooltipAllowedToBeShownSignal(p2)
		if v9[p2] == nil then
			v9[p2] = Signals.createComputed(function(p3): boolean
				return signal(p3)[p2] == true
			end)
		end

		return v9[p2]
	end

	local function dismissTooltip(p2, p3)
		local clone = table.clone(signal(false))

		if clone[p2] ~= true then
			return
		end

		clone[p2] = false
		v7(clone)

		local v10 = signal2(false)

		local v11 = v10[p2] or 0

		if p3 and not (defineFastInt <= v11) then
			v10[p2] = v11 + 1
		else
			v10[p2] = defineFastInt
		end

		SafeAppStorageService.setItem(Constants.AX_TOOLTIP_STORAGE_KEY, serializeSeenTooltips(v10), defineFastFlag)

		SafeAppStorageService.flush()

		v8(v10)
	end

	return {
		getIsTooltipAllowedToBeShown = getIsTooltipAllowedToBeShownSignal,
		dismissTooltip = dismissTooltip
	}
end

return createAXTooltipStore
