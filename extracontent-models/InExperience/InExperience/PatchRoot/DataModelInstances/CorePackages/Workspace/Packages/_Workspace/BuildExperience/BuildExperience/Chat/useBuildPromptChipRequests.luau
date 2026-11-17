local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)
require(BuildExperience.Stores.GetBuildPromptChipsStore)
local promptChipsStatus = require(BuildExperience.Stores.GetBuildPromptChipsStore.promptChipsStatus)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local FIntBuildPromptChipEditDebounceMs = require(BuildExperience.Flags.FIntBuildPromptChipEditDebounceMs)

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceFTUXChipExhaustedTelemetry)

local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)

local PROMPT_CHIPS_STATUS = promptChipsStatus.PROMPT_CHIPS_STATUS
local v = FIntBuildPromptChipEditDebounceMs / 1000
local function getChipClickParameters(data, value: string, p)
	local chips = data.getChips()
	local index = table.find(chips, p)
	local chipClickParameters = { chipText = p.value, index = 0, chipCount = 0, hasPrompt = 0 }
	local v2

	if index ~= nil then
		v2 = tostring(index)
	end

	chipClickParameters.index = v2
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

	local v2 = React.useCallback(function(p, callback)
		local lastTime = os.clock()
		data.requestChips(p, callback, function(p2)
			local v2 = math.max(0, (math.round((os.clock() - lastTime) * 1000)))
			sendBuildExperienceEvent("CHIP_LOAD", telemetryGranularity, {
				elapsedMs = tostring(v2),
				succeeded = tostring(p2)
			})
		end)
	end, { data, telemetryGranularity })

	local v3 = React.useCallback(function()
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

		v3()
		ref2.current = nil
		ref3.current = nil
		ref4.current = nil

		if ref5.current then
			ref5.current = false
			data.reset()
		end
	end, { data, isActive, v3 })

	React.useEffect(function()
		if not isActive then
			return
		end

		if ref4.current ~= nil and ref4.current ~= data2.sessionKey then
			v3()
			ref2.current = nil
			ref3.current = nil
			data.reset()
		end

		ref4.current = data2.sessionKey

		if not (data2.shouldRequestInitialChips and ref3.current ~= data2.sessionKey) then
			return
		end

		v3()
		ref3.current = data2.sessionKey
		ref2.current = ""
		v2({ prompt = "" })
	end, { data, isActive, data2.sessionKey, data2.shouldRequestInitialChips, v3, v2 })

	React.useEffect(function()
		return function()
			v3()
			ref2.current = nil
			ref3.current = nil
			ref4.current = nil
			ref5.current = false
			data.reset()
		end
	end, { data, v3 })

	local requestChipsForEdit = React.useCallback(function(value: string)
		if not isActive then
			return
		end

		v3()

		local v4 = string.match(value, "^%s*(.-)%s*$") or ""

		if v4 == ref2.current then
			local status = data.getStatus()

			if status ~= PROMPT_CHIPS_STATUS.Idle and status ~= PROMPT_CHIPS_STATUS.Failed then
				return
			end
		end

		ref.current = task.delay(v, function()
			ref.current = nil
			ref2.current = v4

			sendBuildExperienceEvent("CHIP_PROMPT_EDIT", telemetryGranularity)
			v2({ prompt = v4 })
		end)
	end, { data, isActive, v3, v2, telemetryGranularity })

	local useCallback = React.useCallback
	local function fn(prompt: string, selectedChip, callback)
		if not isActive then
			return
		end

		v3()
		ref2.current = nil
		local v4

		if FFlagBuildExperienceEventContextTelemetry then
			v4 = getChipClickParameters(data, prompt, selectedChip)
		end

		sendBuildExperienceEvent("CHIP_CLICK", telemetryGranularity, v4)

		v2({ prompt = prompt, selectedChip = selectedChip }, callback)
	end

	local v4

	if FFlagBuildExperienceEventContextTelemetry then
		v4 = data
	end

	local requestChipsForSelection = useCallback(fn, { isActive, v3, v2, telemetryGranularity, v4 })
	local onChipExhausted

	if FFlagBuildExperienceFTUXChipExhaustedTelemetry then
		onChipExhausted = React.useCallback(function()
			if isActive then
				sendBuildExperienceEvent("CHIP_EXHAUSTED", telemetryGranularity)
			end
		end, { isActive, telemetryGranularity })
	end

	return {
		requestChipsForEdit = requestChipsForEdit,
		requestChipsForSelection = requestChipsForSelection,
		onChipExhausted = onChipExhausted
	}
end

return useBuildPromptChipRequests
