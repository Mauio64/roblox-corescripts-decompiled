local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = AvatarExperienceCommon.Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useIsGamepad

local module3 = require("@luauforge/bundled/eie")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed
local module4 = require("@luauforge/deferred/hft")
local module5 = require("@luauforge/bundled/dWU")

local fFlagAXUseSignalsForLayeredClothingLastSavedSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingLastSavedSort
local getLayeredClothingLastSavedSortStore

if fFlagAXUseSignalsForLayeredClothingLastSavedSort then
	getLayeredClothingLastSavedSortStore = require("@luauforge/bundled/dPt").Stores.getLayeredClothingLastSavedSortStore
else
	getLayeredClothingLastSavedSortStore = nil
end

local module6 = require("@luauforge/bundled/dWW")
local module7 = require("@luauforge/bundled/gSD")
local fullView = AvatarExperienceCommon.Enums.FullView

local module8 = require("@luauforge/deferred/hiD")
local module9 = require("@luauforge/bundled/gJS")
local selectEquippedAssets = AvatarExperienceCommon.State.Selectors.selectEquippedAssets
local selectTopBarHeight = AvatarExperienceCommon.State.Selectors.selectTopBarHeight

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module10 = require("@luauforge/deferred/gKK")
local module11 = require("@luauforge/bundled/dXb")
local fFlagAXUseSignalsForLayeredClothingEntryPage = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingEntryPage
local getLayeredClothingEntryPageStore

if fFlagAXUseSignalsForLayeredClothingEntryPage then
	getLayeredClothingEntryPageStore = require("@luauforge/bundled/dPt").Stores.getLayeredClothingEntryPageStore
else
	getLayeredClothingEntryPageStore = nil
end

local module12 = require("@luauforge/bundled/dXe")
local module13 = require("@luauforge/deferred/gKL")

local fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice = AvatarExperienceFlags.FFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice
require("@luauforge/deferred/hiP")

return function(p2)
	local v5 = useIsSpatial()
	local v6 = useDispatch()
	local v7 = useIsGamepad()

	local v8 = useAvatarRoute()
	local v9 = module3(module10)
	local v10 = module3(avatarExperienceAnalyticsService)
	local v11 = useLocalization({
		makeupSorting = "Feature.Avatar.Title.MakeupSortPage",
		noItemText = "Feature.Avatar.Message.LayeredMakeupSortNoEquipped"
	})

	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local v12 = useSelector(module8)
	local v13 = useSelector(module9)
	local v14 = useSelector(selectEquippedAssets)
	local v15 = useSelector(selectTopBarHeight)

	local v16 = React.useCallback(function(p3)
		setState(p3)
	end, {})

	local v17 = React.useCallback(function()
		if not fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
			v6(module12())
		end

		p2.navigation.pop()
		v6(module13(v9.avatarRefineGoBack))

		if fFlagAXUseSignalsForLayeredClothingEntryPage then
			getLayeredClothingEntryPageStore(false).setEntryPage(avatarScreen.None)
		else
			v6(module11(avatarScreen.None))
		end
	end, { v6, p2.navigation, v9 })

	local v18 = React.useCallback(function()
		local function onOverlayClosed()
			if v7 and v8.opaque.name == avatarScreen.LayeredMakeupSort then
				logOnOverlayClosed("LayeredMakeupSort")
			end
		end

		p2.navigation.navigate(avatarScreen.ResetLayeredItemsSortPrompt, {
			onOverlayClosed = onOverlayClosed
		})
	end, { p2.navigation, v7, v8 })

	local v19 = React.useMemo(function()
		return module4(v17)
	end, { v17 })

	React.useEffect(function()
		if
			v8.opaque.name == avatarScreen.LayeredMakeupSort
			and ref.current ~= avatarScreen.LayeredMakeupSort
		then
			local v20 = {}

			for k, v21 in v12 do
				if v14[v21.typeId] and v14[v21.typeId][v21.id] then
					v21.equipped = true
				end

				table.insert(v20, v21)
			end

			if fFlagAXUseSignalsForLayeredClothingLastSavedSort then
				getLayeredClothingLastSavedSortStore(false).setLastSavedSort(v20)
			else
				v6(module5(v20))
			end

			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).setCurrentSort(v12)
			else
				v6(module6(v12))
			end

			v6(module7(v10, avatarScreen.LayeredMakeupSort, fullView.SceneFullView))
		end
	end, { v8, v12, v14, v10 })

	React.useEffect(function()
		ref.current = v8.opaque.name
	end, { v8.opaque.name })

	return {
		isSpatial = v5,
		isGamepad = v7,
		isDragging = state,
		isPortrait = v13,
		topBarHeight = v5 and 0 or v15,
		onDragChange = v16,
		onGoBack = v17,
		onOpenResetPrompt = v18,
		backButton = v19,
		localized = v11,
		equippedLayeredMakeupAssetIdsOrdered = v12
	}
end
