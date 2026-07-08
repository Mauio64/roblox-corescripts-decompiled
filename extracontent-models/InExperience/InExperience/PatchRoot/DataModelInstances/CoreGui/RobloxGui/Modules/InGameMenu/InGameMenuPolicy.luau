local CorePackages = game:GetService("CorePackages")
local PolicyProvider = require(CorePackages.Packages.InGameMenuDependencies).PolicyProvider
local SharedFlags = CorePackages.Workspace.Packages.SharedFlags
local GetFFlagUseVoiceExitBetaLanguage = require(SharedFlags).GetFFlagUseVoiceExitBetaLanguage
local GetFFlagGateEducationalPopupVisibilityViaGUAC = require(SharedFlags).GetFFlagGateEducationalPopupVisibilityViaGUAC
local v6 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v7 = PolicyProvider.withGetPolicyImplementation(v6)
local GetFIntEducationalPopupDisplayMaxCount = require(script.Parent.Parent.Flags.GetFIntEducationalPopupDisplayMaxCount)
local isSubjectToDesktopPolicies = require(CorePackages.Workspace.Packages.SharedFlags).isSubjectToDesktopPolicies

function v7.Mapper(p1) -- line: 16
	-- upvalues: isSubjectToDesktopPolicies (copy), GetFFlagGateEducationalPopupVisibilityViaGUAC (copy), GetFIntEducationalPopupDisplayMaxCount (copy), GetFFlagUseVoiceExitBetaLanguage (copy)
	return {
		enableInGameHomeIcon = function() -- line: 18
			-- upvalues: isSubjectToDesktopPolicies (copy)
			return isSubjectToDesktopPolicies()
		end,
		enableEducationalPopup = function() -- line: 22
			-- upvalues: isSubjectToDesktopPolicies (copy), GetFFlagGateEducationalPopupVisibilityViaGUAC (copy), p1 (copy)
			local EngineFeature = game:GetEngineFeature("NativeCloseIntercept")

			if isSubjectToDesktopPolicies() and EngineFeature then
				if GetFFlagGateEducationalPopupVisibilityViaGUAC() then
					if p1.InExperienceCanViewEducationalPopup == nil then
						return true
					end

					return p1.InExperienceCanViewEducationalPopup
				end

				return true
			end

			return false
		end,
		educationalPopupMaxDisplayCount = function() -- line: 35
			-- upvalues: isSubjectToDesktopPolicies (copy), GetFIntEducationalPopupDisplayMaxCount (copy)
			return isSubjectToDesktopPolicies() and GetFIntEducationalPopupDisplayMaxCount() or 0
		end,
		getGameInfoShowChatFeatures = function() -- line: 39
			-- upvalues: GetFFlagUseVoiceExitBetaLanguage (copy), p1 (copy)
			if GetFFlagUseVoiceExitBetaLanguage() then
				return p1.GameInfoShowChatFeatures or false
			end

			return false
		end,
		enableFullscreenTitleBar = function() -- line: 46
			-- upvalues: p1 (copy)
			return p1.FullscreenTitleBarEnabled or false
		end,
		getDisplayCheckboxInVoiceConsent = function() -- line: 50
			-- upvalues: p1 (copy)
			if p1.DisplayCheckboxInVoiceConsent == nil then
				return true
			end

			return p1.DisplayCheckboxInVoiceConsent
		end
	}
end

return v7
