local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local Signals = require(AvatarExperienceCommonParent.Signals)
local Constants = require(AvatarExperienceCommon.Constants)
local SafeAppStorageService = require(AvatarExperienceCommon.Lib.SafeAppStorageService)
local v6 = game:DefineFastString("AXTooltipAllowedTooltips", "")
local v7 = game:DefineFastFlag("AXTooltipUseMemStorage", false)
local v8 = game:DefineFastInt("AXTooltipMaxNumberOfTimesSeen", 2)

local function deserializeSeenTooltips(s1: string) -- line: 30
	local t1 = {}

	for _, v15 in (s1:split(",")) do
		t1[v15] = not t1[v15] and 1 or t1[v15] + 1
	end

	return t1
end
local function serializeSeenTooltips(t2: {[any]: any}) -- line: 42
	-- upvalues: v8 (copy)
	local t3 = {}

	for v18, v19 in t2 do
		for _ = 1, math.min(v8, v19) do
			table.insert(t3, v18)
		end
	end

	return table.concat(t3, ",")
end
local function createAXTooltipStore() -- line: 54
	-- upvalues: v6 (copy), SafeAppStorageService (copy), Constants (copy), v7 (copy), deserializeSeenTooltips (copy), v8 (copy), serializeSeenTooltips (copy), Signals (copy)
	local parts = v6:split(",")
	local v22 = SafeAppStorageService.getItem(Constants.AX_TOOLTIP_STORAGE_KEY, v7)
	local v23 = deserializeSeenTooltips(v22)
	local t4 = {}
	local t5 = {}

	for _, v27 in parts do
		local v28 = v23[v27] or 0

		if v28 < v8 then
			t4[v27] = true
		end

		t5[v27] = v28
	end

	SafeAppStorageService.setItem(Constants.AX_TOOLTIP_STORAGE_KEY, serializeSeenTooltips(t5), v7)
	SafeAppStorageService.flush()

	local v29, v30 = Signals.createSignal(t4)
	local v31, v32 = Signals.createSignal(t5)
	local t6 = {}

	local function getIsTooltipAllowedToBeShownSignal(s2: string) -- line: 87
		-- upvalues: t6 (copy), Signals (copy), v29 (copy)
		if t6[s2] == nil then
			t6[s2] = Signals.createComputed(function(p1) -- line: 89
				-- upvalues: v29 (copy), s2 (copy)
				return v29(p1)[s2] == true
			end)
		end

		return t6[s2]
	end

	return {
		getIsTooltipAllowedToBeShown = getIsTooltipAllowedToBeShownSignal,
		dismissTooltip = function(s3: string, b1: boolean?) -- line: 97
			-- upvalues: v29 (copy), v30 (copy), v31 (copy), v8 (copy), SafeAppStorageService (copy), Constants (copy), serializeSeenTooltips (copy), v7 (copy), v32 (copy)
			local v38 = table.clone(v29(false))

			if v38[s3] ~= true then
				return
			end

			v38[s3] = false
			v30(v38)

			local v39 = v31(false)
			local v40 = v39[s3] or 0

			if not b1 or v40 >= v8 then
				v39[s3] = v8
			else
				v39[s3] = v40 + 1
			end

			SafeAppStorageService.setItem(Constants.AX_TOOLTIP_STORAGE_KEY, serializeSeenTooltips(v39), v7)
			SafeAppStorageService.flush()
			v32(v39)
		end
	}
end

return createAXTooltipStore
