local parent = script.Parent.Parent

local Constants = require(parent.Constants)

local function MaybeSendEmoteFailureAnalyticsFromPlayer(player, callback): boolean
	local character = player.Character

	if not character then
		callback(Constants.ErrorTypes.TemporarilyUnavailable)
		return true
	end

	local humanoid

	if character then
		humanoid = character:FindFirstChildOfClass("Humanoid") or nil
	end

	if not humanoid then
		callback(Constants.ErrorTypes.TemporarilyUnavailable)
		return true
	end

	if humanoid and humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		callback(Constants.ErrorTypes.SwitchToR15)
		return true
	end

	local animate = character and character:FindFirstChild("Animate") or nil
	local humanoidDescription = humanoid and humanoid:FindFirstChildOfClass("HumanoidDescription") or nil

	if not (animate and humanoidDescription) then
		callback(Constants.ErrorTypes.NotSupported)
		return true
	end

	local playEmote = animate and animate:FindFirstChild("PlayEmote") or nil

	if playEmote and playEmote:IsA("BindableFunction") then
		return false
	end

	callback(Constants.ErrorTypes.NotSupported)
	return true
end

return MaybeSendEmoteFailureAnalyticsFromPlayer
