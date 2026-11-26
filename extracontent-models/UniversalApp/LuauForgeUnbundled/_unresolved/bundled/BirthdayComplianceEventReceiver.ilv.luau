local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin
local fFlagUseSignalsForUserAccess = SharedFlags.FFlagUseSignalsForUserAccess
local isPioneerLaunch = require("@luauforge/bundled/gid").isPioneerLaunch
local useSignalState

if fFlagUseSignalsForUserAccess then
	local SignalsReact = require(CorePackages.Packages.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local getUserAccessStore = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/gin").GetUserAccessStore else nil

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local isLoggedOutUserId = require("@game/CorePackages/Workspace/Packages/AuthCommon").Utils.isLoggedOutUserId

local module3 = require("@luauforge/bundled/dFt")
local module4 = require("@luauforge/bundled/ggi")
local module5 = require("@luauforge/bundled/dKv")
local module6 = require("@luauforge/bundled/gie")
local module7 = require("@luauforge/bundled/gXF")
local module8 = require("@luauforge/bundled/ilw")
local module9 = require("@luauforge/bundled/fGL")

local function BirthdayComplianceEventReceiver(): nil
	local v5 = useDispatch()
	local v6 = useLocalUserId()
	local v7

	if fFlagUseSignalsForUserAccess then
		v7 = useSignalState(getUserAccessStore(false).getUserAccessRestrictionDetail)
	else
		v7 = useSelector(function(p2)
			return p2.UserAccess and p2.UserAccess.restrictionDetail
		end)
	end

	local v8 = not (v7 == nil) and v7.source == module6.BirthdayCompliance

	local ref = React.useRef(false)

	React.useEffect(function()
		if v8 and not ref.current then
			ref.current = true

			local defaultAppPage = module3.GetDefaultAppPage()
			v5(module5({
				{ name = defaultAppPage, rnKey = defaultAppPage },
				{
					name = appPage.BirthdayCompliancePage,
					extraProps = {
						refreshUserAccess = module7,
						refreshUserAccessAfterUpgrade = module8,
						setDarkThemeOverride = module9.SetDarkThemeOverride,
						clearThemeOverride = module9.ClearThemeOverride,
						LogoutThunk = module4
					}
				}
			}))
		elseif ref.current and v7 == nil then
			ref.current = false

			if not isLoggedOutUserId(v6) then
				local v9

				if fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch() then
					v9 = appPage.PioneerPostAuth
				else
					v9 = appPage.Home
				end

				v5(module5({
					{ name = v9, rnKey = v9 }
				}))
			end
		elseif ref.current and not v8 then
			ref.current = false
		end
	end, { v8, v7, v6, v5 })

	return nil
end

return BirthdayComplianceEventReceiver
