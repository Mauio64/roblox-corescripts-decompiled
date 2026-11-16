local StarterGui = game:GetService("StarterGui")

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")
return {
	name = "RBXConsoleCommand",
	alias = { "/console" },
	clientRun = function(): nil
		local success, result = pcall(function()
			return StarterGui:GetCore("DevConsoleVisible")
		end)

		if success then
			pcall(function()
				StarterGui:SetCore("DevConsoleVisible", not result)
			end)
		end

		return nil
	end
}
