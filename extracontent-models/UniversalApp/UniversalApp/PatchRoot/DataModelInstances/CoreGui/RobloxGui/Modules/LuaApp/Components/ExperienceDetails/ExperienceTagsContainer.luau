local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ExperienceTags = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceTags)
local OpenCentralOverlayForExperienceGuidelines = require(Modules.LuaApp.Thunks.OpenCentralOverlayForExperienceGuidelines)
local ExperienceDetailsExperimentation = require(script.Parent.ExperienceDetailsExperimentation)
local v10 = game:DefineFastFlag("LuaAppExperienceTagsStrongLanguageContent", false)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local u15 = nil

if v10 then
	function u15(p1) -- line: 36
		if p1 == nil then
			return false
		end

		for _, v in pairs(p1) do
			if v.name == "strong-language" and v.contains then
				return true
			end
		end

		return false
	end
end

return function(t1: {[any]: any}) -- line: 49
	-- upvalues: useLocalization (copy), useDispatch (copy), React (copy), OpenCentralOverlayForExperienceGuidelines (copy), useSelector (copy), v10 (copy), u15 (ref), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), ExperienceDetailsExperimentation (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ExperienceTags (copy)
	local v20 = useLocalization({
		strongLanguageWarning = "Feature.GameDetails.Label.ContainsStrongLanguagePillWarning"
	})
	local t2 = {}
	local v22 = useDispatch()
	local v23 = React.useCallback(function() -- line: 60
		-- upvalues: v22 (copy), OpenCentralOverlayForExperienceGuidelines (copy), t1 (copy)
		v22(OpenCentralOverlayForExperienceGuidelines(t1.universeId, t1.hideCloseButton))
	end, { t1.universeId })
	local v24 = useSelector(function(p2) -- line: 63
		-- upvalues: t1 (copy)
		return p2.AgeRecommendations[t1.universeId]
	end)

	if t1.includeAgeRecommendations and v24 then
		local summary = v24.summary
		local v26 = if not summary or not summary.ageRecommendation then nil else if not summary.ageRecommendation.displayNameWithHeaderShort then summary.ageRecommendation.displayName else summary.ageRecommendation.displayNameWithHeaderShort

		if v26 then
			table.insert(t2, {
				text = v26,
				onActivated = if not t1.areTagsInteractable then nil else v23
			})
		end
	end

	local v27 = if not v10 then nil else u15(v24 and v24.descriptorUsages)

	if (useSelector(function(p3) -- line: 81
		-- upvalues: t1 (copy)
		return p3.AssetTextFilterSettings[t1.universeId]
	end) or v10 and v27) and (not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not ExperienceDetailsExperimentation.getShouldInterleaveSdui()) or t1.hideContentDescriptors ~= true) then
		table.insert(t2, {
			text = v20.strongLanguageWarning,
			onActivated = if not t1.areTagsInteractable then nil else v23
		})
	end

	local v28 = useSelector(function(p4) -- line: 102
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), t1 (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and t1.shouldHydrateLegacyIxp then
			return p4.GameDetailsV2[t1.universeId]
		end

		return p4.GameDetails[t1.universeId]
	end)
	local v29 = v28 and v28.licenseDescription or nil

	if v29 then
		table.insert(t2, {
			text = v29,
			onActivated = if not t1.areTagsInteractable then nil else nil
		})
	end

	if #t2 > 0 then
		return React.createElement(ExperienceTags, {
			LayoutOrder = t1.LayoutOrder,
			contents = t2
		})
	end

	return nil
end
