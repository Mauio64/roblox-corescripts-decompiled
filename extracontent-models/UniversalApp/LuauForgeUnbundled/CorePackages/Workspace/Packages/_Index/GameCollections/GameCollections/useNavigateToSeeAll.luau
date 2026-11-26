local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/NavigationRodux").Thunks.NavigateDown
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppNavigation").NavigationCommands else nil

local function useNavigateToSeeAll(p2, p3, p4, p5, p6, p7)
	local v5 = useDispatch()

	return (React.useCallback(function()
		if p2 == nil then
			return
		end

		local v6 = {
			name = appPage.GamesList,
			detail = p6,
			extraProps = {
				sortPageId = p5,
				sortName = p6,
				pageContext = p7,
				isOmni = p3,
				sortIndex = if p3 then p4 else nil
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v5(navigateDown(v6))
		end
	end, { v5, p3, p2, p4, p6, p7, p5 }))
end

return useNavigateToSeeAll
