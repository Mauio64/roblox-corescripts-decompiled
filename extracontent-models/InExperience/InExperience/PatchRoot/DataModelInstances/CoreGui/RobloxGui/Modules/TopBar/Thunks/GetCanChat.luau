local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local parent = script.Parent.Parent
local SetCanChat = require(parent.Actions.SetCanChat)

local FFlagTopBarDeprecateChatRodux = require(parent.Flags.FFlagTopBarDeprecateChatRodux)

if FFlagTopBarDeprecateChatRodux then
	return nil
end

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

return function(object)
	coroutine.wrap(function()
		local v

		if RunService:IsStudio() then
			v = true
		else
			local success, result = pcall(function()
				return Chat:CanUserChatAsync(LocalPlayer.UserId)
			end)
			v = success and result
		end

		object:dispatch(SetCanChat(v))

		if not v then
			ChatSelector:SetVisible(false)
		end
	end)()
end
