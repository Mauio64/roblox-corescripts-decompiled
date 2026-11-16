local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMomentsCreateAvatarPosts

local module = require("@luauforge/bundled/dNS")
local module2 = require("@luauforge/bundled/dNc")
require("@luauforge/bundled/dMc")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@luauforge/bundled/dHL")

local purchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated

local v5 = not fFlagMomentsCreateAvatarPosts and {
	height = 1,
	width = 1,
	depth = 1,
	head = 1,
	bodyType = 0,
	proportion = 0
} or AvatarExperienceCommon.Constants.DEFAULT_AVATAR_SCALES

return Rodux.createReducer(v5, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, p3.scales)
	end,
	[module2.name] = function(p2, p3)
		if p3.avatarData then
			return p3.avatarData.scales
		end

		return p2
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.equipped and p3.equipped.AvatarScales then
			return table.clone(p3.equipped.AvatarScales)
		end

		return p2
	end,
	[purchaseItemsSuccess.name] = function(p2, p3)
		local v7 = p2 or v5

		if p3.bodyScales then
			return Cryo.Dictionary.join(v7, p3.bodyScales)
		end

		return v7
	end
})
