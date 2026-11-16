require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local useCtaRenderRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useCtaRenderRow")
local fFlagUserListComposeRenderRowWithCta = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListComposeRenderRowWithCta

local function CtaRenderRowBridge(data)
	local ctaConfig = data.ctaConfig
	local v6 = if fFlagUserListComposeRenderRowWithCta then data.renderRow else nil
	local v7 = useCtaRenderRow(ctaConfig, v6)
	return data.render(v7)
end

return CtaRenderRowBridge
