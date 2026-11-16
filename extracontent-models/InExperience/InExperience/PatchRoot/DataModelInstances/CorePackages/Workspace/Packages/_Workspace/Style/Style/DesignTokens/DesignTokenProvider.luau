local parent = script:FindFirstAncestor("Style").Parent
local ArgCheck = require(parent.ArgCheck)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
require(parent.RobloxAppEnums)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local UIBlox = require(parent.UIBlox)
local Context = UIBlox.Style.Context
local DesignTokenContext = require(script.Parent.DesignTokenContext)

local function DesignTokenProvider(props)
	local v = React.useContext(Context)
	local v2 = useUiModeInfo()
	local uiModeInfo = props.uiModeInfo or v2

	local tokenMappers = props.tokenMappers
	local keys = Cryo.Dictionary.keys(tokenMappers)
	local tokens = v.style.Tokens

	ArgCheck.assert(tokens, "Design Tokens not found, ensure AppStyleProvider has been configured correctly.")

	if not tokens.LuaApps then
		tokens = Cryo.Dictionary.join(tokens, { LuaApps = {} })
	end

	tokens = Cryo.List.foldLeft(keys, function(p, p2)
		local clone = table.clone(p.LuaApps)
		clone[p2] = tokenMappers[p2](uiModeInfo, tokens)

		return Cryo.Dictionary.join(p, { LuaApps = clone })
	end, tokens)

	return React.createElement(DesignTokenContext.Provider, { value = tokens }, props.children)
end

return DesignTokenProvider
