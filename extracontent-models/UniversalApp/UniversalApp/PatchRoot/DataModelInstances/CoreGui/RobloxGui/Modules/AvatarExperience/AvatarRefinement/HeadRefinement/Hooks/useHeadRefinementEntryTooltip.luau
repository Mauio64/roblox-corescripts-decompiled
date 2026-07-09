local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AppStorageService = game:GetService("AppStorageService")
local EngineFeature = game:GetEngineFeature("AXMarketplaceHeadTooltipKeys")
local React = require(CorePackages.Packages.React)
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)
local getShouldShowAdjustmentTooltipFromTime = AvatarExperienceHeadRefinement.Utils.getShouldShowAdjustmentTooltipFromTime
local selectLastTryOnClassicHeadShape = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Selectors.selectLastTryOnClassicHeadShape)
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local FullView = AvatarExperienceCommon.Enums.FullView

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local GetFFlagAXDisableHeadRefinementTooltip = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableHeadRefinementTooltip)
local u16 = AppStorageService

local function getMockAppStorageService() -- line: 33
	return {
		storage = {},
		GetItem = function(p1, p2) -- line: 36
			return p1.storage[p2]
		end,
		SetItem = function(p3, p4, p5) -- line: 39
			p3.storage[p4] = p5
		end,
		Flush = function(_) -- line: 42
		end
	}
end

if not EngineFeature then
	u16 = getMockAppStorageService()
end

local function selectIsDynamicHeadEquipped(p7) -- line: 52
	-- upvalues: Utils (copy)
	return Utils.isDynamicHeadEquipped(p7.AvatarExperience.AvatarEditor.Character.EquippedAssets)
end
local function selectIsTryingOnDynamicHead(p8) -- line: 56
	-- upvalues: Utils2 (copy)
	return Utils2.isTryingOnDynamicHead(p8.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems or {})
end
local function useHeadRefinementEntryTooltip(t1: {[any]: any}) -- line: 68
	-- upvalues: React (copy), useSelector (copy), selectIsDynamicHeadEquipped (copy), selectIsFullView (copy), selectIsTryingOnDynamicHead (copy), selectLastTryOnClassicHeadShape (copy), u16 (ref), FullView (copy), GetFFlagAXDisableHeadRefinementTooltip (copy), getShouldShowAdjustmentTooltipFromTime (copy)
	local v24, v25 = React.useState(false)
	local v26 = useSelector(selectIsDynamicHeadEquipped)
	local v27 = useSelector(function(p9) -- line: 72
		-- upvalues: t1 (copy), selectIsFullView (copy)
		local v39 = t1.avatarRoute and (t1.avatarRoute.opaque and t1.avatarRoute.opaque.name)

		return selectIsFullView(p9, v39)
	end)
	local v28 = useSelector(selectIsTryingOnDynamicHead)
	local v29 = useSelector(selectLastTryOnClassicHeadShape)
	local v30 = t1.appStorageService or u16
	local v31 = t1.shouldBeVisible and ((v29 or not v26) and (v27 ~= FullView.SceneFullView and not v28))

	React.useEffect(function() -- line: 87
		-- upvalues: v31 (copy), v30 (copy), v25 (copy), GetFFlagAXDisableHeadRefinementTooltip (copy), getShouldShowAdjustmentTooltipFromTime (copy)
		if v31 then
			local Item = v30:GetItem("AXMarketplaceHeadAdjustmentTooltipSeenTimestamp")
			local v41 = if not Item then nil else tonumber(Item)

			v25(not GetFFlagAXDisableHeadRefinementTooltip() and getShouldShowAdjustmentTooltipFromTime({
				prevTime = v41,
				currentTime = os.time()
			}))

			return
		end

		v25(false)
	end, {
		v31,
		t1.shouldBeVisible
	})

	return v24, function(t2: {[any]: any}) -- line: 106
		-- upvalues: v30 (copy), v25 (copy)
		if t2.saveDismissTime then
			v30:SetItem("AXMarketplaceHeadAdjustmentTooltipSeenTimestamp", (tostring(os.time())))
			v30:Flush()
		end

		v25(false)
	end
end

return useHeadRefinementEntryTooltip
