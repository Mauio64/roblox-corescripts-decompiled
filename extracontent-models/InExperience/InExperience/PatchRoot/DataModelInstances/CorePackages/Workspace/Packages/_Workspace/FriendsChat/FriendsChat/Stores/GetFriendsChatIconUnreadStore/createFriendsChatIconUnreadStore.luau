local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local InExperienceAppChatModal = require(Parent.AppChat.InExperienceAppChatModal)
local createSignal = Signals.createSignal

return function() -- line: 34
	-- upvalues: createSignal (copy), InExperienceAppChatModal (copy)
	local v5, v6 = createSignal(0)
	local n1 = 0
	local u8 = false

	local function establishBaseline(n2: number) -- line: 40
		-- upvalues: u8 (ref), n1 (ref), v6 (copy)
		u8 = true
		n1 = n2
		v6(0)
	end
	local function recordCanonicalCount(n3: number) -- line: 46
		-- upvalues: u8 (ref), n1 (ref), v6 (copy), v5 (copy)
		if u8 then
			local v15 = n3 - n1

			if v15 > 0 then
				v6(v5(false) + v15)
			end
		end

		n1 = n3
	end

	local default = InExperienceAppChatModal.default

	if default.hasReceivedInitialUnreadCount then
		local v12 = default.unreadCount or 0

		u8 = true
		n1 = v12
		v6(0)
	end

	default.initialUnreadCountSignal.Event:Connect(establishBaseline)
	default.unreadCountSignal.Event:Connect(recordCanonicalCount)

	return {
		getUnreadCountToDisplay = v5,
		clearDisplayCount = function() -- line: 56
			-- upvalues: v6 (copy)
			v6(0)
		end
	}
end
