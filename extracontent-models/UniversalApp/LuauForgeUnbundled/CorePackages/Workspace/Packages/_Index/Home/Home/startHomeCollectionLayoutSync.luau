local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Signals")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/CollectionViews")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Display")

local measureHomeCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/measureHomeCollectionLayout")
local writeHomePageSduiCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/writeHomePageSduiCollectionLayout")

local function startHomeCollectionLayoutSync()
	local mainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore(false)
	local displayStore = Display.GetDisplayStore(false)

	local computed = Signals.createComputed(function(p2)
		mainCollectionLayoutStore.getContainerWidth(p2)
		mainCollectionLayoutStore.getIsContainerMeasured(p2)
		displayStore.getViewportSize(p2)
		displayStore.getTopBarHeight(p2)
		local v5 = measureHomeCollectionLayout()

		if v5 then
			return v5.rows_above_fold
		end

		return nil
	end)

	local v5 = false
	return Signals.createEffect(function(p2)
		local v6 = computed(p2)

		mainCollectionLayoutStore.getNumItemsForAllCategories(p2)

		if v6 == nil or v5 then
			return
		end

		v5 = true
		task.delay(1, function()
			v5 = false
			local v7 = measureHomeCollectionLayout()

			if v7 then
				writeHomePageSduiCollectionLayout(v7)
			end
		end)
	end)
end

return startHomeCollectionLayoutSync
