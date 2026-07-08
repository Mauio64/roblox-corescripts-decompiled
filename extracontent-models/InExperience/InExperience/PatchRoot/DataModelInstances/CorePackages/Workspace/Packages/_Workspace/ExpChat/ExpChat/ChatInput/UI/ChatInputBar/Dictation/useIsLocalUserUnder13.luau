local Players = game:GetService("Players")

local function useIsLocalUserUnder13() -- line: 15
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer == nil then
		return false
	end

	return LocalPlayer:GetUnder13() == true
end

return useIsLocalUserUnder13
