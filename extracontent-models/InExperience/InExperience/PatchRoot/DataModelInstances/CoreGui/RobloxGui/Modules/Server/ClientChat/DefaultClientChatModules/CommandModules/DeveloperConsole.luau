local StarterGui = game:GetService("StarterGui")
local Util = require(script.Parent:WaitForChild("Util"))

function ProcessMessage(p1, _, _) -- line: 9
	-- upvalues: StarterGui (copy)
	if string.sub(p1, 1, 8):lower() == "/console" or string.sub(p1, 1, 11):lower() == "/newconsole" then
		local ok, result = pcall(function() -- line: 11
			-- upvalues: StarterGui (copy)
			return StarterGui:GetCore("DevConsoleVisible")
		end)

		if ok then
			local ok2, result2 = pcall(function() -- line: 13
				-- upvalues: StarterGui (copy), result (copy)
				StarterGui:SetCore("DevConsoleVisible", not result)
			end)

			if not ok2 and result2 then
				print("Error making developer console visible: " .. result2)
			end
		end

		return true
	end

	return false
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.COMPLETED_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
