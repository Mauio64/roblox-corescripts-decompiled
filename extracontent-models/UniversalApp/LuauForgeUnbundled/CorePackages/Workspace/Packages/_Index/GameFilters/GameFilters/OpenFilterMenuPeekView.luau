local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RobloxAppNavigation").NavigationCommands else nil

local function OpenFilterMenuPeekView(p2, onFilterApplied, onFilterMenuClosed, p3)
	return function(object)
		local v5 = {
			name = appPage.GameFilterMenuPeekView,
			extraProps = {
				filter = p2,
				onFilterApplied = onFilterApplied,
				onFilterMenuClosed = onFilterMenuClosed,
				sendFilterClick = p3
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(navigateDown(v5))
		end
	end
end

return OpenFilterMenuPeekView
