local Players = game:GetService("Players")

return {
	createDefaultCharacter = function(flag: boolean)
		local folder

		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			folder = Players:CreateHumanoidModelFromDescriptionAsync(
				Instance.new("HumanoidDescription"),
				Enum.HumanoidRigType.R15
			)
		else
			folder = game.Players:CreateHumanoidModelFromDescription(
				Instance.new("HumanoidDescription"),
				Enum.HumanoidRigType.R15
			)
		end

		for _, descendant in folder:GetDescendants() do
			if descendant:IsA("Decal") then
				descendant.Transparency = 1
			elseif descendant:IsA("MeshPart") then
				descendant.Transparency = 0
				descendant.CanCollide = false
			elseif descendant:IsA("Motor6D") and flag then
				descendant:Destroy()
			end
		end

		return folder
	end
}
