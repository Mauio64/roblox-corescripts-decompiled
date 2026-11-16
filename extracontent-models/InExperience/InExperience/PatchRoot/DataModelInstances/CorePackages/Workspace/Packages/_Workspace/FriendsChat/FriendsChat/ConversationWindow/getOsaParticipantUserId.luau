local getLocalUserId = require(script.Parent.Parent.Utils.getLocalUserId)

local function getOtherParticipantUserId(participants)
	if participants == nil then
		return nil
	end

	local localUserId = getLocalUserId()
	local v

	if localUserId ~= nil then
		v = tostring(localUserId)
	end

	for _, item in participants do
		if tostring(item) ~= v then
			return (tostring(item))
		end
	end

	return nil
end

local function getOsaParticipantUserId(data)
	local v

	if data then
		if data.type == "one_to_one" then
			v = data.source == "friends"
				or data.osaAcknowledgementStatus == "acknowledged"
				or data.osaAcknowledgementStatus == "unacknowledged"
		else
			v = false
		end
	else
		v = data
	end

	if v and data then
		return getOtherParticipantUserId(data.participants)
	end

	return nil
end

return getOsaParticipantUserId
