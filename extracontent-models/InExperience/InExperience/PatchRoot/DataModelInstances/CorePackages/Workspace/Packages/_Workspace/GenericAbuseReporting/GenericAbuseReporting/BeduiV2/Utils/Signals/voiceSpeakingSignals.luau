local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local context = React.createContext(nil)

local function createVoiceSpeakingStore()
	local signal, v = Signals.createSignal({})
	local v2 = {}
	local v3 = {}

	local function pruneCache() -- 1 equivalent call inferred from this helper
		local now = os.clock()

		for k, v4 in v3 do
			if not (now - v4 > 300) then
				continue
			end

			v2[k] = nil
			v3[k] = nil
		end
	end

	return {
		getIsSpeaking = function(p: string)
			v3[p] = os.clock()

			if not v2[p] then
				v2[p] = Signals.createComputed(function(p2): boolean
					return signal(p2)[p] == true
				end)
			end

			return v2[p]
		end,
		setParticipants = function(p)
			pruneCache() -- inferred equivalent call
			v(p)
		end
	}
end

local function buildParticipantsMap(items)
	local participantsMap = {}

	for k, item in pairs(items) do
		participantsMap[tostring(k)] = item.isSignalActive == true
	end

	return participantsMap
end

return {
	useVoiceSpeakingStore = function()
		local v = React.useContext(context)

		local ref = React.useRef(nil)

		if not ref.current then
			ref.current = createVoiceSpeakingStore()
		end

		local current = ref.current

		React.useEffect(function()
			if not v then
				return
			end

			if v.participants then
				current.setParticipants(buildParticipantsMap(v.participants))
			end

			local eventConnection = v.participantsUpdate.Event:Connect(function(p)
				current.setParticipants(buildParticipantsMap(p))
			end)

			return function()
				eventConnection:Disconnect()
			end
		end, { v, current.setParticipants })

		return current
	end,
	createVoiceSpeakingStore = createVoiceSpeakingStore,
	VoiceChatServiceManagerContext = context
}
