local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local TopicInfosReducer = require(CorePackages.Workspace.Packages.TopicInfosRodux).TopicInfosReducer
local useAnimatedScrollToSelection = require(CorePackages.Workspace.Packages.RobloxAppHooks).useAnimatedScrollToSelection
local IconTabGroup = require(CorePackages.Packages.UIBlox).App.Navigation.PrimaryNavBar.IconTabGroup
local Display = require(CorePackages.Workspace.Packages.Display)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagExtendScrollingFramesBySafeInsets = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExtendScrollingFramesBySafeInsets
local OmniFeedTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedTypes

local function GameCategoryTabGroup(t1: {[any]: any}) -- line: 28
	-- upvalues: useSelector (copy), TopicInfosReducer (copy), React (copy), OmniFeedTypes (copy), Cryo (copy), useAnimatedScrollToSelection (copy), FFlagEnableLeftNavOnConsole (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), IconTabGroup (copy)
	local size = t1.size
	local onSelected = t1.onSelected
	local selectedSortIndex = t1.selectedSortIndex
	local selectedSortName = t1.selectedSortName
	local sortCategories = t1.sortCategories
	local v20 = useSelector(function(p1) -- line: 35
		-- upvalues: TopicInfosReducer (copy)
		return p1.Personalization[TopicInfosReducer.key]
	end)
	local v21 = useSelector(function(p2) -- line: 38
		return p2.GameSortGroups
	end)
	local v22 = useSelector(function(p3) -- line: 41
		return p3.OmniRecommendations
	end)
	local v23 = React.useMemo(function() -- line: 46
		-- upvalues: sortCategories (copy), v22 (copy), OmniFeedTypes (copy), v20 (copy), v21 (copy)
		local t2 = {}

		local function addSortToResult(p4, p5) -- line: 49
			-- upvalues: t2 (copy)
			table.insert(t2, {
				sort = p4,
				storeIndex = p5
			})
		end

		for _, v35 in sortCategories do
			if v35.isOmni then
				if v22[v35.sortType] and v22[v35.sortType].sorts then
					for v36, v37 in v22[v35.sortType].sorts do
						if v37.treatmentType == OmniFeedTypes.Carousel then
							table.insert(t2, {
								sort = v20[v37.topicId],
								storeIndex = v36
							})
						end
					end
				end
			else
				for v38, v39 in v21[v35.sortType].sorts do
					table.insert(t2, {
						sort = v20[v39],
						storeIndex = v38
					})
				end
			end
		end

		return t2
	end, {
		v20,
		v21,
		v22,
		sortCategories
	})
	local v24 = React.useCallback(function(p6, p7) -- line: 86
		-- upvalues: onSelected (copy), v23 (copy)
		if onSelected and p7 <= #v23 then
			local storeIndex = p6.storeIndex

			if storeIndex then
				return onSelected(p6.sort, storeIndex, p7)
			end
		end

		return nil
	end, {
		onSelected,
		v23
	})
	local v25 = React.useMemo(function() -- line: 100
		-- upvalues: Cryo (copy), v23 (copy), v24 (copy), selectedSortName (copy)
		return Cryo.List.map(v23, function(p8, p9) -- line: 101
			-- upvalues: v24 (copy), selectedSortName (copy)
			return {
				title = p8.sort.displayName,
				onActivated = function() -- line: 104
					-- upvalues: v24 (copy), p8 (copy), p9 (copy)
					v24(p8, p9)
				end,
				showRoundedBackground = p8.sort.uniqueKey == selectedSortName
			}
		end)
	end, {
		v23,
		selectedSortName
	})
	local v26, v27 = useAnimatedScrollToSelection(Enum.ScrollingDirection.X, not t1.padding and 0 or t1.padding.left)
	local v28 = if not FFlagEnableLeftNavOnConsole or not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return React.createElement("ScrollingFrame", {
		Size = UDim2.new(1, (not FFlagEnableLeftNavOnConsole or not FFlagExtendScrollingFramesBySafeInsets) and 0 or v28.right, 1, 0),
		Selectable = false,
		ClipsDescendants = true,
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasSize = UDim2.new(0, 0, 1, 0),
		CanvasPosition = v26,
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.X,
		BackgroundTransparency = 1,
		[React.Event.SelectionChanged] = v27
	}, {
		TabGroup = React.createElement(IconTabGroup, {
			size = size,
			fillDirection = Enum.FillDirection.Horizontal,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			sortOrder = Enum.SortOrder.LayoutOrder,
			items = v25,
			selection = { selectedSortIndex },
			padding = t1.padding or {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0
			}
		}),
		UIPadding = if not FFlagEnableLeftNavOnConsole or not FFlagExtendScrollingFramesBySafeInsets then nil else React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, v28.right)
		})
	})
end

return GameCategoryTabGroup
