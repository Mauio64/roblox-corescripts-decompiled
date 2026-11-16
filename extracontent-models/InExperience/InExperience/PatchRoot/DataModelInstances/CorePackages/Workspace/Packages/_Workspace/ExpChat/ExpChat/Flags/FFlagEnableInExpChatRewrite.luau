local parent = script:FindFirstAncestor("ExpChat").Parent

local SocialExperiments = require(parent.SocialExperiments)

local engineFeature = game:GetEngineFeature("EnableInExpChatRewrite")
local defineFastString = game:DefineFastString("InExpChatRewriteDeviceNameBlackList", "")
local defineFastString2 = game:DefineFastString("InExpChatRewriteOsVersionBlackList", "")
local defineFastFlag = game:DefineFastFlag("EnableDeviceGateForInExpChatRewrite", false)

if engineFeature and defineFastFlag then
	return not SocialExperiments.GetIsDeviceGated({
		enabled = defineFastFlag,
		featureName = SocialExperiments.DeviceGateFeature.InExpChatRewrite,
		deviceNameBlackListString = defineFastString,
		osVersionBlackListString = defineFastString2
	})
end

return engineFeature
