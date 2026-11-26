local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local GameTileOverlayTextPill = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Overlays/GameTileOverlayTextPill")

local module2 = require("@luauforge/deferred/gCl")
local module3 = require("@luauforge/deferred/gBX")

local defineFastFlag = game:DefineFastFlag("LuaAppExperienceTagsStrongLanguageContent", false)

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fn = defineFastFlag and function(items): boolean
	if items == nil then
		return false
	end

	for k, item in pairs(items) do
		if item.name == "strong-language" and item.contains then
			return true
		end
	end

	return false
end or nil

return function(props)
	local v5 = useLocalization({
		strongLanguageWarning = "Feature.GameDetails.Label.ContainsStrongLanguagePillWarning"
	})

	local v6 = {}

	local v7 = useDispatch()
	local v8 = React.useCallback(function()
		v7(module2(props.universeId, props.hideCloseButton))
	end, { props.universeId })
	local v9 = useSelector(function(p2)
		return p2.AgeRecommendations[props.universeId]
	end)

	if props.includeAgeRecommendations and v9 then
		local summary = v9.summary
		local v10

		if summary and summary.ageRecommendation then
			if summary.ageRecommendation.displayNameWithHeaderShort then
				v10 = summary.ageRecommendation.displayNameWithHeaderShort
			else
				v10 = summary.ageRecommendation.displayName
			end
		end

		if v10 then
			local v12 = if props.areTagsInteractable then v8 else nil
			table.insert(v6, { text = v10, onActivated = v12 })
		end
	end

	local v10 = if defineFastFlag then fn(v9 and v9.descriptorUsages) else nil

	if (useSelector(function(p2)
		return p2.AssetTextFilterSettings[props.universeId]
	end) or defineFastFlag and v10) and (not (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and module3.getShouldInterleaveSdui()) or props.hideContentDescriptors ~= true) then
		local v11 = { text = v5.strongLanguageWarning, onActivated = 0 }

		if not props.areTagsInteractable then
			v8 = nil
		end

		v11.onActivated = v8
		table.insert(v6, v11)
	end

	local v11 = useSelector(function(p2)
		return p2.GameDetailsV2[props.universeId]
	end)

	local licenseDescription = v11 and v11.licenseDescription or nil

	if licenseDescription then
		local areTagsInteractable = props.areTagsInteractable
		table.insert(v6, { text = licenseDescription, onActivated = nil })
	end

	if #v6 > 0 then
		return React.createElement(GameTileOverlayTextPill, {
			LayoutOrder = props.LayoutOrder,
			contents = v6
		})
	end

	return nil
end
