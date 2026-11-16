local StarterGui = game:GetService("StarterGui")
local Util = require(script.Parent:WaitForChild("Util"))

function ProcessMessage(value, _, _): boolean
	if string.sub(value, 1, 8):lower() ~= "/console" and string.sub(value, 1, 11):lower() ~= "/newconsole" then
		return false
	end

	local success, result = pcall(function()
		return StarterGui:GetCore("DevConsoleVisible")
	end)

	if success then
		local success2, result2 = pcall(function()
			StarterGui:SetCore("DevConsoleVisible", not result)
		end)

		if not success2 and result2 then
			print("Error making developer console visible: " .. result2)
		end
	end

	return true
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
