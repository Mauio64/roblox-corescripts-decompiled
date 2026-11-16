local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseGuacForCrossAgeChat = SharedFlags.FFlagExpChatUseGuacForCrossAgeChat
local UniversalAppPolicy

if FFlagExpChatUseGuacForCrossAgeChat then
	UniversalAppPolicy = require(parent.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

local IXPServiceWrapper = require(ExpChat.IXPServiceWrapper)

local defineFastString = game:DefineFastString(
	"ExpChatCrossAgeChatActivityIXPLayerName",
	"User.Communication.AgeCheckedUser"
)
local defineFastString2 = game:DefineFastString(
	"ExpChatCrossAgeChatActivityIXPLayerValue",
	"CrossAgeChatActivityEnabled"
)

local success = nil
local result = nil
local function fetchIXPData()
	success, result = pcall(function()
		return IXPServiceWrapper:GetLayerData(defineFastString)
	end)

	if not success or not result or result[defineFastString2] == nil then
		return false
	end

	IXPServiceWrapper:LogUserLayerExposure(defineFastString)
	return result[defineFastString2]
end

return function()
	if not (FFlagExpChatUseGuacForCrossAgeChat and UniversalAppPolicy.getAppFeaturePolicies().getShowCrossAgeChat()) then
		return false
	end

	if success and result then
		return result[defineFastString2]
	end

	return fetchIXPData()
end
