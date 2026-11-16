local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module3 = require("@luauforge/bundled/dxy")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useTokens = Foundation.Hooks.useTokens

local module4 = require("@luauforge/deferred/gQt")
local module5 = require("@luauforge/deferred/gnq")
local module6 = require("@luauforge/deferred/gQu")
local module7 = require("@luauforge/bundled/dOR")
local module8 = require("@luauforge/bundled/dMx")
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2
local fFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore
local fFlagAXAvatarEditorStoresContext = AvatarExperienceFlags.FFlagAXAvatarEditorStoresContext

local editorInventoryTTIMilestoneManager = require("@luauforge/bundled/ggZ").EditorInventoryTTIMilestoneManager
local module10 = require("@luauforge/bundled/fuM")
local module11 = require("@luauforge/bundled/dMd")
local useSlotBasedEditorContext = module10.Context.useSlotBasedEditorContext
local useAvatarEditorStores = module10.Context.useAvatarEditorStores
local avatarEditorCategories = module11.Enums.AvatarEditorCategories

local module12 = require("@luauforge/deferred/gOS")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local function selectAvatarType(p2)
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local function makeSelectOwnedEmoteIds(p2)
	return function(p3)
		return p3.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[p2] or {}
	end
end

local function makeSelectFetchStatus(list)
	return function(p2)
		if fFlagAXTTIEditorEnableMilestones and #list == 0 then
			return module3.NotStarted
		end

		return performFetch.GetStatus(p2, list)
	end
end

local function EmotesPage(props, p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v5 = Responsive.usePreferredInput()

	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = useAvatarRoute()
	local v9 = useSelector(selectAvatarType)
	local v10 = useTokens()

	local v11 = nil

	if fFlagAXAvatarEditorStoresContext and fFlagAXEditorEnableThumbnailLatencyStore then
		local thumbnailLatencyStores = useAvatarEditorStores().thumbnailLatencyStores

		if thumbnailLatencyStores then
			v11 = thumbnailLatencyStores[avatarEditorCategories.Emotes]
		end
	elseif fFlagAXEditorEnableThumbnailLatencyStore and not fFlagAXAvatarEditorStoresContext then
		local v12 = useSlotBasedEditorContext()

		if v12 then
			local thumbnailLatencyStores = v12.thumbnailLatencyStores

			if thumbnailLatencyStores then
				v11 = thumbnailLatencyStores[avatarEditorCategories.Emotes]
			end
		end
	end

	if fFlagAXEditorEnableThumbnailLatencyStore then
		module12(v11)
	end

	if fFlagAXTTIEditorEnableMilestones then
		local searchUuid = props.categoryInfo.SearchUuid or ""
		local v12 = React.useMemo(function()
			local v13 = searchUuid
			return function(p3)
				return p3.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v13] or {}
			end
		end, { searchUuid })
		local v13 = React.useMemo(function()
			local v14 = searchUuid
			return function(p3)
				if fFlagAXTTIEditorEnableMilestones and #v14 == 0 then
					return module3.NotStarted
				end

				return performFetch.GetStatus(p3, v14)
			end
		end, { searchUuid })
		local v14 = useSelector(v12)
		local v15 = useSelector(v13)
		local ref3 = React.useRef(false)

		React.useEffect(function()
			if editorInventoryTTIMilestoneManager then
				editorInventoryTTIMilestoneManager.ensureSessionActive({
					category = avatarEditorCategories.Emotes,
					page = v8.current.name,
					opaquePage = v8.opaque.name
				})
			end

			if fFlagAXEditorEnableThumbnailLatencyStore and v11 then
				v11.startTracking()
			end
		end, {})

		React.useEffect(function()
			if
				editorInventoryTTIMilestoneManager
				and not ref3.current
				and v15 == module3.Done
				and v14 ~= nil
				and #v14 > 0
			then
				ref3.current = true

				editorInventoryTTIMilestoneManager.L2.functionallyReady()
				editorInventoryTTIMilestoneManager.endTilesTracking()
			end
		end, { v15, v14 })
	end

	local v12

	if fFlagAXEditorEnableThumbnailLatencyStore then
		local ref3 = React.useRef({})
		v12 = React.useCallback(function(p3)
			if v11 == nil then
				return nil
			end

			local current = ref3.current
			local v13 = current[p3]

			if v13 then
				return v13
			end

			local v14 = v11
			local function fn(p4)
				v14.setThumbnailLoaded(p3)
			end
			current[p3] = fn
			return fn
		end, { v11 })
	end

	local v13 = v5 == Responsive.Input.Directional
	local v14 = v13 and v8.current.name == avatarScreen.ItemDetails

	local v15 = React.useCallback(function(p3)
		setState(p3)
	end, {})

	local v16 = React.useCallback(function(p3)
		setState2(p3)
	end, {})

	local v17 = React.useCallback(function(p3)
		local function onOverlayClosed()
			logOnOverlayClosed("EmotesPage", v13)
		end

		if v9 == module8.AvatarType.R6 then
			v7.navigate(avatarScreen.R15UpgradePrompt, {
				onOverlayClosed = onOverlayClosed,
				bodyTextKey = "Feature.Avatar.Message.R15EmotesPrompt"
			})
		end

		v6(module7(p3))
	end, { v9, v7, v6, v13 })

	local createElement = React.createElement
	local frame = focusable.Frame
	local v18 = {
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundTransparency = 1,
		defaultChild = ref,
		restorePreviousChildFocus = props.restorePreviousChildFocus,
		ref = p2
	}

	local v19 = {
		ListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		EquipSlots = React.createElement(module4, {
			slotsCount = props.categoryInfo.EquipSlotsCount,
			lockNavigationCallback = props.lockNavigationCallback,
			unlockNavigationCallback = props.unlockNavigationCallback,
			onActivated = v17,
			LayoutOrder = 1,
			NextSelectionUp = props.NextSelectionUp,
			itemsListRef = ref2,
			ref = ref,
			onFocusChanged = v15,
			itemsListFocused = state2,
			darkenItemsGrid = v14
		}),
		Tiles = 0
	}

	local createElement2 = React.createElement
	local v21 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -72),
		LayoutOrder = 2
	}

	local v22 = {
		GamepadDarkOverlay = state and React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = v10.Color.Extended.Black.Black_50.Transparency,
			BackgroundColor3 = v10.Color.Extended.Black.Black_50.Color3
		}),
		ItemsList = 0
	}

	local createElement3 = React.createElement

	local v25 = if fFlagAXScrollTelemetryIntegration2 then module5.EditorEmotes else nil

	if not fFlagAXEditorEnableThumbnailLatencyStore then
		v12 = nil
	end

	v22.ItemsList = createElement3(module6, {
		buttonBInputRef = ref,
		ref = ref2,
		scrollPerformanceIntervalName = v25,
		onFocusChanged = v16,
		darkenItemsGrid = v14,
		tagBasedImpressionsDetectorExtensions = {},
		NextSelectionUp = ref,
		getOnThumbnailLoadedForItem = v12
	})
	v19.Tiles = createElement2("Frame", v21, v22)
	return createElement(frame, v18, v19)
end

return React.memo(React.forwardRef(EmotesPage))
