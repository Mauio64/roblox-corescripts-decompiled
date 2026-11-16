local iconName = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation").Enums.IconName

local CallCardStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/CallCardStatus")

local function formatDuration(p2)
	if p2 >= 60 then
		return `{math.floor(p2 / 60)} min`
	end

	return `{p2} sec`
end

local function mapCallCard(data, p2, p3)
	local v5 = data.status == CallCardStatus.Ringing or data.status == CallCardStatus.Active
	local v6

	if data.isInitiator then
		v6 = iconName.PhoneArrowDiagonalUp
	else
		v6 = iconName.PhoneArrowDiagonalDown
	end

	local v7 = "Voice call"

	local v8 = nil
	local v9

	if v5 then
		v9 = "Ringing"
	elseif data.status == CallCardStatus.Ongoing then
		v9 = "Ongoing"

		if data.enableJoin then
			v8 = p2
		end
	elseif data.status == CallCardStatus.Answered or data.status == CallCardStatus.Ended then
		if data.durationSeconds ~= nil then
			local durationSeconds = data.durationSeconds

			if durationSeconds >= 60 then
				v9 = `{math.floor(durationSeconds / 60)} min`
			else
				v9 = `{durationSeconds} sec`
			end
		end
	elseif data.isInitiator then
		v9 = "No answer"
	else
		v8 = p3
		v7 = "Missed voice call"
		v9 = "Tap to call back"
	end

	return {
		icon = v6,
		title = v7,
		description = v9,
		isRinging = v5,
		onActivated = v8
	}
end

return mapCallCard
