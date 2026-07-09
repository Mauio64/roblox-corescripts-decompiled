local Parent = script:FindFirstAncestor("Style").Parent
local ArgCheck = require(Parent.ArgCheck)
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local DesignTokenContext = require(script.Parent.DesignTokenContext)

local function useDesignTokens(p1: ((...any) -> ...any)?) -- line: 11
	-- upvalues: React (copy), DesignTokenContext (copy), Dash (copy), ArgCheck (copy)
	local v8 = React.useContext(DesignTokenContext)
	local v9 = p1 or Dash.identity

	ArgCheck.assert(v8, "Design Tokens not found, ensure AppStyleProvider has been configured correctly.")

	return v9(v8)
end

return useDesignTokens
