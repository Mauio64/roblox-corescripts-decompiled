local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local parent = ExperienceStoreServerDrivenUi.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerExperienceStoreActions()
	local v = {
		[SduiActionType.RefreshDeveloperProducts] = FFlagSduiDevStoreSeeAllSupport and {
			lazyHandler = function()
				return require(ExperienceStoreServerDrivenUi.Actions.SduiRefreshDeveloperProductsAction)
			end
		} or nil
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(v)
end

return registerExperienceStoreActions
