local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local Wrappers = require(Foundation.Utility.Wrappers)

local function isPluginSecurity() -- line: 5
	-- upvalues: Wrappers (copy), Flags (copy)
	local CoreGui = Wrappers.Services.CoreGui

	if Flags.FoundationPopoverPluginSecurityGate then
		local ok, _ = pcall(function() -- line: 9
			-- upvalues: CoreGui (copy)
			CoreGui:GetChildren()
		end)

		return ok
	end

	local ok, _ = pcall(function() -- line: 16
		-- upvalues: CoreGui (copy)
		local _ = CoreGui.Name
	end)

	return ok
end

return isPluginSecurity
