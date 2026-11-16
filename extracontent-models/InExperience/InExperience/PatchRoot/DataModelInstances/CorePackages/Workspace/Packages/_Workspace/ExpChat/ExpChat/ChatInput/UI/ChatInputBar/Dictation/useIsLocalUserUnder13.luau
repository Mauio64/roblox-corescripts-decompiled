local Players = game:GetService("Players")

local function useIsLocalUserUnder13(): boolean
	local localPlayer = Players.LocalPlayer

	return localPlayer ~= nil and localPlayer:GetUnder13() == true
end

return useIsLocalUserUnder13
