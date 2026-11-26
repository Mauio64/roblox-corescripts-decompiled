local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/ArgCheck")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/RobloxAppHooks")
require("@game/CorePackages/Workspace/Packages/_Workspace/Style/RobloxAppEnums")
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local context = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/UIBlox").Style.Context
local DesignTokenContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/DesignTokens/DesignTokenContext")

local function DesignTokenProvider(props)
	local v5 = React.useContext(context)
	local v6 = useUiModeInfo()
	local uiModeInfo = props.uiModeInfo or v6

	local tokenMappers = props.tokenMappers
	local keys = Cryo.Dictionary.keys(tokenMappers)
	local tokens = v5.style.Tokens

	ArgCheck.assert(tokens, "Design Tokens not found, ensure AppStyleProvider has been configured correctly.")

	if not tokens.LuaApps then
		tokens = Cryo.Dictionary.join(tokens, { LuaApps = {} })
	end

	tokens = Cryo.List.foldLeft(keys, function(p2, p3)
		local clone = table.clone(p2.LuaApps)
		clone[p3] = tokenMappers[p3](uiModeInfo, tokens)

		return Cryo.Dictionary.join(p2, { LuaApps = clone })
	end, tokens)

	return React.createElement(DesignTokenContext.Provider, { value = tokens }, props.children)
end

return DesignTokenProvider
