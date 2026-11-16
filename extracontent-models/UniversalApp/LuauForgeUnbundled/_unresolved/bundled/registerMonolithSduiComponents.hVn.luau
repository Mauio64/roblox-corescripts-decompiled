local module = require("@luauforge/bundled/hVo")
local getSduiComponentRegistry = module.getSduiComponentRegistry
local sduiComponentType = module.SduiComponentType

local fFlagLuaAppSduiHomeUserInfo = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiHomeUserInfo

local function registerMonolithSduiComponents()
	local v5 = {
		[sduiComponentType.GameSortDropDown] = {
			getLazyComponent = function()
				return require("@luauforge/bundled/hVp")
			end
		},
		[sduiComponentType.HomeUserInfoWidget] = fFlagLuaAppSduiHomeUserInfo and {
			getLazyComponent = function()
				return require("@luauforge/bundled/hVq")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerMonolithSduiComponents
