local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local default = require(Parent.LoggingProtocol).default
local v3 = game:DefineFastFlag("EnableAmpUpsellLogging", false)

return {
	logEventOnceIfEnabled = function(s1: string) -- line: 20
		-- upvalues: v3 (copy), default (copy)
		if v3 then
			default:logEventOnce(s1)
		end
	end
}
