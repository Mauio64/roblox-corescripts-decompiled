local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local PeopleUtility = require(ParentParent.PeopleUtility)
local ButtonVariant = require(ParentParentParent.Foundation).Enums.ButtonVariant
local PeopleBlockStatusStore = require(script.Parent.PeopleBlockStatusStore)

local function createFriendStatusStore() -- line: 31
	-- upvalues: Players (copy), Signals (copy), PeopleUtility (copy), PeopleBlockStatusStore (copy), ButtonVariant (copy)
	local LocalPlayer = Players.LocalPlayer
	local t1 = {}
	local connection = nil

	local function getCurrentFriendStatus(n1: number) -- line: 42
		-- upvalues: LocalPlayer (copy), Players (copy)
		if not n1 or not LocalPlayer then
			return Enum.FriendStatus.Unknown
		end

		local ok, result = pcall(function() -- line: 47
			-- upvalues: Players (copy), n1 (copy), LocalPlayer (copy)
			local PlayerByUserId = Players:GetPlayerByUserId(n1)

			if PlayerByUserId then
				return LocalPlayer:GetFriendStatus(PlayerByUserId)
			end

			return Enum.FriendStatus.Unknown
		end)

		return ok and result or Enum.FriendStatus.Unknown
	end
	local function getFriendStatusSignal(n2: number) -- line: 60
		-- upvalues: Signals (copy), t1 (ref), LocalPlayer (copy), Players (copy)
		if not n2 then
			return Signals.createSignal(Enum.FriendStatus.Unknown)
		end

		if t1[n2] then
			return t1[n2].getter
		end

		local Unknown

		if not n2 or not LocalPlayer then
			Unknown = Enum.FriendStatus.Unknown
		else
			local ok, result = pcall(function() -- line: 47
				-- upvalues: Players (copy), n2 (copy), LocalPlayer (copy)
				local PlayerByUserId = Players:GetPlayerByUserId(n2)

				if PlayerByUserId then
					return LocalPlayer:GetFriendStatus(PlayerByUserId)
				end

				return Enum.FriendStatus.Unknown
			end)

			Unknown = ok and result or Enum.FriendStatus.Unknown
		end

		local v23, v24 = Signals.createSignal(Unknown)

		t1[n2] = {
			getter = v23,
			setter = v24
		}

		return v23
	end
	local function onFriendStatusChanged(p1, p2) -- line: 86
		-- upvalues: t1 (ref)
		if t1[p1.UserId] then
			t1[p1.UserId].setter(p2)
		end
	end
	local function initializeFriendStatusListener() -- line: 192
		-- upvalues: LocalPlayer (copy), connection (ref), onFriendStatusChanged (copy)
		if LocalPlayer then
			connection = LocalPlayer.FriendStatusChanged:Connect(onFriendStatusChanged)
		end
	end

	if LocalPlayer then
		connection = LocalPlayer.FriendStatusChanged:Connect(onFriendStatusChanged)
	end

	return {
		getShouldShowFriendButton = function(n3: number?, p3) -- line: 94
			-- upvalues: Signals (copy), PeopleUtility (copy), PeopleBlockStatusStore (copy)
			return Signals.createComputed(function(p4) -- line: 95
				-- upvalues: PeopleUtility (copy), p3 (copy), n3 (copy), PeopleBlockStatusStore (copy)
				if not PeopleUtility.showPersonButtons(p3, n3) or not n3 then
					return false
				end

				return not PeopleBlockStatusStore.getPlayerBlockStatus(n3)(p4)
			end)
		end,
		getFriendButtonText = function(n4: number?, t2: {[any]: any}) -- line: 110
			-- upvalues: Signals (copy), getFriendStatusSignal (copy)
			if not n4 then
				return Signals.createSignal(t2.addPerson)
			end

			return Signals.createComputed(function(p5) -- line: 115
				-- upvalues: getFriendStatusSignal (copy), n4 (copy), t2 (copy)
				local v40 = getFriendStatusSignal(n4)(p5)

				if v40 == Enum.FriendStatus.Friend then
					return t2.isFriend
				end

				if v40 == Enum.FriendStatus.FriendRequestSent then
					return t2.requestSent
				end

				return t2.addPerson
			end)
		end,
		getFriendButtonVariant = function(n5: number?) -- line: 130
			-- upvalues: Signals (copy), ButtonVariant (copy), getFriendStatusSignal (copy)
			if not n5 then
				return Signals.createSignal(ButtonVariant.Subtle)
			end

			return Signals.createComputed(function(p6) -- line: 135
				-- upvalues: getFriendStatusSignal (copy), n5 (copy), ButtonVariant (copy)
				local v42 = getFriendStatusSignal(n5)(p6)

				if v42 == Enum.FriendStatus.Friend or v42 == Enum.FriendStatus.FriendRequestSent then
					return ButtonVariant.Text
				end

				return ButtonVariant.Subtle
			end)
		end,
		getFriendStatus = function(n6: number?) -- line: 147
			-- upvalues: Signals (copy), getFriendStatusSignal (copy)
			if not n6 then
				return Signals.createSignal(false)
			end

			return Signals.createComputed(function(p7) -- line: 152
				-- upvalues: getFriendStatusSignal (copy), n6 (copy)
				return getFriendStatusSignal(n6)(p7) == Enum.FriendStatus.Friend
			end)
		end,
		getIsFriendButtonDisabled = function(n7: number?) -- line: 159
			-- upvalues: Signals (copy), getFriendStatusSignal (copy)
			if not n7 then
				return Signals.createSignal(false)
			end

			return Signals.createComputed(function(p8) -- line: 164
				-- upvalues: getFriendStatusSignal (copy), n7 (copy)
				local v45 = getFriendStatusSignal(n7)(p8)

				return v45 == Enum.FriendStatus.Friend or v45 == Enum.FriendStatus.FriendRequestSent
			end)
		end,
		getIsFriendButtonGrayedOut = function(n8: number?) -- line: 171
			-- upvalues: Signals (copy), getFriendStatusSignal (copy)
			if not n8 then
				return Signals.createSignal(false)
			end

			return Signals.createComputed(function(p9) -- line: 176
				-- upvalues: getFriendStatusSignal (copy), n8 (copy)
				return getFriendStatusSignal(n8)(p9) == Enum.FriendStatus.FriendRequestSent
			end)
		end,
		sendFriendRequest = function(p10) -- line: 183
			-- upvalues: LocalPlayer (copy)
			if not p10 or not LocalPlayer then
				return
			end

			LocalPlayer:RequestFriendship(p10)
		end,
		cleanup = function() -- line: 199
			-- upvalues: connection (ref), t1 (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			t1 = {}
		end
	}
end

return (createFriendStatusStore())
