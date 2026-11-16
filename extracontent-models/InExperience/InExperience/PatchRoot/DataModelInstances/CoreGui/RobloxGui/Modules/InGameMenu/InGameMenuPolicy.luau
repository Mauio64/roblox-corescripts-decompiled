local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local PolicyProvider = InGameMenuDependencies.PolicyProvider
local SharedFlags = CorePackages.Workspace.Packages.SharedFlags
local module = require(SharedFlags)
local getFFlagGateEducationalPopupVisibilityViaGUAC = module.GetFFlagGateEducationalPopupVisibilityViaGUAC

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v = PolicyProvider.withGetPolicyImplementation(memStorageService)

local GetFIntEducationalPopupDisplayMaxCount = require(script.Parent.Parent.Flags.GetFIntEducationalPopupDisplayMaxCount)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags2.isSubjectToDesktopPolicies

function v.Mapper(data)
	return {
		enableInGameHomeIcon = function()
			return isSubjectToDesktopPolicies()
		end,
		enableEducationalPopup = function()
			local engineFeature = game:GetEngineFeature("NativeCloseIntercept")

			if not (isSubjectToDesktopPolicies() and engineFeature) then
				return false
			end

			if not getFFlagGateEducationalPopupVisibilityViaGUAC() then
				return true
			end

			return data.InExperienceCanViewEducationalPopup == nil or data.InExperienceCanViewEducationalPopup
		end,
		educationalPopupMaxDisplayCount = function()
			return isSubjectToDesktopPolicies() and GetFIntEducationalPopupDisplayMaxCount() or 0
		end,
		getGameInfoShowChatFeatures = function(): boolean
			return false
		end,
		enableFullscreenTitleBar = function()
			return data.FullscreenTitleBarEnabled or false
		end,
		getDisplayCheckboxInVoiceConsent = function()
			return data.DisplayCheckboxInVoiceConsent == nil or data.DisplayCheckboxInVoiceConsent
		end
	}
end

return v
