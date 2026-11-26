local CorePackages = game:GetService("CorePackages")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local React = require(CorePackages.Packages.React)
local profileTypes = require("@luauforge/bundled/ehC").ProfileTypes

local module = require("@luauforge/bundled/fIU")

local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module3 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module4 = require("@luauforge/deferred/gDj")
local module5 = require("@luauforge/bundled/fAJ")
local module6 = require("@luauforge/bundled/fCM")
local module7 = require("@luauforge/deferred/gBT")

local module8 = require("@luauforge/deferred/gBV")

local module9 = require("@luauforge/deferred/gCl")
local module10 = require("@luauforge/deferred/gDl")
local module11 = require("@luauforge/bundled/fzL")

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local function useExperienceDetailsNavigation(p2)
	local v5 = useDispatch()
	return (React.useMemo(function()
		return {
			navigateBack = function()
				if fFlagSignalsNavP3Dispatch then
					return navigationCommands.back()
				end

				return v5(RobloxAppToastsRodux())
			end,
			openLeaveRobloxAlertUIBlox = function(p3)
				v5(module5(p3))
			end,
			openMoreContextualMenu = function(p3, p4, p5, p6)
				v5(module7(p3, p4, nil, p5, p6, if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p2 else nil))
			end,
			openShareContextualMenu = function(p3, p4, p5)
				v5(module8(p3, p4, p5, if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p2 else nil))
			end,
			closeAlert = function()
				v5(module6())
			end,
			openVerifiedBadgeModal = function()
				v5(module4())
			end,
			openCreatorPage = function(p3)
				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(p3))
				else
					v5(module3(p3))
				end
			end,
			openExperienceGuidelinesExplained = function(p3, p4)
				v5(module9(p3, p4))
			end,
			openRefundPolicyLearnMorePage = function(p3)
				v5(module10(p3))
			end,
			openWebview = function(p3, p4)
				v5(module11(p3, p4))
			end,
			openCommunityProfilePage = module.FFlagIsSetupEnabled and function(p3, p4)
				local v6 = {
					name = appPage.ProfilePlatform,
					detail = p3,
					extraProps = { profileType = profileTypes.Community, source = p4 }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v6))
				else
					v5(module3(v6))
				end
			end or nil,
			openUserProfilePage = function(p3, p4)
				local v6 = {
					name = appPage.ProfilePlatform,
					detail = p3,
					extraProps = { profileType = profileTypes.User, source = p4 }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v6))
				else
					v5(module3(v6))
				end
			end
		}
	end, { v5 }))
end

return useExperienceDetailsNavigation
