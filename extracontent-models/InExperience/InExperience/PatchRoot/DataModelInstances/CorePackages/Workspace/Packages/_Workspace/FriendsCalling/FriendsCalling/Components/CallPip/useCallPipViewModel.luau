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

local function getOtherParticipant(p)
	local localPlayer = Players.LocalPlayer
	local v2 = not localPlayer and 0 or localPlayer.UserId
	local otherParticipant = nil

	for _, participant in p.participants do
		if participant.userId == v2 then
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

	local callId = v3 and v3.callId or ""
	local v4 = not v3 and "" or v3.phase.Name
	React.useEffect(function()
		Logger:debug(
			"{} - pip applied: enabled={}, session={}, callId={}, phase={}, connectedAt={}",
			script.Name,
			tostring(v2.hasCall),
			v2.session,
			callId,
			v4,
			(tostring(at))
		)
	end, { callId, at, v4, v2.hasCall, v2.session })
	local v5 = {
		enabled = v2.hasCall,
		session = v2.session,
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
