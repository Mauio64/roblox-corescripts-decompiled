local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("PlayWithRewardComponent").Parent
local SharedFlags = require(parent.SharedFlags)
local t = require(parent.t)

local FFlagPlayWithRewardCoachmarkOverlayFix = SharedFlags.FFlagPlayWithRewardCoachmarkOverlayFix
local defineFastFlag = game:DefineFastFlag("PlayWithRewardCoachmarkWindowResets", false)
local defineFastInt = game:DefineFastInt("PlayWithRewardCoachmarkMaxImpressions", 3)
local defineFastInt2 = game:DefineFastInt("PlayWithRewardCoachmarkMaxImpressions2", 3)
local defineFastInt3 = game:DefineFastInt("PlayWithRewardCoachmarkWindowDays", 30)
local engineFeature = game:GetEngineFeature("PlayWithRewardCoachmarkStorageKey")

local v = defineFastInt3 * 86400

local interface = t.interface({
	windowStartTime = t.number,
	impressionCount = t.number,
	isDismissed = t.boolean
})

local function getDefaultState() -- 1 equivalent call inferred from this helper
	return { windowStartTime = 0, impressionCount = 0, isDismissed = false }
end

local function parseState(p) -- 2 equivalent calls inferred from this helper
	if interface(p) then
		return p
	end

	return getDefaultState() -- inferred equivalent call
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

local function writeStateLookup(p)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)

	if success and type(result) == "string" then
		return (pcall(function()
			AppStorageService:SetItem("PlayWithRewardCoachmark", result)
			AppStorageService:Flush()
		end))
	end

	return false
end

local function mutateStateLookup(p: number, fn) -- 1 equivalent call inferred from this helper
	local v2 = readStateLookup()

	if v2 == nil then
		return false
	end

	local v3 = tostring(p)
	local v4 = fn(parseState(v2[v3])) -- inferred equivalent call

	if v4 == nil then
		return false
	end

	v2[v3] = v4
	return writeStateLookup(v2)
end

local function hasWindowExpired(p, now: number): boolean -- 1 equivalent call inferred from this helper
	return p.windowStartTime > 0 and v <= now - p.windowStartTime
end

local PlayWithRewardCoachmarkStorage = {}

function PlayWithRewardCoachmarkStorage.consumeImpressionIfEligible(p: number)
	local v2

	if FFlagPlayWithRewardCoachmarkOverlayFix then
		v2 = defineFastInt2
	else
		v2 = defineFastInt
	end

	if not engineFeature or v2 <= 0 or v <= 0 then
		return false
	end

	local now = os.time()
	local v3 = { windowStartTime = now, impressionCount = 1, isDismissed = false }
	local v4 = readStateLookup()

	if v4 == nil then
		return false
	end

	local v5 = tostring(p)
	local state = parseState(v4[v5]) -- inferred equivalent call

	if state.windowStartTime ~= 0 then
		if hasWindowExpired(state, now) then -- inferred equivalent call
			if not defineFastFlag then
				v3 = nil
			end
		elseif state.isDismissed or v2 <= state.impressionCount then
			v3 = nil
		else
			state.impressionCount += 1
			v3 = state
		end
	end

	if v3 == nil then
		return false
	end

	v4[v5] = v3
	return writeStateLookup(v4)
end

function PlayWithRewardCoachmarkStorage.dismissCurrentWindow(p: number)
	local function fn(state)
		if state.windowStartTime == 0 or state.isDismissed then
			return nil
		end

		state.isDismissed = true
		return state
	end

	mutateStateLookup(p, fn) -- inferred equivalent call
end

return PlayWithRewardCoachmarkStorage
