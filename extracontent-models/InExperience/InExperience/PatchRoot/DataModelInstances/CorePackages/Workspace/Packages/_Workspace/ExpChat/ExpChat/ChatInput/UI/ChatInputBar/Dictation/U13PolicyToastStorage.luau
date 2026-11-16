local ExpChat = script:FindFirstAncestor("ExpChat")

local perUserAppStorage = require(ExpChat.Utils.perUserAppStorage)
local U13PolicyToastStorage = {}

function U13PolicyToastStorage.hasBeenShown(): boolean
	return perUserAppStorage.getEntry("ExpChatDictationU13PolicyToast").shown == true
end

function U13PolicyToastStorage.markShown()
	perUserAppStorage.updateEntry("ExpChatDictationU13PolicyToast", function(p)
		if p.shown == true then
			return nil
		end

		p.shown = true
		return p
	end)
end

return U13PolicyToastStorage
