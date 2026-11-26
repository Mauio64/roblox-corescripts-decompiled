local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/fDf")
local module3 = require("@luauforge/bundled/dPG")
local module4 = require("@luauforge/bundled/dPH")
local module5 = require("@luauforge/bundled/dVQ")
local module6 = require("@luauforge/bundled/fCm")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function useSortsController()
	module(module2)

	local v5 = useSelector(module6.selectCatalogSort, getUseSelectorDeepEquals())
	local v6 = useSelector(module6.selectCatalogSortAggregation, getUseSelectorDeepEquals())

	local state, setState = React.useState(v5)

	local state2, setState2 = React.useState(v6)

	local state3, setState3 = React.useState(v6)

	local v7 = useDispatch()

	local v8 = state ~= module3.Relevance
	local v9

	if state == v5 and (state ~= module3.MostFavorited or state2 == v6) then
		v9 = state == module3.Bestselling and state3 ~= v6
	else
		v9 = true
	end

	return {
		sortType = state,
		setSortType = setState,
		mostFavoritedAggregation = state2,
		setMostFavoritedAggregation = setState2,
		bestSellingAggregation = state3,
		setBestSellingAggregation = setState3,
		canReset = v8,
		canApply = v9,
		reset = React.useCallback(function()
			setState(module3.Relevance)
			setState2(module4.AllTime)
			setState3(module4.AllTime)
		end),
		apply = React.useCallback(function()
			local v10 = module4.AllTime

			if state == module3.MostFavorited then
				v10 = state2
			elseif state == module3.Bestselling then
				v10 = state3
			end

			v7(module5(state, v10))
		end, { state, state2, state3 })
	}
end

return useSortsController
