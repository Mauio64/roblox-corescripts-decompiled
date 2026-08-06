local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local AppCommonLib = require(WhatsNewParent.AppCommonLib)

require(WhatsNew.Types)

local hadUsageBeforeFeature = require(script.Parent.hadUsageBeforeFeature)
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local v7 = AppCommonLib.Utils.AppStorageJsonCacheUtils.new(AppStorageService)
local t1 = {
	grandfathered = nil,
	onboardingCompletedAt = nil
}

local function getOrCreateStoredEntry(t2: {[any]: any}, s1: string) -- line: 49
	local v22 = t2[s1]

	if type(v22) ~= "table" then
		v22 = {}
		t2[s1] = v22
	end

	return v22
end
local function normalizeMeta(p1) -- line: 58
	-- upvalues: t1 (copy)
	if type(p1) == "table" then
		return table.clone(p1)
	end

	return table.clone(t1)
end
local function emptyDeviceData() -- line: 65
	-- upvalues: t1 (copy)
	return {
		meta = table.clone(t1),
		entries = {}
	}
end
local function normalizeDeviceData(t3: {[any]: any}) -- line: 72
	-- upvalues: t1 (copy)
	local meta = t3.meta

	t3.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

	if type(t3.entries) ~= "table" then
		t3.entries = {}
	end

	return t3
end
local function deepClone(p2) -- line: 80
	-- upvalues: deepClone (copy)
	local t4 = {}

	if type(p2) == "table" then
		for v28, v29 in p2 do
			if type(v29) == "table" then
				t4[v28] = deepClone(v29)
			else
				t4[v28] = v29
			end
		end
	end

	return t4
end
local function readDeviceData() -- line: 94
	-- upvalues: v7 (copy)
	local v30 = v7:getCachedJsonForKey("WhatsNewEntries")

	if type(v30) == "table" then
		return v30
	end

	return nil
end
local function cloneStoredDeviceData(t5: {[any]: any}) -- line: 102
	-- upvalues: deepClone (copy), t1 (copy)
	local t6 = {
		meta = t5.meta,
		entries = deepClone(t5.entries)
	}
	local meta = t6.meta

	t6.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

	if type(t6.entries) ~= "table" then
		t6.entries = {}
	end

	return t6
end
local function writeDeviceData(t7: {[any]: any}) -- line: 109
	-- upvalues: HttpService (copy), AppStorageService (copy), v7 (copy)
	local ok, result = pcall(function() -- line: 110
		-- upvalues: HttpService (copy), t7 (copy)
		return HttpService:JSONEncode(t7)
	end)

	if not ok or type(result) ~= "string" then
		warn(`WhatsNew EntryStorage: failed to encode storage: { result }`)

		return false
	end

	local ok2, result2 = pcall(function() -- line: 118
		-- upvalues: AppStorageService (copy), result (copy)
		AppStorageService:SetItem("WhatsNewEntries", result)
		AppStorageService:Flush()
	end)

	if not ok2 then
		warn(`WhatsNew EntryStorage: failed to persist storage: { result2 }`)

		return false
	end

	v7:getCachedJsonForKey("WhatsNewEntries", true)

	return true
end
local function getDeviceData() -- line: 131
	-- upvalues: v7 (copy), emptyDeviceData (copy), deepClone (copy), t1 (copy)
	local v39 = v7:getCachedJsonForKey("WhatsNewEntries")
	local v40 = if type(v39) ~= "table" then nil else v39

	if v40 == nil then
		return (emptyDeviceData())
	end

	local t8 = {
		meta = v40.meta,
		entries = deepClone(v40.entries)
	}
	local meta = t8.meta

	t8.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

	if type(t8.entries) ~= "table" then
		t8.entries = {}
	end

	return t8
end
local function updateDeviceData(p3: ((...any) -> ...any)) -- line: 140
	-- upvalues: v7 (copy), deepClone (copy), t1 (copy), emptyDeviceData (copy), writeDeviceData (copy)
	local v44 = v7:getCachedJsonForKey("WhatsNewEntries")
	local v45 = if type(v44) ~= "table" then nil else v44
	local t9

	if v45 then
		t9 = {
			meta = v45.meta,
			entries = deepClone(v45.entries)
		}

		local meta = t9.meta

		t9.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

		if type(t9.entries) ~= "table" then
			t9.entries = {}
		end
	else
		t9 = emptyDeviceData()
	end

	local meta = t9.meta

	t9.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

	if type(t9.entries) ~= "table" then
		t9.entries = {}
	end

	local v49 = p3(t9)

	if v49 == nil then
		return
	end

	local meta2 = v49.meta

	v49.meta = if type(meta2) ~= "table" then table.clone(t1) else table.clone(meta2)

	if type(v49.entries) ~= "table" then
		v49.entries = {}
	end

	writeDeviceData(v49)
end
local function toSnapshot(t10: {[any]: any}?) -- line: 154
	local t11 = {}

	if type(t10) ~= "table" then
		return t11
	end

	for v53, v54 in t10 do
		if type(v54) == "table" then
			t11[v53] = {
				optOutCount = 0,
				adopted = false,
				seen = v54.seen
			}
		end
	end

	return t11
end

return {
	STORAGE_KEY = "WhatsNewEntries",
	clearJsonCacheForTests = function() -- line: 175
		-- upvalues: v7 (copy)
		v7._jsonDecodeCache = {}
	end,
	clearForTests = function() -- line: 178
		-- upvalues: writeDeviceData (copy), emptyDeviceData (copy), v7 (copy)
		writeDeviceData((emptyDeviceData()))
		v7._jsonDecodeCache = {}
	end,
	getEntries = function() -- line: 182
		-- upvalues: v7 (copy), emptyDeviceData (copy), deepClone (copy), t1 (copy), toSnapshot (copy)
		local v55 = v7:getCachedJsonForKey("WhatsNewEntries")
		local v56 = if type(v55) ~= "table" then nil else v55
		local v57

		if v56 == nil then
			v57 = emptyDeviceData()
		else
			v57 = {
				meta = v56.meta,
				entries = deepClone(v56.entries)
			}

			local meta = v57.meta

			v57.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

			if type(v57.entries) ~= "table" then
				v57.entries = {}
			end
		end

		return (toSnapshot(v57.entries))
	end,
	getMeta = function() -- line: 187
		-- upvalues: v7 (copy), emptyDeviceData (copy), deepClone (copy), t1 (copy), normalizeMeta (copy)
		local v59 = v7:getCachedJsonForKey("WhatsNewEntries")
		local v60 = if type(v59) ~= "table" then nil else v59
		local v61

		if v60 == nil then
			v61 = emptyDeviceData()
		else
			v61 = {
				meta = v60.meta,
				entries = deepClone(v60.entries)
			}

			local meta = v61.meta

			v61.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

			if type(v61.entries) ~= "table" then
				v61.entries = {}
			end
		end

		local meta = v61.meta

		return normalizeMeta(meta)
	end,
	setMeta = function(p4) -- line: 192
		-- upvalues: updateDeviceData (copy), t1 (copy)
		updateDeviceData(function(p5) -- line: 193
			-- upvalues: p4 (copy), t1 (copy)
			local v74 = p4

			p5.meta = if type(v74) ~= "table" then table.clone(t1) else table.clone(v74)

			return p5
		end)
	end,
	markSeen = function(s2: string, s3: string) -- line: 199
		-- upvalues: updateDeviceData (copy)
		updateDeviceData(function(p6) -- line: 200
			-- upvalues: s2 (copy), s3 (copy)
			local entries = p6.entries
			local v77 = s2
			local v78 = entries[v77]

			if type(v78) ~= "table" then
				v78 = {}
				entries[v77] = v78
			end

			v78.seen = s3

			return p6
		end)
	end,
	runMigration = function(t12: {[any]: any}?) -- line: 207
		-- upvalues: v7 (copy), emptyDeviceData (copy), deepClone (copy), t1 (copy), hadUsageBeforeFeature (copy), updateDeviceData (copy)
		local v68 = v7:getCachedJsonForKey("WhatsNewEntries")
		local v69 = if type(v68) ~= "table" then nil else v68
		local v70

		if v69 == nil then
			v70 = emptyDeviceData()
		else
			v70 = {
				meta = v69.meta,
				entries = deepClone(v69.entries)
			}

			local meta = v70.meta

			v70.meta = if type(meta) ~= "table" then table.clone(t1) else table.clone(meta)

			if type(v70.entries) ~= "table" then
				v70.entries = {}
			end
		end

		local meta = v70.meta

		if type(meta) == "table" and meta.grandfathered ~= nil then
			return
		end

		if hadUsageBeforeFeature() then
			updateDeviceData(function(p7) -- line: 217
				-- upvalues: meta (copy)
				p7.meta = {
					grandfathered = true,
					onboardingCompletedAt = meta and meta.onboardingCompletedAt or nil
				}

				return p7
			end)

			if t12 and t12.onGrandfathered then
				t12.onGrandfathered()

				return
			end
		else
			updateDeviceData(function(p8) -- line: 229
				-- upvalues: meta (copy)
				p8.meta = {
					grandfathered = false,
					onboardingCompletedAt = meta and meta.onboardingCompletedAt or nil
				}

				return p8
			end)
		end
	end
}
