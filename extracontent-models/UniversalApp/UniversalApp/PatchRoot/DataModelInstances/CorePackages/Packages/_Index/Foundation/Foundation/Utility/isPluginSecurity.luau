local Foundation = script:FindFirstAncestor("Foundation")
local Wrappers = require(Foundation.Utility.Wrappers)

local function isPluginSecurity() -- line: 4
	-- upvalues: Wrappers (copy)
	local CoreGui = Wrappers.Services.CoreGui
	local ok, _ = pcall(function() -- line: 6
		-- upvalues: CoreGui (copy)
		CoreGui:GetChildren()
	end)

	return ok
end

return isPluginSecurity
