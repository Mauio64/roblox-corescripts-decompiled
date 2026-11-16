local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dLY")

local module2 = require("@luauforge/bundled/dHL")
local setAnimationPreview = module2.Actions.SetAnimationPreview
local setSpawnEffectPreview = module2.Actions.SetSpawnEffectPreview
local navigatedToNonTryOnPage = module2.Actions.NavigatedToNonTryOnPage
local clearTryOns = module2.Actions.ClearTryOns
local fFlagAXSpawnEffectPreview = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSpawnEffectPreview
local characterHistoryStateChangeButtonActivated = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Actions.CharacterHistoryStateChangeButtonActivated

return Rodux.createReducer(
	{
		AnimationPreview = nil,
		AnimationPreviewAssetTypeIdString = nil,
		SpawnEffectPreview = nil
	},
	{
		[module.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, {
				AnimationPreview = Cryo.None,
				AnimationPreviewAssetTypeIdString = Cryo.None
			})
		end,
		[setAnimationPreview.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, {
				AnimationPreview = p3.assetId,
				AnimationPreviewAssetTypeIdString = p3.assetTypeIdString
			})
		end,
		[setSpawnEffectPreview.name] = function(p2, p3)
			if not fFlagAXSpawnEffectPreview then
				return p2
			end

			local join = Cryo.Dictionary.join
			local v7 = if p3.assetId then p3.assetId else Cryo.None
			return join(p2, { SpawnEffectPreview = v7 })
		end,
		[navigatedToNonTryOnPage.name] = function(p2, p3)
			if fFlagAXSpawnEffectPreview and p2.SpawnEffectPreview then
				return Cryo.Dictionary.join(p2, { SpawnEffectPreview = Cryo.None })
			end

			return p2
		end,
		[clearTryOns.name] = function(p2, p3)
			if fFlagAXSpawnEffectPreview and p2.SpawnEffectPreview then
				return Cryo.Dictionary.join(p2, { SpawnEffectPreview = Cryo.None })
			end

			return p2
		end,
		[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
			if p3.tryOn and p3.tryOn.TryOn then
				return table.clone(p3.tryOn.TryOn)
			end

			return p2
		end
	}
)
