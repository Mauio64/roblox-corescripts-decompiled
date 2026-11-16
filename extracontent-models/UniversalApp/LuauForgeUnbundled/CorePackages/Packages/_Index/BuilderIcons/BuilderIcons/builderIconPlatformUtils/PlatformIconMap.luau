local module = require("@luauforge/bundled/ftu")
local module2 = require("@luauforge/bundled/ftv")

local fFlagEnableMicrosoftStorePaymentsPlatform = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMicrosoftStorePaymentsPlatform

local fFlagEnableMilkyWayPaymentsPlatformV2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMilkyWayPaymentsPlatformV2

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies

return function(p2, p3, p4)
	if p2 == Enum.Platform.XBoxOne then
		return module.Xbox
	end

	if p2 == Enum.Platform.IOS then
		return module.Apple
	end

	if p2 == Enum.Platform.Windows or p2 == Enum.Platform.OSX or p2 == Enum.Platform.Linux then
		if
			fFlagEnableMicrosoftStorePaymentsPlatform
			and getAppFeaturePolicies().getUsePaymentPlatformMicrosoftStore()
		then
			return module.Microsoft
		end

		return module.Web
	elseif p2 == Enum.Platform.Android then
		if p3 then
			return module.Amazon
		end

		if p4 then
			return module.Maquettes
		end

		if
			fFlagEnableMilkyWayPaymentsPlatformV2
			and getAppFeaturePolicies().getUsePaymentPlatformMilkyWayStore()
		then
			return module.MilkyWay
		end

		return module.Google
	else
		if p2 == Enum.Platform.UWP then
			return module.UWP
		end

		if module2() and (p2 == Enum.Platform.PS4 or p2 == Enum.Platform.PS5) then
			return module.Palisades
		end

		return module.None
	end
end
