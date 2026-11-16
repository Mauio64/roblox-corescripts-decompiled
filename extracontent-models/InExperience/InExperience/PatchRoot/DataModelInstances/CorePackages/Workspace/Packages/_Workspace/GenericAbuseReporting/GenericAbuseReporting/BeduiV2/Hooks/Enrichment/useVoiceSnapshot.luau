local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local function computeChannelId(p) -- 1 equivalent call inferred from this helper
	if not p then
		return ""
	end

	if game:GetEngineFeature("VoiceChatServiceExposesChannelId") and p.service then
		return (tostring(p.service:GetChannelId()))
	end

	if p.service then
		return (tostring(p.service:GetGroupId()))
	end

	return ""
end

local function buildState(p)
	local sortedPlayerListUserIds = {}

	if p and p.participants then
		for k in pairs(p.participants) do
			local v = tonumber(k)

			if v then
				table.insert(sortedPlayerListUserIds, v)
			end
		end

		table.sort(sortedPlayerListUserIds)
	end

	return {
		sortedPlayerListUserIds = sortedPlayerListUserIds,
		channelId = computeChannelId(p), -- inferred equivalent call
		voiceUserCount = #sortedPlayerListUserIds
	}
end

return {
	useVoiceSnapshot = function(p)
		local ref = React.useRef(buildState(p))

		React.useEffect(function()
			if not p then
				return
			end

			ref.current = buildState(p)

			local eventConnection = p.participantsUpdate.Event:Connect(function()
				ref.current = buildState(p)
			end)

			return function()
				eventConnection:Disconnect()
			end
		end, { p })

		return ref
	end
}
