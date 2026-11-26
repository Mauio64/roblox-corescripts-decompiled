local IXPService = game:GetService("IXPService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local module = require("@luauforge/bundled/fyF")
local module2 = require("@luauforge/bundled/gfg")

local defineFastString = game:DefineFastString(
	"LuaAppVngAppIxpUserLayer",
	"PlayerApp.HomePageUpsell.VNGApp"
)
local defineFastString2 = game:DefineFastString("LuaAppVngIxpFrequency", "frequency")
local defineFastString3 = game:DefineFastString("LuaAppVngIxpDismissable", "dismissable")
local defineFastString4 = game:DefineFastString("LuaAppVngIxpEnabled", "enabled")
local defineFastInt = game:DefineFastInt("LuaAppVngUpsellNagFrequencySec", 86400)
local defineFastFlag = game:DefineFastFlag("LuaAppVngUpsellAlwaysEnabled", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppVngUpsellAlwaysCanClose", false)

local v5 = nil

local function CheckForVngAppUpsellForVnUsers(p2): nil
	local state, setState = React.useState(false)
	local v6

	if fFlagSignalsNavP3fGameDetails then
		v6 = useSignalState(getLegacyNavigationStore(false).getCurrentPageName)
	else
		v6 = useSelector(module)
	end

	local v7 = useDispatch()
	local v8

	if defineFastFlag then
		v8 = {}
	else
		v8 = useUserExperiment({ defineFastString }, function(p3)
			local v9 = p3[defineFastString] or {}

			local v10 = tostring(v9[defineFastString4])
			local v11 = tostring(v9[defineFastString3])

			return {
				upsellEnabled = v10 and v10 == "true" and true or false,
				upsellFrequency = v9[defineFastString2],
				upsellDismissable = v11 and v11 == "true" and true or false
			}
		end)

		React.useEffect(function()
			if not state then
				local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
				v7(module2(IXPService, userId)):andThen(function()
					setState(true)
				end)
			end
		end, { state })
	end

	React.useEffect(function()
		if
			(defineFastFlag or state and v8.upsellEnabled)
			and (not v5 or v5 < DateTime.now().UnixTimestampMillis)
		then
			local v9 = defineFastInt

			if v8.upsellFrequency then
				v9 = tonumber(v8.upsellFrequency)
			end

			v5 = DateTime.now().UnixTimestampMillis + v9 * 1000
			local v10 = defineFastFlag2

			if v8.upsellDismissable then
				v10 = v8.upsellDismissable
			end

			v7(setCentralOverlay(centralOverlayType.VngAppUpsell, {
				isDismissable = v10
			}))
		end
	end, { v5, v6, v8, state })

	return nil
end

return CheckForVngAppUpsellForVnUsers
