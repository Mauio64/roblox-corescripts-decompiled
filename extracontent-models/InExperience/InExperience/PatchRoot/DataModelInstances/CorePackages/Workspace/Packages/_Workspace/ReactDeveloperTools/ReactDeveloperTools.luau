local scriptParent = script.Parent
local v2 = game:DefineFastFlag("DebugLuaAppEnableReactDevTools", false)
local v3 = game:DefineFastFlag("DebugLuaAppsReactDevToolsProfileOnStart", false)
local v4 = game:DefineFastString("DebugLuaAppReactDevToolsHost", "localhost")
local v5 = game:DefineFastInt("DebugLuaAppReactDevToolsPort", 8097)

return {
	startup = function(b1: boolean?) -- line: 9
		-- upvalues: v2 (copy), scriptParent (copy), v4 (copy), v5 (copy), v3 (copy)
		if v2 or b1 then
			_G.__PROFILE__ = true
			_G.__DEV__ = true
			require(scriptParent.Dev.ReactDevtoolsCore).backend.connectToDevtools({
				host = v4,
				port = v5,
				profileOnStart = v3
			})
		end
	end
}
