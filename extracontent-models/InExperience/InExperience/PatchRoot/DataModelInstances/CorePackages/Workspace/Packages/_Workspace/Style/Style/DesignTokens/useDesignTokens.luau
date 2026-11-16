local parent = script:FindFirstAncestor("Style").Parent
local ArgCheck = require(parent.ArgCheck)
local Dash = require(parent.Dash)
local React = require(parent.React)
local DesignTokenContext = require(script.Parent.DesignTokenContext)

local function useDesignTokens(callback)
	local v = React.useContext(DesignTokenContext)
	local v2 = callback or Dash.identity

	ArgCheck.assert(v, "Design Tokens not found, ensure AppStyleProvider has been configured correctly.")

	return v2(v)
end

return useDesignTokens
