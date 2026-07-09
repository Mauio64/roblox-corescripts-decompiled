local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local AmpUpsell = require(SocialUpsellParent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local AppPage = require(SocialUpsellParent.RobloxAppEnums).AppPage
local NavigateBack = require(SocialUpsellParent.NavigationRodux).Thunks.NavigateBack
local NavigateDown = require(SocialUpsellParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(SocialUpsellParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialUpsellParent.RobloxAppNavigation).NavigationCommands
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local FFlagEnableAEGIS2CommsFAEUpsell = require(SocialUpsellParent.SharedFlags).FFlagEnableAEGIS2CommsFAEUpsell
local v13 = game:DefineFastFlag("ManuallyInvokeAmpUpsell2", false)
local FFlagSupportVPC = require(SocialUpsell.Flag.FFlagSupportVPC)
local manuallyInvokeAmpUpsell = require(SocialUpsell.Utils.manuallyInvokeAmpUpsell)
local FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = require(SocialUpsellParent.SharedFlags).FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature
local FStringCoreContentAmpNameSpace = require(SocialUpsellParent.SharedFlags).FStringCoreContentAmpNameSpace
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local v19 = if not v13 then game:DefineFastString("CommsFAEFeatureName", "TriggerAgeVerifyRecourse") else require(SocialUpsell.Flag.FStringCommsFAEFeatureName)
local v20 = if not v13 then game:DefineFastString("CommsFAENamespace", "social/Upsells") else require(SocialUpsell.Flag.FStringCommsFAENamespace)

return function(s1: string?, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?, s2: string?, b1: boolean?, b2: boolean?) -- line: 33
	-- upvalues: FFlagSupportVPC (copy), SocialUpsellType (copy), AccessResponseEnum (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), InExpAmpWizardController (copy), FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature (copy), FStringCoreContentAmpNameSpace (copy), OpenAmpWizardContainer (copy), v13 (copy), manuallyInvokeAmpUpsell (copy), v19 (copy), v20 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateBack (copy), NavigateDown (copy)
	return function(p3) -- line: 42
		-- upvalues: FFlagSupportVPC (copy), b2 (copy), s1 (copy), SocialUpsellType (copy), s2 (copy), AccessResponseEnum (copy), p1 (copy), p2 (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), b1 (copy), InExpAmpWizardController (copy), FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature (copy), FStringCoreContentAmpNameSpace (copy), OpenAmpWizardContainer (copy), v13 (copy), manuallyInvokeAmpUpsell (copy), v19 (copy), v20 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateBack (copy), NavigateDown (copy)
		if FFlagSupportVPC and b2 then
			local v28 = s1 or SocialUpsellType.FacialAgeEstimation .. (s2 or "")

			local function vpcCompletionCallback(p4, _) -- line: 46
				-- upvalues: AccessResponseEnum (copy), p1 (copy), p2 (copy)
				if p4 == AccessResponseEnum.Granted then
					if p1 then
						p1()

						return
					end
				elseif p2 then
					p2()
				end
			end

			if FFlagEnableAEGIS2CommsFAEUpsell and b1 then
				return InExpAmpWizardController.OpenAmpWizardContainerInExp(FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature, vpcCompletionCallback, nil, v28, nil, FStringCoreContentAmpNameSpace)
			end

			return p3:dispatch(OpenAmpWizardContainer(FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature, vpcCompletionCallback, nil, v28, nil, FStringCoreContentAmpNameSpace))
		end

		if FFlagEnableAEGIS2CommsFAEUpsell and b1 then
			local v30 = s1 or SocialUpsellType.FacialAgeEstimation

			if v13 then
				return (manuallyInvokeAmpUpsell(v30, p1, p2))
			end

			return (InExpAmpWizardController.OpenAmpWizardContainerInExp(v19, function(p6, _) -- line: 85
				-- upvalues: AccessResponseEnum (copy), p1 (copy), p2 (copy)
				if p6 == AccessResponseEnum.Granted then
					if p1 then
						p1()

						return
					end
				elseif p2 then
					p2()
				end
			end, nil, v30, nil, v20))
		end

		local t1 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				skipFacialAgeEstimationWebLinkModal = true,
				featureName = v19,
				nameSpace = v20,
				entryPointEventCtx = s1 or SocialUpsellType.FacialAgeEstimation,
				metadata = {
					source = s2
				},
				completionCallback = function(p8, _) -- line: 113
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v10 (copy), p3 (copy), NavigateBack (copy), AccessResponseEnum (copy), p1 (copy), p2 (copy)
					if FFlagSignalsNavP3Dispatch then
						v10.back(true)
					else
						p3:dispatch(NavigateBack(true))
					end

					if p8 == AccessResponseEnum.Granted then
						if p1 then
							p1()

							return
						end
					elseif p2 then
						p2()
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			return v10.down(v10.fromLegacyPage(t1))
		end

		return p3:dispatch(NavigateDown(t1))
	end
end
