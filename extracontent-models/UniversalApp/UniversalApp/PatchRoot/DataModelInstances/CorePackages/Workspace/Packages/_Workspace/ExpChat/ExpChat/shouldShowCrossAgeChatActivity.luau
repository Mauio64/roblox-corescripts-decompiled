local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local FFlagExpChatUseGuacForCrossAgeChat = require(ExpChatParent.SharedFlags).FFlagExpChatUseGuacForCrossAgeChat
local UniversalAppPolicy = nil

if FFlagExpChatUseGuacForCrossAgeChat then
	UniversalAppPolicy = require(ExpChatParent.UniversalAppPolicy)
end

local IXPServiceWrapper = require(ExpChat.IXPServiceWrapper)
local v6 = game:DefineFastString("ExpChatCrossAgeChatActivityIXPLayerName", "User.Communication.AgeCheckedUser")
local v7 = game:DefineFastString("ExpChatCrossAgeChatActivityIXPLayerValue", "CrossAgeChatActivityEnabled")
local u8 = nil
local u9 = nil

local function fetchIXPData() -- line: 21
	-- upvalues: u8 (ref), u9 (ref), IXPServiceWrapper (copy), v6 (copy), v7 (copy)
	local ok, result = pcall(function() -- line: 22
		-- upvalues: IXPServiceWrapper (copy), v6 (copy)
		return IXPServiceWrapper:GetLayerData(v6)
	end)

	u8 = ok
	u9 = result

	if not u8 or (not u9 or u9[v7] == nil) then
		return false
	end

	IXPServiceWrapper:LogUserLayerExposure(v6)

	return u9[v7]
end

return function() -- line: 35
	-- upvalues: FFlagExpChatUseGuacForCrossAgeChat (copy), UniversalAppPolicy (ref), u8 (ref), u9 (ref), v7 (copy), fetchIXPData (copy)
	if not FFlagExpChatUseGuacForCrossAgeChat then
		return false
	end

	if not UniversalAppPolicy.getAppFeaturePolicies().getShowCrossAgeChat() then
		return false
	end

	if u8 and u9 then
		return u9[v7]
	end

	return (fetchIXPData())
end
