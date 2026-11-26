local Players = game:GetService("Players")

local function getOtherDisplayNameInWhisperChannel(instance, p2)
	for i, textSource in ipairs(instance:GetChildren()) do
		if not textSource:IsA("TextSource") then
			continue
		end

		local playerByUserId = Players:GetPlayerByUserId(textSource.UserId)

		if playerByUserId and playerByUserId ~= p2 then
			return playerByUserId.DisplayName
		end
	end

	return nil
end

return getOtherDisplayNameInWhisperChannel
