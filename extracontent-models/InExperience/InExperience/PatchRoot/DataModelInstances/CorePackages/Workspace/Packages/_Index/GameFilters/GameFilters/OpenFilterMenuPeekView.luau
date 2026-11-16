local parent = script:FindFirstAncestor("GameFilters").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function OpenFilterMenuPeekView(filter, onFilterApplied, onFilterMenuClosed, sendFilterClick)
	return function(object)
		local v = {
			name = AppPage.GameFilterMenuPeekView,
			extraProps = {
				filter = filter,
				onFilterApplied = onFilterApplied,
				onFilterMenuClosed = onFilterMenuClosed,
				sendFilterClick = sendFilterClick
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v))
		else
			object:dispatch(NavigateDown(v))
		end
	end
end

return OpenFilterMenuPeekView
