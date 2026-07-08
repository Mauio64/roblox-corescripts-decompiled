local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local MessageBus = require(MomentsParent.MessageBus).MessageBus
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetFFlagMomentsPauseAudioThroughTeleport = require(Moments.Flags.GetFFlagMomentsPauseAudioThroughTeleport)

local function gameLeaveMessageValidator(p1) -- line: 30
	return typeof(p1) == "table"
end
local function useResetTeleportingOnGameLeave() -- line: 34
	-- upvalues: React (copy), GetFFlagMomentsPauseAudioThroughTeleport (copy), MessageBus (copy), gameLeaveMessageValidator (copy), GetMomentsPreferencesStore (copy)
	React.useEffect(function() -- line: 35
		-- upvalues: GetFFlagMomentsPauseAudioThroughTeleport (copy), MessageBus (copy), gameLeaveMessageValidator (copy), GetMomentsPreferencesStore (copy)
		if not GetFFlagMomentsPauseAudioThroughTeleport() then
			return
		end

		local v10 = MessageBus.Subscriber.new()
		local v11 = MessageBus.getMessageId("Game", "onGameLeave")

		v10:subscribe({
			mid = v11,
			validateParams = gameLeaveMessageValidator
		}, function(_) -- line: 45
			-- upvalues: GetMomentsPreferencesStore (copy)
			GetMomentsPreferencesStore(false).setTeleporting(false)
		end)

		return function() -- line: 51
			-- upvalues: v10 (copy), v11 (copy)
			v10:unsubscribeWithMsgId(v11)
		end
	end, {})
end

return useResetTeleportingOnGameLeave
