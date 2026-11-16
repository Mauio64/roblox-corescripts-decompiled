local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseGuacForFOMOUpsell = SharedFlags.FFlagExpChatUseGuacForFOMOUpsell
local UniversalAppPolicy

if FFlagExpChatUseGuacForFOMOUpsell then
	UniversalAppPolicy = require(parent.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

local IXPServiceWrapper = require(ExpChat.IXPServiceWrapper)

local defineFastString = game:DefineFastString("ExpChatFOMOUpsellIXPLayerName", "User.Communication.NonAgeCheckedUser")
local defineFastString2 = game:DefineFastString("ExpChatFOMOUpsellIXPLayerValue", "FOMOUpsellEnabled")

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
	if not (FFlagExpChatUseGuacForFOMOUpsell and UniversalAppPolicy.getAppFeaturePolicies().getShowFOMOUpsell()) then
		return false
	end

	if success and result then
		return result[defineFastString2]
	end

	return fetchIXPData()
end
