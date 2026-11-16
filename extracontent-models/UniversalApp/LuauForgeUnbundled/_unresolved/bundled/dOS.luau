local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dHL")

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory
local module = require("@luauforge/bundled/dOT")
local module2 = require("@luauforge/bundled/dOg")
local module3 = require("@luauforge/bundled/dOh")
local module4 = require("@luauforge/bundled/dOU")
local module5 = require("@luauforge/bundled/dMZ")
require("@luauforge/bundled/dMc")
local module6 = require("@luauforge/bundled/dNa")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local outfitId = tostring(p3.outfit.outfitId)
		local outfit = p3.outfit

		if fFlagAXMigrateOutfitsToUserInventory then
			local v6 = p2[outfitId]

			if v6 then
				outfit = Cryo.Dictionary.join(outfit, {
					receivedFromInventoryFetch = v6.receivedFromInventoryFetch or outfit.receivedFromInventoryFetch,
					receivedFromGetOutfit = v6.receivedFromGetOutfit or outfit.receivedFromGetOutfit
				})
			end
		end

		return Cryo.Dictionary.join(p2, { [outfitId] = outfit })
	end,
	[module2.name] = function(p2, p3)
		local outfitId = tostring(p3.outfitId)
		return Cryo.Dictionary.join(p2, { [outfitId] = Cryo.None })
	end,
	[module3.name] = function(p2, p3)
		local outfitId = tostring(p3.outfitId)
		return Cryo.Dictionary.join(p2, { [outfitId] = Cryo.None })
	end,
	[module4.name] = function(p2, p3)
		local v6 = p2[p3.outfitId]

		if not v6 then
			return p2
		end

		return Cryo.Dictionary.join(p2, {
			[p3.outfitId] = Cryo.Dictionary.join(v6, { name = p3.name })
		})
	end,
	[module5.name] = module6.isEnabled() and function(p2, p3)
		local clone = table.clone(p2)

		for k, outfit in p3.outfits do
			local v6 = p2[k]
			local outfitInfo = outfit.outfitInfo

			if fFlagAXMigrateOutfitsToUserInventory and v6 then
				outfitInfo = Cryo.Dictionary.join(outfitInfo, {
					receivedFromInventoryFetch = v6.receivedFromInventoryFetch or outfitInfo.receivedFromInventoryFetch,
					receivedFromGetOutfit = v6.receivedFromGetOutfit or outfitInfo.receivedFromGetOutfit
				})
			end

			clone[k] = outfitInfo
		end

		return clone
	end or nil
})
