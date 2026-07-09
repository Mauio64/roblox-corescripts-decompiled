local StarterGui = game:GetService("StarterGui")

require(script.Parent.types)

return {
	name = script.Name,
	alias = { "/console" },
	clientRun = function() -- line: 7
		-- upvalues: StarterGui (copy)
		local ok, result = pcall(function() -- line: 8
			-- upvalues: StarterGui (copy)
			return StarterGui:GetCore("DevConsoleVisible")
		end)

		if ok then
			pcall(function() -- line: 12
				-- upvalues: StarterGui (copy), result (copy)
				StarterGui:SetCore("DevConsoleVisible", not result)
			end)
		end

		return nil
	end
}
