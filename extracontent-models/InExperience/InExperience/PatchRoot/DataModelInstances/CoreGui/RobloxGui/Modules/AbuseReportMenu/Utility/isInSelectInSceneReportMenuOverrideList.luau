local Players = game:GetService("Players")

game:DefineFastString("SelectInSceneReportMenuOverrideUserIds", "")

function isInSelectInSceneReportMenuOverrideList(): boolean
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		localPlayer = Players.LocalPlayer
	end

	for k in game:GetFastString("SelectInSceneReportMenuOverrideUserIds"):gmatch("%d+") do
		if localPlayer and tonumber(k) == localPlayer.UserId then
			return true
		end
	end

	return false
end

return isInSelectInSceneReportMenuOverrideList
