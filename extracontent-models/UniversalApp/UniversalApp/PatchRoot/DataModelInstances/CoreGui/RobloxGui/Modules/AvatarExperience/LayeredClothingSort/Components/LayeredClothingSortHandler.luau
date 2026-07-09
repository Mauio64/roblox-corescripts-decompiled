local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local tutils = require(CorePackages.Packages.tutils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local ClearCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.ClearCurrentSort)
local ClearRemovedItems = require(Modules.AvatarExperience.LayeredClothingSort.Actions.ClearRemovedItems)
local v10 = Roact.PureComponent:extend("LayeredClothingSortHandler")

v10.validateProps = t.strictInterface({
	avatarRoute = t.table,
	tryOnItems = t.table,
	currentSort = t.optional(t.table),
	clearCurrentSort = t.callback,
	clearRemovedItems = t.callback
})

function v10.render(_) -- line: 35
	return nil
end

local function hasSameKeys(p2, p3) -- line: 39
	-- upvalues: tutils (copy)
	local n1 = 0

	for v16 in p2 do
		n1 += 1

		if p3[v16] == nil then
			return false
		end
	end

	return n1 == tutils.fieldCount(p3)
end

function v10.didSwitchTryOn(p4, p5) -- line: 51
	-- upvalues: tutils (copy)
	local tryOnItems = p5.tryOnItems
	local tryOnItems2 = p4.props.tryOnItems
	local n2 = 0
	local v23

	for v22 in tryOnItems do
		n2 += 1

		if tryOnItems2[v22] == nil then
			v23 = false

			return not v23
		end
	end

	v23 = n2 == tutils.fieldCount(tryOnItems2)

	return not v23
end
function v10.didUpdate(p6, p7) -- line: 55
	-- upvalues: AvatarScreen (copy)
	local name = p6.props.avatarRoute.opaque.name
	local name2 = p7.avatarRoute.opaque.name
	local v28 = p6:didSwitchTryOn(p7)

	if name ~= AvatarScreen.LayeredClothingSort and (v28 and #p6.props.currentSort > 0) then
		p6.props.clearCurrentSort()
	end

	if name ~= name2 and name2 == AvatarScreen.LayeredClothingSort then
		p6.props.clearRemovedItems()
	end
end

return (RoactRodux.connect(function(p8, _) -- line: 76
	return {
		tryOnItems = p8.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		currentSort = p8.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList
	}
end, function(p10) -- line: 81
	-- upvalues: ClearCurrentSort (copy), ClearRemovedItems (copy)
	return {
		clearCurrentSort = function() -- line: 83
			-- upvalues: p10 (copy), ClearCurrentSort (copy)
			p10(ClearCurrentSort())
		end,
		clearRemovedItems = function() -- line: 86
			-- upvalues: p10 (copy), ClearRemovedItems (copy)
			p10(ClearRemovedItems())
		end
	}
end)(v10))
