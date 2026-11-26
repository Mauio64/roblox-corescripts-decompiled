local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/React")
local Players = game:GetService("Players")
local v5 = nil
pcall(function()
	local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
	v5 = ThirdPartyUserService
end)
local GamepadDisconnectedModalView = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/GamepadDisconnectedModalView")

local function getPlatformOrRobloxUsername()
	local v6 = not v5 and "" or v5:GetUserPlatformName()

	if v6 == "" or v6 == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer then
			v6 = localPlayer.DisplayName or localPlayer.Name
		end
	end

	return v6 or ""
end

return function(p2)
	local v6 = not v5 and "" or v5:GetUserPlatformName()

	if v6 == "" or v6 == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer then
			v6 = localPlayer.DisplayName or localPlayer.Name
		end
	end

	return React.createElement(GamepadDisconnectedModalView, {
		username = v6 or ""
	})
end
