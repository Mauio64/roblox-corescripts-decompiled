local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Signals")

local context = React.createContext(nil)

local function createVoiceSpeakingStore()
	local signal, v5 = Signals.createSignal({})
	local v6 = {}
	local v7 = {}

	local function pruneCache()
		local now = os.clock()

		for k, v8 in v7 do
			if not (now - v8 > 300) then
				continue
			end

			v6[k] = nil
			v7[k] = nil
		end
	end

	return {
		getIsSpeaking = function(p2)
			v7[p2] = os.clock()

			if not v6[p2] then
				v6[p2] = Signals.createComputed(function(p3): boolean
					return signal(p3)[p2] == true
				end)
			end

			return v6[p2]
		end,
		setParticipants = function(p2)
			local now = os.clock()

			for k, v8 in v7 do
				if not (now - v8 > 300) then
					continue
				end

				v6[k] = nil
				v7[k] = nil
			end

			v5(p2)
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
		local v5 = React.useContext(context)

		local ref = React.useRef(nil)

		if not ref.current then
			ref.current = createVoiceSpeakingStore()
		end

		local current = ref.current

		React.useEffect(function()
			if not v5 then
				return
			end

			if v5.participants then
				current.setParticipants(buildParticipantsMap(v5.participants))
			end

			local eventConnection = v5.participantsUpdate.Event:Connect(function(p2)
				current.setParticipants(buildParticipantsMap(p2))
			end)

			return function()
				eventConnection:Disconnect()
			end
		end, { v5, current.setParticipants })

		return current
	end,
	createVoiceSpeakingStore = createVoiceSpeakingStore,
	VoiceChatServiceManagerContext = context
}
