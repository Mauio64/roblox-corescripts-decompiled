local Players = game:GetService("Players")

local Moments = script:FindFirstAncestor("Moments")

local GetFStringMomentsDebugModeAllowList = require(Moments.Flags.GetFStringMomentsDebugModeAllowList)
local parseUserAllowList = require(Moments.Utils.parseUserAllowList)

local function checkDebugAccess()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return parseUserAllowList(GetFStringMomentsDebugModeAllowList(), localPlayer.UserId)
	end

	return false
end

return checkDebugAccess
