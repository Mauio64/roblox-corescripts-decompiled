local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local tutils = require(CorePackages.Packages.tutils)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local fFlagAXUseSignalsForLayeredClothingCurrentSort = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local module = require("@luauforge/bundled/dTC")
local module2 = require("@luauforge/bundled/dTE")

local extended = Roact.PureComponent:extend("LayeredClothingSortHandler")

extended.validateProps = t.strictInterface({
	avatarRoute = t.table,
	tryOnItems = t.table,
	currentSort = t.optional(t.table),
	clearCurrentSort = t.callback,
	clearRemovedItems = t.callback
})

function extended.render(p2): nil
	return nil
end

local function hasSameKeys(items, p2): boolean
	local count = 0

	for k in items do
		count += 1

		if p2[k] == nil then
			return false
		end
	end

	return count == tutils.fieldCount(p2)
end

function extended:didSwitchTryOn(p3): boolean
	local tryOnItems = p3.tryOnItems
	local tryOnItems2 = self.props.tryOnItems
	local count = 0
	local flag = true
	local v5

	for k in tryOnItems do
		count += 1

		if tryOnItems2[k] == nil then
			v5 = false
			flag = false
			break
		end
	end

	if flag then
		v5 = count == tutils.fieldCount(tryOnItems2)
	end

	return not v5
end

function extended:didUpdate(p2)
	local name = self.props.avatarRoute.opaque.name
	local name2 = p2.avatarRoute.opaque.name
	local didSwitchTryOn = self:didSwitchTryOn(p2)
	local v5

	if fFlagAXUseSignalsForLayeredClothingCurrentSort then
		v5 = getLayeredClothingCurrentSortStore(false).getOrderedList(false)
	else
		v5 = self.props.currentSort
	end

	if name ~= avatarScreen.LayeredClothingSort and didSwitchTryOn and #v5 > 0 then
		self.props.clearCurrentSort()
	end

	if name ~= name2 and name2 == avatarScreen.LayeredClothingSort then
		self.props.clearRemovedItems()
	end
end

return (RoactRodux.connect(function(p2, p3)
	local v5 = {
		tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		currentSort = 0
	}

	local v6 = if not fFlagAXUseSignalsForLayeredClothingCurrentSort then p2.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList else nil
	v5.currentSort = v6
	return v5
end, function(callback)
	return {
		clearCurrentSort = function()
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).clearCurrentSort()
			else
				callback(module())
			end
		end,
		clearRemovedItems = function()
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).clearRemovedItems()
			else
				callback(module2())
			end
		end
	}
end)(extended))
