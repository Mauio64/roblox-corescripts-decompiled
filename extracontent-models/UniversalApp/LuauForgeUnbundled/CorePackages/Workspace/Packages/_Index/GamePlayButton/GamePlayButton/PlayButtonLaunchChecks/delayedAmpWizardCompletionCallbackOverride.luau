local appPage = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").AppPage
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NavigationRodux").Selectors
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NavigationRodux").Thunks.NavigateBack
local accessResponseEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AmpUpsell").AmpEnums.AccessResponseEnum
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppNavigation").NavigationCommands else nil

local getLegacyNavigationStore = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NavigationRodux").GetLegacyNavigationStore else nil

return function(callback, p2)
	if p2 and p2 > 0 then
		return function(object, p3, p4)
			if not (object and object.getState and object.dispatch) then
				return
			end

			if p3 == accessResponseEnum.Granted then
				task.delay(p2 / 1000, function()
					local v5

					if fFlagSignalsNavP3Dispatch then
						v5 = getLegacyNavigationStore(false).getCurrentPageName(false)
					else
						v5 = selectors.selectCurrentPageName(object:getState())
					end

					if v5 == appPage.AmpWizardContainer then
						if fFlagSignalsNavP3Dispatch then
							navigationCommands.back(true)
						else
							object:dispatch(navigateBack(true))
						end
					end

					callback(p3, p4)
				end)
				return
			end

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back(true)
			else
				object:dispatch(navigateBack(true))
			end

			callback(p3, p4)
		end
	end

	return nil
end
