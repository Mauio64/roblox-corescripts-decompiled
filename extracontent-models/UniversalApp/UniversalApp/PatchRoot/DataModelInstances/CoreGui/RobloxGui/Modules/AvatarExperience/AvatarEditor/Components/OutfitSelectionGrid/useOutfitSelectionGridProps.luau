local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Modules = CoreGui.RobloxGui.Modules
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local GetOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfits)
local RequestStatusEnum = require(Modules.AvatarExperience.Common.Enum.RequestStatusEnum)
local useRequest = require(Modules.AvatarExperience.Common.Hooks.useRequest)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local OutfitSelectionGridItemContainer = require(script.Parent.Items.OutfitSelectionGridItemContainer)
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local v22 = game:DefineFastInt("AXMaxOutfitSelectionCount", 10)

require(script.Parent.OutfitSelectionGrid)

local function selectOutfitInfos(p1) -- line: 55
	return p1.AvatarExperience.AvatarEditor.OutfitInfos
end
local function selectScreenSize(p2) -- line: 59
	return p2.ScreenSize
end
local function selectHasMoreItemsForListKey(s1: string) -- line: 63
	return function(p3) -- line: 64
		-- upvalues: s1 (copy)
		return not p3.AvatarExperience.AvatarEditor.PageFinished[s1]
	end
end
local function selectOutfitIdsForListKey(s2: string) -- line: 70
	return function(p4) -- line: 71
		-- upvalues: s2 (copy)
		local t1 = {}

		for _, v67 in p4.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[s2] or {} do
			table.insert(t1, (tostring(v67)))
		end

		return t1
	end
end
local function useOutfitSelectionGridProps(t2: {[any]: any}) -- line: 82
	-- upvalues: React (copy), Utils (copy), useFocusGuiObject (copy), useSelector (copy), selectOutfitInfos (copy), selectScreenSize (copy), useAppPolicy (copy), useDispatch (copy), GetOutfits (copy), useRequest (copy), RequestStatusEnum (copy), useLocalization (copy), v22 (copy), useStyle (copy), Cryo (copy), v22 (copy), SetCurrentToastMessage (copy), ToastType (copy), Constants2 (copy), wasLastInputGamepad (copy), Constants (copy), OutfitSelectionGridItemContainer (copy)
	local v33 = t2.isEditable == nil or t2.isEditable
	local v34 = React.useMemo(function() -- line: 85
		-- upvalues: Utils (copy), t2 (copy), v33 (copy)
		return Utils.getOutfitSubtypeKey(t2.outfitType, v33)
	end, {
		t2.outfitType,
		v33
	})
	local v35 = useFocusGuiObject()
	local v36 = React.useMemo(function() -- line: 91
		-- upvalues: v34 (copy)
		local v68 = v34

		return function(p5) -- line: 64
			-- upvalues: v68 (copy)
			return not p5.AvatarExperience.AvatarEditor.PageFinished[v68]
		end
	end, { v34 })
	local v37 = React.useMemo(function() -- line: 95
		-- upvalues: v34 (copy)
		local v69 = v34

		return function(p6) -- line: 71
			-- upvalues: v69 (copy)
			local t3 = {}

			for _, v90 in p6.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v69] or {} do
				table.insert(t3, (tostring(v90)))
			end

			return t3
		end
	end, { v34 })
	local v38 = useSelector(v36)
	local v39 = useSelector(v37)
	local v40 = useSelector(selectOutfitInfos)
	local v41 = useSelector(selectScreenSize)
	local v42 = useAppPolicy(function(p7) -- line: 104
		return p7.getCustomOutfitNames()
	end)
	local v43 = useAppPolicy(function(p8) -- line: 107
		return p8.getEnableContinuousLoad()
	end)
	local v44 = useDispatch()
	local v45 = React.useCallback(function() -- line: 113
		-- upvalues: v44 (copy), GetOutfits (copy), v34 (copy), v33 (copy), t2 (copy)
		return v44(GetOutfits(v34, v33, nil, t2.outfitType))
	end, {
		v44,
		v34,
		t2.outfitType,
		v33
	})
	local v46, v47 = useRequest(v45)
	local v48 = v46.status == RequestStatusEnum.Pending
	local v49 = useLocalization({
		itemType = "Feature.Avatar.Label.Avatars",
		loadMore = "Feature.Catalog.Action.LoadMore",
		maxSelectionToast = {
			"Feature.Avatar.Toast.MaxOutfitsSelected",
			maxSelectCount = v22
		}
	})
	local v50 = useLocalization({
		noItemsLabel = {
			"Feature.Avatar.Label.NoItems",
			itemType = v49.itemType
		}
	})
	local t4 = {
		itemType = v49.itemType,
		noItemsLabel = v50.noItemsLabel,
		maxSelectionToast = v49.maxSelectionToast,
		loadMore = v49.loadMore
	}
	local v52 = useStyle()
	local v53 = React.useRef(nil)
	local v54 = React.useRef(0)
	local v55 = React.useRef(0)
	local v56 = React.useRef(t2.multiSelect)

	React.useEffect(function() -- line: 146
		-- upvalues: v56 (copy), t2 (copy)
		if v56.current == true and t2.multiSelect == false then
			t2.setSelectedOutfits({})
		end

		v56.current = t2.multiSelect
	end, {
		t2.multiSelect,
		t2.setSelectedOutfits
	})
	React.useEffect(function() -- line: 153
		-- upvalues: t2 (copy), Cryo (copy), v39 (copy)
		local t5 = {}
		local v73 = false

		for _, v75 in t2.selectedOutfits do
			if Cryo.List.find(v39, v75) then
				table.insert(t5, v75)
			else
				v73 = true
			end
		end

		if v73 then
			t2.setSelectedOutfits(t5)
		end
	end, {
		v39,
		t2.selectedOutfits,
		t2.setSelectedOutfits
	})

	local v57 = React.useCallback(function(t6: {[any]: any}) -- line: 168
		-- upvalues: v22 (copy), v44 (copy), SetCurrentToastMessage (copy), t4 (copy), ToastType (copy), t2 (copy)
		if #t6 > v22 then
			v44(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = t4.maxSelectionToast,
				toastType = ToastType.InformationMessage
			}))

			return
		end

		t2.setSelectedOutfits(t6)
	end, {
		v44,
		t2.setSelectedOutfits,
		t4.maxSelectionToast
	})
	local v58 = React.useCallback(function() -- line: 180
		-- upvalues: t2 (copy), Constants2 (copy), v55 (copy), v54 (copy)
		if t2.setCanScroll then
			local v77 = Constants2.ItemsGridTopPadding + Constants2.ItemsGridBottomPadding

			t2.setCanScroll(v55.current + v77 > v54.current)
		end
	end, { t2.setCanScroll })
	local v59 = React.useCallback(function(p9) -- line: 187
		-- upvalues: v54 (copy), v58 (copy)
		v54.current = p9.AbsoluteSize.Y
		v58()
	end, { v58 })
	local v60 = React.useCallback(function(p10) -- line: 192
		-- upvalues: v55 (copy), v58 (copy)
		v55.current = p10.AbsoluteContentSize.Y
		v58()
	end, { v58 })
	local v61 = React.useCallback(function() -- line: 198
		-- upvalues: wasLastInputGamepad (copy), v38 (copy), v39 (copy), Constants (copy), v35 (copy), v53 (copy), v47 (copy)
		local v80 = wasLastInputGamepad()
		local v81 = not (v38 and #v39 == 0) and v39 or nil
		local ShimmerCardsToDisplay = Constants.ShimmerCardsToDisplay
		local v83 = (v81 and #v81 or ShimmerCardsToDisplay) > 0

		if v80 and (v83 and v35 and v53.current) then
			v35(v53.current)
		end

		v47()
	end, {
		v38,
		v39,
		v35,
		v47
	})
	local v62 = React.useCallback(function(p11) -- line: 219
		-- upvalues: React (copy), OutfitSelectionGridItemContainer (copy), t2 (copy), v40 (copy), v57 (copy)
		local v85 = if typeof(p11) ~= "table" then p11 else nil

		return React.createElement(OutfitSelectionGridItemContainer, {
			multiSelect = t2.multiSelect ~= nil and t2.multiSelect,
			itemId = v85,
			outfitInfo = v40[tostring(v85)],
			setSelectedOutfits = v57,
			selectedOutfits = t2.selectedOutfits,
			onToggleOutfitCard = t2.onToggleOutfitCard
		})
	end, {
		t2.selectedOutfits,
		t2.multiSelect,
		t2.onToggleOutfitCard,
		t2.setSelectedOutfits,
		v40,
		v57
	})

	return {
		goBack = t2.goBack,
		pageOwner = t2.pageOwner,
		forwardRef = t2.forwardRef,
		showCustomOutfitNames = v42,
		enableContinuousLoad = v43,
		outfitIds = v39,
		screenSize = v41,
		hasMoreItems = v38,
		loadMoreItems = v47,
		isFetchingMore = v48,
		localized = t4,
		loadableGridViewRef = v53,
		stylePalette = v52,
		absoluteSizeChanged = v59,
		contentSizeChanged = v60,
		onLoadMoreButtonActivated = v61,
		renderItem = v62
	}
end

return useOutfitSelectionGridProps
