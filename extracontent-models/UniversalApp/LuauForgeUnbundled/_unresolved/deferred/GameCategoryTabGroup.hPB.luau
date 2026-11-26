local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local topicInfosReducer = require("@luauforge/bundled/dCQ").TopicInfosReducer

local useAnimatedScrollToSelection = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useAnimatedScrollToSelection
local UIBlox = require(CorePackages.Packages.UIBlox)
local iconTabGroup = UIBlox.App.Navigation.PrimaryNavBar.IconTabGroup
local module = require("@luauforge/bundled/dXA")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagExtendScrollingFramesBySafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagExtendScrollingFramesBySafeInsets

local omniFeedTypes = require("@luauforge/bundled/cBc").OmniFeedTypes

local function GameCategoryTabGroup(props)
	local size = props.size
	local onSelected = props.onSelected
	local selectedSortIndex = props.selectedSortIndex
	local selectedSortName = props.selectedSortName
	local sortCategories = props.sortCategories

	local v5 = useSelector(function(p2)
		return p2.Personalization[topicInfosReducer.key]
	end)

	local v6 = useSelector(function(p2)
		return p2.GameSortGroups
	end)

	local v7 = useSelector(function(p2)
		return p2.OmniRecommendations
	end)

	local v8 = React.useMemo(function()
		local result = {}

		local function addSortToResult(p2, p3)
			table.insert(result, { sort = p2, storeIndex = p3 })
		end

		for k, sortCategory in sortCategories do
			if sortCategory.isOmni then
				if v7[sortCategory.sortType] and v7[sortCategory.sortType].sorts then
					for k2, sort in v7[sortCategory.sortType].sorts do
						if sort.treatmentType == omniFeedTypes.Carousel then
							table.insert(result, {
								sort = v5[sort.topicId],
								storeIndex = k2
							})
						end
					end
				end
			else
				for k2, sort in v6[sortCategory.sortType].sorts do
					table.insert(result, { sort = v5[sort], storeIndex = k2 })
				end
			end
		end

		return result
	end, { v5, v6, v7, sortCategories })

	local v9 = React.useCallback(function(p2, p3)
		local storeIndex = onSelected and p3 <= #v8 and p2.storeIndex

		if storeIndex then
			return onSelected(p2.sort, storeIndex, p3)
		end

		return nil
	end, { onSelected, v8 })

	local v10 = React.useMemo(function()
		return Cryo.List.map(v8, function(p2, p3)
			return {
				title = p2.sort.displayName,
				onActivated = function()
					v9(p2, p3)
				end,
				showRoundedBackground = p2.sort.uniqueKey == selectedSortName
			}
		end)
	end, { v8, selectedSortName })

	local v11, v12 = useAnimatedScrollToSelection(
		Enum.ScrollingDirection.X,
		not props.padding and 0 or props.padding.left
	)
	local v13

	if fFlagExtendScrollingFramesBySafeInsets then
		v13 = useSignalState(module.GetDisplayStore().getDeviceSafePadding)
	end

	local createElement = React.createElement
	local v15 = {
		Size = UDim2.new(1, not fFlagExtendScrollingFramesBySafeInsets and 0 or v13.right, 1, 0),
		Selectable = false,
		ClipsDescendants = true,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.new(0, 0, 1, 0),
		CanvasPosition = v11,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		BackgroundTransparency = 1,
		[React.Event.SelectionChanged] = v12
	}
	local v16 = {
		TabGroup = React.createElement(iconTabGroup, {
			size = size,
			fillDirection = Enum.FillDirection.Horizontal,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			sortOrder = Enum.SortOrder.LayoutOrder,
			items = v10,
			selection = { selectedSortIndex },
			padding = props.padding or { left = 0, right = 0, top = 0, bottom = 0 }
		}),
		UIPadding = 0
	}

	local v17 = if fFlagExtendScrollingFramesBySafeInsets then React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, v13.right)
	}) else nil
	v16.UIPadding = v17
	return createElement("ScrollingFrame", v15, v16)
end

return GameCategoryTabGroup
