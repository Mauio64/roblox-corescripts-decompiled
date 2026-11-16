local Players = game:GetService("Players")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local PeopleUtility = require(parent.PeopleUtility)
local Foundation = require(parent2.Foundation)

local ButtonVariant = Foundation.Enums.ButtonVariant

local PeopleBlockStatusStore = require(script.Parent.PeopleBlockStatusStore)

local function createFriendStatusStore()
	local localPlayer = Players.LocalPlayer

	local v = {}

	local friendStatusChangedConnection = nil

	local function getCurrentFriendStatus(p: number) -- 1 equivalent call inferred from this helper
		if p and localPlayer then
			local success, result = pcall(function()
				local playerByUserId = Players:GetPlayerByUserId(p)

				if playerByUserId then
					return localPlayer:GetFriendStatus(playerByUserId)
				end

				return Enum.FriendStatus.Unknown
			end)

			return success and result or Enum.FriendStatus.Unknown
		end

		return Enum.FriendStatus.Unknown
	end

	local function getFriendStatusSignal(p: number)
		if not p then
			return Signals.createSignal(Enum.FriendStatus.Unknown)
		end

		if v[p] then
			return v[p].getter
		end

		local currentFriendStatus = getCurrentFriendStatus(p) -- inferred equivalent call
		local signal, setter = Signals.createSignal(currentFriendStatus)

		v[p] = { getter = signal, setter = setter }

		return signal
	end

	local function onFriendStatusChanged(p, p2)
		if v[p.UserId] then
			v[p.UserId].setter(p2)
		end
	end

	local function getShouldShowFriendButton(p: number?, p2)
		return Signals.createComputed(function(p3): boolean
			if PeopleUtility.showPersonButtons(p2, p) and p then
				return not PeopleBlockStatusStore.getPlayerBlockStatus(p)(p3)
			end

			return false
		end)
	end

	local function getFriendButtonText(p: number?, data)
		if p then
			return Signals.createComputed(function(p2)
				local v2 = getFriendStatusSignal(p)(p2)

				if v2 == Enum.FriendStatus.Friend then
					return data.isFriend
				end

				if v2 == Enum.FriendStatus.FriendRequestSent then
					return data.requestSent
				end

				return data.addPerson
			end)
		end

		return Signals.createSignal(data.addPerson)
	end

	local function getFriendButtonVariant(p: number?)
		if p then
			return Signals.createComputed(function(p2)
				local v2 = getFriendStatusSignal(p)(p2)

				if v2 == Enum.FriendStatus.Friend or v2 == Enum.FriendStatus.FriendRequestSent then
					return ButtonVariant.Text
				end

				return ButtonVariant.Subtle
			end)
		end

		return Signals.createSignal(ButtonVariant.Subtle)
	end

	local function getFriendStatus(p: number?)
		if p then
			return Signals.createComputed(function(p2): boolean
				return getFriendStatusSignal(p)(p2) == Enum.FriendStatus.Friend
			end)
		end

		return Signals.createSignal(false)
	end

	local function getIsFriendButtonDisabled(p: number?)
		if p then
			return Signals.createComputed(function(p2): boolean
				local v2 = getFriendStatusSignal(p)(p2)
				return v2 == Enum.FriendStatus.Friend or v2 == Enum.FriendStatus.FriendRequestSent
			end)
		end

		return Signals.createSignal(false)
	end

	local function getIsFriendButtonGrayedOut(p: number?)
		if p then
			return Signals.createComputed(function(p2): boolean
				return getFriendStatusSignal(p)(p2) == Enum.FriendStatus.FriendRequestSent
			end)
		end

		return Signals.createSignal(false)
	end

	local function sendFriendRequest(p)
		if p and localPlayer then
			localPlayer:RequestFriendship(p)
		end
	end

	local function initializeFriendStatusListener() -- 1 equivalent call inferred from this helper
		if localPlayer then
			friendStatusChangedConnection = localPlayer.FriendStatusChanged:Connect(onFriendStatusChanged)
		end
	end

	local function cleanup()
		if friendStatusChangedConnection then
			friendStatusChangedConnection:Disconnect()
			friendStatusChangedConnection = nil
		end

		v = {}
	end

	initializeFriendStatusListener() -- inferred equivalent call
	return {
		getShouldShowFriendButton = getShouldShowFriendButton,
		getFriendButtonText = getFriendButtonText,
		getFriendButtonVariant = getFriendButtonVariant,
		getFriendStatus = getFriendStatus,
		getIsFriendButtonDisabled = getIsFriendButtonDisabled,
		getIsFriendButtonGrayedOut = getIsFriendButtonGrayedOut,
		sendFriendRequest = sendFriendRequest,
		cleanup = cleanup
	}
end

return createFriendStatusStore()
