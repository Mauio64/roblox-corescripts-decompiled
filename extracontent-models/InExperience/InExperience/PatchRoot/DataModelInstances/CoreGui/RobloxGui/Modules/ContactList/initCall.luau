local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Modules = CoreGui.RobloxGui.Modules
local default = require(Modules.VoiceChat.VoiceChatServiceManager).default

require(CorePackages.Workspace.Packages.CallProtocol)

local dependencies = require(script.Parent.dependencies)
local RoduxCall = dependencies.RoduxCall
local CallAction = RoduxCall.Enums.CallAction
local teleportToRootPlace = dependencies.teleportToRootPlace
local EngineFeature = game:GetEngineFeature("EnableIrisRerouteToRCC")
local u14 = nil
local u15 = nil
local u16 = nil
local u17 = nil
local u18 = nil
local u19 = nil
local u20 = nil

return function(p1) -- line: 26
	-- upvalues: RobloxReplicatedStorage (copy), RoduxCall (copy), Players (copy), FaceAnimatorService (copy), default (copy), u14 (ref), u15 (ref), u16 (ref), u17 (ref), EngineFeature (copy), u18 (ref), HttpService (copy), u19 (ref), u20 (ref), CallAction (copy), teleportToRootPlace (copy)
	p1:getCallState():andThen(function(p2) -- line: 40
		-- upvalues: RoduxCall (copy), Players (copy), p1 (copy)
		if p2.status == RoduxCall.Enums.Status.Teleporting and (Players.LocalPlayer and p2.callerId == Players.LocalPlayer.UserId and p2.callId) then
			if p2.instanceId == game.JobId then
				p1:teleportSuccessCall(p2.callId)

				return
			end

			p1:finishCall(p2.callId)

			return
		end

		if p2.status == RoduxCall.Enums.Status.Accepting and Players.LocalPlayer and p2.calleeId == Players.LocalPlayer.UserId and p2.callId then
			if p2.instanceId == game.JobId then
				p1:answerSuccessCall(p2.callId)

				return
			end

			p1:rejectCall(p2.callId)
		end
	end)
	FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(function() -- line: 69
		-- upvalues: p1 (copy), FaceAnimatorService (copy)
		p1:updateMicAndCamState(nil, FaceAnimatorService.VideoAnimationEnabled)
	end)
	default.muteChanged.Event:Connect(function(p3) -- line: 74
		-- upvalues: default (copy), p1 (copy)
		local v25 = default:getService()

		if v25 and (v25.VoiceChatState ~= Enum.VoiceChatState.Leaving and v25.VoiceChatState ~= Enum.VoiceChatState.Ended) then
			p1:updateMicAndCamState(p3, nil)
		end
	end)
	u14 = p1:listenToHandleMicAndCamChanged(function(p4) -- line: 87
		-- upvalues: default (copy), FaceAnimatorService (copy)
		local v27 = default:getService()

		if v27 and (v27.VoiceChatState == Enum.VoiceChatState.Joined and default.localMuted ~= nil and p4.muted ~= nil and p4.muted ~= default.localMuted) then
			default:ToggleMic("CallAPI")
		end

		if FaceAnimatorService:IsStarted() and FaceAnimatorService.VideoAnimationEnabled ~= p4.camEnabled and p4.camEnabled ~= nil then
			FaceAnimatorService.VideoAnimationEnabled = p4.camEnabled
		end
	end)
	u15 = p1:listenToHandleTeleportingCall(function(p5) -- line: 111
		-- upvalues: RoduxCall (copy), Players (copy), p1 (copy), RobloxReplicatedStorage (copy)
		if p5.status == RoduxCall.Enums.Status.Teleporting and (Players.LocalPlayer and p5.callId and p5.callerId == Players.LocalPlayer.UserId) then
			coroutine.wrap(function() -- line: 118
				-- upvalues: p5 (copy), p1 (copy), RobloxReplicatedStorage (copy)
				if p5.instanceId == game.JobId then
					p1:teleportSuccessCall(p5.callId)

					return
				end

				RobloxReplicatedStorage:WaitForChild("ContactListIrisInviteTeleport", 1e999):FireServer(p5.placeId, p5.instanceId, p5.reservedServerAccessCode, p5.callId)
			end)()
		end
	end)
	u16 = p1:listenToHandleTransferCallTeleportJoin(function(p6) -- line: 138
		-- upvalues: RobloxReplicatedStorage (copy)
		local t1 = {
			callId = p6.callId,
			participants = {
				tostring(p6.callerId),
				(tostring(p6.calleeId))
			}
		}

		coroutine.wrap(function() -- line: 28
			-- upvalues: RobloxReplicatedStorage (copy), t1 (copy)
			RobloxReplicatedStorage:WaitForChild("UpdateCurrentCall", 1e999):FireServer(t1)
		end)()
	end)
	u17 = p1:listenToHandleTransferCallTeleportLeave(function(_) -- line: 145
		-- upvalues: RobloxReplicatedStorage (copy)
		local v32 = nil

		coroutine.wrap(function() -- line: 28
			-- upvalues: RobloxReplicatedStorage (copy), v32 (copy)
			RobloxReplicatedStorage:WaitForChild("UpdateCurrentCall", 1e999):FireServer(v32)
		end)()
	end)

	if EngineFeature then
		u18 = p1:listenToHandleInitCall(function(p8) -- line: 152
			-- upvalues: RobloxReplicatedStorage (copy), HttpService (copy)
			coroutine.wrap(function() -- line: 153
				-- upvalues: RobloxReplicatedStorage (copy), p8 (copy), HttpService (copy)
				RobloxReplicatedStorage:WaitForChild("ContactListInvokeIrisInvite", 1e999):FireServer(p8.tag, p8.calleeId, p8.calleeCombinedName, p8.muted, p8.camEnabled, HttpService:GetUserAgent(), 2)
			end)()
		end)
	end

	u19 = p1:listenToHandleActiveCall(function(p9) -- line: 169
		-- upvalues: RobloxReplicatedStorage (copy)
		local t2 = {
			callId = p9.callId,
			participants = {
				tostring(p9.callerId),
				(tostring(p9.calleeId))
			}
		}

		coroutine.wrap(function() -- line: 28
			-- upvalues: RobloxReplicatedStorage (copy), t2 (copy)
			RobloxReplicatedStorage:WaitForChild("UpdateCurrentCall", 1e999):FireServer(t2)
		end)()
	end)
	u20 = p1:listenToHandleEndCall(function(p10) -- line: 176
		-- upvalues: RobloxReplicatedStorage (copy), CallAction (copy), teleportToRootPlace (copy)
		local v37 = nil

		coroutine.wrap(function() -- line: 28
			-- upvalues: RobloxReplicatedStorage (copy), v37 (copy)
			RobloxReplicatedStorage:WaitForChild("UpdateCurrentCall", 1e999):FireServer(v37)
		end)()

		if p10.callAction == CallAction.Finish and game.JobId == p10.instanceId then
			teleportToRootPlace()
		end
	end)
end
