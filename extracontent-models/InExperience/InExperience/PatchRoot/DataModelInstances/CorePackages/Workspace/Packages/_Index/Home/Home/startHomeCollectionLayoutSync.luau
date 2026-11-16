local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local Signals = require(parent.Signals)
local CollectionViews = require(parent.CollectionViews)
local Display = require(parent.Display)

local measureHomeCollectionLayout = require(Home.measureHomeCollectionLayout)
local writeHomePageSduiCollectionLayout = require(Home.writeHomePageSduiCollectionLayout)

local function startHomeCollectionLayoutSync()
	local mainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore(false)
	local displayStore = Display.GetDisplayStore(false)

	local computed = Signals.createComputed(function(p)
		mainCollectionLayoutStore.getContainerWidth(p)
		mainCollectionLayoutStore.getIsContainerMeasured(p)
		displayStore.getViewportSize(p)
		displayStore.getTopBarHeight(p)
		local v = measureHomeCollectionLayout()
		return if v then v.rows_above_fold else nil
	end)

	local v = false
	return Signals.createEffect(function(p)
		local v2 = computed(p)

		mainCollectionLayoutStore.getNumItemsForAllCategories(p)

		if v2 == nil or v then
			return
		end

		v = true
		task.delay(1, function()
			v = false
			local v3 = measureHomeCollectionLayout()

			if v3 then
				writeHomePageSduiCollectionLayout(v3)
			end
		end)
	end)
end

return startHomeCollectionLayoutSync
