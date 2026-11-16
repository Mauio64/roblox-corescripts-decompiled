local parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local GetConversationStore = require(parent.AppChat.GetConversationStore)
local getFFlagAppChatEnableRootedNavigation = require(parent.AppChat.getFFlagAppChatEnableRootedNavigation)

return function()
	local signal, setSelectedConversationId = createSignal(nil)

	local signal2, v = createSignal(nil)

	local signal3, v2 = createSignal(nil)
	local signal4, setInputBarFocused = createSignal(false)
	local getEffectiveConversationId, cleanup

	if getFFlagAppChatEnableRootedNavigation() then
		getEffectiveConversationId = Signals.createComputed(function(p)
			local v3 = signal(p)

			if not (v3 ~= nil and GetConversationStore(p).getConversation(v3, p) ~= nil) then
				return nil
			end

			return v3
		end)

		local v3 = nil
		cleanup = Signals.createEffect(function(p)
			local v4 = signal(p)
			local v5 = getEffectiveConversationId(p)

			if v5 ~= nil then
				v3 = v5
				return
			end

			if v4 == nil or v4 ~= v3 then
				v3 = nil

				return
			end

			v3 = nil
			setSelectedConversationId(nil)
		end)
	else
		getEffectiveConversationId = signal

		cleanup = function() end
	end

	return {
		getSelectedConversationId = signal,
		getEffectiveConversationId = getEffectiveConversationId,
		setSelectedConversationId = setSelectedConversationId,
		getFocusInputBarRequestTime = signal2,
		requestFocusInputBar = function(p: number?)
			v(p or os.clock())
		end,
		clearFocusInputBarRequest = function()
			v(nil)
		end,
		getConversationListFocusRequestTime = signal3,
		requestFocusConversationList = function(p: number?)
			v2(p or os.clock())
		end,
		clearConversationListFocusRequest = function()
			v2(nil)
		end,
		getIsInputBarFocused = signal4,
		setInputBarFocused = setInputBarFocused,
		cleanup = cleanup
	}
end
