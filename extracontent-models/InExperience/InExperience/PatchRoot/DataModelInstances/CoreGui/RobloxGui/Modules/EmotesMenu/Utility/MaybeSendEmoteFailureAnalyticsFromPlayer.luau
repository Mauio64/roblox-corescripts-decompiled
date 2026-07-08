local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

local function MaybeSendEmoteFailureAnalyticsFromPlayer(p1, p2) -- line: 16
	-- upvalues: Constants (copy)
	local Character = p1.Character

	if not Character then
		p2(Constants.ErrorTypes.TemporarilyUnavailable)

		return true
	end

	local v7 = Character and Character:FindFirstChildOfClass("Humanoid") or nil

	if not v7 then
		p2(Constants.ErrorTypes.TemporarilyUnavailable)

		return true
	end

	if v7 and v7.RigType ~= Enum.HumanoidRigType.R15 then
		p2(Constants.ErrorTypes.SwitchToR15)

		return true
	end

	local v8 = Character and Character:FindFirstChild("Animate") or nil
	local v9 = v7 and v7:FindFirstChildOfClass("HumanoidDescription") or nil

	if not v8 or not v9 then
		p2(Constants.ErrorTypes.NotSupported)

		return true
	end

	local v10 = v8 and v8:FindFirstChild("PlayEmote") or nil

	if not v10 or not v10:IsA("BindableFunction") then
		p2(Constants.ErrorTypes.NotSupported)

		return true
	end

	return false
end

return MaybeSendEmoteFailureAnalyticsFromPlayer
