local CorePackages = game:GetService("CorePackages")
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local React = require(CorePackages.Packages.React)
local ProfileTypes = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums).ProfileTypes
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local OpenVerifiedBadgeModal = require(Modules.LuaApp.Thunks.OpenVerifiedBadgeModal)
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local OpenCentralOverlayForGameDetailMore = require(Modules.LuaApp.Thunks.OpenCentralOverlayForGameDetailMore)
local OpenCentralOverlayForGameDetailsPlayWithFriends = require(Modules.LuaApp.Thunks.OpenCentralOverlayForGameDetailsPlayWithFriends)
local OpenCentralOverlayForExperienceGuidelines = require(Modules.LuaApp.Thunks.OpenCentralOverlayForExperienceGuidelines)
local OpenRefundPolicyLearnMorePage = require(Modules.LuaApp.Thunks.OpenRefundPolicyLearnMorePage)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local function useExperienceDetailsNavigation(b1: boolean?) -- line: 29
	-- upvalues: useDispatch (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateBack (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), OpenCentralOverlayForGameDetailMore (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), OpenCentralOverlayForGameDetailsPlayWithFriends (copy), CloseCentralOverlay (copy), OpenVerifiedBadgeModal (copy), NavigateDown (copy), OpenCentralOverlayForExperienceGuidelines (copy), OpenRefundPolicyLearnMorePage (copy), OpenWebview (copy), EnableCommunityProfilePageIXP (copy), AppPage (copy), ProfileTypes (copy)
	local v23 = useDispatch()

	return (React.useMemo(function() -- line: 31
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), v23 (copy), NavigateBack (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), OpenCentralOverlayForGameDetailMore (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), OpenCentralOverlayForGameDetailsPlayWithFriends (copy), CloseCentralOverlay (copy), OpenVerifiedBadgeModal (copy), NavigateDown (copy), OpenCentralOverlayForExperienceGuidelines (copy), OpenRefundPolicyLearnMorePage (copy), OpenWebview (copy), EnableCommunityProfilePageIXP (copy), AppPage (copy), ProfileTypes (copy)
		return {
			navigateBack = function() -- line: 33
				-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), v23 (copy), NavigateBack (copy)
				if FFlagSignalsNavP3Dispatch then
					return v11.back()
				end

				return v23(NavigateBack())
			end,
			openLeaveRobloxAlertUIBlox = function(p1) -- line: 40
				-- upvalues: v23 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
				v23(OpenCentralOverlayForLeaveRobloxAlert(p1))
			end,
			openMoreContextualMenu = function(p2, p3, p4, p5) -- line: 43
				-- upvalues: v23 (copy), OpenCentralOverlayForGameDetailMore (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy)
				v23(OpenCentralOverlayForGameDetailMore(p2, p3, nil, p4, p5, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else b1))
			end,
			openShareContextualMenu = function(p6, p7, p8) -- line: 55
				-- upvalues: v23 (copy), OpenCentralOverlayForGameDetailsPlayWithFriends (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy)
				v23(OpenCentralOverlayForGameDetailsPlayWithFriends(p6, p7, p8, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else b1))
			end,
			closeAlert = function() -- line: 65
				-- upvalues: v23 (copy), CloseCentralOverlay (copy)
				v23(CloseCentralOverlay())
			end,
			openVerifiedBadgeModal = function() -- line: 68
				-- upvalues: v23 (copy), OpenVerifiedBadgeModal (copy)
				v23(OpenVerifiedBadgeModal())
			end,
			openCreatorPage = function(p9) -- line: 71
				-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), v23 (copy), NavigateDown (copy)
				if FFlagSignalsNavP3Dispatch then
					v11.down(v11.fromLegacyPage(p9))

					return
				end

				v23(NavigateDown(p9))
			end,
			openExperienceGuidelinesExplained = function(p10, p11) -- line: 78
				-- upvalues: v23 (copy), OpenCentralOverlayForExperienceGuidelines (copy)
				v23(OpenCentralOverlayForExperienceGuidelines(p10, p11))
			end,
			openRefundPolicyLearnMorePage = function(p12) -- line: 81
				-- upvalues: v23 (copy), OpenRefundPolicyLearnMorePage (copy)
				v23(OpenRefundPolicyLearnMorePage(p12))
			end,
			openWebview = function(p13, p14) -- line: 84
				-- upvalues: v23 (copy), OpenWebview (copy)
				v23(OpenWebview(p13, p14))
			end,
			openCommunityProfilePage = if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else function(s1: string, s2: string) -- line: 88
				-- upvalues: AppPage (copy), ProfileTypes (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v23 (copy), NavigateDown (copy)
				local t1 = {
					name = AppPage.ProfilePlatform,
					detail = s1,
					extraProps = {
						profileType = ProfileTypes.Community,
						source = s2
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v11.down(v11.fromLegacyPage(t1))

					return
				end

				v23(NavigateDown(t1))
			end,
			openUserProfilePage = function(n1: number, s3: string) -- line: 104
				-- upvalues: AppPage (copy), ProfileTypes (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), v23 (copy), NavigateDown (copy)
				local t2 = {
					name = AppPage.ProfilePlatform,
					detail = n1,
					extraProps = {
						profileType = ProfileTypes.User,
						source = s3
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v11.down(v11.fromLegacyPage(t2))

					return
				end

				v23(NavigateDown(t2))
			end
		}
	end, { v23 }))
end

return useExperienceDetailsNavigation
