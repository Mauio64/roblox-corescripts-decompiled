local iconName = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation").Enums.IconName

local CallCardStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/CallCardStatus")

local function formatDuration(p2)
	if p2 >= 60 then
		return `{math.floor(p2 / 60)} min`
	end

	return `{p2} sec`
end

local function mapCallCard(data, onActivated, p2, p3)
	local v5 = data.status == CallCardStatus.Ringing or data.status == CallCardStatus.Active
	local v6

	if data.isInitiator then
		v6 = iconName.PhoneArrowDiagonalUp
	else
		v6 = iconName.PhoneArrowDiagonalDown
	end

	local v7 = "Voice call"
	local v8

	if v5 then
		v8 = "Ringing"

		if data.isInitiator then
			onActivated = nil
		end
	elseif data.status == CallCardStatus.Ongoing then
		onActivated = p3
		v8 = "Ongoing"
	elseif data.status == CallCardStatus.Answered or data.status == CallCardStatus.Ended then
		if data.durationSeconds ~= nil then
			local durationSeconds = data.durationSeconds

			if durationSeconds >= 60 then
				v8 = `{math.floor(durationSeconds / 60)} min`
			else
				v8 = `{durationSeconds} sec`
			end
		end

		onActivated = p2
	elseif data.isInitiator then
		onActivated = p2
		v8 = "No answer"
	else
		onActivated = p2
		v7 = "Missed voice call"
		v8 = "Tap to call back"
	end

	return {
		icon = v6,
		title = v7,
		description = v8,
		isRinging = v5,
		onActivated = onActivated
	}
end

return mapCallCard
