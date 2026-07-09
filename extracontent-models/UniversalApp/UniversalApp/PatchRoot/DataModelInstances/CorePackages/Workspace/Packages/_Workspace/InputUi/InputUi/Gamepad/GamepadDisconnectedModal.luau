local Parent = script:FindFirstAncestor("InputUi").Parent
local React = require(Parent.React)
local Players = game:GetService("Players")
local ThirdPartyUserService = nil

pcall(function() -- line: 6
	-- upvalues: ThirdPartyUserService (ref)
	ThirdPartyUserService = game:GetService("ThirdPartyUserService")
end)

local GamepadDisconnectedModalView = require(script.Parent.GamepadDisconnectedModalView)

local function getPlatformOrRobloxUsername() -- line: 11
	-- upvalues: ThirdPartyUserService (ref), Players (copy)
	local s1 = ""

	if ThirdPartyUserService then
		s1 = ThirdPartyUserService:GetUserPlatformName()
	end

	if s1 == "" or s1 == nil then
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer then
			s1 = LocalPlayer.DisplayName or LocalPlayer.Name
		end
	end

	return s1 or ""
end

return function(_) -- line: 25
	-- upvalues: ThirdPartyUserService (ref), Players (copy), React (copy), GamepadDisconnectedModalView (copy)
	local s2 = ""

	if ThirdPartyUserService then
		s2 = ThirdPartyUserService:GetUserPlatformName()
	end

	if s2 == "" or s2 == nil then
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer then
			s2 = LocalPlayer.DisplayName or LocalPlayer.Name
		end
	end

	local v12 = s2 or ""

	return React.createElement(GamepadDisconnectedModalView, {
		username = v12
	})
end
