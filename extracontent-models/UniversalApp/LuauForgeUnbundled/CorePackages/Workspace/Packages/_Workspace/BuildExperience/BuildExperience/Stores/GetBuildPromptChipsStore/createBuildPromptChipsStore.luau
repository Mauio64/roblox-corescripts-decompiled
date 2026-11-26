local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local PROMPT_CHIPS_STATUS = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptChipsStore/promptChipsStatus").PROMPT_CHIPS_STATUS

local function createBuildPromptChipsStore(p2)
	local v5

	if p2 == nil or p2.requestSuggestions == nil then
		v5 = CreatorAgentChat.requestBuildSuggestions
	else
		v5 = p2.requestSuggestions
	end

	local signal, v6 = Signals.createSignal({})

	local signal2, v7 = Signals.createSignal(PROMPT_CHIPS_STATUS.Idle)

	local fn = nil
	local count = 0

	local function cancel()
		count += 1

		if fn ~= nil then
			fn()
			fn = nil
		end
	end

	local function requestChips(p3, callback, callback2)
		count += 1

		if fn ~= nil then
			fn()
			fn = nil
		end

		local v8 = count
		v7(PROMPT_CHIPS_STATUS.Loading)

		local v10 = { prompt = p3.prompt, selectedChip = 0 }
		local v11 = if p3.selectedChip ~= nil then p3.selectedChip.value else nil
		v10.selectedChip = v11
		local v12 = v5(v10)

		local v13 = false
		local effect = Signals.createEffect(function(p4)
			local state = v12.state(p4)

			if v13 or state.status == "pending" then
				return
			end

			v13 = true

			local result = state.result

			if state.status == "succeeded" and result ~= nil then
				v6(result.chips)
				v7(PROMPT_CHIPS_STATUS.Succeeded)

				if result.prompt ~= nil and callback ~= nil then
					callback(result.prompt)
				end

				if callback2 ~= nil then
					callback2(true)
				end
			else
				v6({})
				v7(PROMPT_CHIPS_STATUS.Failed)

				if callback2 ~= nil then
					callback2(false)
				end
			end
		end)

		if v8 == count then
			fn = function()
				effect()
				v12.dispose()
			end
			return
		end

		effect()
		v12.dispose()
	end

	local function reset()
		count += 1

		if fn ~= nil then
			fn()
			fn = nil
		end

		v6({})
		v7(PROMPT_CHIPS_STATUS.Idle)
	end

	return {
		getChips = signal,
		getStatus = signal2,
		requestChips = requestChips,
		reset = reset
	}
end

return createBuildPromptChipsStore
