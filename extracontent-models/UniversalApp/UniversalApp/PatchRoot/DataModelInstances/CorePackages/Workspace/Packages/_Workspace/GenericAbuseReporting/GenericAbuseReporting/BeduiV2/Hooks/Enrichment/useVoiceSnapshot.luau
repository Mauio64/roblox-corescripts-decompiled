local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)

local function computeChannelId(p1) -- line: 16
	if not p1 then
		return ""
	end

	if game:GetEngineFeature("VoiceChatServiceExposesChannelId") and p1.service then
		return (tostring(p1.service:GetChannelId()))
	end

	if p1.service then
		return (tostring(p1.service:GetGroupId()))
	end

	return ""
end
local function buildState(p2) -- line: 28
	local t1 = {}

	if p2 and p2.participants then
		for k in pairs(p2.participants) do
			local num = tonumber(k)

			if num then
				table.insert(t1, num)
			end
		end

		table.sort(t1)
	end

	return {
		sortedPlayerListUserIds = t1,
		channelId = if p2 then if not game:GetEngineFeature("VoiceChatServiceExposesChannelId") or not p2.service then not p2.service and "" or tostring(p2.service:GetGroupId()) else tostring(p2.service:GetChannelId()) else "",
		voiceUserCount = #t1
	}
end

return {
	useVoiceSnapshot = function(p3) -- line: 53
		-- upvalues: React (copy), buildState (copy)
		local v11 = React.useRef((buildState(p3)))

		React.useEffect(function() -- line: 56
			-- upvalues: p3 (copy), v11 (copy), buildState (copy)
			if not p3 then
				return
			end

			v11.current = buildState(p3)

			local connection = p3.participantsUpdate.Event:Connect(function() -- line: 63
				-- upvalues: v11 (copy), buildState (copy), p3 (copy)
				v11.current = buildState(p3)
			end)

			return function() -- line: 67
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { p3 })

		return v11
	end
}
