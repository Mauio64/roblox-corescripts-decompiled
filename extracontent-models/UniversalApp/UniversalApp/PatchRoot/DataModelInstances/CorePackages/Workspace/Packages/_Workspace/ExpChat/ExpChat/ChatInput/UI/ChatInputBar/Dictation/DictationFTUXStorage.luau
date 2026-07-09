local ExpChat = script:FindFirstAncestor("ExpChat")
local perUserAppStorage = require(ExpChat.Utils.perUserAppStorage)

return {
	hasBeenDismissed = function() -- line: 16
		-- upvalues: perUserAppStorage (copy)
		return perUserAppStorage.getEntry("ExpChatDictationFtux").dismissed == true
	end,
	markDismissed = function() -- line: 21
		-- upvalues: perUserAppStorage (copy)
		perUserAppStorage.updateEntry("ExpChatDictationFtux", function(t1: {[any]: any}) -- line: 22
			if t1.dismissed == true then
				return nil
			end

			t1.dismissed = true

			return t1
		end)
	end,
	hasBeenUsed = function() -- line: 31
		-- upvalues: perUserAppStorage (copy)
		return perUserAppStorage.getEntry("ExpChatDictationFtux").used == true
	end,
	markUsed = function() -- line: 36
		-- upvalues: perUserAppStorage (copy)
		perUserAppStorage.updateEntry("ExpChatDictationFtux", function(t2: {[any]: any}) -- line: 37
			if t2.used == true then
				return nil
			end

			t2.used = true

			return t2
		end)
	end
}
