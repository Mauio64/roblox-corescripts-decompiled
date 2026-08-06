local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local SocialServerDrivenUiParent = SocialServerDrivenUi.Parent
local SduiCoreSystem = require(SocialServerDrivenUiParent.SduiCoreSystem)
local SduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry
local FFlagSduiSearchPeoplePlayerTileTelemetry = require(SocialServerDrivenUiParent.SharedFlags).FFlagSduiSearchPeoplePlayerTileTelemetry

local function registerSocialImpressions() -- line: 13
	-- upvalues: SduiImpressionEventType (copy), FFlagSduiSearchPeoplePlayerTileTelemetry (copy), SocialServerDrivenUi (copy), getSduiImpressionHandlerRegistry (copy)
	local t1 = {
		[SduiImpressionEventType.playerTileImpressions] = if not FFlagSduiSearchPeoplePlayerTileTelemetry then nil else {
			skipItemImpressionsLog = true,
			lazyHandler = function() -- line: 17
				-- upvalues: SocialServerDrivenUi (copy)
				return require(SocialServerDrivenUi.Impressions.SduiPlayerTileImpressionsHandler)
			end
		}
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(t1)
end

return registerSocialImpressions
