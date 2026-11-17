local parent = script:FindFirstAncestor("SocialCards").Parent

local Foundation = require(parent.Foundation)

local IconName = Foundation.Enums.IconName

local CallCardStatus = require(script.Parent.CallCardStatus)

local function formatDuration(durationSeconds: number) -- 1 equivalent call inferred from this helper
	if durationSeconds >= 60 then
		return `{math.floor(durationSeconds / 60)} min`
	end

	return `{durationSeconds} sec`
end

local function mapCallCard(data, onActivated, callback, callback2)
	local isRinging = data.status == CallCardStatus.Ringing or data.status == CallCardStatus.Active
	local icon

	if data.isInitiator then
		icon = IconName.PhoneArrowDiagonalUp
	else
		icon = IconName.PhoneArrowDiagonalDown
	end

	local title = "Voice call"
	local description

	if isRinging then
		description = "Ringing"

		if data.isInitiator then
			onActivated = nil
		end
	elseif data.status == CallCardStatus.Ongoing then
		onActivated = callback2
		description = "Ongoing"
	elseif data.status == CallCardStatus.Answered or data.status == CallCardStatus.Ended then
		if data.durationSeconds ~= nil then
			description = formatDuration(data.durationSeconds) -- inferred equivalent call
		end

		onActivated = callback
	elseif data.isInitiator then
		onActivated = callback
		description = "No answer"
	else
		onActivated = callback
		title = "Missed voice call"
		description = "Tap to call back"
	end

	return {
		icon = icon,
		title = title,
		description = description,
		isRinging = isRinging,
		onActivated = onActivated
	}
end

return mapCallCard
