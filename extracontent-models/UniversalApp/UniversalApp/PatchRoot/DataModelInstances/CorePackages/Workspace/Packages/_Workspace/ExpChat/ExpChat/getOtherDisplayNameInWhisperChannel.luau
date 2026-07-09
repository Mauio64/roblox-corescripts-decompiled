local Players = game:GetService("Players")

local function getOtherDisplayNameInWhisperChannel(p1, p2) -- line: 3
	-- upvalues: Players (copy)
	for _, child in ipairs(p1:GetChildren()) do
		if not child:IsA("TextSource") then
			continue
		end

		local UserId = child.UserId
		local PlayerByUserId = Players:GetPlayerByUserId(UserId)

		if PlayerByUserId and PlayerByUserId ~= p2 then
			return PlayerByUserId.DisplayName
		end
	end

	return nil
end

return getOtherDisplayNameInWhisperChannel
