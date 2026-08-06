local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local SocialServerDrivenUiParent = SocialServerDrivenUi.Parent
local React = require(SocialServerDrivenUiParent.React)
local registerSocialActions = require(SocialServerDrivenUi.Actions.registerSocialActions)
local registerSocialActionTelemetryHandlers = require(SocialServerDrivenUi.Actions.TelemetryHandlers.registerSocialActionTelemetryHandlers)
local registerSocialComponents = require(SocialServerDrivenUi.System.registerSocialComponents)
local registerSocialImpressions = require(SocialServerDrivenUi.Impressions.registerSocialImpressions)
local FFlagSduiActionTelemetryHandler = require(SocialServerDrivenUiParent.SharedFlags).FFlagSduiActionTelemetryHandler
local FFlagSduiCreateSocialTelemetryRegistries = require(SocialServerDrivenUi.Flags.FFlagSduiCreateSocialTelemetryRegistries)

local function SduiSocialRegister() -- line: 16
	-- upvalues: React (copy), registerSocialComponents (copy), registerSocialActions (copy), FFlagSduiCreateSocialTelemetryRegistries (copy), registerSocialImpressions (copy), FFlagSduiActionTelemetryHandler (copy), registerSocialActionTelemetryHandlers (copy)
	React.useEffect(function() -- line: 17
		-- upvalues: registerSocialComponents (copy), registerSocialActions (copy), FFlagSduiCreateSocialTelemetryRegistries (copy), registerSocialImpressions (copy), FFlagSduiActionTelemetryHandler (copy), registerSocialActionTelemetryHandlers (copy)
		registerSocialComponents()
		registerSocialActions()

		if FFlagSduiCreateSocialTelemetryRegistries then
			registerSocialImpressions()

			if FFlagSduiActionTelemetryHandler then
				registerSocialActionTelemetryHandlers()
			end
		end
	end, {})

	return nil
end

return React.memo(SduiSocialRegister)
