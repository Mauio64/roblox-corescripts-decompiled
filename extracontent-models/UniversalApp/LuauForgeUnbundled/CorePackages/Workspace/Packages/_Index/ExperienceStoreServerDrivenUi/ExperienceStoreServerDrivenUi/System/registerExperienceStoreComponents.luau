local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SduiCoreSystem")
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local sduiComponentType = SduiCoreSystem.SduiComponentType

local fFlagSduiGameItemsComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSduiGameItemsComponent
local fFlagSduiLocalFeedFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagSduiLocalFeedFilter

local function registerExperienceStoreComponents()
	local v5 = {
		[sduiComponentType.PillTabsCarousel] = fFlagSduiLocalFeedFilter and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Components/SduiPillTabsCarousel")
			end
		} or nil,
		[sduiComponentType.VirtualGameItemText] = fFlagSduiGameItemsComponent and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Components/SduiVirtualGameItemText")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerExperienceStoreComponents
