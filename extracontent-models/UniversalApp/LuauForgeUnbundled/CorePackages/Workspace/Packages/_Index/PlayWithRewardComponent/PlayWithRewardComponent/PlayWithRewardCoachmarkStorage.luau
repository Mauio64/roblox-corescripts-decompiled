local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/SharedFlags")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/t")

local fFlagPlayWithRewardCoachmarkOverlayFix = SharedFlags.FFlagPlayWithRewardCoachmarkOverlayFix
local defineFastFlag = game:DefineFastFlag("PlayWithRewardCoachmarkWindowResets", false)
local defineFastInt = game:DefineFastInt("PlayWithRewardCoachmarkMaxImpressions", 3)
local defineFastInt2 = game:DefineFastInt("PlayWithRewardCoachmarkMaxImpressions2", 3)
local defineFastInt3 = game:DefineFastInt("PlayWithRewardCoachmarkWindowDays", 30)
local engineFeature = game:GetEngineFeature("PlayWithRewardCoachmarkStorageKey")

local v5 = defineFastInt3 * 86400

local interface = t.interface({
	windowStartTime = t.number,
	impressionCount = t.number,
	isDismissed = t.boolean
})

local function getDefaultState()
	return { windowStartTime = 0, impressionCount = 0, isDismissed = false }
end

local function parseState(p2)
	if interface(p2) then
		return p2
	end

	return { windowStartTime = 0, impressionCount = 0, isDismissed = false }
end

local function readStateLookup()
	if not engineFeature then
		return nil
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem("PlayWithRewardCoachmark")
	end)

	if not success or type(result) ~= "string" then
		return nil
	end

	if result == "" then
		return {}
	end

	local success2, result2 = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	if success2 and type(result2) == "table" then
		return result2
	end

	return {}
end

local function writeStateLookup(p2)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success and type(result) == "string" then
		return (pcall(function()
			AppStorageService:SetItem("PlayWithRewardCoachmark", result)
			AppStorageService:Flush()
		end))
	end

	return false
end

local function mutateStateLookup(p2, callback)
	local v6 = readStateLookup()

	if v6 == nil then
		return false
	end

	local v7 = tostring(p2)
	local v8 = v6[v7]
	local v9 = callback(not interface(v8) and {
		windowStartTime = 0,
		impressionCount = 0,
		isDismissed = false
	} or v8)

	if v9 == nil then
		return false
	end

	v6[v7] = v9
	return writeStateLookup(v6)
end

local function hasWindowExpired(p2, p3)
	local v6 = p2.windowStartTime > 0 and v5 <= p3 - p2.windowStartTime
	return v6
end

return {
	consumeImpressionIfEligible = function(p2)
		local v6 = if fFlagPlayWithRewardCoachmarkOverlayFix then defineFastInt2 else defineFastInt

		if not engineFeature or v6 <= 0 or v5 <= 0 then
			return false
		end

		local now = os.time()
		local v7 = { windowStartTime = now, impressionCount = 1, isDismissed = false }
		local v8 = readStateLookup()

		if v8 == nil then
			return false
		end

		local v9 = tostring(p2)
		local v10 = v8[v9]
		local v11 = not interface(v10)
			and { windowStartTime = 0, impressionCount = 0, isDismissed = false }
			or v10

		if v11.windowStartTime ~= 0 then
			local v12 = v11.windowStartTime > 0 and v5 <= now - v11.windowStartTime

			if v12 then
				if not defineFastFlag then
					v7 = nil
				end
			elseif v11.isDismissed or v6 <= v11.impressionCount then
				v7 = nil
			else
				v11.impressionCount += 1
				v7 = v11
			end
		end

		if v7 == nil then
			return false
		end

		v8[v9] = v7
		return writeStateLookup(v8)
	end,
	dismissCurrentWindow = function(p2)
		local v6 = readStateLookup()

		if v6 == nil then
			return
		end

		local v7 = tostring(p2)
		local v8 = v6[v7]
		local v9 = not interface(v8)
			and { windowStartTime = 0, impressionCount = 0, isDismissed = false }
			or v8

		if v9.windowStartTime == 0 or v9.isDismissed then
			v9 = nil
		else
			v9.isDismissed = true
		end

		if v9 == nil then
			return
		end

		v6[v7] = v9
		writeStateLookup(v6)
	end
}
