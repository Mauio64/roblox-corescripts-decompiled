local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local VOICE_STATE = require(Parent.VoiceChat).Constants.VOICE_STATE

local function createVoiceStore() -- line: 26
	-- upvalues: createSignal (copy), createComputed (copy), VOICE_STATE (copy)
	local v7, v8 = createSignal({})
	local t1 = {}

	local function getKey(p1) -- line: 32
		return (tostring(p1))
	end

	return {
		getOrCreateVoiceState = function(p2) -- line: 36
			-- upvalues: t1 (copy), createComputed (copy), v7 (copy)
			local str = tostring(p2)

			if not t1[str] then
				t1[str] = createComputed(function(p3) -- line: 39
					-- upvalues: v7 (copy), str (copy)
					return v7(p3)[str]
				end)
			end

			return t1[str]
		end,
		getVoiceParticipants = v7,
		handleVoiceParticipantAdded = function(p4) -- line: 48
			-- upvalues: v8 (copy), VOICE_STATE (copy)
			local str = tostring(p4)

			v8(function(p5) -- line: 51
				-- upvalues: str (copy), VOICE_STATE (copy)
				local v24 = table.clone(p5)

				v24[str] = v24[str] or VOICE_STATE.HIDDEN

				return v24
			end)
		end,
		handleVoiceParticipantRemoved = function(p6) -- line: 61
			-- upvalues: v8 (copy), t1 (copy)
			local str = tostring(p6)

			v8(function(p7) -- line: 64
				-- upvalues: t1 (copy), str (copy)
				if t1[str] then
					t1[str] = nil
				end

				local v26 = table.clone(p7)

				v26[str] = nil

				return v26
			end)
		end,
		handleVoiceParticipantsChanged = function(t2: {[any]: any}) -- line: 75
			-- upvalues: v8 (copy), VOICE_STATE (copy)
			v8(function(p8) -- line: 76
				-- upvalues: t2 (copy), VOICE_STATE (copy)
				local v28 = table.clone(p8)

				for v29, v30 in t2 do
					local INACTIVE = VOICE_STATE.INACTIVE

					if not v30.subscriptionCompleted then
						INACTIVE = VOICE_STATE.CONNECTING
					elseif v30.isMutedLocally then
						INACTIVE = VOICE_STATE.LOCAL_MUTED
					elseif v30.isMuted then
						INACTIVE = VOICE_STATE.MUTED
					elseif v30.isSignalActive then
						INACTIVE = VOICE_STATE.TALKING
					end

					v28[tostring(v29)] = INACTIVE
				end

				return v28
			end)
		end,
		handleVoiceStateChanged = function(p9, s1: string?) -- line: 96
			-- upvalues: v8 (copy)
			local str = tostring(p9)

			v8(function(p10) -- line: 99
				-- upvalues: str (copy), s1 (copy)
				if p10[str] then
					local v33 = table.clone(p10)

					v33[str] = s1

					return v33
				end

				return p10
			end)
		end
	}
end

return createVoiceStore
