local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux2.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags2.FFlagEnableAEGIS2CommsFAEUpsell
local defineFastFlag = game:DefineFastFlag("ManuallyInvokeAmpUpsell2", false)
local manuallyInvokeAmpUpsell = require(SocialUpsell.Utils.manuallyInvokeAmpUpsell)

local SharedFlags3 = require(parent.SharedFlags)
local FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = SharedFlags3.FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature
local SharedFlags4 = require(parent.SharedFlags)
local FStringCoreContentAmpNameSpace = SharedFlags4.FStringCoreContentAmpNameSpace

local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local featureName

if defineFastFlag then
	featureName = require(SocialUpsell.Flag.FStringCommsFAEFeatureName)
else
	featureName = game:DefineFastString("CommsFAEFeatureName", "TriggerAgeVerifyRecourse")
end

local nameSpace

if defineFastFlag then
	nameSpace = require(SocialUpsell.Flag.FStringCommsFAENamespace)
else
	nameSpace = game:DefineFastString("CommsFAENamespace", "social/Upsells")
end

return function(p: string?, callback, callback2, source: string?, flag: boolean?, flag2: boolean?)
	return function(object)
		if flag2 then
			local v = p or SocialUpsellType.FacialAgeEstimation .. (source or "")
			local function vpcCompletionCallback(p2, _)
				if p2 == AccessResponseEnum.Granted then
					if callback then
						callback()
					end
				elseif callback2 then
					callback2()
				end
			end

			if FFlagEnableAEGIS2CommsFAEUpsell and flag then
				return InExpAmpWizardController.OpenAmpWizardContainerInExp(
					FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature,
					vpcCompletionCallback,
					nil,
					v,
					nil,
					FStringCoreContentAmpNameSpace
				)
			end

			return object:dispatch(OpenAmpWizardContainer(
				FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature,
				vpcCompletionCallback,
				nil,
				v,
				nil,
				FStringCoreContentAmpNameSpace
			))
		elseif FFlagEnableAEGIS2CommsFAEUpsell and flag then
			local v = p or SocialUpsellType.FacialAgeEstimation

			if defineFastFlag then
				return (manuallyInvokeAmpUpsell(v, callback, callback2))
			end

			return (InExpAmpWizardController.OpenAmpWizardContainerInExp(featureName, function(p2, _)
				if p2 == AccessResponseEnum.Granted then
					if callback then
						callback()
					end
				elseif callback2 then
					callback2()
				end
			end, nil, v, nil, nameSpace))
		else
			local v = {
				name = AppPage.AmpWizardContainer,
				extraProps = {
					featureName = featureName,
					nameSpace = nameSpace,
					entryPointEventCtx = p or SocialUpsellType.FacialAgeEstimation,
					metadata = { source = source },
					skipFacialAgeEstimationWebLinkModal = true,
					completionCallback = function(p2, _)
						if FFlagSignalsNavP3Dispatch then
							navigationCommands.back(true)
						else
							object:dispatch(NavigateBack(true))
						end

						if p2 == AccessResponseEnum.Granted then
							if callback then
								callback()
							end
						elseif callback2 then
							callback2()
						end
					end
				}
			}

			if FFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(v))
			end

			return object:dispatch(NavigateDown(v))
		end
	end
end
