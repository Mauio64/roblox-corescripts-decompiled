local module = require("@luauforge/bundled/igL")

local function useRemoteAvatarUpdateEffect(callback)
	module.useRealtimeNamespace("SignupAvatarInitializationProcessor", function(p2)
		callback()
	end, { callback })
	module.useRealtimeConnectionStateChanged("SignupAvatarInitializationProcessor", function(p2, p3)
		if p3 then
			callback()
		end
	end, { callback })
end

return useRemoteAvatarUpdateEffect
