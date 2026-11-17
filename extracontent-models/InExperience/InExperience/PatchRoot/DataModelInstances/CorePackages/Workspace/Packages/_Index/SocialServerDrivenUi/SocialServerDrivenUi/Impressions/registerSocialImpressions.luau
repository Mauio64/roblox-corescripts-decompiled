local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiImpressionEventType = SduiCoreSystem.SduiImpressionEventType
local getSduiImpressionHandlerRegistry = SduiCoreSystem.getSduiImpressionHandlerRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSearchPeoplePlayerTileTelemetry = SharedFlags.FFlagSduiSearchPeoplePlayerTileTelemetry

local function registerSocialImpressions()
	local v = {
		[SduiImpressionEventType.playerTileImpressions] = FFlagSduiSearchPeoplePlayerTileTelemetry and {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Impressions.SduiPlayerTileImpressionsHandler)
			end,
			skipItemImpressionsLog = true
		} or nil,
		[SduiImpressionEventType.socialProofTextImpressions] = {
			lazyHandler = function()
				return require(SocialServerDrivenUi.Impressions.SduiSocialProofTextImpressionsHandler)
			end,
			skipItemImpressionsLog = true
		}
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v)
end

return registerSocialImpressions
