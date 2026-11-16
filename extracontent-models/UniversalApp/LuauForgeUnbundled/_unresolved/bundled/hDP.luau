local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/geC")
local module3 = require("@luauforge/bundled/eee")

local module4 = require("@luauforge/bundled/hDQ")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

return function(p2, p3, p4)
	return function(object)
		local v5 = p2.challengeType == module2.Captcha

		if p3 ~= nil then
			v5 = p3
		end

		if module4() then
			local v6 = {
				name = v5 and module.ChallengeHybridOverlayPage or module.ChallengeHybridWebView,
				extraProps = p2
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6), p4)
			else
				object:dispatch(module3(v6, p4))
			end
		else
			local v6 = {
				name = v5 and module.ChallengeHybridOverlayPage or module.ChallengeHybridWebView,
				extraProps = p2
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				object:dispatch(module3(v6))
			end
		end
	end
end
