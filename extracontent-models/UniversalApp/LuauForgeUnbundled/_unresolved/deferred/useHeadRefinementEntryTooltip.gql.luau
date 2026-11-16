local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local v5 = game:GetService("AppStorageService")

local engineFeature = game:GetEngineFeature("AXMarketplaceHeadTooltipKeys")

local React = require(CorePackages.Packages.React)

local module2 = require("@luauforge/bundled/dHO")
require("@luauforge/bundled/dMd")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module3 = require("@luauforge/bundled/fvh")
local module4 = require("@luauforge/bundled/fuD")
local getShouldShowAdjustmentTooltipFromTime = module2.Utils.getShouldShowAdjustmentTooltipFromTime

local module5 = require("@luauforge/bundled/ggv")
local module6 = require("@luauforge/bundled/goe")
local fullView = AvatarExperienceCommon.Enums.FullView

require("@luauforge/bundled/dHK")

local module7 = require("@luauforge/deferred/gqm")

local function getMockAppStorageService()
	return {
		storage = {},
		GetItem = function(self, p3)
			return self.storage[p3]
		end,
		SetItem = function(self, p3, p4)
			self.storage[p3] = p4
		end,
		Flush = function(self) end
	}
end

if not engineFeature then
	v5 = getMockAppStorageService()
end

local function selectIsDynamicHeadEquipped(p2)
	return module3.isDynamicHeadEquipped(p2.AvatarExperience.AvatarEditor.Character.EquippedAssets)
end

local function selectIsTryingOnDynamicHead(p2)
	return module4.isTryingOnDynamicHead(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems or {})
end

local function useHeadRefinementEntryTooltip(data)
	local state, setState = React.useState(false)

	local v6 = useSelector(selectIsDynamicHeadEquipped)
	local v7 = useSelector(function(p2)
		return module6(p2, data.avatarRoute and data.avatarRoute.opaque and data.avatarRoute.opaque.name)
	end)

	local v8 = useSelector(selectIsTryingOnDynamicHead)

	local v9 = useSelector(module5)

	local appStorageService = data.appStorageService or v5
	local v10 = data.shouldBeVisible and (v9 or not v6)

	if v10 then
		v10 = not (v7 == fullView.SceneFullView) and not v8
	end

	React.useEffect(function()
		if not v10 then
			setState(false)

			return
		end

		local item = appStorageService:GetItem("AXMarketplaceHeadAdjustmentTooltipSeenTimestamp")
		local v11 = if item then tonumber(item) else nil
		setState(not module7() and getShouldShowAdjustmentTooltipFromTime({
			prevTime = v11,
			currentTime = os.time()
		}))
	end, { v10, data.shouldBeVisible })

	return state, function(p2)
		if p2.saveDismissTime then
			appStorageService:SetItem(
				"AXMarketplaceHeadAdjustmentTooltipSeenTimestamp",
				(tostring(os.time()))
			)
			appStorageService:Flush()
		end

		setState(false)
	end
end

return useHeadRefinementEntryTooltip
