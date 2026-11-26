local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local React = require(CorePackages.Packages.React)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local useNavigation = Navigation.useNavigation
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local appSessionService = RoactServiceTags.AppSessionService
local appEventIngestService = RoactServiceTags.AppEventIngestService
local roactNetworking = RoactServiceTags.RoactNetworking
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local getTestId = RoactUtils.getTestId
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local sessionType = require("@luauforge/bundled/fwa").SessionType
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/Responsive").useDeviceInsets
local shouldUseDeviceSafeInsets = require("@luauforge/bundled/dXA").shouldUseDeviceSafeInsets
local useCurrentSquadId = require("@luauforge/deferred/hYG").useCurrentSquadId

local module4 = require("@luauforge/bundled/cBc")
local module5 = require("@luauforge/bundled/egz")
local searchLandingPageSurface = module4.SearchLandingPageSurface
local modules = require("@luauforge/bundled/dtb").Modules
local searchConstants = modules.Personalization.Search.SearchConstants
local searchLandingPageSession = modules.Personalization.Sessions.SearchLandingPageSession
local apiFetchSearchLandingPage = modules.LuaApp.Thunks.Search.ApiFetchSearchLandingPage

local module6 = require("@luauforge/bundled/dzD")
local module7 = require("@luauforge/bundled/fvZ")
local module8 = require("@luauforge/bundled/fvU")
local module9 = require("@luauforge/bundled/fwU")
local module10 = require("@luauforge/bundled/fwY")
local module11 = require("@luauforge/deferred/hYH")
local module12 = require("@luauforge/deferred/hYI")
local fIntSearchLandingPageSideMargin = modules.Personalization.Search.FIntSearchLandingPageSideMargin

local defineFastFlag = game:DefineFastFlag("SearchOverlayIgnoreTopGuiInset", false)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local fFlagUseSignalsForAppTopBanner = SharedFlags.FFlagUseSignalsForAppTopBanner
local fFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
local fFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete
local sduiSearchAutocomplete

if fFlagLuaAppSduiSearchAutocomplete then
	sduiSearchAutocomplete = require("@luauforge/bundled/fwb").SduiSearchAutocomplete
else
	sduiSearchAutocomplete = nil
end

local prewarmSearchAutocompleteTemplates

if fFlagLuaAppSduiSearchAutocomplete then
	prewarmSearchAutocompleteTemplates = require("@luauforge/bundled/fwb").prewarmSearchAutocompleteTemplates
else
	prewarmSearchAutocompleteTemplates = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local getAppTopBannerStore

if fFlagUseSignalsForAppTopBanner then
	getAppTopBannerStore = require("@luauforge/bundled/dzW").GetAppTopBannerStore
else
	getAppTopBannerStore = nil
end

local NAV_BAR_SIZE = module6.NAV_BAR_SIZE

function LUAUFORGE_MODULE_GLOBALS_hYF_SearchPageOverlay(props)
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = useStyle()
	local v8 = useDesignTokens()
	local v9 = useCurrentSquadId()
	local v10 = useRoactService(appEventIngestService)
	local v11 = useRoactService(appSessionService)
	local v12 = useRoactService(roactNetworking)

	if fFlagLuaAppSduiSearchAutocomplete then
		React.useEffect(function()
			prewarmSearchAutocompleteTemplates():catch(function() end)
		end, {})
	end

	local v13

	if fFlagSignalsNavP3fGameDetails then
		v13 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
	else
		v13 = useSelector(function(p2)
			if fFlagUseNavigationSelectors then
				return selectors.selectCurrentRoactNavigationRoute(p2).key
			end

			return p2.Navigation.currentRoute.key
		end)
	end

	local v14 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v15 = useSelector(function(p2): boolean
		return p2.FormFactor == formFactor.COMPACT
	end)
	local v16

	if defineFastFlag then
		if fFlagUseSignalsForAppTopBanner then
			v16 = useSignalState(getAppTopBannerStore(false).getIsVisible) == true
		else
			v16 = useSelector(function(p2): boolean
				return (p2.AppTopBanner.expanded and not p2.AppTopBanner.isDisabled) == true
			end)
		end
	else
		v16 = false
	end

	local v17 = not defineFastFlag and 0 or useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end)

	local v18 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)

	local v19 = useSelector(function(p2)
		return p2.GlobalGuiInset or { left = 0, top = 0, right = 0, bottom = 0 }
	end)

	local searchTokens = searchConstants.getSearchTokens(v8)
	local searchMargin = searchTokens.searchMargin
	local shadowBoldness = searchTokens.backgroundContainer.shadowBoldness
	local shadowTopOffset = searchTokens.backgroundContainer.shadowTopOffset
	local shadowBottomOffset = searchTokens.backgroundContainer.shadowBottomOffset
	local v20 = shadowBoldness * 2 + searchMargin * 2
	local v21 = not (defineFastFlag and v16) and 0 or v17
	local v22 = if defineFastFlag and v16 then v18 - v17 else v18
	local udim

	if v15 then
		udim = UDim2.new(0, 0, 0, not defineFastFlag and 0 or v21)
	else
		udim = UDim2.new(0.5, 0, 0, not defineFastFlag and 0 or v21)
	end

	local vector2 = if v15 then Vector2.new(0, 0) else Vector2.new(0.5, 0)
	local udim2 = if v15 then UDim.new(0, searchMargin) else UDim.new(0, 0)
	local v23

	if fFlagFixOverlayTopInsetForDeviceSafeInsets then
		local v24 = useDeviceInsets()
		v23 = not shouldUseDeviceSafeInsets and 0 or v24.top
	else
		v23 = 0
	end

	local v24 = if defineFastFlag then v22 else v19.top + v18

	if fFlagFixOverlayTopInsetForDeviceSafeInsets then
		v24 += v23
	end

	local x = v14.X
	local udim3

	if v15 then
		udim3 = UDim.new(1, 0)
	else
		udim3 = UDim.new(
			0,
			math.clamp(
				x * searchTokens.backgroundContainer.screenWidthScale,
				math.min(
					searchTokens.backgroundContainer.minimumWidth,
					x - searchTokens.backgroundContainer.padding
				),
				searchTokens.backgroundContainer.maximumWidth
			) - v20
		)
	end

	local ref = React.useRef(v13)
	local ref2 = React.useRef(v24)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)

	local ref5 = if fFlagLuaAppSduiSearchAutocomplete then React.useRef(nil) else nil
	local ref6 = if fFlagLuaAppSduiSearchAutocomplete then React.useRef(0) else nil
	local ref7 = if fFlagLuaAppSduiSearchAutocomplete then React.useRef(false) else nil
	local v25, v26 = useAnimatedBinding(v24)
	local state, setState = React.useState(props.initialSearchText)
	local state2, setState2 = React.useState({})
	local state3, setState3

	if fFlagLuaAppSduiSearchAutocomplete then
		state3, setState3 = React.useState("")
	end

	local v27 = if fFlagLuaAppSduiSearchAutocomplete then state3 == "" else nil
	local v28

	if state and state ~= "" then
		if
			fFlagLuaAppSduiSearchAutocomplete and module5.isSearchTypeInOmniSearch(props.searchType)
			or #state2 > 0
		then
			v28 = searchConstants.OverlayContentPageType.AutocompleteSuggestions
		else
			v28 = searchConstants.OverlayContentPageType.NoResults
		end
	else
		v28 = searchConstants.OverlayContentPageType.LandingPage
	end

	local useCallback = React.useCallback
	local function fn(value)
		local v29, v30, v31

		if v15 then
			v29 = if defineFastFlag then v14.Y - v19.top - v21 else v14.Y

			if not v29 then
				v30 = v24

				v31 = if defineFastFlag then v14.Y - v19.top - v21 else v14.Y
				v29 = math.clamp(value, v30, v31)
			end
		else
			v30 = v24

			v31 = if defineFastFlag then v14.Y - v19.top - v21 else v14.Y
			v29 = math.clamp(value, v30, v31)
		end

		v26(ReactOtter.spring(v29, { dampingRatio = 0.9, frequency = 6 }))
	end

	local top = if defineFastFlag then v19.top else nil
	local v32 = useCallback(fn, {
		v15,
		v14,
		v24,
		v26,
		top,
		if defineFastFlag then v21 else nil
	})

	local v33 = React.useCallback(function(p2, p3)
		return v6(module7(p2, p3))
	end, { v6 })

	local v34 = React.useCallback(function()
		if props.closeCentralOverlayThunk then
			v6(props.closeCentralOverlayThunk())
		end

		if v11:SessionExists(sessionType.StructuralIdentifier.GameSearchAutocomplete) then
			v11:RemoveSession(sessionType.StructuralIdentifier.GameSearchAutocomplete)
		end
	end, { props.closeCentralOverlayThunk, v6, v11 })

	local v35 = React.useCallback(function()
		v34()
		v11:RemoveSession(sessionType.StructuralIdentifier.SearchLandingPage)
	end, { v34, v11 })

	local v36 = React.useCallback(function()
		module12(v11)
	end, { v11 })

	local v37 = React.useCallback(function()
		v11:SetSession(
			sessionType.StructuralIdentifier.Level1,
			sessionType.StructuralIdentifier.GameSearchAutocomplete,
			sessionType.StructuralIdentifier.GameSearchAutocomplete
		)
	end, { v11 })

	local useCallback2 = React.useCallback
	local function fn2(p2)
		if not p2 then
			return
		end

		assert(p2 ~= nil, "onAbsoluteContentSizeChangedCallback: obj is nil")
		local y = p2.AbsoluteContentSize.Y

		local v38 = if defineFastFlag then y + v22 else y + v19.top + v18

		if fFlagFixOverlayTopInsetForDeviceSafeInsets then
			v38 += v23
		end

		ref2.current = v38
		v32(v38)
	end

	local top2 = if not defineFastFlag then v19.top else nil
	local v39 = if not defineFastFlag then v18 else nil
	local v40 = if defineFastFlag then v22 else nil
	local v42 = useCallback2(fn2, {
		top2,
		v39,
		v32,
		v40,
		if fFlagFixOverlayTopInsetForDeviceSafeInsets then v23 else nil
	})

	local v43 = React.useCallback(function()
		module8(v10, "searchLandingPage", "cancel", nil, true, ref.current)
		v35()
	end, { v35, v10 })

	local v44 = React.useCallback(function()
		v36()
		v37()
		module8(v10, "searchLandingPage", "open", nil, true, ref.current)
	end, { v10, v36, v37 })
	local v45

	if fFlagLuaAppSduiSearchAutocomplete then
		v45 = React.useCallback(function(p2)
			ref6.current = p2.AbsoluteSize.Y
			v32(v24 + p2.AbsoluteSize.Y)
		end, { v24, v32 })
	end

	local v46

	if fFlagLuaAppSduiSearchAutocomplete then
		local v48 = if defineFastFlag then v14.Y - v19.top - v21 else v14.Y
		v46 = math.max(0, v48 - v24)
	else
		v46 = 0
	end

	local v47 = React.useCallback(function(p2, p3, p4, p5)
		local v49 = if fFlagLuaAppSduiSearchAutocomplete then p5 or props.searchType else props.searchType
		v33(p2, {
			isAutocompleteSuggestion = p3,
			allAutocompleteSuggestions = p4,
			searchType = v49,
			isAvatarAutocompleteEnabled = false,
			navigation = v5,
			pageOwner = v5.state.routeName,
			sessionService = v11,
			eventIngest = v10
		})
		v35()
	end, { v33, v35, props.searchType, v10, v11, v5 })

	React.useEffect(function()
		if v9 == "" or v9 == nil then
			v6(apiFetchSearchLandingPage(v12, searchLandingPageSession:Get()))
		else
			v6(apiFetchSearchLandingPage(
				v12,
				searchLandingPageSession:Get(),
				searchLandingPageSurface.Party
			))
		end

		v36()

		return function()
			v35()
		end
	end, { v36, v35, v12, v6, v11, v9 })

	local useEffect = React.useEffect
	local function fn3()
		if v28 == searchConstants.OverlayContentPageType.LandingPage then
			if fFlagLuaAppSduiSearchAutocomplete then
				ref7.current = false
				ref6.current = 0
			end

			v32(ref2.current)
		elseif v28 == searchConstants.OverlayContentPageType.AutocompleteSuggestions then
			if fFlagLuaAppSduiSearchAutocomplete and module5.isSearchTypeInOmniSearch(props.searchType) then
				if v27 then
					if ref7.current then
						ref7.current = false
						ref6.current = 0
					end
				else
					ref7.current = true
				end
			end

			local v49 = if fFlagLuaAppSduiSearchAutocomplete and module5.isSearchTypeInOmniSearch(props.searchType) then v24 + ref6.current else searchTokens.searchBarListPicker.height + v24
			v32(v49)
		elseif v28 == searchConstants.OverlayContentPageType.NoResults then
			v32(v24)
		end
	end

	local v50 = if fFlagLuaAppSduiSearchAutocomplete then v27 else nil
	local v51 = if fFlagLuaAppSduiSearchAutocomplete then module5.isSearchTypeInOmniSearch(props.searchType) else nil
	useEffect(fn3, { v28, v24, v32, v50, v51 })

	React.useEffect(function()
		if v13 ~= ref.current then
			v34()
		end
	end, { v13, v34 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local newUDim2 = UDim2.new

	local v58 = if defineFastFlag then (if v15 then -v21 else v19.top) else 0
	local v54 = {}
	v54.Size = newUDim2(1, 0, 1, v58)

	local newUDim2_2 = UDim2.new

	local v62 = if defineFastFlag then (if v15 then v21 * 0.5 else -v19.top * 0.5) else 0
	v54.Position = newUDim2_2(0.5, 0, 0.5, v62)

	v54.AnchorPoint = Vector2.new(0.5, 0.5)
	v54.Text = ""
	v54.TextTransparency = 1
	v54.BackgroundTransparency = v8.Color.Common.Scrim.Transparency
	v54.BackgroundColor3 = v8.Color.Common.Scrim.Color3
	v54.AutoButtonColor = false
	v54.BorderSizePixel = 0
	v54[React.Event.Activated] = v43
	v54.ZIndex = 1
	v54.Selectable = false
	local children = {
		AbsorbInput = createElement2("TextButton", v54),
		OverlayContainer = 0
	}

	local createElement3 = React.createElement
	local v64 = {
		["Position"] = udim,
		AnchorPoint = vector2,
		Size = v25:map(function(p2)
			if v15 then
				return UDim2.new(1, 0, 0, p2)
			end

			return UDim2.new(udim3.Scale, udim3.Offset, 0, p2)
		end),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Selectable = false,
		ZIndex = 2,
		ClipsDescendants = v15,
		AutoButtonColor = false,
		Active = true,
		Text = ""
	}

	local tag = React.Tag
	local v65 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-search-overlay") else nil
	v64[tag] = v65
	local v66 = {
		Shadow = React.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, -shadowBoldness - shadowTopOffset),
			Size = UDim2.new(1, v20, 1, shadowBoldness * 2 + shadowTopOffset + shadowBottomOffset),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = -1,
			Image = images["component_assets/dropshadow_16_20"],
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(28, 28, 29, 29),
			ImageColor3 = v7.Theme.DropShadow.Color,
			ImageTransparency = v7.Theme.DropShadow.Transparency
		}, {
			Background = React.createElement("Frame", {
				Position = UDim2.new(0, shadowBoldness, 0, shadowBoldness),
				Size = UDim2.new(1, -shadowBoldness * 2, 1, -shadowBoldness * 2),
				BorderSizePixel = 0,
				BackgroundColor3 = searchTokens.backgroundContainer.backgroundColor3,
				BackgroundTransparency = searchTokens.backgroundContainer.backgroundTransparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 14)
				})
			})
		}),
		ContentWrapper = 0
	}

	local createElement4 = React.createElement
	local v68 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v69 = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = udim2,
			PaddingRight = udim2,
			PaddingTop = UDim.new(0, v24 - NAV_BAR_SIZE)
		}),
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SearchBar = 0,
		Content = 0
	}

	local createElement5 = React.createElement
	local v71 = {
		layoutOrder = 1,
		Size = UDim2.new(
			1,
			v15 and 0 or searchMargin * 2 - fIntSearchLandingPageSideMargin * 2,
			0,
			NAV_BAR_SIZE
		),
		anchorPoint = Vector2.new(0.5, 0),
		cancelSearch = v43,
		confirmSearch = v47,
		onFocused = v44,
		isCompactView = false,
		placeholderText = props.placeholderText,
		searchType = props.searchType,
		autocomplete = true,
		focusController = props.focusController,
		isSearching = true,
		animated = true,
		modernUI = true,
		initialSearchText = props.initialSearchText,
		searchBarPadding = 0,
		disableListPicker = true,
		onTextChanged = setState,
		onPickerItemsChanged = setState2,
		listPickerRef = ref4,
		searchBoxRef = if fFlagLuaAppSduiSearchAutocomplete then ref5 else nil,
		updateAutocompleteOnMount = true,
		onSduiAutocompleteChanged = 0,
		animationSettings = 0
	}

	if not fFlagLuaAppSduiSearchAutocomplete then
		setState3 = nil
	end

	v71.onSduiAutocompleteChanged = setState3

	v71.animationSettings = not v15
		and {
			originalWidth = searchConstants.NON_COMPACT_SEARCH_BAR_SIZE,
			animationStyle = searchConstants.SearchBarAnimationStyle.ExpandFromCenter
		}
		or nil
	v69.SearchBar = createElement5(module9, v71)
	local v73

	if v28 == searchConstants.OverlayContentPageType.LandingPage then
		v73 = React.createElement(module11, {
			layoutOrder = 2,
			size = UDim2.new(1, searchMargin * 2, 1, -v24),
			position = UDim2.new(0.5, 0, 0, 0),
			scrollingFrameRef = ref3,
			onAbsoluteContentSizeChanged = v42,
			isCompactView = v15,
			defaultContainerSize = Vector2.new(v14.X * udim3.Scale + udim3.Offset + searchMargin * 2, 0)
		})
	elseif v28 == searchConstants.OverlayContentPageType.AutocompleteSuggestions then
		if fFlagLuaAppSduiSearchAutocomplete and module5.isSearchTypeInOmniSearch(props.searchType) then
			v73 = React.createElement(sduiSearchAutocomplete, {
				prefix = state3 or "",
				LayoutOrder = 2,
				Size = UDim2.new(
					1,
					v15 and 0 or searchMargin * 2 - fIntSearchLandingPageSideMargin * 2,
					0,
					0
				),
				maxHeight = v46,
				nextSelectionUp = ref5,
				onCancel = v43,
				onAbsoluteSizeChange = v45,
				ref = ref4
			})
		else
			v73 = React.createElement(module10, {
				layoutOrder = 2,
				items = state2,
				width = UDim.new(1, v15 and 0 or searchMargin * 2 - fIntSearchLandingPageSideMargin * 2),
				height = UDim.new(1, -v24),
				BackgroundTransparency = 1,
				removeAdditionalMargins = true,
				ref = ref4
			})
		end
	end

	v69.Content = v73
	v66.ContentWrapper = createElement4("Frame", v68, v69)
	children.OverlayContainer = createElement3("TextButton", v64, v66)
	return createElement(fragment, nil, children)
end

return LUAUFORGE_MODULE_GLOBALS_hYF_SearchPageOverlay
