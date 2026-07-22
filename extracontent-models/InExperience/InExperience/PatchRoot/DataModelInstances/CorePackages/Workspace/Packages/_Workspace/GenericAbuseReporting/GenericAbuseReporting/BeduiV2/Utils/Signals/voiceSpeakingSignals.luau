local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local v4 = React.createContext(nil)

local function createVoiceSpeakingStore() -- line: 17
	-- upvalues: Signals (copy)
	local v7, v8 = Signals.createSignal({})
	local t1 = {}
	local t2 = {}

	local function pruneCache() -- line: 22
		-- upvalues: t2 (copy), t1 (copy)
		local elapsed = os.clock()

		for v20, v21 in t2 do
			if elapsed - v21 > 300 then
				t1[v20] = nil
				t2[v20] = nil
			end
		end
	end

	return {
		getIsSpeaking = function(s1: string) -- line: 32
			-- upvalues: t2 (copy), t1 (copy), Signals (copy), v7 (copy)
			t2[s1] = os.clock()

			if not t1[s1] then
				t1[s1] = Signals.createComputed(function(p1) -- line: 35
					-- upvalues: v7 (copy), s1 (copy)
					return v7(p1)[s1] == true
				end)
			end

			return t1[s1]
		end,
		setParticipants = function(t3: {[any]: any}) -- line: 43
			-- upvalues: t2 (copy), t1 (copy), v8 (copy)
			local elapsed = os.clock()

			for v25, v26 in t2 do
				if elapsed - v26 > 300 then
					t1[v25] = nil
					t2[v25] = nil
				end
			end

			v8(t3)
		end
	}
end
local function buildParticipantsMap(p2) -- line: 54
	local t4 = {}

	for k, v in pairs(p2) do
		t4[tostring(k)] = v.isSignalActive == true
	end

	return t4
end

return {
	useVoiceSpeakingStore = function() -- line: 62
		-- upvalues: React (copy), v4 (copy), createVoiceSpeakingStore (copy), buildParticipantsMap (copy)
		local v16 = React.useContext(v4)
		local v17 = React.useRef(nil)

		if not v17.current then
			v17.current = createVoiceSpeakingStore()
		end

		local current = v17.current

		React.useEffect(function() -- line: 71
			-- upvalues: v16 (copy), current (copy), buildParticipantsMap (copy)
			if not v16 then
				return
			end

			if v16.participants then
				current.setParticipants((buildParticipantsMap(v16.participants)))
			end

			local connection = v16.participantsUpdate.Event:Connect(function(p3) -- line: 80
				-- upvalues: current (copy), buildParticipantsMap (copy)
				current.setParticipants((buildParticipantsMap(p3)))
			end)

			return function() -- line: 84
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {
			v16,
			current.setParticipants
		})

		return current
	end,
	createVoiceSpeakingStore = createVoiceSpeakingStore,
	VoiceChatServiceManagerContext = v4
}
