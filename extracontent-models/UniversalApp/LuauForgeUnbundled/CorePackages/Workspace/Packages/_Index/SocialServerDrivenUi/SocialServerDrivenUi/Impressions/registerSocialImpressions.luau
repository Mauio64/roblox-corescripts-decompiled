local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry

local fFlagSduiSearchPeoplePlayerTileTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagSduiSearchPeoplePlayerTileTelemetry

local function registerSocialImpressions()
	local v5 = {
		[sduiImpressionEventType.playerTileImpressions] = fFlagSduiSearchPeoplePlayerTileTelemetry and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Impressions/SduiPlayerTileImpressionsHandler")
			end,
			skipItemImpressionsLog = true
		} or nil
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v5)
end

return registerSocialImpressions
