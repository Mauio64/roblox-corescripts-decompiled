local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("PlayWithRewardComponent").Parent
local SharedFlags = require(Parent.SharedFlags)
local t = require(Parent.t)
local FFlagPlayWithRewardCoachmarkOverlayFix = SharedFlags.FFlagPlayWithRewardCoachmarkOverlayFix
local v7 = game:DefineFastFlag("PlayWithRewardCoachmarkWindowResets", false)
local v8 = game:DefineFastInt("PlayWithRewardCoachmarkMaxImpressions", 3)
local v9 = game:DefineFastInt("PlayWithRewardCoachmarkMaxImpressions2", 3)
local v10 = game:DefineFastInt("PlayWithRewardCoachmarkWindowDays", 30)
local EngineFeature = game:GetEngineFeature("PlayWithRewardCoachmarkStorageKey")
local v12 = v10 * 86400
local v13 = t.interface({
	windowStartTime = t.number,
	impressionCount = t.number,
	isDismissed = t.boolean
})

local function getDefaultState() -- line: 49
	return {
		windowStartTime = 0,
		impressionCount = 0,
		isDismissed = false
	}
end
local function parseState(p1) -- line: 57
	-- upvalues: v13 (copy)
	if not v13(p1) then
		return {
			windowStartTime = 0,
			impressionCount = 0,
			isDismissed = false
		}
	end

	return p1
end
local function readStateLookup() -- line: 66
	-- upvalues: EngineFeature (copy), AppStorageService (copy), HttpService (copy)
	if not EngineFeature then
		return nil
	end

	local ok, result = pcall(function() -- line: 71
		-- upvalues: AppStorageService (copy)
		return AppStorageService:GetItem("PlayWithRewardCoachmark")
	end)

	if not ok or type(result) ~= "string" then
		return nil
	end

	if result == "" then
		return {}
	end

	local ok2, result2 = pcall(function() -- line: 82
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" then
		return {}
	end

	return result2
end
local function writeStateLookup(t1: {[any]: any}) -- line: 92
	-- upvalues: HttpService (copy), AppStorageService (copy)
	local ok, result = pcall(function() -- line: 93
		-- upvalues: HttpService (copy), t1 (copy)
		return HttpService:JSONEncode(t1)
	end)

	if not ok or type(result) ~= "string" then
		return false
	end

	return (pcall(function() -- line: 100
		-- upvalues: AppStorageService (copy), result (copy)
		AppStorageService:SetItem("PlayWithRewardCoachmark", result)
		AppStorageService:Flush()
	end))
end
local function mutateStateLookup(n1: number, p2: ((...any) -> ...any)) -- line: 107
	-- upvalues: readStateLookup (copy), v13 (copy), writeStateLookup (copy)
	local v30 = readStateLookup()

	if v30 == nil then
		return false
	end

	local str = tostring(n1)
	local v32 = v30[str]
	local v33 = p2(if v13(v32) then v32 else {
		windowStartTime = 0,
		impressionCount = 0,
		isDismissed = false
	})

	if v33 == nil then
		return false
	end

	v30[str] = v33

	return (writeStateLookup(v30))
end
local function hasWindowExpired(t2: {[any]: any}, n2: number) -- line: 126
	-- upvalues: v12 (copy)
	return t2.windowStartTime > 0 and n2 - t2.windowStartTime >= v12
end

return {
	consumeImpressionIfEligible = function(n3: number) -- line: 132
		-- upvalues: FFlagPlayWithRewardCoachmarkOverlayFix (copy), v9 (copy), v8 (copy), EngineFeature (copy), v12 (copy), v7 (copy), readStateLookup (copy), v13 (copy), writeStateLookup (copy)
		local v37 = if not FFlagPlayWithRewardCoachmarkOverlayFix then v8 else v9

		if not EngineFeature or (v37 <= 0 or v12 <= 0) then
			return false
		end

		local timestamp = os.time()
		local t3 = {
			impressionCount = 1,
			isDismissed = false,
			windowStartTime = timestamp
		}
		local v40 = readStateLookup()

		if v40 == nil then
			return false
		end

		local str = tostring(n3)
		local v42 = v40[str]
		local v43 = if v13(v42) then v42 else {
			windowStartTime = 0,
			impressionCount = 0,
			isDismissed = false
		}

		if v43.windowStartTime == 0 then
		elseif v43.windowStartTime > 0 and timestamp - v43.windowStartTime >= v12 then
			t3 = if not v7 then nil else t3
		elseif v43.isDismissed or v37 <= v43.impressionCount then
			t3 = nil
		else
			v43.impressionCount = v43.impressionCount + 1
			t3 = v43
		end

		if t3 == nil then
			return false
		end

		v40[str] = t3

		return (writeStateLookup(v40))
	end,
	dismissCurrentWindow = function(n4: number) -- line: 166
		-- upvalues: readStateLookup (copy), v13 (copy), writeStateLookup (copy)
		local v45 = readStateLookup()

		if v45 == nil then
			return
		end

		local str = tostring(n4)
		local v47 = v45[str]
		local v48 = if v13(v47) then v47 else {
			windowStartTime = 0,
			impressionCount = 0,
			isDismissed = false
		}

		if v48.windowStartTime == 0 or v48.isDismissed then
			v48 = nil
		else
			v48.isDismissed = true
		end

		if v48 == nil then
			return
		end

		v45[str] = v48
		writeStateLookup(v45)
	end
}
