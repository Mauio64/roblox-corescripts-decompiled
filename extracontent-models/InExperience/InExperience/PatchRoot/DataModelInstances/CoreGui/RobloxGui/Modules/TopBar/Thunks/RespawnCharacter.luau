local AvatarEditorService = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateRespawnRodux) then
	return nil
end

return function(p1) -- line: 13
	-- upvalues: AvatarEditorService (copy), Players (copy)
	local v5 = p1:getState()

	AvatarEditorService:BustAvatarFetchCache()

	if v5.respawn.customCallback then
		v5.respawn.customCallback:Fire()

		return
	end

	local Character = Players.LocalPlayer.Character

	if Character ~= nil then
		local Humanoid = Character:FindFirstChild("Humanoid")

		if Humanoid ~= nil and Humanoid:IsA("Humanoid") then
			Humanoid.Health = 0
		end
	end
end
