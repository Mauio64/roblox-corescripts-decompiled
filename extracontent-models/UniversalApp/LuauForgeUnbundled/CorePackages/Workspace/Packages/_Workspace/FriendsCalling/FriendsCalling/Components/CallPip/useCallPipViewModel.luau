local Players = game:GetService("Players")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallParticipant/CallParticipantCard")
local GetFriendsCallingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Stores/GetFriendsCallingStore")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Logger")

local friendsCallingParticipantStatus = Enum.FriendsCallingParticipantStatus
local friendsCallingPhase = Enum.FriendsCallingPhase

local useSignalState = SignalsReact.useSignalState

local v5 = {
	userId = 0,
	name = "",
	statusText = nil,
	isMuted = false,
	isSpeaking = false,
	isDimmed = true,
	showStatusAnimation = false
}

local function isBeingRung(p2): boolean
	return p2.status == friendsCallingParticipantStatus.Ringing
end

local function getOtherParticipant(p2)
	local localPlayer = Players.LocalPlayer
	local v6 = not localPlayer and 0 or localPlayer.UserId
	local otherParticipant = nil

	for k, participant in p2.participants do
		if participant.userId == v6 then
			continue
		end

		if participant.status == friendsCallingParticipantStatus.Ringing then
			otherParticipant = participant
			break
		end

		otherParticipant = participant
	end

	return otherParticipant
end

local function toCard(p2)
	local otherParticipant = getOtherParticipant(p2)

	if otherParticipant == nil then
		if p2.phase == friendsCallingPhase.Ringing then
			return {
				userId = 0,
				name = "",
				statusText = "Ringing",
				isMuted = false,
				isSpeaking = false,
				isDimmed = true,
				showStatusAnimation = true
			}
		end

		return v5
	else
		local v6 = p2.phase == friendsCallingPhase.Ended
		local v7 = otherParticipant.status == friendsCallingParticipantStatus.Invited
		local v8 = p2.phase == friendsCallingPhase.Ringing
		return {
			userId = otherParticipant.userId,
			name = tostring(otherParticipant.userId),
			statusText = v8 and "Ringing" or nil,
			isMuted = otherParticipant.isLocalMuted,
			isSpeaking = otherParticipant.isSpeaking,
			isDimmed = v8 or v6 or v7,
			showStatusAnimation = v8
		}
	end
end

local function useCallPipViewModel()
	local v6 = GetFriendsCallingStore(false)
	local v7 = useSignalState(v6.getWindowView)
	local v8 = useSignalState(v6.getCall)
	local ref = React.useRef(nil)
	local at

	if v8 and v8.phase == friendsCallingPhase.Active then
		local current = ref.current
		local v9 = (current == nil or current.callId ~= v8.callId)
			and { callId = v8.callId, at = os.clock() }
			or current

		if current ~= v9 then
			ref.current = v9
		end

		at = v9.at
	else
		at = nil
	end

	local v9 = if v8 then toCard(v8) else v5
	local callId = v8 and v8.callId or ""
	local v10 = not v8 and "" or v8.phase.Name
	React.useEffect(function()
		Logger:debug(
			"{} - pip applied: enabled={}, session={}, callId={}, phase={}, connectedAt={}",
			"useCallPipViewModel",
			tostring(v7.hasCall),
			v7.session,
			callId,
			v10,
			(tostring(at))
		)
	end, { callId, at, v10, v7.hasCall, v7.session })
	local v11 = {
		enabled = v7.hasCall,
		session = v7.session,
		connectedAt = at,
		callId = 0,
		participant = 0
	}

	local v12 = if v8 then v8.callId else nil
	v11.callId = v12
	v11.participant = v9
	return v11
end

return useCallPipViewModel
