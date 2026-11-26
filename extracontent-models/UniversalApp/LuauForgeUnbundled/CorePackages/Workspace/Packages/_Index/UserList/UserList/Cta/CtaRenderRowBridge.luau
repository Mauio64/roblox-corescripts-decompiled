require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local useCtaRenderRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useCtaRenderRow")

local function CtaRenderRowBridge(data)
	local v5 = useCtaRenderRow(data.ctaConfig, data.renderRow)
	return data.render(v5)
end

return CtaRenderRowBridge
