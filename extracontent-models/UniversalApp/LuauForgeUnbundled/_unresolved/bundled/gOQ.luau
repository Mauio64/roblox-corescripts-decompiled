local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/ghP")

local module2 = require("@luauforge/bundled/dPB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local v5 = {
	{ name = avatarScreen.AvatarExperienceRoot }
}

return function(p2, p3, p4)
	return function(object)
		object:dispatch(module2(p2, p3))

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.to(navigationCommands.fromLegacyPage(v5[#v5]), p4)
		else
			object:dispatch(module(v5, p4))
		end
	end
end
