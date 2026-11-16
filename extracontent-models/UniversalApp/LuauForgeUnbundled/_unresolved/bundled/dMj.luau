local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/bundled/dMl")
local module2 = require("@luauforge/bundled/dMm")

local module3 = require("@luauforge/bundled/dMn")
local module4 = require("@luauforge/bundled/dMs")

local module5 = require("@luauforge/bundled/dMt")

local v5 = {
	screen = avatarScreen.None,
	params = nil,
	requestId = 0,
	completedRequestId = 0
}

return Rodux.createReducer(v5, {
	[module.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			screen = p3.screen,
			params = p3.params,
			requestId = p2.requestId + 1
		})
	end,
	[module2.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { completedRequestId = p3.requestId })
	end,
	[module3.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			params = Cryo.Dictionary.join(p2.params or {}, {
				creatorName = Cryo.None,
				minPrice = Cryo.None,
				maxPrice = Cryo.None,
				salesTypeFilter = Cryo.None,
				includeNotForSale = Cryo.None,
				sortType = Cryo.None,
				sortAggregation = Cryo.None,
				category = Cryo.None,
				subcategory = Cryo.None,
				taxonomy = Cryo.None,
				keyword = Cryo.None,
				topics = Cryo.None,
				wearTimeFilter = Cryo.None
			})
		})
	end,
	[module4.name] = function(p2, data)
		return Cryo.Dictionary.join(p2, {
			params = Cryo.Dictionary.join(p2.params or {}, {
				itemId = data.itemId,
				itemType = data.itemType,
				wasItemEquipped = data.wasItemEquipped or false,
				fetchItemFailed = data.fetchItemFailed or false
			})
		})
	end,
	[module5.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			params = Cryo.Dictionary.join(p2.params or {}, {
				category = Cryo.None,
				subcategory = Cryo.None,
				opaquePage = avatarScreen.AvatarEditor
			})
		})
	end
})
