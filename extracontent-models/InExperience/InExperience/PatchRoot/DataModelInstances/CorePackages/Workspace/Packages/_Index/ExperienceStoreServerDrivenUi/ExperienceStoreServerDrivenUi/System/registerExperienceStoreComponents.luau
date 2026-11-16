local ExperienceStoreServerDrivenUi = script:FindFirstAncestor("ExperienceStoreServerDrivenUi")
local parent = ExperienceStoreServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local SduiComponentType = SduiCoreSystem.SduiComponentType

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiGameItemsComponent = SharedFlags.FFlagSduiGameItemsComponent
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiLocalFeedFilter = SharedFlags2.FFlagSduiLocalFeedFilter

local function registerExperienceStoreComponents()
	local v = {
		[SduiComponentType.PillTabsCarousel] = FFlagSduiLocalFeedFilter and {
			getLazyComponent = function()
				return require(ExperienceStoreServerDrivenUi.Components.SduiPillTabsCarousel)
			end
		} or nil,
		[SduiComponentType.VirtualGameItemText] = FFlagSduiGameItemsComponent and {
			getLazyComponent = function()
				return require(ExperienceStoreServerDrivenUi.Components.SduiVirtualGameItemText)
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v)
end

return registerExperienceStoreComponents
