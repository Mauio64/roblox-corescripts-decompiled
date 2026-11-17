local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

require(parent.React)
require(UserList.Common.Types)

local useCtaRenderRow = require(UserList.Hooks.useCtaRenderRow)

local function CtaRenderRowBridge(data)
	local v = useCtaRenderRow(data.ctaConfig, data.renderRow)
	return data.render(v)
end

return CtaRenderRowBridge
