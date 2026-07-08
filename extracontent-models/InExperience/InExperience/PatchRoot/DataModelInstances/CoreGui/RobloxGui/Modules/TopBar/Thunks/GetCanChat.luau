local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ParentParent = script.Parent.Parent
local SetCanChat = require(ParentParent.Actions.SetCanChat)

if require(ParentParent.Flags.FFlagTopBarDeprecateChatRodux) then
	return nil
end

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

return function(p1) -- line: 26
	-- upvalues: RunService (copy), Chat (copy), LocalPlayer (ref), SetCanChat (copy), ChatSelector (copy)
	coroutine.wrap(function() -- line: 27
		-- upvalues: RunService (copy), Chat (copy), LocalPlayer (ref), p1 (copy), SetCanChat (copy), ChatSelector (copy)
		local v11 = true

		if not RunService:IsStudio() then
			local ok, result = pcall(function() -- line: 30
				-- upvalues: Chat (copy), LocalPlayer (ref)
				return Chat:CanUserChatAsync(LocalPlayer.UserId)
			end)

			v11 = ok and result
		end

		p1:dispatch(SetCanChat(v11))

		if not v11 then
			ChatSelector:SetVisible(false)
		end
	end)()
end
