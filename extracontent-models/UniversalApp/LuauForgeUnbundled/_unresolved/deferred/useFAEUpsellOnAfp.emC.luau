local module = require("@luauforge/deferred/eil")

local module2 = require("@luauforge/deferred/eiD")
local module3 = require("@luauforge/deferred/eiy")

local module4 = require("@luauforge/deferred/eiz")
local fStringEligibleToAgeVerifyAmpFeature = module4.FStringEligibleToAgeVerifyAmpFeature
local fStringAgeCheckAmpNameSpace = module4.FStringAgeCheckAmpNameSpace

local module5 = require("@luauforge/deferred/ejN")
local ampApiProvider = module5.AmpApiProvider
local ampEnums = module5.AmpEnums

local autoPromptStatus = require("@luauforge/deferred/ekd").Signals.autoPromptStatus

local module6 = require("@luauforge/deferred/emw")
local useSocialUpsellOverlayController = module6.Hooks.useSocialUpsellOverlayController
local socialUpsellType = module6.Enums.SocialUpsellType
local upsellEntrySurfaceType = module6.Analytics.Enum.UpsellEntrySurfaceType
local upsellComponent = module6.Analytics.Enum.UpsellComponent

local module7 = require("@luauforge/deferred/emD")

local defineFastInt = game:DefineFastInt("FAEUpsellOnAfpImpressionCap", 1)

local function isAlreadyShownInitState(): boolean
	local value = module7.getValue()
	return value < 0 or defineFastInt <= value
end

local function useFAEUpsellOnAfp()
	local v5 = module2()
	local state, setState = module.useState(isAlreadyShownInitState)

	local v6 = useSocialUpsellOverlayController(false)

	local v7 = module.useCallback(function()
		setState(true)
		module7.incrementValue()
		v5(module3.FAEModalImpression)
		v6.openSocialOverlay(socialUpsellType.FacialAgeEstimation, {
			upsellEntrySurface = upsellEntrySurfaceType.AddFriendsPage,
			upsellEntryComponent = upsellComponent.Modal,
			entryPointEventCtx = socialUpsellType.FacialAgeEstimation .. upsellEntrySurfaceType.AddFriendsPage,
			shouldIncludeVPC = true
		})
	end, { v5, v6.openSocialOverlay })

	module.useEffect(function()
		if state then
			return
		end

		local flag = false

		local function tryDispatchFAEUpsell(p2)
			if
				flag
				or (p2 == nil or p2)
				or ampApiProvider.upsellFeatureAccess(
					fStringEligibleToAgeVerifyAmpFeature,
					{},
					fStringAgeCheckAmpNameSpace
				).access ~= ampEnums.AccessResponseEnum.Granted
			then
				return
			end

			flag = true
			v7()
		end

		local statusChangedConnection = autoPromptStatus.statusChanged:connect(tryDispatchFAEUpsell)
		tryDispatchFAEUpsell(autoPromptStatus.getStatus())

		return function()
			statusChangedConnection:disconnect()
		end
	end, { state, setState, v7 })
end

return useFAEUpsellOnAfp
