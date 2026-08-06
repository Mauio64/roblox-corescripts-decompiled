local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local InExperienceAppChatModal = require(Parent.AppChat.InExperienceAppChatModal)
local GetFriendsTabVisibilityStore = require(script.Parent.Parent.GetFriendsTabVisibilityStore)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

return function() -- line: 41
	-- upvalues: createSignal (copy), createComputed (copy), GetFriendsTabVisibilityStore (copy), InExperienceAppChatModal (copy)
	local v7, v8 = createSignal(0)
	local n1 = 0
	local u10 = false
	local v11 = createComputed(function(p1) -- line: 50
		-- upvalues: GetFriendsTabVisibilityStore (copy), v7 (copy)
		if not GetFriendsTabVisibilityStore(p1).getIsFriendsTabVisible(p1) then
			return 0
		end

		return v7(p1)
	end)

	local function establishBaseline(n2: number) -- line: 57
		-- upvalues: u10 (ref), n1 (ref), v8 (copy)
		u10 = true
		n1 = n2
		v8(0)
	end
	local function recordCanonicalCount(n3: number) -- line: 63
		-- upvalues: u10 (ref), GetFriendsTabVisibilityStore (copy), n1 (ref), v8 (copy), v7 (copy)
		if u10 and GetFriendsTabVisibilityStore(false).getIsFriendsTabVisible(false) then
			local v19 = n3 - n1

			if v19 > 0 then
				v8(v7(false) + v19)
			end
		end

		n1 = n3
	end

	local default = InExperienceAppChatModal.default

	if default.hasReceivedInitialUnreadCount then
		local v15 = default.unreadCount or 0

		u10 = true
		n1 = v15
		v8(0)
	end

	default.initialUnreadCountSignal.Event:Connect(establishBaseline)
	default.unreadCountSignal.Event:Connect(recordCanonicalCount)

	return {
		getUnreadCountToDisplay = v11,
		clearDisplayCount = function() -- line: 75
			-- upvalues: v8 (copy)
			v8(0)
		end
	}
end
