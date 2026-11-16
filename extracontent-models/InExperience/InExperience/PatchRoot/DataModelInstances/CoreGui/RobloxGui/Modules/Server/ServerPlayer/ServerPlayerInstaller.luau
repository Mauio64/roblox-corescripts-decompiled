local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)

return function()
	local StarterPlayer = game:GetService("StarterPlayer")

	if StarterPlayer:FindFirstChild("PlayerSettings") == nil then
		local playerSettings = Instance.new("ModuleScript")
		playerSettings.Name = "PlayerSettings"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			playerSettings.Source = ServerUtil.getSourceForServerScript(script.Parent.DefaultServerPlayerModules:WaitForChild("PlayerSettings"))
		else
			playerSettings.Source = script.Parent.DefaultServerPlayerModules:WaitForChild("PlayerSettings").Source
		end

		playerSettings.Parent = game:GetService("StarterPlayer")
		playerSettings.Archivable = false
	end
end
