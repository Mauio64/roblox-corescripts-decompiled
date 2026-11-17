local FriendsCalling = script:FindFirstAncestor("FriendsCalling")
local parent = FriendsCalling.Parent

local Players = game:GetService("Players")
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(FriendsCalling.Components.CallParticipant.CallParticipantCard)
local GetFriendsCallingStore = require(FriendsCalling.Stores.GetFriendsCallingStore)
local Logger = require(FriendsCalling.Logger)

local FriendsCallingParticipantStatus = Enum.FriendsCallingParticipantStatus
local FriendsCallingPhase = Enum.FriendsCallingPhase

local useSignalState = SignalsReact.useSignalState

local v = {
	userId = 0,
	name = "",
	statusText = nil,
	isMuted = false,
	isSpeaking = false,
	isDimmed = true,
	showStatusAnimation = false
}

local function isBeingRung(participant): boolean -- 1 equivalent call inferred from this helper
	return participant.status == FriendsCallingParticipantStatus.Ringing
end

local function getSelfUserId() -- 2 equivalent calls inferred from this helper
	local localPlayer = Players.LocalPlayer
	return if localPlayer then localPlayer.UserId else 0
end

local function isRingingForSomeoneElse(p): boolean -- 1 equivalent call inferred from this helper
	local initiatorUserId = p.initiatorUserId
	return p.phase == FriendsCallingPhase.Ringing and initiatorUserId ~= 0 and initiatorUserId ~= getSelfUserId() -- inferred equivalent call
end

local function getOtherParticipant(p)
	local selfUserId = getSelfUserId() -- inferred equivalent call
	local otherParticipant = nil

	for _, participant in p.participants do
		if participant.userId == selfUserId then
			continue
		end

		if isBeingRung(participant) then -- inferred equivalent call
			otherParticipant = participant
			break
		end

		otherParticipant = participant
	end

	return otherParticipant
end

local function toCard(p)
	local otherParticipant = getOtherParticipant(p)

	if otherParticipant == nil then
		if p.phase == FriendsCallingPhase.Ringing then
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

		return v
	else
		local v2 = p.phase == FriendsCallingPhase.Ended
		local v3 = otherParticipant.status == FriendsCallingParticipantStatus.Invited
		local showStatusAnimation = p.phase == FriendsCallingPhase.Ringing
		return {
			userId = otherParticipant.userId,
			name = tostring(otherParticipant.userId),
			statusText = showStatusAnimation and "Ringing" or nil,
			isMuted = otherParticipant.isLocalMuted,
			isSpeaking = otherParticipant.isSpeaking,
			isDimmed = showStatusAnimation or v2 or v3,
			showStatusAnimation = showStatusAnimation
		}
	end
end

local function useCallPipViewModel()
	local friendsCallingStore = GetFriendsCallingStore(false)
	local v2 = useSignalState(friendsCallingStore.getWindowView)
	local v3 = useSignalState(friendsCallingStore.getCall)
	local expandCount = useSignalState(friendsCallingStore.getExpandCount)
	local ref = React.useRef(nil)
	local at

	if v3 and v3.phase == FriendsCallingPhase.Active then
		local current = ref.current
		local current2 = (current == nil or current.callId ~= v3.callId) and {
				callId = v3.callId,
				at = os.clock()
			}
			or current

		if current ~= current2 then
			ref.current = current2
		end

		at = current2.at
	else
		at = nil
	end

	local participant

	if v3 then
		participant = toCard(v3)
	else
		participant = v
	end

	local enabled = v2.hasCall

	if enabled then
		enabled = v3 == nil or not isRingingForSomeoneElse(v3) -- inferred equivalent call
	end

	local callId = v3 and v3.callId or ""
	local v4 = not v3 and "" or v3.phase.Name
	React.useEffect(function()
		Logger:debug(
			"{} - pip applied: enabled={}, session={}, callId={}, phase={}, connectedAt={}",
			script.Name,
			tostring(enabled),
			v2.session,
			callId,
			v4,
			(tostring(at))
		)
	end, { callId, at, enabled, v4, v2.session })
	local v5 = {
		enabled = enabled,
		session = v2.session,
		expandCount = expandCount,
		connectedAt = at,
		callId = 0,
		participant = 0
	}
	local callId2

	if v3 then
		callId2 = v3.callId
	end

	v5.callId = callId2
	v5.participant = participant
	return v5
end

return useCallPipViewModel
