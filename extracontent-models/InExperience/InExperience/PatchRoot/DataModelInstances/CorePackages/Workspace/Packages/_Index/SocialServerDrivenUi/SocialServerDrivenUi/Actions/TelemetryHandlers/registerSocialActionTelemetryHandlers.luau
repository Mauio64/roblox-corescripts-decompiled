local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local getSduiTelemetryHandlerNameRegistry = require(Parent.SduiCoreSystem).getSduiTelemetryHandlerNameRegistry
local FFlagSduiSearchPeoplePlayerTileTelemetry = require(Parent.SharedFlags).FFlagSduiSearchPeoplePlayerTileTelemetry

local function registerSocialActionTelemetryHandlers() -- line: 9
	-- upvalues: getSduiTelemetryHandlerNameRegistry (copy), FFlagSduiSearchPeoplePlayerTileTelemetry (copy)
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		PlayerTileClick = if not FFlagSduiSearchPeoplePlayerTileTelemetry then nil else {
			lazyHandler = function() -- line: 13
				return require(script.Parent.SduiPlayerTileClickTelemetryHandler)
			end
		}
	})
end

return registerSocialActionTelemetryHandlers
