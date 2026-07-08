local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ServerUtil = require(RobloxGui.Modules.Server.ServerUtil)

return function() -- line: 5
	-- upvalues: ServerUtil (copy)
	if game:GetService("StarterPlayer"):FindFirstChild("PlayerSettings") == nil then
		local ModuleScript = Instance.new("ModuleScript")

		ModuleScript.Name = "PlayerSettings"

		if ServerUtil.getFFlagServerCoreScriptSourceCode() then
			ModuleScript.Source = ServerUtil.getSourceForServerScript(script.Parent.DefaultServerPlayerModules:WaitForChild("PlayerSettings"))
		else
			ModuleScript.Source = script.Parent.DefaultServerPlayerModules:WaitForChild("PlayerSettings").Source
		end

		ModuleScript.Parent = game:GetService("StarterPlayer")
		ModuleScript.Archivable = false
	end
end
