local AvatarEditorService = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")

local parent = script.Parent.Parent
local FFlagTopBarDeprecateRespawnRodux = require(parent.Flags.FFlagTopBarDeprecateRespawnRodux)

if FFlagTopBarDeprecateRespawnRodux then
	return nil
end

return function(object)
	local state = object:getState()

	AvatarEditorService:BustAvatarFetchCache()

	if state.respawn.customCallback then
		state.respawn.customCallback:Fire()
		return
	end

	local character = Players.LocalPlayer.Character

	if character ~= nil then
		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid ~= nil and humanoid:IsA("Humanoid") then
			humanoid.Health = 0
		end
	end
end
