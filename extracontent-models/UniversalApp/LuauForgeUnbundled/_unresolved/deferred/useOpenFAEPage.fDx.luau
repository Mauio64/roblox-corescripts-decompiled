local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local getFaeFeatureAccessStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Stores.GetFaeFeatureAccessStore
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local startFacialAgeEstimation = require("@luauforge/bundled/fDy").Thunks.startFacialAgeEstimation
local module = require("@luauforge/bundled/fDz")
local module2 = require("@luauforge/bundled/fDf")
local module3 = require("@luauforge/bundled/dFm")
local module4 = require("@luauforge/bundled/dzE")
local module5 = require("@luauforge/bundled/eie")
local module6 = require("@luauforge/bundled/egx")

local defineFastInt = game:DefineFastInt("AXFaeFeatureAccessRefetchDelayMs", 0)
local defineFastFlag = game:DefineFastFlag("AXEnableFaeSuccessToastDurationSeconds", false)
local defineFastInt2 = game:DefineFastInt("AXFaeFeatureAccessToastDurationSeconds", 3)

local function useOpenFAEPage(p2, p3, p4, p5, p6)
	local v5 = useDispatch()
	local v6 = module5(module6)
	local v7 = module5(module2)
	local v8 = useAvatarRoute()
	local v9 = useNavigation()

	local v10 = useLocalization({
		ageVerificationComplete = {
			"Feature.MarketplaceFAEUpsell.Message.AgeCheckCompleteItem",
			itemName = p6
		}
	})

	return React.useCallback(function()
		v5(startFacialAgeEstimation("MarketplaceUpsell", function()
			v5(module3({
				toastMessage = v10.ageVerificationComplete,
				isLocalized = true,
				toastType = module4.SuccessConfirmation,
				duration = if defineFastFlag then defineFastInt2 else nil
			}))

			task.delay(defineFastInt / 1000, function()
				getFaeFeatureAccessStore.getFaeFeatureAccessStore().fetch(v6)
			end)

			if p5 and p4 and p2 then
				v5(module(v6, v7, p3, p4, p2, false, v8, v9, nil))
			end

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				v5(navigateBack())
			end
		end, function()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				v5(navigateBack())
			end
		end, "MarketplaceUpsell"))
	end, {
		v5,
		v10,
		v6,
		v7,
		v8,
		v9,
		p2,
		p3,
		p4,
		p5
	})
end

return useOpenFAEPage
