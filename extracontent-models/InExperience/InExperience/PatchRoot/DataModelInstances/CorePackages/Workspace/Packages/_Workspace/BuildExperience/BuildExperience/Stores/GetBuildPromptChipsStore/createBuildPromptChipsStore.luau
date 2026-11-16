local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Signals = require(parent.Signals)

require(BuildExperience.Chat.chatTypes)
local promptChipsStatus = require(script.Parent.promptChipsStatus)

local PROMPT_CHIPS_STATUS = promptChipsStatus.PROMPT_CHIPS_STATUS

local function createBuildPromptChipsStore(p)
	local v

	if p == nil or p.requestSuggestions == nil then
		v = CreatorAgentChat.requestBuildSuggestions
	else
		v = p.requestSuggestions
	end

	local signal, v2 = Signals.createSignal({})

	local signal2, v3 = Signals.createSignal(PROMPT_CHIPS_STATUS.Idle)

	local fn = nil
	local count = 0

	local function cancel() -- 2 equivalent calls inferred from this helper
		count += 1

		if fn ~= nil then
			fn()
			fn = nil
		end
	end

	local function requestChips(p2, callback, callback2)
		cancel() -- inferred equivalent call
		local v4 = count
		v3(PROMPT_CHIPS_STATUS.Loading)

		local v5 = { prompt = p2.prompt, selectedChip = 0 }
		local selectedChip

		if p2.selectedChip ~= nil then
			selectedChip = p2.selectedChip.value
		end

		v5.selectedChip = selectedChip
		local v6 = v(v5)

		local v7 = false
		local effect = Signals.createEffect(function(p3)
			local state = v6.state(p3)

			if v7 or state.status == "pending" then
				return
			end

			v7 = true

			local result = state.result

			if state.status == "succeeded" and result ~= nil then
				v2(result.chips)
				v3(PROMPT_CHIPS_STATUS.Succeeded)

				if result.prompt ~= nil and callback ~= nil then
					callback(result.prompt)
				end

				if callback2 ~= nil then
					callback2(true)
				end
			else
				v2({})
				v3(PROMPT_CHIPS_STATUS.Failed)

				if callback2 ~= nil then
					callback2(false)
				end
			end
		end)

		if v4 == count then
			fn = function()
				effect()
				v6.dispose()
			end
			return
		end

		effect()
		v6.dispose()
	end

	local function reset()
		cancel() -- inferred equivalent call
		v2({})
		v3(PROMPT_CHIPS_STATUS.Idle)
	end

	return { getChips = signal, getStatus = signal2, requestChips = requestChips, reset = reset }
end

return createBuildPromptChipsStore
