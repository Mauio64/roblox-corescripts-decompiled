local Players = game:GetService("Players")

local function getOtherDisplayNameInWhisperChannel(instance, p)
	for _, textSource in ipairs(instance:GetChildren()) do
		if not textSource:IsA("TextSource") then
			continue
		end

		local playerByUserId = Players:GetPlayerByUserId(textSource.UserId)

		if playerByUserId and playerByUserId ~= p then
			return playerByUserId.DisplayName
		end
	end

	return nil
end

return getOtherDisplayNameInWhisperChannel
