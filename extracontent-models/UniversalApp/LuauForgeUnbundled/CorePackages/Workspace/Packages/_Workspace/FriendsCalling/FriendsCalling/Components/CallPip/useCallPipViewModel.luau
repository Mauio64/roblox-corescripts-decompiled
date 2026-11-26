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

local function getSelfUserId()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return localPlayer.UserId
	end

	return 0
end

local function isRingingForSomeoneElse(p2)
	local initiatorUserId = p2.initiatorUserId
	local v6

	if p2.phase == friendsCallingPhase.Ringing and initiatorUserId ~= 0 then
		local localPlayer = Players.LocalPlayer
		v6 = initiatorUserId ~= (not localPlayer and 0 or localPlayer.UserId)
	else
		v6 = false
	end

	return v6
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
	local v9 = useSignalState(v6.getExpandCount)
	local ref = React.useRef(nil)
	local at

	if v8 and v8.phase == friendsCallingPhase.Active then
		local current = ref.current
		local v10 = (current == nil or current.callId ~= v8.callId)
			and { callId = v8.callId, at = os.clock() }
			or current

		if current ~= v10 then
			ref.current = v10
		end

		at = v10.at
	else
		at = nil
	end

	local v10 = if v8 then toCard(v8) else v5
	local v11 = v7.hasCall

	if v11 then
		local v12

		if v8 == nil then
			v12 = false
		else
			local initiatorUserId = v8.initiatorUserId

			if v8.phase == friendsCallingPhase.Ringing and initiatorUserId ~= 0 then
				local localPlayer = Players.LocalPlayer
				v12 = initiatorUserId ~= (not localPlayer and 0 or localPlayer.UserId)
			else
				v12 = false
			end
		end

		v11 = not v12
	end

	local callId = v8 and v8.callId or ""
	local v12 = not v8 and "" or v8.phase.Name
	React.useEffect(function()
		Logger:debug(
			"{} - pip applied: enabled={}, session={}, callId={}, phase={}, connectedAt={}",
			"useCallPipViewModel",
			tostring(v11),
			v7.session,
			callId,
			v12,
			(tostring(at))
		)
	end, { callId, at, v11, v12, v7.session })
	local v13 = {
		enabled = v11,
		session = v7.session,
		expandCount = v9,
		connectedAt = at,
		callId = 0,
		participant = 0
	}

	local v14 = if v8 then v8.callId else nil
	v13.callId = v14
	v13.participant = v10
	return v13
end

return useCallPipViewModel
