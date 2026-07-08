local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Selectors = require(Parent.NavigationRodux).Selectors
local NavigateBack = require(Parent.NavigationRodux).Thunks.NavigateBack
local AccessResponseEnum = require(Parent.AmpUpsell).AmpEnums.AccessResponseEnum
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function(p1: ((...any) -> ...any), n1: number) -- line: 13
	-- upvalues: AccessResponseEnum (copy), Selectors (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateBack (copy)
	if not n1 or not (n1 > 0) then
		return nil
	end

	return function(p2, p3, p4) -- line: 21
		-- upvalues: AccessResponseEnum (copy), n1 (copy), Selectors (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateBack (copy), p1 (copy)
		if not p2 or (not p2.getState or not p2.dispatch) then
			return
		end

		if p3 == AccessResponseEnum.Granted then
			task.delay(n1 / 1000, function() -- line: 27
				-- upvalues: Selectors (copy), p2 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateBack (copy), p1 (copy), p3 (copy), p4 (copy)
				if Selectors.selectCurrentPageName(p2:getState()) == AppPage.AmpWizardContainer then
					if FFlagSignalsNavP3Dispatch then
						v7.back(true)
					else
						p2:dispatch(NavigateBack(true))
					end
				end

				p1(p3, p4)
			end)

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v7.back(true)
		else
			p2:dispatch(NavigateBack(true))
		end

		p1(p3, p4)
	end
end
