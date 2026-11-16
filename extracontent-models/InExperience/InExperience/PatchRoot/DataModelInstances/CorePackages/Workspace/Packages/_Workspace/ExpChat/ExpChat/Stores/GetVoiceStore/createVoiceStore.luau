local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local VoiceChat = require(parent.VoiceChat)
local VOICE_STATE = VoiceChat.Constants.VOICE_STATE

local function createVoiceStore()
	local signal, v = createSignal({})

	local v2 = {}

	local function getKey(p) -- 5 equivalent calls inferred from this helper
		return (tostring(p))
	end

	return {
		getOrCreateVoiceState = function(p)
			local key = getKey(p) -- inferred equivalent call

			if not v2[key] then
				v2[key] = createComputed(function(p2)
					return signal(p2)[key]
				end)
			end

			return v2[key]
		end,
		getVoiceParticipants = signal,
		handleVoiceParticipantAdded = function(p)
			local key = getKey(p) -- inferred equivalent call
			v(function(p2)
				local clone = table.clone(p2)
				clone[key] = clone[key] or VOICE_STATE.HIDDEN

				return clone
			end)
		end,
		handleVoiceParticipantRemoved = function(p)
			local key = getKey(p) -- inferred equivalent call
			v(function(p2)
				if v2[key] then
					v2[key] = nil
				end

				local clone = table.clone(p2)
				clone[key] = nil
				return clone
			end)
		end,
		handleVoiceParticipantsChanged = function(items)
			v(function(p)
				local clone = table.clone(p)

				for k, item in items do
					local v3 = VOICE_STATE.INACTIVE

					if item.subscriptionCompleted then
						if item.isMutedLocally then
							v3 = VOICE_STATE.LOCAL_MUTED
						elseif item.isMuted then
							v3 = VOICE_STATE.MUTED
						elseif item.isSignalActive then
							v3 = VOICE_STATE.TALKING
						end
					else
						v3 = VOICE_STATE.CONNECTING
					end

					clone[getKey(k)] = v3 -- inferred equivalent call
				end

				return clone
			end)
		end,
		handleVoiceStateChanged = function(p, p2: string?)
			local key = getKey(p) -- inferred equivalent call
			v(function(p3)
				if not p3[key] then
					return p3
				end

				local clone = table.clone(p3)
				clone[key] = p2
				return clone
			end)
		end
	}
end

return createVoiceStore
