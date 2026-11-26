local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptChipsStore")
local promptChipsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptChipsStore/promptChipsStatus")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local FIntBuildPromptChipEditDebounceMs = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntBuildPromptChipEditDebounceMs")

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFTUXChipExhaustedTelemetry")

local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")

local PROMPT_CHIPS_STATUS = promptChipsStatus.PROMPT_CHIPS_STATUS
local v5 = FIntBuildPromptChipEditDebounceMs / 1000
local function getChipClickParameters(data, value, p2)
	local chips = data.getChips()
	local index = table.find(chips, p2)
	local chipClickParameters = {
		chipText = p2.value,
		index = 0,
		chipCount = 0,
		hasPrompt = 0
	}
	local v6 = if index ~= nil then tostring(index) else nil
	chipClickParameters.index = v6
	chipClickParameters.chipCount = tostring(#chips)
	chipClickParameters.hasPrompt = tostring(string.find(value, "%S") ~= nil)
	return chipClickParameters
end

local function useBuildPromptChipRequests(data, data2)
	local isActive = data2.isActive
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(isActive)
	local telemetryGranularity = data2.telemetryGranularity

	local v6 = React.useCallback(function(p2, p3)
		local lastTime = os.clock()
		data.requestChips(p2, p3, function(p4)
			local v7 = math.max(0, (math.round((os.clock() - lastTime) * 1000)))
			sendBuildExperienceEvent("CHIP_LOAD", telemetryGranularity, {
				elapsedMs = tostring(v7),
				succeeded = tostring(p4)
			})
		end)
	end, { data, telemetryGranularity })

	local v7 = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			task.cancel(current)
			ref.current = nil
		end
	end, {})

	React.useEffect(function()
		if isActive then
			ref5.current = true
			return
		end

		v7()
		ref2.current = nil
		ref3.current = nil
		ref4.current = nil

		if ref5.current then
			ref5.current = false
			data.reset()
		end
	end, { data, isActive, v7 })

	React.useEffect(function()
		if not isActive then
			return
		end

		if ref4.current ~= nil and ref4.current ~= data2.sessionKey then
			v7()
			ref2.current = nil
			ref3.current = nil
			data.reset()
		end

		ref4.current = data2.sessionKey

		if not (data2.shouldRequestInitialChips and ref3.current ~= data2.sessionKey) then
			return
		end

		v7()
		ref3.current = data2.sessionKey
		ref2.current = ""
		v6({ prompt = "" })
	end, { data, isActive, data2.sessionKey, data2.shouldRequestInitialChips, v7, v6 })

	React.useEffect(function()
		return function()
			v7()
			ref2.current = nil
			ref3.current = nil
			ref4.current = nil
			ref5.current = false
			data.reset()
		end
	end, { data, v7 })

	local v8 = React.useCallback(function(value)
		if not isActive then
			return
		end

		v7()

		local v9 = string.match(value, "^%s*(.-)%s*$") or ""

		if v9 == ref2.current then
			local status = data.getStatus()

			if status ~= PROMPT_CHIPS_STATUS.Idle and status ~= PROMPT_CHIPS_STATUS.Failed then
				return
			end
		end

		ref.current = task.delay(v5, function()
			ref.current = nil
			ref2.current = v9

			sendBuildExperienceEvent("CHIP_PROMPT_EDIT", telemetryGranularity)
			v6({ prompt = v9 })
		end)
	end, { data, isActive, v7, v6, telemetryGranularity })

	local function fn(p2, p3, p4)
		if not isActive then
			return
		end

		v7()
		ref2.current = nil

		local v12 = if FFlagBuildExperienceEventContextTelemetry then getChipClickParameters(data, p2, p3) else nil
		sendBuildExperienceEvent("CHIP_CLICK", telemetryGranularity, v12)

		v6({ prompt = p2, selectedChip = p3 }, p4)
	end

	local v11 = React.useCallback(fn, {
		isActive,
		v7,
		v6,
		telemetryGranularity,
		if FFlagBuildExperienceEventContextTelemetry then data else nil
	})
	local v12

	if FFlagBuildExperienceFTUXChipExhaustedTelemetry then
		v12 = React.useCallback(function()
			if isActive then
				sendBuildExperienceEvent("CHIP_EXHAUSTED", telemetryGranularity)
			end
		end, { isActive, telemetryGranularity })
	end

	return {
		requestChipsForEdit = v8,
		requestChipsForSelection = v11,
		onChipExhausted = v12
	}
end

return useBuildPromptChipRequests
