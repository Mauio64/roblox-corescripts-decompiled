local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local useIsGamepad = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useIsGamepad
local Modules = CoreGui.RobloxGui.Modules
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local makeAvatarBackButton = require(Modules.AvatarExperience.Common.Components.TopBar.makeAvatarBackButton)
local SetLastSavedSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetLastSavedSort)
local SetCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetCurrentSort)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local selectEquippedLayeredMakeupOrdered = require(Modules.AvatarExperience.LayeredMakeupSort.Selectors.selectEquippedLayeredMakeupOrdered)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local selectTopBarHeight = AvatarExperienceCommon.State.Selectors.selectTopBarHeight
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.LayeredClothingSort.Services.Analytics)
local SetEntryPage = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetEntryPage)
local UnlockCharacterUpdates = require(Modules.AvatarExperience.LayeredClothingSort.Actions.UnlockCharacterUpdates)
local SendRefinementAnalytics = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.SendRefinementAnalytics)

require(Modules.AvatarExperience.LayeredMakeupSort.Components.LayeredMakeupSortPage)

return function(t1: {[any]: any}) -- line: 39
	-- upvalues: useIsSpatial (copy), useDispatch (copy), useIsGamepad (copy), useAvatarRoute (copy), useRoactService (copy), Analytics2 (copy), Analytics (copy), useLocalization (copy), React (copy), useSelector (copy), selectEquippedLayeredMakeupOrdered (copy), selectIsPortrait (copy), selectEquippedAssets (copy), selectTopBarHeight (copy), UnlockCharacterUpdates (copy), SendRefinementAnalytics (copy), SetEntryPage (copy), AvatarScreen (copy), logOnOverlayClosed (copy), makeAvatarBackButton (copy), SetLastSavedSort (copy), SetCurrentSort (copy), SetFullView (copy), FullView (copy)
	local v30 = useIsSpatial()
	local v31 = useDispatch()
	local v32 = useIsGamepad()
	local v33 = useAvatarRoute()
	local v34 = useRoactService(Analytics2)
	local v35 = useRoactService(Analytics)
	local v36 = useLocalization({
		makeupSorting = "Feature.Avatar.Title.MakeupSortPage",
		noItemText = "Feature.Avatar.Message.LayeredMakeupSortNoEquipped"
	})
	local v37, v38 = React.useState(false)
	local v39 = React.useRef(nil)
	local v40 = useSelector(selectEquippedLayeredMakeupOrdered)
	local v41 = useSelector(selectIsPortrait)
	local v42 = useSelector(selectEquippedAssets)
	local v43 = useSelector(selectTopBarHeight)

	if v30 then
		v43 = 0
	end

	local v44 = React.useCallback(function(p1) -- line: 64
		-- upvalues: v38 (copy)
		v38(p1)
	end, {})
	local v45 = React.useCallback(function() -- line: 68
		-- upvalues: v31 (copy), UnlockCharacterUpdates (copy), t1 (copy), SendRefinementAnalytics (copy), v34 (copy), SetEntryPage (copy), AvatarScreen (copy)
		v31(UnlockCharacterUpdates())
		t1.navigation.pop()
		v31(SendRefinementAnalytics(v34.avatarRefineGoBack))
		v31(SetEntryPage(AvatarScreen.None))
	end, {
		v31,
		t1.navigation,
		v34
	})
	local v46 = React.useCallback(function() -- line: 86
		-- upvalues: v32 (copy), v33 (copy), AvatarScreen (copy), logOnOverlayClosed (copy), t1 (copy)
		t1.navigation.navigate(AvatarScreen.ResetLayeredItemsSortPrompt, {
			onOverlayClosed = function() -- line: 87
				-- upvalues: v32 (copy), v33 (copy), AvatarScreen (copy), logOnOverlayClosed (copy)
				if v32 and v33.opaque.name == AvatarScreen.LayeredMakeupSort then
					logOnOverlayClosed("LayeredMakeupSort")
				end
			end
		})
	end, {
		t1.navigation,
		v32,
		v33
	})
	local v47 = React.useMemo(function() -- line: 100
		-- upvalues: makeAvatarBackButton (copy), v45 (copy)
		return makeAvatarBackButton(v45)
	end, { v45 })

	React.useEffect(function() -- line: 105
		-- upvalues: v33 (copy), AvatarScreen (copy), v39 (copy), v40 (copy), v42 (copy), v31 (copy), SetLastSavedSort (copy), SetCurrentSort (copy), SetFullView (copy), v35 (copy), FullView (copy)
		if v33.opaque.name == AvatarScreen.LayeredMakeupSort and v39.current ~= AvatarScreen.LayeredMakeupSort then
			local t2 = {}

			for _, v51 in v40 do
				if v42[v51.typeId] and v42[v51.typeId][v51.id] then
					v51.equipped = true
				end

				table.insert(t2, v51)
			end

			v31(SetLastSavedSort(t2))
			v31(SetCurrentSort(v40))
			v31(SetFullView(v35, AvatarScreen.LayeredMakeupSort, FullView.SceneFullView))
		end
	end, {
		v33,
		v40,
		v42,
		v35
	})
	React.useEffect(function() -- line: 132
		-- upvalues: v39 (copy), v33 (copy)
		v39.current = v33.opaque.name
	end, { v33.opaque.name })

	return {
		isSpatial = v30,
		isGamepad = v32,
		isDragging = v37,
		isPortrait = v41,
		topBarHeight = v43,
		onDragChange = v44,
		onGoBack = v45,
		onOpenResetPrompt = v46,
		backButton = v47,
		localized = v36,
		equippedLayeredMakeupAssetIdsOrdered = v40
	}
end
