local Players = game:GetService("Players")

game:DefineFastString("DSAReportingAndTransparencyOverrideUserIds", "")

function LUAUFORGE_MODULE_GLOBALS_dak_isInDSAFeaturesOverrideList(p2): boolean
	local v5 = 0

	if p2 == nil then
		local localPlayer = Players.LocalPlayer

		while not localPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			localPlayer = Players.LocalPlayer
		end

		if localPlayer then
			v5 = localPlayer.UserId
		end
	else
		v5 = p2
	end

	for k in game:GetFastString("DSAReportingAndTransparencyOverrideUserIds"):gmatch("%d+") do
		if tonumber(k) == v5 then
			return true
		end
	end

	return false
end

return LUAUFORGE_MODULE_GLOBALS_dak_isInDSAFeaturesOverrideList
