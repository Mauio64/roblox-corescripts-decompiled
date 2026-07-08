local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local v3 = if not RunService:IsStudio() then nil else game:GetService("StudioService")

local function useLocalUserId(p1) -- line: 5
	-- upvalues: Players (copy), v3 (copy)
	local v6 = p1 or Players

	if v6.LocalPlayer then
		return v6.LocalPlayer.UserId
	end

	if v3 then
		return v3:GetUserId()
	end

	return 0
end

return useLocalUserId
