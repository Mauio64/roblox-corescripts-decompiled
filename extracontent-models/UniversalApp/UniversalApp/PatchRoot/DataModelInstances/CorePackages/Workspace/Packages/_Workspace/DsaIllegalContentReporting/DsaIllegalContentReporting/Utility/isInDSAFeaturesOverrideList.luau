local Players = game:GetService("Players")

game:DefineFastString("DSAReportingAndTransparencyOverrideUserIds", "")

function isInDSAFeaturesOverrideList(n1: number?) -- line: 5
	-- upvalues: Players (copy)
	local n2 = 0

	if n1 ~= nil then
		n2 = n1
	else
		local LocalPlayer = Players.LocalPlayer

		while not LocalPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end

		if LocalPlayer then
			n2 = LocalPlayer.UserId
		end
	end

	for match in game:GetFastString("DSAReportingAndTransparencyOverrideUserIds"):gmatch("%d+") do
		if n2 == tonumber(match) then
			return true
		end
	end

	return false
end

return isInDSAFeaturesOverrideList
