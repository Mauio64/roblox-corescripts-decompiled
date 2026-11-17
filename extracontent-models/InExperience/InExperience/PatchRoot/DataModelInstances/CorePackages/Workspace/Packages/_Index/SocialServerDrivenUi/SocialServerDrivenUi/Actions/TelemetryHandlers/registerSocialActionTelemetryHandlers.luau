local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiTelemetryHandlerNameRegistry = SduiCoreSystem.getSduiTelemetryHandlerNameRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSearchPeoplePlayerTileTelemetry = SharedFlags.FFlagSduiSearchPeoplePlayerTileTelemetry
local FFlagSduiSocialUpsellButtonClickTelemetry = SharedFlags.FFlagSduiSocialUpsellButtonClickTelemetry
local function registerSocialActionTelemetryHandlers()
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		PlayerTileClick = FFlagSduiSearchPeoplePlayerTileTelemetry and {
			lazyHandler = function()
				return require(script.Parent.SduiPlayerTileClickTelemetryHandler)
			end
		} or nil,
		SocialUpsellButtonClick = FFlagSduiSocialUpsellButtonClickTelemetry and {
			lazyHandler = function()
				return require(script.Parent.SduiSocialUpsellButtonClickTelemetryHandler)
			end
		} or nil,
		SocialProofTextClick = {
			lazyHandler = function()
				return require(script.Parent.SduiSocialProofTextClickTelemetryHandler)
			end
		}
	})
end

return registerSocialActionTelemetryHandlers
