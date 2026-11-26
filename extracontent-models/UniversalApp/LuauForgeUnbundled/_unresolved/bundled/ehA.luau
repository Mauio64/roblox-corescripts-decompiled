local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ehB")
local module2 = require("@luauforge/bundled/dFu")
local Dash = require(CorePackages.Packages.Dash)
local module3 = require("@luauforge/bundled/ehz")
local module4 = require("@luauforge/bundled/ecs")
local constants = require("@luauforge/bundled/cqW").Constants

local module5 = require("@luauforge/bundled/ehn")
local module6 = require("@luauforge/bundled/ehy")

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local v5 = module5()

return function(p2, data)
	return function(object)
		module3.Stopwatch.start(module3.Events.ProfileOpened)
		local v6 = if data and data.mockProfileAnalytics_dev then data.mockProfileAnalytics_dev else v5

		v6.fireAnalyticsEvent(module6.ProfileLoadingStage, {
			status = module4.Analytics.Enums.LoadingStages.Started
		})

		if data and data.profileType == constants.CONTACTS_PROFILE_TYPE and data.contactProps then
			local v7 = {
				name = module2.ProfilePlatform,
				detail = data.contactProps.contactId,
				extraProps = Dash.join(data, { profileType = constants.CONTACT })
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v7))
			else
				object:dispatch(module(v7))
			end
		else
			local v7 = {
				name = module2.ProfilePlatform,
				detail = p2,
				extraProps = data
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v7))
			else
				object:dispatch(module(v7))
			end
		end
	end
end
