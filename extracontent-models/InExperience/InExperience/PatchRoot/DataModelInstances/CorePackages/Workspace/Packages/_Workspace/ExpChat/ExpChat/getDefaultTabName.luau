local ExpChat = script:FindFirstAncestor("ExpChat")

local isGlobalTabFirst = require(ExpChat.isGlobalTabFirst)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)

local function getDefaultTabName(p): nil | string
	if FFlagExpChatGlobalTabDefault and isGlobalTabFirst() and p.RBXGlobal ~= nil then
		return "RBXGlobal"
	end

	return if p.RBXGeneral ~= nil then "RBXGeneral" else nil
end

return getDefaultTabName
