local parent = script:FindFirstAncestor("InputUi").Parent
local React = require(parent.React)
local Players = game:GetService("Players")
local v = nil
pcall(function()
	local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
	v = ThirdPartyUserService
end)
local GamepadDisconnectedModalView = require(script.Parent.GamepadDisconnectedModalView)

local function getPlatformOrRobloxUsername()
	local v2 = not v and "" or v:GetUserPlatformName()

	if v2 == "" or v2 == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer then
			v2 = localPlayer.DisplayName or localPlayer.Name
		end
	end

	return v2 or ""
end

return function(_)
	local v2 = not v and "" or v:GetUserPlatformName()

	if v2 == "" or v2 == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer then
			v2 = localPlayer.DisplayName or localPlayer.Name
		end
	end

	return React.createElement(GamepadDisconnectedModalView, {
		username = v2 or ""
	})
end
