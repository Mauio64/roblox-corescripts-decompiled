local UserInputService = game:GetService("UserInputService")
local AvatarChatService = game:GetService("AvatarChatService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local SocialExperiments = require(Parent.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE
local FFlagAEGIS2UseGuacToShowFAEUpsell = require(Parent.SharedFlags).FFlagAEGIS2UseGuacToShowFAEUpsell
local UniversalAppPolicy = nil

if FFlagAEGIS2UseGuacToShowFAEUpsell then
	UniversalAppPolicy = require(Parent.UniversalAppPolicy)
end

return function() -- line: 21
	-- upvalues: FFlagAEGIS2UseGuacToShowFAEUpsell (copy), UserInputService (copy), AvatarChatService (copy), FFlagTestDeviceForFAEUpsell (copy), deviceMeetsRequirementsForFAE (copy), UniversalAppPolicy (ref)
	if FFlagAEGIS2UseGuacToShowFAEUpsell then
		local v9 = UniversalAppPolicy.getAppFeaturePolicies().getShowInExpFAEUpsell()

		if v9 then
			v9 = AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

			if v9 then
				if FFlagTestDeviceForFAEUpsell then
					return (deviceMeetsRequirementsForFAE())
				end

				v9 = true
			end
		end

		return v9
	end

	local Platform = UserInputService:GetPlatform()
	local v11

	if Platform ~= Enum.Platform.IOS and Platform ~= Enum.Platform.Android and Platform ~= Enum.Platform.Windows then
		v11 = false

		if Platform ~= Enum.Platform.OSX then
			return v11
		end
	end

	v11 = AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

	if v11 then
		if FFlagTestDeviceForFAEUpsell then
			return (deviceMeetsRequirementsForFAE())
		end

		v11 = true
	end

	return v11
end
