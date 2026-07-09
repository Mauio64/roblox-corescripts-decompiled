local Parent = script:FindFirstAncestor("Style").Parent
local ArgCheck = require(Parent.ArgCheck)
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local RobloxAppHooks = require(Parent.RobloxAppHooks)

require(Parent.RobloxAppEnums)

local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local Context = require(Parent.UIBlox).Style.Context
local DesignTokenContext = require(script.Parent.DesignTokenContext)

local function DesignTokenProvider(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), Context (copy), useUiModeInfo (copy), Cryo (copy), ArgCheck (copy), DesignTokenContext (copy)
	local v11 = React.useContext(Context)
	local v12 = useUiModeInfo()
	local u13 = t1.uiModeInfo or v12
	local tokenMappers = t1.tokenMappers
	local v15 = Cryo.Dictionary.keys(tokenMappers)
	local Tokens = v11.style.Tokens

	ArgCheck.assert(Tokens, "Design Tokens not found, ensure AppStyleProvider has been configured correctly.")

	if not Tokens.LuaApps then
		Tokens = Cryo.Dictionary.join(Tokens, {
			LuaApps = {}
		})
	end

	Tokens = Cryo.List.foldLeft(v15, function(p1, p2) -- line: 42
		-- upvalues: tokenMappers (copy), u13 (ref), Tokens (ref), Cryo (copy)
		local v19 = table.clone(p1.LuaApps)

		v19[p2] = tokenMappers[p2](u13, Tokens)

		return Cryo.Dictionary.join(p1, {
			LuaApps = v19
		})
	end, Tokens)

	return React.createElement(DesignTokenContext.Provider, {
		value = Tokens
	}, t1.children)
end

return DesignTokenProvider
