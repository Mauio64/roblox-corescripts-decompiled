local IXPService = game:GetService("IXPService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local FFlagSignalsNavP3hMisc = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3hMisc
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v12 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getCurrentPage = require(Modules.LuaApp.getCurrentPage)
local WaitUntilIXPUserInit = require(Modules.LuaApp.Thunks.WaitUntilIXPUserInit)
local v16 = game:DefineFastString("LuaAppVngAppIxpUserLayer", "PlayerApp.HomePageUpsell.VNGApp")
local v17 = game:DefineFastString("LuaAppVngIxpFrequency", "frequency")
local v18 = game:DefineFastString("LuaAppVngIxpDismissable", "dismissable")
local v19 = game:DefineFastString("LuaAppVngIxpEnabled", "enabled")
local v20 = game:DefineFastInt("LuaAppVngUpsellNagFrequencySec", 86400)
local v21 = game:DefineFastFlag("LuaAppVngUpsellAlwaysEnabled", false)
local v22 = game:DefineFastFlag("LuaAppVngUpsellAlwaysCanClose", false)
local u23 = nil

local function CheckForVngAppUpsellForVnUsers(_) -- line: 31
	-- upvalues: React (copy), FFlagSignalsNavP3hMisc (copy), v12 (copy), useSignalState (copy), useSelector (copy), getCurrentPage (copy), useDispatch (copy), v21 (copy), useUserExperiment (copy), v16 (copy), v19 (copy), v18 (copy), v17 (copy), Players (copy), WaitUntilIXPUserInit (copy), IXPService (copy), u23 (ref), v20 (copy), v22 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	local v26, v27 = React.useState(false)
	local name

	if FFlagSignalsNavP3hMisc then
		local v28 = v12(false)

		name = useSignalState(v28.getCurrentPage).name
	else
		name = useSelector(getCurrentPage)
	end

	local v30 = useDispatch()
	local t1 = {}

	if not v21 then
		t1 = useUserExperiment({ v16 }, function(p2) -- line: 46
			-- upvalues: v16 (copy), v19 (copy), v18 (copy), v17 (copy)
			local v33 = p2[v16] or {}
			local str = tostring(v33[v19])
			local str2 = tostring(v33[v18])

			return {
				upsellEnabled = not not str and (str == "true" or false),
				upsellFrequency = v33[v17],
				upsellDismissable = not not str2 and (str2 == "true" or false)
			}
		end)
		React.useEffect(function() -- line: 59
			-- upvalues: v26 (copy), Players (copy), v30 (copy), WaitUntilIXPUserInit (copy), IXPService (copy), v27 (copy)
			if not v26 then
				local v36 = Players.LocalPlayer and Players.LocalPlayer.UserId or 0

				v30(WaitUntilIXPUserInit(IXPService, v36)):andThen(function() -- line: 62
					-- upvalues: v27 (copy)
					v27(true)
				end)
			end
		end, { v26 })
	end

	React.useEffect(function() -- line: 69
		-- upvalues: v21 (copy), v26 (copy), t1 (ref), u23 (ref), v20 (copy), v22 (copy), v30 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		if (v21 or v26 and t1.upsellEnabled) and (not u23 or u23 < DateTime.now().UnixTimestampMillis) then
			local v37 = v20

			if t1.upsellFrequency then
				v37 = tonumber(t1.upsellFrequency)
			end

			u23 = DateTime.now().UnixTimestampMillis + v37 * 1000

			local v38 = v22

			if t1.upsellDismissable then
				v38 = t1.upsellDismissable
			end

			v30(SetCentralOverlay(CentralOverlayType.VngAppUpsell, {
				isDismissable = v38
			}))
		end
	end, {
		u23,
		name,
		t1,
		v26
	})

	return nil
end

return CheckForVngAppUpsellForVnUsers
