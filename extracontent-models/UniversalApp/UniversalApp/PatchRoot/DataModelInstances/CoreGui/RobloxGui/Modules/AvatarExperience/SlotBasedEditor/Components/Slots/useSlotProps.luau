local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local BatchUnequipByAssetType = require(Modules.AvatarExperience.AvatarEditor.Actions.BatchUnequipByAssetType)
local NormalizeAvatar = require(Modules.AvatarExperience.AvatarEditor.Actions.NormalizeAvatar)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local useSlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext
local Constants = AvatarExperienceSlotBasedEditor.Constants
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local buildSlots = AvatarExperienceSlotBasedEditor.Utils.buildSlots
local buildBodySlotViewportProps = AvatarExperienceSlotBasedEditor.Utils.buildBodySlotViewportProps
local AvatarEditorSubcategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorSubcategories
local SlotCircularGradientFrame = AvatarExperienceSlotBasedEditor.Components.SlotCircularGradientFrame
local Categories = AvatarExperienceSlotBasedEditor.Enums.Categories
local ClearAllButton = AvatarExperienceSlotBasedEditor.Components.ClearAllButton
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local SlotItemCardThumbnail = AvatarExperienceSlotBasedEditor.Components.SlotItemCardThumbnail
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(script.Parent.Parent.Parent.Services.Analytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local getAssetTypesByCategory = AvatarExperienceSlotBasedEditor.Utils.getAssetTypesByCategory
local useSlotItemCardBreakpoints = AvatarExperienceSlotBasedEditor.Hooks.useSlotItemCardBreakpoints

require(script.Parent.Parent.SlotNavigation)
require(script.Parent.Parent.SlotSubNavigation)
require(script.Parent.Slots)

local ItemView = AvatarExperienceSlotBasedEditor.Enums.ItemView
local NavigationParams = AvatarExperienceSlotBasedEditor.Enums.NavigationParams
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local LookViewport = require(Modules.AvatarExperience.Common.Components.Looks.LookViewport)
local SlotType = AvatarExperienceSlotBasedEditor.Enums.SlotType
local FFlagAXEnableClearAllConfirmationPrompt = require(Modules.AvatarExperience.Flags.FFlagAXEnableClearAllConfirmationPrompt)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXFixCheckOnEquippedAssets = require(Modules.AvatarExperience.Flags.FFlagAXFixCheckOnEquippedAssets)
local FFlagAXImproveSlotBasedEditorPerformance = require(Modules.AvatarExperience.Flags.FFlagAXImproveSlotBasedEditorPerformance)
local FFlagAXSlotsDesktopCrashFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsDesktopCrashFix
local FFlagAXSlotBasedEditorCategoryTooltip = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotBasedEditorCategoryTooltip
local FFlagAXSlotsDesktopRedesign = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsDesktopRedesign
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXMigrateSlotsSignals = AvatarExperienceFlags.FFlagAXMigrateSlotsSignals
local FFlagAXSlotsDisableScrollAwayOnLandscape = AvatarExperienceFlags.FFlagAXSlotsDisableScrollAwayOnLandscape
local FFlagAXFixLookLinkToCustomize = AvatarExperienceFlags.FFlagAXFixLookLinkToCustomize
local v52 = game:DefineFastFlag("AXSlotCategoriesNilCheck", false)

local function buildStringsToLocalize(t1: {[any]: any}, s1: string) -- line: 91
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), SlotType (copy)
	local t2 = {}

	for _, v63 in t1 do
		if FFlagAXCustomizeMakeupSupport and v63.slotType == SlotType.LayeredSlot then
			for i = 1, v63.layerLimit do
				t2[v63.nameTranslationKey .. "_" .. i] = {
					v63.nameTranslationKey,
					layerIndex = i
				}
			end
		else
			t2[v63.nameTranslationKey] = v63.nameTranslationKey
		end
	end

	t2[s1] = s1

	return t2
end
local function getCategoryIndices(s2: string) -- line: 110
	-- upvalues: GetAvatarEditorCategories (copy), FFlagAXEditorSubcategoryFilters (copy)
	for v66, v67 in (GetAvatarEditorCategories()) do
		if v67.Subcategories then
			for v68, v69 in v67.Subcategories do
				if s2 == v69.NavigationKey then
					return v66, v68, nil
				end

				if FFlagAXEditorSubcategoryFilters and v69.SubcategoryFilters then
					for v70, v71 in v69.SubcategoryFilters do
						if s2 == v71.NavigationKey then
							return v66, v68, v70
						end
					end
				end
			end
		end
	end

	return nil, nil, nil
end
local function shallowEqual(p1, p2) -- line: 133
	if p1 == p2 then
		return true
	end

	if type(p1) ~= "table" or type(p2) ~= "table" then
		return false
	end

	for v74, v75 in p1 do
		if v75 ~= p2[v74] then
			return false
		end
	end

	for v76, _ in p2 do
		if p1[v76] == nil then
			return false
		end
	end

	return true
end

local u56 = nil
local u57 = nil

if FFlagAXCustomizeMakeupSupport then
	function u56(p3) -- line: 161
		return p3.AvatarExperience.AvatarEditor.Categories.category
	end
	function u57(p4) -- line: 164
		return p4.AvatarExperience.AvatarEditor.Categories.subcategory
	end
end

local function useSlotProps(t3: {[any]: any}) -- line: 169
	-- upvalues: useSlotBasedEditorContext (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), Analytics2 (copy), useTokens (copy), RoactLocalization (copy), useNavigation (copy), useAvatarRoute (copy), React (copy), useSelector (copy), DeviceOrientationMode (copy), FFlagAXCustomizeMakeupSupport (copy), u56 (ref), u57 (ref), useSlotItemCardBreakpoints (copy), FFlagAXFixCheckOnEquippedAssets (copy), FFlagAXImproveSlotBasedEditorPerformance (copy), Cryo (copy), FFlagAXMigrateSlotsSignals (copy), SignalsReact (copy), buildSlots (copy), Constants (copy), useLocalization (copy), buildStringsToLocalize (copy), shallowEqual (copy), GetAvatarEditorCategories (copy), v52 (copy), getCategoryIndices (copy), SetCategoryAndSubcategory (copy), FFlagAXEditorSubcategoryFilters (copy), FFlagAXSlotsDesktopRedesign (copy), NormalizeAvatar (copy), Categories (copy), FFlagAXSlotsDesktopCrashFix (copy), FFlagAXSlotsDisableScrollAwayOnLandscape (copy), FFlagAXSlotBasedEditorCategoryTooltip (copy), FFlagAXFixLookLinkToCustomize (copy), FFlagAXEnableClearAllConfirmationPrompt (copy), getAssetTypesByCategory (copy), BatchUnequipByAssetType (copy), AvatarScreen (copy), ClearAllButton (copy), AvatarEditorSubcategories (copy), LookViewport (copy), buildBodySlotViewportProps (copy), Constants2 (copy), SlotCircularGradientFrame (copy), SlotItemCardThumbnail (copy), SlotType (copy), NavigationParams (copy), ItemView (copy)
	local v81 = useSlotBasedEditorContext()
	local v82 = useDispatch()
	local v83 = useRoactService(Analytics)
	local v84 = useRoactService(Analytics2)
	local v85 = useTokens()
	local v86 = useRoactService(RoactLocalization)
	local v87 = useNavigation()
	local v88 = useAvatarRoute()
	local v89 = React.useRef(nil)
	local v90 = useSelector(function(p5) -- line: 179
		-- upvalues: DeviceOrientationMode (copy)
		return p5.DeviceOrientation == DeviceOrientationMode.Portrait
	end)
	local u91 = nil
	local u92 = nil

	if FFlagAXCustomizeMakeupSupport then
		u91 = useSelector(u56)
		u92 = useSelector(u57)
	end

	local v93 = useSlotItemCardBreakpoints(v89.current and v89.current.AbsoluteSize)
	local v94 = useSelector(function(p6) -- line: 193
		-- upvalues: FFlagAXFixCheckOnEquippedAssets (copy)
		if FFlagAXFixCheckOnEquippedAssets then
			return p6.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
		end

		return p6.AvatarExperience.AvatarEditor.Character.EquippedAssets
	end)
	local u96

	if FFlagAXImproveSlotBasedEditorPerformance then
		local v95 = useSelector(function(p7) -- line: 203
			return p7.AvatarExperience.AvatarEditor.Character.BodyColor3s
		end)

		u96 = React.useMemo(function() -- line: 206
			-- upvalues: Cryo (copy), v95 (copy)
			return Cryo.Dictionary.values(v95)
		end, { v95 })
	else
		u96 = useSelector(function(p8) -- line: 210
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.values(p8.AvatarExperience.AvatarEditor.Character.BodyColor3s)
		end)
	end

	assert(v81 ~= nil, "useSlotProps must be used within a SlotBasedEditorContextProvider")

	local v97 = if not FFlagAXMigrateSlotsSignals then v81.slotCategory else SignalsReact.useSignalState(v81.signalStore.getSlotCategory)
	local v98 = if not FFlagAXMigrateSlotsSignals then v81.setSlotCategory else v81.signalStore.setSlotCategory
	local v99 = if not FFlagAXMigrateSlotsSignals then v81.slotIndex else SignalsReact.useSignalState(v81.signalStore.getSlotIndex)
	local v100 = if not FFlagAXMigrateSlotsSignals then v81.setSlotIndex else v81.signalStore.setSlotIndex
	local u101 = if not FFlagAXMigrateSlotsSignals then if not FFlagAXImproveSlotBasedEditorPerformance then buildSlots(Constants.SlotEditorCategories[v97].slots, v94) else React.useMemo(function() -- line: 238
		-- upvalues: buildSlots (copy), Constants (copy), v97 (copy), v94 (copy)
		return buildSlots(Constants.SlotEditorCategories[v97].slots, v94)
	end, {
		v97,
		v94
	}) else SignalsReact.useSignalState(v81.signalStore.getSlots)
	local nameTranslationKey = Constants.SlotEditorCategories[v97].nameTranslationKey
	local u105

	if FFlagAXImproveSlotBasedEditorPerformance then
		local v103 = useLocalization((buildStringsToLocalize(u101, nameTranslationKey)))
		local v104 = React.useRef(nil)

		u105 = React.useMemo(function() -- line: 256
			-- upvalues: v104 (copy), shallowEqual (copy), v103 (copy)
			if v104.current and shallowEqual(v103, v104.current) then
				return v104.current
			end

			v104.current = v103

			return v103
		end, { v103 })
	else
		u105 = useLocalization((buildStringsToLocalize(u101, nameTranslationKey)))
	end

	local v106 = if not FFlagAXCustomizeMakeupSupport then nil else GetAvatarEditorCategories()
	local v107 = if FFlagAXCustomizeMakeupSupport then React.useCallback(function(p9) -- line: 273
		-- upvalues: v52 (copy), v106 (copy), u91 (ref), u92 (ref), getCategoryIndices (copy), v82 (copy), SetCategoryAndSubcategory (copy), v83 (copy), FFlagAXEditorSubcategoryFilters (copy)
		local v125 = nil
		local v126 = nil
		local v127 = nil

		if p9.eligibleSubcategories ~= nil and (not v52 or v106[u91].Subcategories ~= nil) then
			if p9.currentAssetType == nil then
				if table.find(p9.eligibleSubcategories, v106[u91].Subcategories[u92].NavigationKey) then
					v125 = u91
					v126 = u92
					v127 = nil
				end
			else
				for v128, v129 in v106[u91].Subcategories do
					if table.find(p9.eligibleSubcategories, v129.NavigationKey) and v129.AssetTypeIdStrings ~= nil and table.find(v129.AssetTypeIdStrings, (tostring(p9.currentAssetType.Value))) then
						v125 = u91
						v126 = v128
						v127 = nil

						break
					end
				end
			end
		end

		if v125 == nil then
			v125, v126, v127 = getCategoryIndices(p9.editorSubcategory)
		end

		if v125 and v126 then
			v82(SetCategoryAndSubcategory(v125, v126, v83, if not FFlagAXEditorSubcategoryFilters then nil else v127))
		end
	end, {
		u91,
		u92,
		v82,
		v83
	}) else nil
	local v108 = React.useCallback(function(p10, p11) -- line: 331
		-- upvalues: v98 (copy), v100 (copy), FFlagAXSlotsDesktopRedesign (copy), v90 (copy), FFlagAXCustomizeMakeupSupport (copy), v82 (copy), SetCategoryAndSubcategory (copy), v83 (copy), NormalizeAvatar (copy)
		v98(p10)
		v100(1)

		if FFlagAXSlotsDesktopRedesign or (v90 or FFlagAXCustomizeMakeupSupport) then
			v82(SetCategoryAndSubcategory(p11.index + 1, 1, v83))
		end

		if FFlagAXCustomizeMakeupSupport then
			v82(NormalizeAvatar())
		end
	end, {
		v98,
		v100,
		v82,
		if not FFlagAXImproveSlotBasedEditorPerformance or FFlagAXSlotsDesktopRedesign then nil else v90,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v83
	})
	local v109 = React.useMemo(function() -- line: 352
		-- upvalues: v93 (copy), Constants (copy), v108 (copy), v97 (copy), FFlagAXSlotsDesktopRedesign (copy), Categories (copy), v90 (copy), FFlagAXSlotsDesktopCrashFix (copy)
		local t4 = {
			enableSnapToSelectedItem = true,
			LayoutOrder = 2,
			navHeight = v93.navHeight,
			categories = table.clone(Constants.SlotEditorCategories),
			onSlotCategorySelected = v108,
			slotCategory = v97
		}

		if FFlagAXSlotsDesktopRedesign then
			t4.categories[Categories.All].hide = v90
		end

		if FFlagAXSlotsDesktopCrashFix then
			t4.categories[Categories.Avatars].hide = not (FFlagAXSlotsDesktopRedesign or v90)
			t4.categories[Categories.Emotes].hide = not (FFlagAXSlotsDesktopRedesign or v90)

			return t4
		end

		if not FFlagAXSlotsDesktopRedesign and not v90 then
			t4.categories[Categories.Avatars] = nil
			t4.categories[Categories.Emotes] = nil
		end

		return t4
	end, {
		v90,
		v97,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v93,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v108
	})
	local v110 = if not FFlagAXSlotsDisableScrollAwayOnLandscape then nil else not v90 or Constants.SlotEditorCategories[v97].disableScrollAway
	local u111 = nil

	if FFlagAXSlotBasedEditorCategoryTooltip then
		local v112 = useSelector(function(p12) -- line: 393
			return p12.AvatarExperience.Common.FullView.AvatarEditor
		end)

		u111 = React.useMemo(function() -- line: 398
			-- upvalues: v112 (copy), t3 (copy), FFlagAXSlotsDisableScrollAwayOnLandscape (copy), v110 (copy)
			local v134 = tostring(v112) ~= "FullView.SceneFullView"
			local v135 = t3.slotSubNavigationFill == 1 or (t3.slotSubNavigationFill == nil or FFlagAXSlotsDisableScrollAwayOnLandscape and v110)

			return v134 and v135
		end, {
			v112,
			t3.slotSubNavigationFill,
			if not FFlagAXSlotsDisableScrollAwayOnLandscape then nil else v110
		})
	end

	if FFlagAXCustomizeMakeupSupport then
		React.useEffect(function() -- line: 415
			-- upvalues: FFlagAXFixLookLinkToCustomize (copy), v98 (copy), v106 (copy), u91 (ref), v99 (copy), u101 (ref), u92 (ref), v100 (copy)
			if FFlagAXFixLookLinkToCustomize then
				v98(v106[u91].NavigationKey)
			end

			if v106[u91].Subcategories ~= nil then
				if not FFlagAXFixLookLinkToCustomize then
					v98(v106[u91].NavigationKey)
				end

				if v99 ~= nil and u101[v99] ~= nil and u101[v99].eligibleSubcategories ~= nil and table.find(u101[v99].eligibleSubcategories, v106[u91].Subcategories[u92].NavigationKey) then
					return
				end

				for v136, v137 in u101 do
					if if v137.eligibleSubcategories == nil then v137.editorSubcategory == v106[u91].Subcategories[u92].NavigationKey else table.find(v137.eligibleSubcategories, v106[u91].Subcategories[u92].NavigationKey) then
						v100(v136)

						return
					end
				end
			end
		end, {
			u91,
			u92,
			v100,
			v98,
			v106,
			u101,
			if not FFlagAXFixLookLinkToCustomize then nil else v99
		})
	end

	local v113 = React.useMemo(function() -- line: 466
		-- upvalues: v97 (copy), v99 (copy), Constants (copy), v93 (copy), FFlagAXSlotBasedEditorCategoryTooltip (copy), u111 (ref), Categories (copy), FFlagAXEnableClearAllConfirmationPrompt (copy), getAssetTypesByCategory (copy), u101 (ref), v82 (copy), BatchUnequipByAssetType (copy), FFlagAXCustomizeMakeupSupport (copy), v100 (copy), v107 (copy), v87 (copy), AvatarScreen (copy), React (copy), ClearAllButton (copy), v86 (copy), AvatarEditorSubcategories (copy), LookViewport (copy), buildBodySlotViewportProps (copy), Constants2 (copy), v94 (copy), SlotCircularGradientFrame (copy), u96 (ref), SlotItemCardThumbnail (copy), SlotType (copy), u105 (ref), FFlagAXMigrateSlotsSignals (copy), v81 (copy), v84 (copy), NormalizeAvatar (copy), v88 (copy), NavigationParams (copy), ItemView (copy), getCategoryIndices (copy), SetCategoryAndSubcategory (copy), v83 (copy), FFlagAXEditorSubcategoryFilters (copy)
		local t5 = {
			enableIntroScroll = true,
			slotCategory = v97,
			slotIndex = v99,
			index = Constants.SlotEditorCategories[v97].index,
			slots = {},
			buttonPadding = v93.scrollingFramePadding.buttonPadding,
			contentPadding = v93.scrollingFramePadding.contentPadding,
			enableSnapToSelectedItem = v93.enableSnapToSelectedSlot,
			AutomaticSize = Enum.AutomaticSize.Y,
			slotSubNavigationFrameHeight = v93.slotCardTotalHeight,
			canShowTooltip = if not FFlagAXSlotBasedEditorCategoryTooltip then nil else u111
		}

		if v97 ~= Categories.Body then
			t5.clearAllButton = {
				onActivated = function() -- line: 484
					-- upvalues: FFlagAXEnableClearAllConfirmationPrompt (copy), getAssetTypesByCategory (copy), v97 (copy), u101 (ref), v82 (copy), BatchUnequipByAssetType (copy), FFlagAXCustomizeMakeupSupport (copy), Constants (copy), v100 (copy), v107 (copy), v87 (copy), AvatarScreen (copy)
					if FFlagAXEnableClearAllConfirmationPrompt then
						v87.navigate(AvatarScreen.SlotEditorClearAllConfirmationPrompt, {
							slotCategory = v97,
							clearAll = function() -- line: 486
								-- upvalues: getAssetTypesByCategory (copy), v97 (copy), u101 (ref), v82 (copy), BatchUnequipByAssetType (copy), FFlagAXCustomizeMakeupSupport (copy), Constants (copy), v100 (copy), v107 (copy)
								local v149 = getAssetTypesByCategory(v97, u101)

								if #v149 > 0 then
									v82(BatchUnequipByAssetType(v149))
								end

								if FFlagAXCustomizeMakeupSupport and Constants.SlotEditorCategories[v97].resetSlotOnClearAll then
									v100(1)
									v107(u101[1])
								end
							end
						})

						return
					end

					local v141 = getAssetTypesByCategory(v97, u101)

					if #v141 > 0 then
						v82(BatchUnequipByAssetType(v141))
					end
				end,
				renderHeaderSlot = function() -- line: 512
					-- upvalues: React (copy), ClearAllButton (copy)
					return React.createElement(ClearAllButton)
				end,
				Size = v93.itemCardSize,
				text = v86:Format("Feature.Avatar.Action.Clear")
			}
		end

		for v139, v140 in u101 do
			table.insert(t5.slots, {
				renderHeaderSlot = function() -- line: 522
					-- upvalues: v140 (copy), AvatarEditorSubcategories (copy), React (copy), LookViewport (copy), buildBodySlotViewportProps (copy), Constants2 (copy), v94 (copy), SlotCircularGradientFrame (copy), u96 (ref), SlotItemCardThumbnail (copy), v93 (copy)
					if v140.editorSubcategory == AvatarEditorSubcategories.PurchasedCharacters then
						return React.createElement(LookViewport, buildBodySlotViewportProps(Constants2.DefaultBodyColor3, v94))
					end

					if v140.editorSubcategory == AvatarEditorSubcategories.Skin then
						return React.createElement(SlotCircularGradientFrame, {
							Colors = u96
						})
					end

					if v140.editorSubcategory == AvatarEditorSubcategories.Build then
						return React.createElement(SlotItemCardThumbnail, {
							ignoredUrl = true,
							icon = v140.icon,
							iconFrameStyles = v93.slotItemCardThumbnailStyles.iconFrameStyles
						})
					end

					local v142 = false

					if table.find(v140.assetTypes, Enum.AvatarAssetType.Face) then
						local v143 = v94[tostring(Enum.AvatarAssetType.DynamicHead.Value)]

						if v143 ~= nil and next(v143) then
							v142 = true
						end
					end

					return React.createElement(SlotItemCardThumbnail, {
						url = v140.thumbnailUrl,
						icon = v140.icon,
						enableThumbnailOverlay = v142,
						iconFrameStyles = v93.slotItemCardThumbnailStyles.iconFrameStyles
					})
				end,
				BackgroundTransparency = not v140.thumbnailUrl and (v140.editorSubcategory ~= AvatarEditorSubcategories.Skin and (v140.editorSubcategory ~= AvatarEditorSubcategories.Build and v140.editorSubcategory ~= AvatarEditorSubcategories.PurchasedCharacters)) and 1 or nil,
				title = if not FFlagAXCustomizeMakeupSupport or v140.slotType ~= SlotType.LayeredSlot then u105[v140.nameTranslationKey] else u105[v140.nameTranslationKey .. "_" .. v140.layerIndex + 1],
				Size = v93.itemCardSize,
				isActive = v139 == if not FFlagAXMigrateSlotsSignals then v81.slotIndex else v99,
				editorSubcategory = v140.editorSubcategory,
				slotType = if not FFlagAXCustomizeMakeupSupport then nil else v140.slotType or SlotType.BaseSlot,
				onActivated = function() -- line: 576
					-- upvalues: v84 (copy), v140 (copy), FFlagAXCustomizeMakeupSupport (copy), v139 (copy), v99 (copy), v100 (copy), v107 (copy), u101 (ref), v82 (copy), NormalizeAvatar (copy), v88 (copy), AvatarScreen (copy), v87 (copy), NavigationParams (copy), ItemView (copy), getCategoryIndices (copy), SetCategoryAndSubcategory (copy), v83 (copy), FFlagAXEditorSubcategoryFilters (copy)
					v84.slotClick(v140)

					local v144 = nil
					local v145 = nil
					local v146 = nil

					if FFlagAXCustomizeMakeupSupport then
						if v140.deselectable and v139 == v99 then
							v100(1)
							v107(u101[1])
							v82(NormalizeAvatar())

							return
						end

						v107(v140)

						local v147 = v88.current.name == AvatarScreen.LookDetails

						v87.navigate(AvatarScreen.AvatarEditor, {
							[NavigationParams.itemView] = ItemView.SlotItems
						})

						if v147 then
							v87.navigate(AvatarScreen.LookDetails)
						end

						if not u101[v139].deselectable or v139 ~= v99 then
							v100(v139)

							return
						end
					else
						if v144 == nil then
							v144, v145, v146 = getCategoryIndices(v140.editorSubcategory)
						end

						if v144 and v145 then
							v82(SetCategoryAndSubcategory(v144, v145, v83, if not FFlagAXEditorSubcategoryFilters then nil else v146))

							local v148 = v88.current.name == AvatarScreen.LookDetails

							v87.navigate(AvatarScreen.AvatarEditor, {
								[NavigationParams.itemView] = ItemView.SlotItems
							})

							if v148 then
								v87.navigate(AvatarScreen.LookDetails)
							end

							if not u101[v139].deselectable or v139 ~= v99 then
								v100(v139)
							end
						end
					end
				end,
				hide = if not FFlagAXCustomizeMakeupSupport then nil else v140.hide
			})
		end

		return t5
	end, {
		v99,
		v97,
		v85,
		u105,
		v82,
		v84,
		v83,
		v87,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else u101,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v93,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v94,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else u96,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v81,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v88,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v100,
		if not FFlagAXImproveSlotBasedEditorPerformance then nil else v86,
		if not FFlagAXSlotBasedEditorCategoryTooltip then nil else u111,
		if not FFlagAXCustomizeMakeupSupport then nil else v106
	})
	local navHeight = v93.navHeight

	if #v113.slots > 0 then
		navHeight += v93.slotCardTotalHeight
	end

	local v115 = v106 and v106[u91]
	local v116 = v115 and (v115.Subcategories and v115.Subcategories[u92])
	local v117 = v115 and v115.hideFilter
	local v118 = v116 and v116.hideFilter
	local v119 = v117 or v118

	return {
		slotNavigationProps = v109,
		slotSubNavigationProps = v113,
		ref = v89,
		navigationFrameHeight = navHeight,
		slotSubNavigationFill = not FFlagAXSlotsDisableScrollAwayOnLandscape and 1 or (t3.slotSubNavigationFill or 1),
		slotCardTotalHeight = v93.slotCardTotalHeight,
		navHeight = v93.navHeight,
		disableScrollAway = if not FFlagAXSlotsDisableScrollAwayOnLandscape then nil else v110,
		absoluteSizeChanged = if not FFlagAXSlotsDisableScrollAwayOnLandscape then nil else t3.absoluteSizeChanged,
		hideFilter = v119
	}
end

return useSlotProps
