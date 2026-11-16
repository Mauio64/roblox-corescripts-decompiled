local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dNW")
local module2 = require("@luauforge/bundled/dNc")
local module3 = require("@luauforge/bundled/dNQ")
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dMc")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated
local purchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess

local v5 = {
	headColor3 = module3.DefaultBodyColor3,
	leftArmColor3 = module3.DefaultBodyColor3,
	leftLegColor3 = module3.DefaultBodyColor3,
	rightArmColor3 = module3.DefaultBodyColor3,
	rightLegColor3 = module3.DefaultBodyColor3,
	torsoColor3 = module3.DefaultBodyColor3
}

return Rodux.createReducer(v5, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, p3.bodyColor3s)
	end,
	[module2.name] = function(p2, p3)
		return p3.avatarData.bodyColor3s
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.equipped and p3.equipped.BodyColor3s then
			return table.clone(p3.equipped.BodyColor3s)
		end

		return p2
	end,
	[purchaseItemsSuccess.name] = function(p2, p3)
		local v7 = p2 or v5

		if p3.bodyColor3s then
			return Cryo.Dictionary.join(v7, p3.bodyColor3s)
		end

		return v7
	end
})
