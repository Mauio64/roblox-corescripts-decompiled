local fFlagSduiDevStoreSeeAllSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSduiDevStoreSeeAllSupport

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerExperienceStoreActions()
	local v5 = {
		[sduiActionType.RefreshDeveloperProducts] = fFlagSduiDevStoreSeeAllSupport and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Actions/SduiRefreshDeveloperProductsAction")
			end
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v5)
end

return registerExperienceStoreActions
