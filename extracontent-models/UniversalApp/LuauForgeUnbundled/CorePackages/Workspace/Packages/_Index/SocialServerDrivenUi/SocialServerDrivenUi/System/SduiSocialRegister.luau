local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")

local registerSocialActions = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/registerSocialActions")

local registerSocialActionTelemetryHandlers = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/TelemetryHandlers/registerSocialActionTelemetryHandlers")
local registerSocialComponents = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/System/registerSocialComponents")
local registerSocialImpressions = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Impressions/registerSocialImpressions")

local FFlagSduiCreateSocialTelemetryRegistries = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Flags/FFlagSduiCreateSocialTelemetryRegistries")

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
