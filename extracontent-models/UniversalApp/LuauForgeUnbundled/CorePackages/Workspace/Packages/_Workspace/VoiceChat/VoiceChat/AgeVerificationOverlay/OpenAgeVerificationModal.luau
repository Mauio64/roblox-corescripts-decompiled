local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/RobloxAppNavigation").NavigationCommands else nil

return function(p2)
	return function(object)
		local v5 = { name = appPage.AgeVerificationRequired, detail = p2 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(navigateDown(v5))
		end
	end
end
