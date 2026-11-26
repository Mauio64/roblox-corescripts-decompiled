local Players = game:GetService("Players")

local GetFStringMomentsDebugModeAllowList = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFStringMomentsDebugModeAllowList")
local parseUserAllowList = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/parseUserAllowList")

local function checkDebugAccess()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return parseUserAllowList(GetFStringMomentsDebugModeAllowList(), localPlayer.UserId)
	end

	return false
end

return checkDebugAccess
