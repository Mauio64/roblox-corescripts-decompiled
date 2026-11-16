local Players = game:GetService("Players")

local function getWhisperChannelOtherDisplayName(instance, p: string)
	for _, textSource in instance:GetChildren() do
		if not (textSource:IsA("TextSource") and tostring(textSource.UserId) ~= p) then
			continue
		end

		local playerByUserId = Players:GetPlayerByUserId(textSource.UserId)

		if playerByUserId then
			return playerByUserId.DisplayName
		end
	end

	return nil
end

return getWhisperChannelOtherDisplayName
