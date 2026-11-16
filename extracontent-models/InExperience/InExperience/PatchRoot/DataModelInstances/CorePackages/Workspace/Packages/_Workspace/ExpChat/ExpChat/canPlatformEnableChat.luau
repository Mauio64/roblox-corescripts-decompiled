local UserInputService = game:GetService("UserInputService")
local AvatarChatService = game:GetService("AvatarChatService")

local parent = script:FindFirstAncestor("ExpChat").Parent
local SocialExperiments = require(parent.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE

local SharedFlags = require(parent.SharedFlags)
local FFlagAEGIS2UseGuacToShowFAEUpsell = SharedFlags.FFlagAEGIS2UseGuacToShowFAEUpsell
local UniversalAppPolicy

if FFlagAEGIS2UseGuacToShowFAEUpsell then
	UniversalAppPolicy = require(parent.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

return function()
	if FFlagAEGIS2UseGuacToShowFAEUpsell then
		local v = UniversalAppPolicy.getAppFeaturePolicies().getShowInExpFAEUpsell()
			and AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

		if not v then
			return v
		end

		if FFlagTestDeviceForFAEUpsell then
			return (deviceMeetsRequirementsForFAE())
		end

		v = true
		return true
	else
		local platform = UserInputService:GetPlatform()
		local v

		if
			platform ~= Enum.Platform.IOS
			and platform ~= Enum.Platform.Android
			and platform ~= Enum.Platform.Windows
			and platform ~= Enum.Platform.OSX
		then
			v = false
			return false
		end

		v = AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

		if not v then
			return v
		end

		if FFlagTestDeviceForFAEUpsell then
			return (deviceMeetsRequirementsForFAE())
		end

		v = true
		return true
	end
end
