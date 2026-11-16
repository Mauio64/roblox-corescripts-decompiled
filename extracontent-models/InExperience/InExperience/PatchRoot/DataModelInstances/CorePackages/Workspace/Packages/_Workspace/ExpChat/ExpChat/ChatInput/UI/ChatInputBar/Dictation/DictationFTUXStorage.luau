local ExpChat = script:FindFirstAncestor("ExpChat")

local perUserAppStorage = require(ExpChat.Utils.perUserAppStorage)
local DictationFTUXStorage = {}

function DictationFTUXStorage.hasBeenDismissed(): boolean
	return perUserAppStorage.getEntry("ExpChatDictationFtux").dismissed == true
end

function DictationFTUXStorage.markDismissed()
	perUserAppStorage.updateEntry("ExpChatDictationFtux", function(p)
		if p.dismissed == true then
			return nil
		end

		p.dismissed = true
		return p
	end)
end

function DictationFTUXStorage.hasBeenUsed(): boolean
	return perUserAppStorage.getEntry("ExpChatDictationFtux").used == true
end

function DictationFTUXStorage.markUsed()
	perUserAppStorage.updateEntry("ExpChatDictationFtux", function(p)
		if p.used == true then
			return nil
		end

		p.used = true
		return p
	end)
end

return DictationFTUXStorage
