local Players = game:GetService("Players")
local Moments = script:FindFirstAncestor("Moments")
local GetFStringMomentsDebugModeAllowList = require(Moments.Flags.GetFStringMomentsDebugModeAllowList)
local parseUserAllowList = require(Moments.Utils.parseUserAllowList)

local function checkDebugAccess() -- line: 15
	-- upvalues: Players (copy), parseUserAllowList (copy), GetFStringMomentsDebugModeAllowList (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return false
	end

	return parseUserAllowList(GetFStringMomentsDebugModeAllowList(), LocalPlayer.UserId)
end

return checkDebugAccess
