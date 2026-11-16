local getSduiTelemetryHandlerNameRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").getSduiTelemetryHandlerNameRegistry

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags")
local fFlagSduiSearchPeoplePlayerTileTelemetry = SharedFlags.FFlagSduiSearchPeoplePlayerTileTelemetry
local fFlagSduiSocialUpsellButtonClickTelemetry = SharedFlags.FFlagSduiSocialUpsellButtonClickTelemetry

local function registerSocialActionTelemetryHandlers()
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		PlayerTileClick = fFlagSduiSearchPeoplePlayerTileTelemetry and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/TelemetryHandlers/SduiPlayerTileClickTelemetryHandler")
			end
		} or nil,
		SocialUpsellButtonClick = fFlagSduiSocialUpsellButtonClickTelemetry and {
			lazyHandler = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/TelemetryHandlers/SduiSocialUpsellButtonClickTelemetryHandler")
			end
		} or nil
	})
end

return registerSocialActionTelemetryHandlers
