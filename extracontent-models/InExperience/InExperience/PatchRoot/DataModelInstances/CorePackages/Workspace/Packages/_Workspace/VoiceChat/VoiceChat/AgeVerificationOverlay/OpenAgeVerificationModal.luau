local Parent = script:FindFirstAncestor("VoiceChat").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v5 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function(s1: string) -- line: 14
	-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
	return function(p1) -- line: 15
		-- upvalues: AppPage (copy), s1 (copy), FFlagSignalsNavP3Dispatch (copy), v5 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.AgeVerificationRequired,
			detail = s1
		}

		if FFlagSignalsNavP3Dispatch then
			v5.down(v5.fromLegacyPage(t1))

			return
		end

		p1:dispatch(NavigateDown(t1))
	end
end
