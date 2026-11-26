local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dRk")
local Cryo = require(CorePackages.Packages.Cryo)

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local purchaseItemsSuccess = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").State.Actions.PurchaseItemsSuccess

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated

local v5 = {}

return Rodux.createReducer(v5, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, p3.bodyPartRangeIds)
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.equipped and p3.equipped.BodyPartRangeIds then
			return table.clone(p3.equipped.BodyPartRangeIds)
		end

		return p2
	end,
	[purchaseItemsSuccess.name] = function(p2, p3)
		local v7 = p2 or v5

		if p3.bodyPartColorRangeIds then
			return Cryo.Dictionary.join(v7, p3.bodyPartColorRangeIds)
		end

		return v7
	end
})
