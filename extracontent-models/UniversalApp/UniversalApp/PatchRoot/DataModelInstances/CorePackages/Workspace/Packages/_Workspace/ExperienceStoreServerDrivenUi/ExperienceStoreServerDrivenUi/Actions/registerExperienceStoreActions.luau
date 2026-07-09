local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local ExperienceStoreServerDrivenUiParent = ExperienceStoreServerDrivenUi.Parent
local FFlagSduiDevStoreSeeAllSupport = require(ExperienceStoreServerDrivenUiParent.SharedFlags).FFlagSduiDevStoreSeeAllSupport
local SduiCoreSystem = require(ExperienceStoreServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerExperienceStoreActions() -- line: 13
	-- upvalues: SduiActionType (copy), FFlagSduiDevStoreSeeAllSupport (copy), ExperienceStoreServerDrivenUi (copy), getSduiActionHandlerRegistry (copy)
	local t1 = {
		[SduiActionType.RefreshDeveloperProducts] = if not FFlagSduiDevStoreSeeAllSupport then nil else {
			lazyHandler = function() -- line: 17
				-- upvalues: ExperienceStoreServerDrivenUi (copy)
				return require(ExperienceStoreServerDrivenUi.Actions.SduiRefreshDeveloperProductsAction)
			end
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(t1)
end

return registerExperienceStoreActions
