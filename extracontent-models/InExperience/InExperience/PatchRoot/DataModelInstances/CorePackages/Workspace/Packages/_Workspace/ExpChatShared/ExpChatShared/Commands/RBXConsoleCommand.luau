local StarterGui = game:GetService("StarterGui")

require(script.Parent.types)
return {
	name = script.Name,
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
