local Parent = script:FindFirstAncestor("AvatarExperienceInitialization").Parent
local RealtimeDelivery = require(Parent.RealtimeDelivery)

local function useRemoteAvatarUpdateEffect(p1: ((...any) -> ...any)) -- line: 8
	-- upvalues: RealtimeDelivery (copy)
	RealtimeDelivery.useRealtimeNamespace("SignupAvatarInitializationProcessor", function(_) -- line: 9
		-- upvalues: p1 (copy)
		p1()
	end, { p1 })
	RealtimeDelivery.useRealtimeConnectionStateChanged("SignupAvatarInitializationProcessor", function(_, p4) -- line: 14
		-- upvalues: p1 (copy)
		if p4 then
			p1()
		end
	end, { p1 })
end

return useRemoteAvatarUpdateEffect
