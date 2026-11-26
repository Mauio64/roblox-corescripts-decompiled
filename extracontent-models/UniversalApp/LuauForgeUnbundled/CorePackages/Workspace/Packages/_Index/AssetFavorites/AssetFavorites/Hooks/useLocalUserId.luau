local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StudioService = if RunService:IsStudio() then game:GetService("StudioService") else nil

local function useLocalUserId(p2)
	local v5 = p2 or Players

	if v5.LocalPlayer then
		return v5.LocalPlayer.UserId
	end

	if StudioService then
		return StudioService:GetUserId()
	end

	return 0
end

return useLocalUserId
