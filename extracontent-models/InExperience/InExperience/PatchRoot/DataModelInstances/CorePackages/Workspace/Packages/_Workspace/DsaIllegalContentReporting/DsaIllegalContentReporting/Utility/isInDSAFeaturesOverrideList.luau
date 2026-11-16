local Players = game:GetService("Players")

game:DefineFastString("DSAReportingAndTransparencyOverrideUserIds", "")

function isInDSAFeaturesOverrideList(p: number?): boolean
	local v = 0

	if p == nil then
		local localPlayer = Players.LocalPlayer

		while not localPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			localPlayer = Players.LocalPlayer
		end

		if localPlayer then
			v = localPlayer.UserId
		end
	else
		v = p
	end

	for k in game:GetFastString("DSAReportingAndTransparencyOverrideUserIds"):gmatch("%d+") do
		if tonumber(k) == v then
			return true
		end
	end

	return false
end

return isInDSAFeaturesOverrideList
