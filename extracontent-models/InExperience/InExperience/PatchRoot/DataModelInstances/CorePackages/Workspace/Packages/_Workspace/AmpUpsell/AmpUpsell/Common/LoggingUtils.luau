local parent = script:FindFirstAncestor("AmpUpsell").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local defineFastFlag = game:DefineFastFlag("EnableAmpUpsellLogging", false)

return {
	logEventOnceIfEnabled = function(p: string)
		if defineFastFlag then
			default:logEventOnce(p)
		end
	end
}
