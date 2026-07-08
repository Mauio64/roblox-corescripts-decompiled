local Parent = script:FindFirstAncestor("ExpChat").Parent
local SocialExperiments = require(Parent.SocialExperiments)
local EngineFeature = game:GetEngineFeature("EnableInExpChatRewrite")
local v4 = game:DefineFastString("InExpChatRewriteDeviceNameBlackList", "")
local v5 = game:DefineFastString("InExpChatRewriteOsVersionBlackList", "")
local v6 = game:DefineFastFlag("EnableDeviceGateForInExpChatRewrite", false)

if EngineFeature and v6 then
	return not SocialExperiments.GetIsDeviceGated({
		enabled = v6,
		featureName = SocialExperiments.DeviceGateFeature.InExpChatRewrite,
		deviceNameBlackListString = v4,
		osVersionBlackListString = v5
	})
end

return EngineFeature
