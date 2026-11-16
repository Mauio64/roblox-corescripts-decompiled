local parent = script:FindFirstAncestor("FriendsChat").Parent

local Signals = require(parent.Signals)
local InExperienceAppChatModal = require(parent.AppChat.InExperienceAppChatModal)
local GetFriendsTabVisibilityStore = require(script.Parent.Parent.GetFriendsTabVisibilityStore)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

return function()
	local signal, v = createSignal(0)

	local v2 = 0
	local v3 = false

	local getUnreadCountToDisplay = createComputed(function(p)
		if GetFriendsTabVisibilityStore(p).getIsFriendsTabVisible(p) then
			return signal(p)
		end

		return 0
	end)

	local function establishBaseline(unreadCount: number) -- 1 equivalent call inferred from this helper
		v3 = true
		v2 = unreadCount
		v(0)
	end

	local function recordCanonicalCount(p: number)
		if v3 and GetFriendsTabVisibilityStore(false).getIsFriendsTabVisible(false) then
			local v4 = p - v2

			if v4 > 0 then
				v(signal(false) + v4)
			end
		end

		v2 = p
	end

	local function clearDisplayCount()
		v(0)
	end

	local default = InExperienceAppChatModal.default

	if default.hasReceivedInitialUnreadCount then
		establishBaseline(default.unreadCount or 0) -- inferred equivalent call
	end

	default.initialUnreadCountSignal.Event:Connect(establishBaseline)
	default.unreadCountSignal.Event:Connect(recordCanonicalCount)

	return {
		getUnreadCountToDisplay = getUnreadCountToDisplay,
		clearDisplayCount = clearDisplayCount
	}
end
