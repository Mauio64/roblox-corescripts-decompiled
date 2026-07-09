local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local React = require(CorePackages.Packages.React)
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Navigation = require(CorePackages.Workspace.Packages.Navigation)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local useNavigation = Navigation.useNavigation
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useCurrentSquadId = require(CorePackages.Workspace.Packages.SquadsCore.Hooks).useCurrentSquadId
local SearchLandingPageSurface = require(CorePackages.Workspace.Packages.DiscoveryTypes).SearchLandingPageSurface
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SearchConstants = Modules.Personalization.Search.SearchConstants
local SearchLandingPageSession = Modules.Personalization.Sessions.SearchLandingPageSession
local ApiFetchSearchLandingPage = Modules.LuaApp.Thunks.Search.ApiFetchSearchLandingPage
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules2.LuaApp.Constants)
local ConfirmSearch = require(Modules2.LuaApp.Thunks.ConfirmSearch)
local search = require(Modules2.LuaApp.Analytics.Events.search)
local SearchBar = require(Modules2.LuaApp.Components.SearchBar)
local SearchBarListPicker = require(Modules2.LuaApp.Components.SearchBarListPicker)
local SearchLandingPage = require(Modules2.Personalization.Search.SearchLandingPage)
local setSearchLandingPageSessionInfo = require(Modules2.Personalization.Sessions.setSearchLandingPageSessionInfo)
local FFlagBoldSearchListPickerSuggestions = require(Modules2.LuaApp.Flags.FFlagBoldSearchListPickerSuggestions)
local FIntSearchLandingPageSideMargin = Modules.Personalization.Search.FIntSearchLandingPageSideMargin
local v39 = game:DefineFastFlag("SearchOverlayIgnoreTopGuiInset", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v45 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local NAV_BAR_SIZE = Constants.NAV_BAR_SIZE

function SearchPageOverlay(t1: {[any]: any}) -- line: 79
	-- upvalues: useNavigation (copy), useDispatch (copy), useStyle (copy), useDesignTokens (copy), useCurrentSquadId (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), RoactNetworking (copy), FFlagSignalsNavP3hMisc (copy), v45 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), FormFactor (copy), v39 (copy), SearchConstants (copy), React (copy), useAnimatedBinding (copy), ReactOtter (copy), ConfirmSearch (copy), SessionType (copy), setSearchLandingPageSessionInfo (copy), search (copy), ApiFetchSearchLandingPage (copy), SearchLandingPageSession (copy), SearchLandingPageSurface (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ImageSetLabel (copy), Images (copy), NAV_BAR_SIZE (copy), SearchBar (copy), FIntSearchLandingPageSideMargin (copy), SearchLandingPage (copy), SearchBarListPicker (copy), FFlagBoldSearchListPickerSuggestions (copy)
	local v48 = useNavigation()
	local v49 = useDispatch()
	local v50 = useStyle()
	local v51 = useDesignTokens()
	local v52 = useCurrentSquadId()
	local v53 = useRoactService(AppEventIngestService)
	local v54 = useRoactService(AppSessionService)
	local v55 = useRoactService(RoactNetworking)
	local key

	if FFlagSignalsNavP3hMisc then
		local v56 = v45(false)

		key = useSignalState(v56.getCurrentRoute).key
	else
		key = useSelector(function(p1) -- line: 96
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return Selectors.selectCurrentRoactNavigationRoute(p1).key
			end

			return p1.Navigation.currentRoute.key
		end)
	end

	local v58 = useSelector(function(p2) -- line: 102
		return p2.ScreenSize
	end)
	local v59 = useSelector(function(p3) -- line: 105
		-- upvalues: FormFactor (copy)
		return p3.FormFactor == FormFactor.COMPACT
	end)
	local v60 = not not v39 and useSelector(function(p4) -- line: 109
		return (p4.AppTopBanner.expanded and not p4.AppTopBanner.isDisabled) == true
	end)
	local v61 = not v39 and 0 or useSelector(function(p5) -- line: 114
		return p5.TopBar.statusBarHeight
	end)
	local v62 = useSelector(function(p6) -- line: 118
		return p6.TopBar.topBarHeight
	end)
	local v63 = useSelector(function(p7) -- line: 121
		return p7.GlobalGuiInset or {
			left = 0,
			top = 0,
			right = 0,
			bottom = 0
		}
	end)
	local v64 = SearchConstants.getSearchTokens(v51)
	local searchMargin = v64.searchMargin
	local shadowBoldness = v64.backgroundContainer.shadowBoldness
	local shadowTopOffset = v64.backgroundContainer.shadowTopOffset
	local shadowBottomOffset = v64.backgroundContainer.shadowBottomOffset
	local v69 = shadowBoldness * 2 + searchMargin * 2
	local v70 = (not v39 or not v60) and 0 or v61
	local v71 = if not v39 or not v60 then v62 else v62 - v61
	local v72 = if not v59 then UDim2.new(0.5, 0, 0, not v39 and 0 or v70) else UDim2.new(0, 0, 0, not v39 and 0 or v70)
	local v73 = if not v59 then Vector2.new(0.5, 0) else Vector2.new(0, 0)
	local v74 = if not v59 then UDim.new(0, 0) else UDim.new(0, searchMargin)
	local v75 = if not v39 then v63.top + v62 else v71
	local X = v58.X
	local v77 = if not v59 then UDim.new(0, math.clamp(X * v64.backgroundContainer.screenWidthScale, math.min(v64.backgroundContainer.minimumWidth, X - v64.backgroundContainer.padding), v64.backgroundContainer.maximumWidth) - v69) else UDim.new(1, 0)
	local v78 = React.useRef(key)
	local v79 = React.useRef(v75)
	local v80 = React.useRef(nil)
	local v81 = React.useRef(nil)
	local v82, v83 = useAnimatedBinding(v75)
	local v84, v85 = React.useState(t1.initialSearchText)
	local v86, v87 = React.useState({})
	local v88 = if not not v84 and v84 ~= "" then if not (#v86 > 0) then SearchConstants.OverlayContentPageType.NoResults else SearchConstants.OverlayContentPageType.AutocompleteSuggestions else SearchConstants.OverlayContentPageType.LandingPage
	local v89 = React.useCallback(function(n1: number) -- line: 180
		-- upvalues: v59 (copy), v39 (copy), v58 (copy), v63 (copy), v70 (copy), v75 (copy), v83 (copy), ReactOtter (copy)
		local v107 = v59 and (if not v39 then v58.Y else v58.Y - v63.top - v70) or math.clamp(n1, v75, if not v39 then v58.Y else v58.Y - v63.top - v70)

		v83(ReactOtter.spring(v107, {
			dampingRatio = 0.9,
			frequency = 6
		}))
	end, {
		v59,
		v58,
		v75,
		v83,
		if not v39 then nil else v63.top,
		if not v39 then nil else v70
	})
	local v90 = React.useCallback(function(p8, p9) -- line: 206
		-- upvalues: v49 (copy), ConfirmSearch (copy)
		return v49(ConfirmSearch(p8, p9))
	end, { v49 })
	local v91 = React.useCallback(function() -- line: 210
		-- upvalues: t1 (copy), v49 (copy), v54 (copy), SessionType (copy)
		if t1.closeCentralOverlayThunk then
			v49(t1.closeCentralOverlayThunk())
		end

		if v54:SessionExists(SessionType.StructuralIdentifier.GameSearchAutocomplete) then
			v54:RemoveSession(SessionType.StructuralIdentifier.GameSearchAutocomplete)
		end
	end, {
		t1.closeCentralOverlayThunk,
		v49,
		v54
	})
	local v92 = React.useCallback(function() -- line: 219
		-- upvalues: v91 (copy), v54 (copy), SessionType (copy)
		v91()
		v54:RemoveSession(SessionType.StructuralIdentifier.SearchLandingPage)
	end, {
		v91,
		v54
	})
	local v93 = React.useCallback(function() -- line: 224
		-- upvalues: setSearchLandingPageSessionInfo (copy), v54 (copy)
		setSearchLandingPageSessionInfo(v54)
	end, { v54 })
	local v94 = React.useCallback(function() -- line: 228
		-- upvalues: v54 (copy), SessionType (copy)
		v54:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.GameSearchAutocomplete, SessionType.StructuralIdentifier.GameSearchAutocomplete)
	end, { v54 })
	local v95 = React.useCallback(function(p10) -- line: 237
		-- upvalues: v39 (copy), v71 (copy), v63 (copy), v62 (copy), v79 (copy), v89 (copy)
		if not p10 then
			return
		end

		assert(p10 ~= nil, "onAbsoluteContentSizeChangedCallback: obj is nil")

		local AbsoluteContentSizeY = p10.AbsoluteContentSize.Y
		local v112 = if not v39 then AbsoluteContentSizeY + v63.top + v62 else AbsoluteContentSizeY + v71

		v79.current = v112
		v89(v112)
	end, {
		if not v39 then v63.top else nil,
		if not v39 then v62 else nil,
		v89,
		if not v39 then nil else v71
	})
	local v96 = React.useCallback(function() -- line: 258
		-- upvalues: search (copy), v53 (copy), v78 (copy), v92 (copy)
		search(v53, "searchLandingPage", "cancel", nil, true, v78.current)
		v92()
	end, {
		v92,
		v53
	})
	local v97 = React.useCallback(function() -- line: 263
		-- upvalues: v93 (copy), v94 (copy), search (copy), v53 (copy), v78 (copy)
		v93()
		v94()
		search(v53, "searchLandingPage", "open", nil, true, v78.current)
	end, {
		v53,
		v93,
		v94
	})
	local v98 = React.useCallback(function(p11, p12, p13) -- line: 270
		-- upvalues: t1 (copy), v48 (copy), v54 (copy), v53 (copy), v90 (copy), v92 (copy)
		local t2 = {
			isAvatarAutocompleteEnabled = false,
			isAutocompleteSuggestion = p12,
			allAutocompleteSuggestions = p13,
			searchType = t1.searchType,
			navigation = v48,
			pageOwner = v48.state.routeName,
			sessionService = v54,
			eventIngest = v53
		}

		v90(p11, t2)
		v92()
	end, {
		v90,
		v92,
		t1.searchType,
		v53,
		v54,
		v48
	})

	React.useEffect(function() -- line: 289
		-- upvalues: v52 (copy), v49 (copy), ApiFetchSearchLandingPage (copy), v55 (copy), SearchLandingPageSession (copy), SearchLandingPageSurface (copy), v93 (copy), v92 (copy)
		if v52 ~= "" and v52 ~= nil then
			v49(ApiFetchSearchLandingPage(v55, SearchLandingPageSession:Get(), SearchLandingPageSurface.Party))
		else
			v49(ApiFetchSearchLandingPage(v55, SearchLandingPageSession:Get()))
		end

		v93()

		return function() -- line: 303
			-- upvalues: v92 (copy)
			v92()
		end
	end, {
		v93,
		v92,
		v55,
		v49,
		v54,
		v52
	})
	React.useEffect(function() -- line: 311
		-- upvalues: v88 (copy), SearchConstants (copy), v89 (copy), v79 (copy), v64 (copy), v75 (copy)
		if v88 == SearchConstants.OverlayContentPageType.LandingPage then
			v89(v79.current)

			return
		end

		if v88 == SearchConstants.OverlayContentPageType.AutocompleteSuggestions then
			v89(v64.searchBarListPicker.height + v75)

			return
		end

		if v88 == SearchConstants.OverlayContentPageType.NoResults then
			v89(v75)
		end
	end, {
		v88,
		v75,
		v89
	})
	React.useEffect(function() -- line: 327
		-- upvalues: key (ref), v78 (copy), v91 (copy)
		if key ~= v78.current then
			v91()
		end
	end, {
		key,
		v91
	})

	return React.createElement(React.Fragment, nil, {
		AbsorbInput = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, not v39 and 0 or if not v59 then v63.top else -v70),
			Position = UDim2.new(0.5, 0, 0.5, not v39 and 0 or if not v59 then -v63.top * 0.5 else v70 * 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Text = "",
			TextTransparency = 1,
			BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v51.Semantic.Color.Common.Overlay else v51.Color.Common.Scrim)).Transparency,
			BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v51.Semantic.Color.Common.Overlay else v51.Color.Common.Scrim)).Color3,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			[React.Event.Activated] = v96,
			ZIndex = 1,
			Selectable = false
		}),
		OverlayContainer = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			ZIndex = 2,
			AutoButtonColor = false,
			Active = true,
			Text = "",
			Position = v72,
			AnchorPoint = v73,
			Size = v82:map(function(p14) -- line: 370
				-- upvalues: v59 (copy), v77 (copy)
				if v59 then
					return UDim2.new(1, 0, 0, p14)
				end

				return UDim2.new(v77.Scale, v77.Offset, 0, p14)
			end),
			ClipsDescendants = v59
		}, {
			Shadow = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = -1,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, -shadowBoldness - shadowTopOffset),
				Size = UDim2.new(1, v69, 1, shadowBoldness * 2 + shadowTopOffset + shadowBottomOffset),
				Image = Images["component_assets/dropshadow_16_20"],
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(28, 28, 29, 29),
				ImageColor3 = v50.Theme.DropShadow.Color,
				ImageTransparency = v50.Theme.DropShadow.Transparency
			}, {
				Background = React.createElement("Frame", {
					BorderSizePixel = 0,
					Position = UDim2.new(0, shadowBoldness, 0, shadowBoldness),
					Size = UDim2.new(1, -shadowBoldness * 2, 1, -shadowBoldness * 2),
					BackgroundColor3 = v64.backgroundContainer.backgroundColor3,
					BackgroundTransparency = v64.backgroundContainer.backgroundTransparency
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 14)
					})
				})
			}),
			ContentWrapper = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingLeft = v74,
					PaddingRight = v74,
					PaddingTop = UDim.new(0, v75 - NAV_BAR_SIZE)
				}),
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				SearchBar = React.createElement(SearchBar, {
					layoutOrder = 1,
					isCompactView = false,
					autocomplete = true,
					isSearching = true,
					animated = true,
					modernUI = true,
					searchBarPadding = 0,
					disableListPicker = true,
					updateAutocompleteOnMount = true,
					Size = UDim2.new(1, if not v59 then searchMargin * 2 - FIntSearchLandingPageSideMargin * 2 else 0, 0, NAV_BAR_SIZE),
					anchorPoint = Vector2.new(0.5, 0),
					cancelSearch = v96,
					confirmSearch = v98,
					onFocused = v97,
					placeholderText = t1.placeholderText,
					searchType = t1.searchType,
					focusController = t1.focusController,
					initialSearchText = t1.initialSearchText,
					onTextChanged = v85,
					onPickerItemsChanged = v87,
					listPickerRef = v81,
					animationSettings = if v59 then nil else {
						originalWidth = SearchConstants.NON_COMPACT_SEARCH_BAR_SIZE,
						animationStyle = SearchConstants.SearchBarAnimationStyle.ExpandFromCenter
					}
				}),
				Content = if v88 ~= SearchConstants.OverlayContentPageType.LandingPage then if v88 ~= SearchConstants.OverlayContentPageType.AutocompleteSuggestions then nil else React.createElement(SearchBarListPicker, {
					layoutOrder = 2,
					BackgroundTransparency = 1,
					removeAdditionalMargins = true,
					items = v86,
					width = UDim.new(1, if not v59 then searchMargin * 2 - FIntSearchLandingPageSideMargin * 2 else 0),
					height = UDim.new(1, -v75),
					ref = v81,
					currentKeyword = if not FFlagBoldSearchListPickerSuggestions then nil else v84
				}) else React.createElement(SearchLandingPage, {
					layoutOrder = 2,
					size = UDim2.new(1, searchMargin * 2, 1, -v75),
					position = UDim2.new(0.5, 0, 0, 0),
					scrollingFrameRef = v80,
					onAbsoluteContentSizeChanged = v95,
					isCompactView = v59,
					defaultContainerSize = Vector2.new(v58.X * v77.Scale + v77.Offset + searchMargin * 2, 0)
				})
			})
		})
	})
end

return SearchPageOverlay
