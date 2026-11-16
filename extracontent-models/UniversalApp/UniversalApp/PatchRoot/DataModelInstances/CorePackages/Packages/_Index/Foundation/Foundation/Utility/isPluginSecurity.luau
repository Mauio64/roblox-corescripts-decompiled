local Foundation = script:FindFirstAncestor("Foundation")
local Wrappers = require(Foundation.Utility.Wrappers)

local function isPluginSecurity()
	local coreGui = Wrappers.Services.CoreGui
	local success, _ = pcall(function()
		coreGui:GetChildren()
	end)

	return success
end

return isPluginSecurity
