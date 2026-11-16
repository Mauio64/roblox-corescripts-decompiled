local parent = script:FindFirstAncestor("GamePlayButton").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux2.Thunks.NavigateBack
local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local getLegacyNavigationStore

if FFlagSignalsNavP3Dispatch then
	local NavigationRodux3 = require(parent.NavigationRodux)
	getLegacyNavigationStore = NavigationRodux3.GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

return function(callback, p: number)
	if p and p > 0 then
		return function(object, p2, p3)
			if not (object and object.getState and object.dispatch) then
				return
			end

			if p2 == AccessResponseEnum.Granted then
				task.delay(p / 1000, function()
					local v

					if FFlagSignalsNavP3Dispatch then
						v = getLegacyNavigationStore(false).getCurrentPageName(false)
					else
						v = Selectors.selectCurrentPageName(object:getState())
					end

					if v == AppPage.AmpWizardContainer then
						if FFlagSignalsNavP3Dispatch then
							navigationCommands.back(true)
						else
							object:dispatch(NavigateBack(true))
						end
					end

					callback(p2, p3)
				end)
				return
			end

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.back(true)
			else
				object:dispatch(NavigateBack(true))
			end

			callback(p2, p3)
		end
	end

	return nil
end
