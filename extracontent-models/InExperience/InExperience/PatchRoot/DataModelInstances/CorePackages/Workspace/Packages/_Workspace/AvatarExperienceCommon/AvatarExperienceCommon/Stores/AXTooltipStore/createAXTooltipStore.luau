local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local parent = AvatarExperienceCommon.Parent
local Signals = require(parent.Signals)
local Constants = require(AvatarExperienceCommon.Constants)
local SafeAppStorageService = require(AvatarExperienceCommon.Lib.SafeAppStorageService)

local defineFastString = game:DefineFastString("AXTooltipAllowedTooltips", "")

local defineFastFlag = game:DefineFastFlag("AXTooltipUseMemStorage", false)

local defineFastInt = game:DefineFastInt("AXTooltipMaxNumberOfTimesSeen", 2)

local function deserializeSeenTooltips(item: string)
	local parts = item:split(",")
	local result = {}

	for _, part in parts do
		result[part] = not result[part] and 1 or result[part] + 1
	end

	return result
end

local function serializeSeenTooltips(items)
	local v = {}

	for k, item in items do
		for _ = 1, math.min(defineFastInt, item) do
			table.insert(v, k)
		end
	end

	return table.concat(v, ",")
end

local function createAXTooltipStore()
	local parts = defineFastString:split(",")

	local v = deserializeSeenTooltips(SafeAppStorageService.getItem(Constants.AX_TOOLTIP_STORAGE_KEY, defineFastFlag))

	local partSet = {}
	local v2 = {}

	for _, part in parts do
		local v3 = v[part] or 0

		if v3 < defineFastInt then
			partSet[part] = true
		end

		v2[part] = v3
	end

	SafeAppStorageService.setItem(Constants.AX_TOOLTIP_STORAGE_KEY, serializeSeenTooltips(v2), defineFastFlag)

	SafeAppStorageService.flush()

	local signal, v3 = Signals.createSignal(partSet)
	local signal2, v4 = Signals.createSignal(v2)

	local v5 = {}

	local function getIsTooltipAllowedToBeShownSignal(p: string)
		if v5[p] == nil then
			v5[p] = Signals.createComputed(function(p2): boolean
				return signal(p2)[p] == true
			end)
		end

		return v5[p]
	end

	local function dismissTooltip(p: string, flag: boolean?)
		local clone = table.clone(signal(false))

		if clone[p] ~= true then
			return
		end

		clone[p] = false
		v3(clone)

		local v6 = signal2(false)

		local v7 = v6[p] or 0

		if flag and not (defineFastInt <= v7) then
			v6[p] = v7 + 1
		else
			v6[p] = defineFastInt
		end

		SafeAppStorageService.setItem(Constants.AX_TOOLTIP_STORAGE_KEY, serializeSeenTooltips(v6), defineFastFlag)

		SafeAppStorageService.flush()

		v4(v6)
	end

	return {
		getIsTooltipAllowedToBeShown = getIsTooltipAllowedToBeShownSignal,
		dismissTooltip = dismissTooltip
	}
end

return createAXTooltipStore
