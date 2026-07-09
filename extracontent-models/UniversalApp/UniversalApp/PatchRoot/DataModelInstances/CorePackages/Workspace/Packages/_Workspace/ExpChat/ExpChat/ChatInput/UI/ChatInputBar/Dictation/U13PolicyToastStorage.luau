local ExpChat = script:FindFirstAncestor("ExpChat")
local perUserAppStorage = require(ExpChat.Utils.perUserAppStorage)

return {
	hasBeenShown = function() -- line: 11
		-- upvalues: perUserAppStorage (copy)
		return perUserAppStorage.getEntry("ExpChatDictationU13PolicyToast").shown == true
	end,
	markShown = function() -- line: 16
		-- upvalues: perUserAppStorage (copy)
		perUserAppStorage.updateEntry("ExpChatDictationU13PolicyToast", function(t1: {[any]: any}) -- line: 17
			if t1.shown == true then
				return nil
			end

			t1.shown = true

			return t1
		end)
	end
}
