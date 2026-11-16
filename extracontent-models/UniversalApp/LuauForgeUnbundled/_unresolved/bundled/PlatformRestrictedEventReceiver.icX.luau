local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local openAmpWizardContainer = require("@luauforge/bundled/eeI").OpenAmpWizardContainer
local eventStreamConstants = require("@luauforge/bundled/fsz").EventStreamConstants

local getFFlagLuaAppPlatformRestrictionVPC = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppPlatformRestrictionVPC
local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForUserAccess

local useIsRestrictedBySource = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/fDS").useIsRestrictedBySource else nil

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/fBP")
local module3 = require("@luauforge/bundled/dHq")
local module4 = require("@luauforge/bundled/fDK")
local module5 = require("@luauforge/bundled/gxq")

local platformRestrictedPage = eventStreamConstants.Context.PlatformRestrictedPage

local function openAmpWizard(data)
	return openAmpWizardContainer(
		data.featureName,
		data.completionCallback,
		data.recourseData,
		data.entryPointEventCtx,
		data.extraParameters,
		data.nameSpace
	)
end

local function PlatformRestrictedEventReceiver(): nil
	local v5 = useDispatch()
	local v6

	if fFlagUseSignalsForUserAccess then
		v6 = useIsRestrictedBySource(module4.PlatformAccess)
	else
		v6 = useSelector(function(p2)
			return p2.UserAccess
				and p2.UserAccess.restrictionDetail
				and p2.UserAccess.restrictionDetail.source == module4.PlatformAccess
		end)
	end

	local ref = React.useRef(false)

	React.useEffect(function()
		local fFlagLuaAppPlatformRestrictionVPC = getFFlagLuaAppPlatformRestrictionVPC()

		if v6 then
			if not ref.current then
				ref.current = true
				local v7 = { LogoutThunk = module2 }

				if fFlagLuaAppPlatformRestrictionVPC then
					function v7.openVpcWizard(p2)
						v5(openAmpWizard({
							featureName = "CanRequestPlatformAccessRestrictionLifting",
							completionCallback = p2,
							entryPointEventCtx = platformRestrictedPage,
							nameSpace = "account_management/VerifiedParentalConsent",
							recourseData = { restrictionType = "PlatformAccess" }
						}))
					end
					v7.refreshUserAccess = module5
				end

				v5(module3({
					{ name = appPage.PlatformLockedPage, extraProps = v7 }
				}))
			end
		elseif fFlagLuaAppPlatformRestrictionVPC and ref.current then
			ref.current = false
			v5(module3())
		end
	end, { v6, v5 })

	return nil
end

return PlatformRestrictedEventReceiver
