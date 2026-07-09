local CorePackages = game:GetService("CorePackages")
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FetchGameDetailsPageData = require(Modules.LuaApp.Thunks.Games.FetchGameDetailsPageData)
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local EdpSduiUtils = require(script.Parent.EdpSduiUtils)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local function useExperienceDetailsFetches(s1: string?, b1: boolean?, b2: boolean?) -- line: 19
	-- upvalues: useDispatch (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), React (copy), ServerDrivenUi (copy), EdpSduiUtils (copy), SignalsReact (copy), FetchGameDetailsPageData (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	local v16 = useDispatch()
	local u17 = nil

	if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp then
		local v18 = React.useMemo(function() -- line: 27
			-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), b2 (copy), s1 (copy), ServerDrivenUi (copy), EdpSduiUtils (copy)
			return function(p1) -- line: 28
				-- upvalues: FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), b2 (copy), s1 (copy), ServerDrivenUi (copy), EdpSduiUtils (copy)
				if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and b2) and s1 then
					return (ServerDrivenUi.getSduiFeedStore(EdpSduiUtils.getEdpStoreKey((tostring(s1)))).getDataUpdatedTimestamp(p1))
				end

				return nil
			end
		end, {
			s1,
			b2
		})

		u17 = SignalsReact.useSignalState(v18)
	end

	return (React.useMemo(function() -- line: 46
		-- upvalues: v16 (copy), FetchGameDetailsPageData (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), b2 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), u17 (ref)
		return {
			fetchGameDetailsPageData = function(p2, p3, p4) -- line: 48
				-- upvalues: v16 (copy), FetchGameDetailsPageData (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), b2 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), u17 (ref)
				return v16(FetchGameDetailsPageData(p2, p3, p4, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else b1, if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else b2, if not (not not FFlagLuaAppEdpBackendV2SduiInterleaveIxp and b2) and not FFlagLuaAppEdpBackendV2SduiInterleaveDefault then nil else u17))
			end
		}
	end, {
		v16,
		u17,
		if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else b2,
		if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else b1
	}))
end

return useExperienceDetailsFetches
