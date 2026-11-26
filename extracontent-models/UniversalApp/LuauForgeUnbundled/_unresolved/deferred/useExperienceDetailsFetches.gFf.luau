local CorePackages = game:GetService("CorePackages")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gDu")

local module2 = require("@luauforge/bundled/dDZ")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local module3 = require("@luauforge/deferred/gBN")

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local function useExperienceDetailsFetches(p2, p3, p4)
	local v5 = useDispatch()
	local v6

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		local v7 = React.useMemo(function()
			return function(p5)
				if
					(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p4)
					and p2
				then
					return (module2.getSduiFeedStore(module3.getEdpStoreKey((tostring(p2)))).getDataUpdatedTimestamp(p5))
				end

				return nil
			end
		end, { p2, p4 })
		v6 = SignalsReact.useSignalState(v7)
	else
		v6 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		return {
			fetchGameDetailsPageData = function(p5, p6, p7)
				local v9 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p3 else nil
				local v10 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then p4 else nil
				local v11 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p4 or fFlagLuaAppEdpBackendV2SduiInterleaveDefault then v6 else nil
				return v5(module(p5, p6, p7, v9, v10, v11))
			end
		}
	end

	local v9 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then p4 else nil
	return (useMemo(fn, {
		v5,
		v6,
		v9,
		if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p3 else nil
	}))
end

return useExperienceDetailsFetches
