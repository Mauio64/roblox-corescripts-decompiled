local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StudioService

if RunService:IsStudio() then
	StudioService = game:GetService("StudioService")
else
	StudioService = nil
end

local function useLocalUserId(p)
	local v = p or Players

	if v.LocalPlayer then
		return v.LocalPlayer.UserId
	end

	if StudioService then
		return StudioService:GetUserId()
	end

	return 0
end

return useLocalUserId
