local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useTokens = Foundation.Hooks.useTokens
local EquipSlots = require(Modules.AvatarExperience.AvatarEditor.Components.EquipSlots)
local ItemsList = require(Modules.AvatarExperience.AvatarEditor.Components.ItemsList)
local SetSelectedEmoteSlot = require(Modules.AvatarExperience.AvatarEditor.Actions.SetSelectedEmoteSlot)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXTTIEditorEnableMilestones = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXTTIEditorEnableMilestones
local EditorInventoryTTIMilestoneManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).EditorInventoryTTIMilestoneManager

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local function selectAvatarType(p1) -- line: 45
	return p1.AvatarExperience.AvatarEditor.Character.AvatarType
end
local function makeSelectOwnedEmoteIds(s1: string) -- line: 49
	return function(p2) -- line: 50
		-- upvalues: s1 (copy)
		return p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[s1] or {}
	end
end
local function makeSelectFetchStatus(s2: string) -- line: 56
	-- upvalues: FFlagAXTTIEditorEnableMilestones (copy), RetrievalStatus (copy), PerformFetch (copy)
	return function(p3) -- line: 57
		-- upvalues: FFlagAXTTIEditorEnableMilestones (copy), s2 (copy), RetrievalStatus (copy), PerformFetch (copy)
		if FFlagAXTTIEditorEnableMilestones and #s2 == 0 then
			return RetrievalStatus.NotStarted
		end

		return PerformFetch.GetStatus(p3, s2)
	end
end
local function EmotesPage(t1: {[any]: any}, p4) -- line: 65
	-- upvalues: React (copy), Responsive (copy), useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), useSelector (copy), selectAvatarType (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useTokens (copy), FFlagAXTTIEditorEnableMilestones (copy), RetrievalStatus (copy), PerformFetch (copy), EditorInventoryTTIMilestoneManager (copy), AvatarScreen (copy), logOnOverlayClosed (copy), Constants (copy), SetSelectedEmoteSlot (copy), Focusable (copy), EquipSlots (copy), ItemsList (copy)
	local v34 = React.useRef(nil)
	local v35 = React.useRef(nil)
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState(false)
	local v40 = Responsive.usePreferredInput()
	local v41 = useDispatch()
	local v42 = useNavigation()
	local v43 = useAvatarRoute()
	local v44 = useSelector(selectAvatarType)
	local v45 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
	local v46 = useTokens()

	if FFlagAXTTIEditorEnableMilestones then
		local v47 = t1.categoryInfo.SearchUuid or ""
		local v48 = React.useMemo(function() -- line: 87
			-- upvalues: v47 (copy)
			local v61 = v47

			return function(p5) -- line: 50
				-- upvalues: v61 (copy)
				return p5.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v61] or {}
			end
		end, { v47 })
		local v49 = React.useMemo(function() -- line: 90
			-- upvalues: v47 (copy), FFlagAXTTIEditorEnableMilestones (copy), RetrievalStatus (copy), PerformFetch (copy)
			local v62 = v47

			return function(p6) -- line: 57
				-- upvalues: FFlagAXTTIEditorEnableMilestones (copy), v62 (copy), RetrievalStatus (copy), PerformFetch (copy)
				if FFlagAXTTIEditorEnableMilestones and #v62 == 0 then
					return RetrievalStatus.NotStarted
				end

				return PerformFetch.GetStatus(p6, v62)
			end
		end, { v47 })
		local v50 = useSelector(v48)
		local v51 = useSelector(v49)
		local v52 = React.useRef(false)
		local v53 = React.useRef(false)

		React.useEffect(function() -- line: 97
			-- upvalues: v51 (copy), RetrievalStatus (copy), v52 (copy), EditorInventoryTTIMilestoneManager (copy), v53 (copy), v50 (copy)
			if v51 == RetrievalStatus.Fetching then
				v52.current = true
			end

			if EditorInventoryTTIMilestoneManager and v52.current and not v53.current and v51 == RetrievalStatus.Done and v50 ~= nil and #v50 > 0 then
				v53.current = true
				EditorInventoryTTIMilestoneManager.endTilesTracking()
			end
		end, {
			v51,
			v50
		})
	end

	local v54 = v40 == Responsive.Input.Directional
	local v55 = v54 and v43.current.name == AvatarScreen.ItemDetails
	local v56 = React.useCallback(function(p7) -- line: 118
		-- upvalues: v37 (copy)
		v37(p7)
	end, {})
	local v57 = React.useCallback(function(p8) -- line: 122
		-- upvalues: v39 (copy)
		v39(p8)
	end, {})
	local v58 = React.useCallback(function(p9) -- line: 126
		-- upvalues: logOnOverlayClosed (copy), v54 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v45 (copy), v44 (copy), Constants (copy), v42 (copy), AvatarScreen (copy), v41 (copy), SetSelectedEmoteSlot (copy)
		if v44 == Constants.AvatarType.R6 then
			v42.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Message.R15EmotesPrompt",
				onOverlayClosed = function() -- line: 127
					-- upvalues: logOnOverlayClosed (copy), v54 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v45 (copy)
					logOnOverlayClosed("EmotesPage", v54)

					if not FFlagAXMigrateAXToGlobalAutofocus and v54 then
						v45.captureFocus()
					end
				end
			})
		end

		v41(SetSelectedEmoteSlot(p9))
	end, {
		v44,
		v42,
		v41,
		if not FFlagAXMigrateAXToGlobalAutofocus then v45 else nil,
		v54
	})

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		defaultChild = v34,
		restorePreviousChildFocus = t1.restorePreviousChildFocus,
		ref = p4
	}, {
		ListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		EquipSlots = React.createElement(EquipSlots, {
			LayoutOrder = 1,
			slotsCount = t1.categoryInfo.EquipSlotsCount,
			lockNavigationCallback = t1.lockNavigationCallback,
			unlockNavigationCallback = t1.unlockNavigationCallback,
			onActivated = v58,
			NextSelectionUp = t1.NextSelectionUp,
			itemsListRef = v35,
			ref = v34,
			onFocusChanged = v56,
			itemsListFocused = v38,
			darkenItemsGrid = v55
		}),
		Tiles = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, -72)
		}, {
			GamepadDarkOverlay = v36 and React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = v46.Color.Extended.Black.Black_50.Transparency,
				BackgroundColor3 = v46.Color.Extended.Black.Black_50.Color3
			}),
			ItemsList = React.createElement(ItemsList, {
				buttonBInputRef = v34,
				ref = v35,
				onFocusChanged = v57,
				darkenItemsGrid = v55,
				tagBasedImpressionsDetectorExtensions = {},
				NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then nil else v34
			})
		})
	})
end

return React.memo(React.forwardRef(EmotesPage))
