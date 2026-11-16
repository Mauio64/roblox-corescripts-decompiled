local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/LoggingProtocol").default

local defineFastFlag = game:DefineFastFlag("EnableAmpUpsellLogging", false)

return {
	logEventOnceIfEnabled = function(p2)
		if defineFastFlag then
			default:logEventOnce(p2)
		end
	end
}
