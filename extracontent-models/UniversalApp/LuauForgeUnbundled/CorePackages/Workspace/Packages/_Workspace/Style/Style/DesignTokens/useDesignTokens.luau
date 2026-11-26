local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/ArgCheck")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/React")
local DesignTokenContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/DesignTokens/DesignTokenContext")

local function useDesignTokens(p2)
	local v5 = React.useContext(DesignTokenContext)
	local v6 = p2 or Dash.identity

	ArgCheck.assert(v5, "Design Tokens not found, ensure AppStyleProvider has been configured correctly.")

	return v6(v5)
end

return useDesignTokens
