local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/AmpUpsell")
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local openAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RobloxAppEnums").AppPage
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/NavigationRodux").Thunks.NavigateBack
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RobloxAppNavigation").NavigationCommands else nil

local SocialUpsellType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
local fFlagEnableAEGIS2CommsFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FFlagEnableAEGIS2CommsFAEUpsell
local defineFastFlag = game:DefineFastFlag("ManuallyInvokeAmpUpsell2", false)
local manuallyInvokeAmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/manuallyInvokeAmpUpsell")

local fStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature
local fStringCoreContentAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FStringCoreContentAmpNameSpace

local inExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local v5

if defineFastFlag then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FStringCommsFAEFeatureName")
else
	v5 = game:DefineFastString("CommsFAEFeatureName", "TriggerAgeVerifyRecourse")
end

local v6

if defineFastFlag then
	v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FStringCommsFAENamespace")
else
	v6 = game:DefineFastString("CommsFAENamespace", "social/Upsells")
end

return function(p2, callback, callback2, value, p3, p4)
	return function(object)
		if p4 then
			local v7 = p2 or SocialUpsellType.FacialAgeEstimation .. (value or "")
			local function vpcCompletionCallback(p5, p6)
				if p5 == accessResponseEnum.Granted then
					if callback then
						callback()
					end
				elseif callback2 then
					callback2()
				end
			end

			if fFlagEnableAEGIS2CommsFAEUpsell and p3 then
				return inExpAmpWizardController.OpenAmpWizardContainerInExp(
					fStringTriggerAgeCheckUpsellIncludingVPCAmpFeature,
					vpcCompletionCallback,
					nil,
					v7,
					nil,
					fStringCoreContentAmpNameSpace
				)
			end

			return object:dispatch(openAmpWizardContainer(
				fStringTriggerAgeCheckUpsellIncludingVPCAmpFeature,
				vpcCompletionCallback,
				nil,
				v7,
				nil,
				fStringCoreContentAmpNameSpace
			))
		elseif fFlagEnableAEGIS2CommsFAEUpsell and p3 then
			local v7 = p2 or SocialUpsellType.FacialAgeEstimation

			if defineFastFlag then
				return (manuallyInvokeAmpUpsell(v7, callback, callback2))
			end

			return (inExpAmpWizardController.OpenAmpWizardContainerInExp(v5, function(p5, p6)
				if p5 == accessResponseEnum.Granted then
					if callback then
						callback()
					end
				elseif callback2 then
					callback2()
				end
			end, nil, v7, nil, v6))
		else
			local v7 = {
				name = appPage.AmpWizardContainer,
				extraProps = {
					featureName = v5,
					nameSpace = v6,
					entryPointEventCtx = p2 or SocialUpsellType.FacialAgeEstimation,
					metadata = { source = value },
					skipFacialAgeEstimationWebLinkModal = true,
					completionCallback = function(p5, p6)
						if fFlagSignalsNavP3Dispatch then
							navigationCommands.back(true)
						else
							object:dispatch(navigateBack(true))
						end

						if p5 == accessResponseEnum.Granted then
							if callback then
								callback()
							end
						elseif callback2 then
							callback2()
						end
					end
				}
			}

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(v7))
			end

			return object:dispatch(navigateDown(v7))
		end
	end
end
