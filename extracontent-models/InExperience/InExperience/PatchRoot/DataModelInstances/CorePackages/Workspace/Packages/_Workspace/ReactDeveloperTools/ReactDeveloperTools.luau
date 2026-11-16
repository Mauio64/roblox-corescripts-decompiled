local parent = script.Parent

local defineFastFlag = game:DefineFastFlag("DebugLuaAppEnableReactDevTools", false)

local defineFastFlag2 = game:DefineFastFlag("DebugLuaAppsReactDevToolsProfileOnStart", false)
local defineFastString = game:DefineFastString("DebugLuaAppReactDevToolsHost", "localhost")
local defineFastInt = game:DefineFastInt("DebugLuaAppReactDevToolsPort", 8097)

return {
	startup = function(flag: boolean?)
		if defineFastFlag or flag then
			_G.__PROFILE__ = true
			_G.__DEV__ = true

			local ReactDevtoolsCore = require(parent.Dev.ReactDevtoolsCore)
			ReactDevtoolsCore.backend.connectToDevtools({
				host = defineFastString,
				port = defineFastInt,
				profileOnStart = defineFastFlag2
			})
		end
	end
}
