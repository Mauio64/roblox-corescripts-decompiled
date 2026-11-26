local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local function computeChannelId(p2)
	if not p2 then
		return ""
	end

	if game:GetEngineFeature("VoiceChatServiceExposesChannelId") and p2.service then
		return (tostring(p2.service:GetChannelId()))
	end

	if p2.service then
		return (tostring(p2.service:GetGroupId()))
	end

	return ""
end

local function buildState(p2)
	local v5 = {}

	if p2 and p2.participants then
		for k in pairs(p2.participants) do
			local v6 = tonumber(k)

			if v6 then
				table.insert(v5, v6)
			end
		end

		table.sort(v5)
	end

	local v6

	if p2 then
		if game:GetEngineFeature("VoiceChatServiceExposesChannelId") and p2.service then
			v6 = tostring(p2.service:GetChannelId())
		else
			v6 = not p2.service and "" or tostring(p2.service:GetGroupId())
		end
	else
		v6 = ""
	end

	return {
		sortedPlayerListUserIds = v5,
		channelId = v6,
		voiceUserCount = #v5
	}
end

return {
	useVoiceSnapshot = function(p2)
		local ref = React.useRef(buildState(p2))

		React.useEffect(function()
			if not p2 then
				return
			end

			ref.current = buildState(p2)

			local eventConnection = p2.participantsUpdate.Event:Connect(function()
				ref.current = buildState(p2)
			end)

			return function()
				eventConnection:Disconnect()
			end
		end, { p2 })

		return ref
	end
}
