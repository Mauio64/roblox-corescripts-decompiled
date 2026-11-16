local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent
local React = require(parent.React)

local registerSocialActions = require(SocialServerDrivenUi.Actions.registerSocialActions)

local registerSocialActionTelemetryHandlers = require(SocialServerDrivenUi.Actions.TelemetryHandlers.registerSocialActionTelemetryHandlers)
local registerSocialComponents = require(SocialServerDrivenUi.System.registerSocialComponents)
local registerSocialImpressions = require(SocialServerDrivenUi.Impressions.registerSocialImpressions)

local FFlagSduiCreateSocialTelemetryRegistries = require(SocialServerDrivenUi.Flags.FFlagSduiCreateSocialTelemetryRegistries)

local function SduiSocialRegister(): nil
	React.useEffect(function()
		registerSocialComponents()
		registerSocialActions()

		if FFlagSduiCreateSocialTelemetryRegistries then
			registerSocialImpressions()
			registerSocialActionTelemetryHandlers()
		end
	end, {})
	return nil
end

return React.memo(SduiSocialRegister)
