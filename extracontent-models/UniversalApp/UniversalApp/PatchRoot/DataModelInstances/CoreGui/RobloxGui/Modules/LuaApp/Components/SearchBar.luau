local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")
local GuiService = game:GetService("GuiService")
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Cryo = require(CorePackages.Packages.Cryo)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local GameIconRodux = require(CorePackages.Workspace.Packages.GameIconRodux)
local ApiFetchGameIcons = GameIconRodux.GameIcons.ApiFetchGameIcons
local GameIconReducer = GameIconRodux.GameIcons.GameIconReducer
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local DiscoveryUtils = require(CorePackages.Workspace.Packages.DiscoveryUtils)
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default
local SettingsRoute = require(CorePackages.Workspace.Packages.LinkingProtocol).Enums.SettingsRoute
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources
local SearchConstants = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.Search.SearchConstants
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SearchUtil = require(Modules.LuaApp.Util.SearchUtil)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local SearchBarListPicker = require(Modules.LuaApp.Components.SearchBarListPicker)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FetchAutocompleteSuggestion = require(Modules.LuaApp.Thunks.FetchAutocompleteSuggestion)
local SetSearchBarFocused = require(Modules.LuaApp.Actions.SetSearchBarFocused)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AutocompleteSuggestion = require(Modules.LuaApp.Models.AutocompleteSuggestion)
local searchAutocomplete = require(Modules.LuaApp.Analytics.Events.searchAutocomplete)
local searchAutocompleteEventNew = require(Modules.LuaApp.Analytics.Events.searchAutocompleteEventNew)
local searchTextTrim = require(Modules.LuaApp.Analytics.Events.searchTextTrim)
local searchClear = require(Modules.LuaApp.Analytics.Events.searchClear)
local searchSuggestionClicked = require(Modules.LuaApp.Analytics.Events.searchSuggestionClicked)
local getCurrentPage = require(Modules.LuaApp.getCurrentPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateDownTo3DQRCodePage = require(Modules.LuaApp.Thunks.NavigateDownTo3DQRCodePage)
local AppPage = require(Modules.LuaApp.AppPage)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v77 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local GetSearchBarStore = require(CorePackages.Workspace.Packages.SearchBarStore).GetSearchBarStore
local GetFIntLuaAppAutocompleteDebounceMs = require(Modules.LuaApp.Flags.GetFIntLuaAppAutocompleteDebounceMs)
local GetFIntLuaAppAutocompleteSearchTextMaxLen = require(Modules.LuaApp.Flags.GetFIntLuaAppAutocompleteSearchTextMaxLen)
local GetFFlagLuaAppAutocompleteIXPConfig = require(Modules.LuaApp.Flags.GetFFlagLuaAppAutocompleteIXPConfig)
local GetFFlagAvatarAutocompleteEnabledForAll = require(Modules.AvatarExperience.Flags.GetFFlagAvatarAutocompleteEnabledForAll)
local FFlagUseSignalsForSearchBar = SharedFlags.FFlagUseSignalsForSearchBar
local FFlagBoldSearchListPickerSuggestions = require(Modules.LuaApp.Flags.FFlagBoldSearchListPickerSuggestions)
local FFlagSearchOmniAutocompletePage = SharedFlags.FFlagSearchOmniAutocompletePage
local v86 = game:DefineFastFlag("ImproveSearchSelectionUX2", false)
local FFlagUsesCancelSearchAppPolicy = SharedFlags.FFlagUsesCancelSearchAppPolicy
local FFlagEnableAppNavGamepadRemoval = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAppNavGamepadRemoval
local FFlagQRInSearchScanner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagQRInSearchScanner
local FFlagQRInSearchProfileQR = require(CorePackages.Workspace.Packages.SharedFlags).FFlagQRInSearchProfileQR
local v91 = game:DefineFastFlag("AXMigrateSearchBarToFocusNavigation", false)
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local v93 = game:DefineFastFlag("LuaAppNewSlpEndpointIxpEnabled", false)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v95 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local v96 = game:DefineFastString("LuaAppNewSlpEndpointIxpLayer", "Growth.Omnisearch.SearchLandingPage")
local RecentSearchTermsAppStorage = require(CorePackages.Workspace.Packages.AvatarExperienceSearch).Utils.RecentSearchTermsAppStorage
local v98 = not FFlagSearchOmniAutocompletePage and 28 or SearchConstants.SEARCH_BAR_HEIGHT
local v99 = not FFlagSearchOmniAutocompletePage and 12 or SearchConstants.SEARCH_BAR_PADDING
local v100 = not FFlagSearchOmniAutocompletePage and 20 or SearchConstants.SEARCH_BAR_TEXT_SIZE
local v101 = not FFlagSearchOmniAutocompletePage and 9 or SearchConstants.SEARCH_BAR_ICON_PADDING
local v102 = not FFlagSearchOmniAutocompletePage and 36 or SearchConstants.SEARCH_BAR_TEXT_PADDING_WITH_ICON
local v103 = not FFlagSearchOmniAutocompletePage and 12 or SearchConstants.SEARCH_BAR_TEXT_PADDING_WITHOUT_ICON
local v104 = not FFlagSearchOmniAutocompletePage and 16 or SearchConstants.CLEAR_IMAGE_SIZE
local v105 = not FFlagSearchOmniAutocompletePage and 6 or SearchConstants.CLEAR_IMAGE_PADDING
local v106 = v105 * 2 + v104
local v107 = not FFlagSearchOmniAutocompletePage and 88 or SearchConstants.CANCEL_BUTTON_WIDTH
local v108 = not FFlagSearchOmniAutocompletePage and 7 or SearchConstants.CANCEL_BUTTON_PADDING
local v109 = not FFlagSearchOmniAutocompletePage and 540 or SearchConstants.TABLET_LIST_PICKER_HEIGHT
local v110 = GetFIntLuaAppAutocompleteDebounceMs() / 1000
local t1 = {
	Image = "LuaApp/buttons/buttonFill",
	SliceCenter = Rect.new(8, 8, 9, 9)
}
local v112 = Images["icons/actions/edit/clear_small"]
local v113 = if not FFlagQRInSearchScanner and not FFlagQRInSearchProfileQR then nil else {
	description = "QR code button in SearchBar",
	links = "",
	eventName = EventTypes.ButtonClick,
	backends = { SupportedTelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("QRClickInOmniSearchThrottlingPercentage", 10000),
	lastUpdated = {
		25,
		11,
		6
	}
}
local v114 = if not FFlagEnableAppNavGamepadRemoval then {
	[Enum.UserInputType.Keyboard] = true,
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
} else nil
local Platform = UserInputService:GetPlatform()
local v116 = Platform == Enum.Platform.XBox360 or Platform == Enum.Platform.XBoxOne
local v117 = GuiService:IsTenFootInterface()
local v118 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
local v119 = Platform == Enum.Platform.Android

local function applyTokenScaling(n1: number, p1) -- line: 176
	return n1 * (p1.Stroke and p1.Stroke.Standard or (p1.Global and p1.Stroke.Standard or 1))
end

local v121 = Roact.PureComponent:extend("SearchBar")

v121.validateProps = t.strictInterface({
	Size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	cancelSearch = t.optional(t.callback),
	confirmSearch = t.optional(t.callback),
	onTextCleared = t.optional(t.callback),
	onFocused = t.optional(t.callback),
	placeholderText = t.optional(t.string),
	isCompactView = t.optional(t.boolean),
	modernUI = t.optional(t.boolean),
	initialSearchText = t.optional(t.string),
	autocomplete = t.optional(t.boolean),
	searchType = t.optional(t.string),
	isSearching = t.optional(t.boolean),
	searchBarPadding = t.optional(t.number),
	animated = t.optional(t.boolean),
	animationSettings = t.optional(t.table),
	focusController = t.optional(t.table),
	forwardRef = t.optional(t.table),
	[Roact.Ref] = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	autocompleteIXPConfigTbl = t.optional(t.table),
	ixpDisableGamesAutocomplete = t.optional(t.boolean),
	forceShowCancelButton = t.optional(t.boolean),
	onSameTermConfirmSearch = t.optional(t.callback),
	searchPageOverlayEnabled = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.boolean),
	disableListPicker = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.boolean),
	onTextChanged = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.callback),
	listPickerRef = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.table),
	onPickerItemsChanged = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.callback),
	layoutOrder = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.integer),
	updateAutocompleteOnMount = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.boolean),
	onExitSearch = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.callback),
	focusGuiObject = if not v86 then nil else t.optional(t.callback),
	focusedGuiObject = if not v86 then nil else t.optional(t.Instance),
	gameIcons = t.optional(t.table),
	autocompleteSuggestions = t.optional(t.table),
	avatarAutocompleteSuggestions = t.optional(t.table),
	currentPage = t.string,
	getAutocompleteFetchingStatus = t.callback,
	fetchAutocompleteSuggestion = t.callback,
	fetchGameIcons = t.callback,
	setSearchBarFocused = t.callback,
	dispatchSearchPageOverlay = if not FFlagSearchOmniAutocompletePage then nil else t.callback,
	navigateToScanQrCode = if not FFlagQRInSearchScanner then nil else t.callback,
	navigateToCameraPermissionOverlay = if not FFlagQRInSearchScanner then nil else t.callback,
	navigateToProfileQrCode = if not FFlagQRInSearchProfileQR then nil else t.callback,
	networking = t.callback,
	eventIngest = t.table,
	sessionService = t.optional(t.union(t.Instance, t.table)),
	shouldShowRecentSearchTerms = t.optional(t.boolean)
})
v121.defaultProps = {
	cancelSearch = nil,
	confirmSearch = nil,
	onTextCleared = nil,
	onFocused = nil,
	placeholderText = "",
	isCompactView = false,
	modernUI = false,
	initialSearchText = "",
	autocomplete = false,
	searchType = "None",
	isSearching = false,
	searchBarPadding = 24,
	animated = false,
	forceShowCancelButton = false,
	Size = UDim2.new(1, 0, 1, 0)
}

function v121.init(p2) -- line: 268
	-- upvalues: FFlagEnableAppNavGamepadRemoval (copy), v107 (copy), Roact (copy), FFlagSearchOmniAutocompletePage (copy), v86 (copy), FocusNavigationUtils (copy), InputHandlers (copy), AutocompleteSuggestion (copy), GetFIntLuaAppAutocompleteSearchTextMaxLen (copy), v110 (copy), DiscoveryUtils (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), IXPService (copy), AppUserLayers (copy), v93 (copy), v96 (copy), v119 (copy), FFlagEnableLeftNavOnConsole (copy), v117 (copy), v116 (copy), IsVRAppBuild (copy), FFlagUsesCancelSearchAppPolicy (copy), getAppFeaturePolicies (copy), v118 (copy), RunService (copy), SessionType (copy), searchClear (copy), v114 (copy), SearchUtil (copy), searchTextTrim (copy), RecentSearchTermsAppStorage (copy), RetrievalStatus (copy), searchSuggestionClicked (copy), SearchTypes (copy), searchAutocompleteEventNew (copy), searchAutocomplete (copy)
	local v129 = p2.props.initialSearchText or ""

	p2.state = {
		autocompleteKeyword = "",
		listPickerShown = false,
		clearButtonVisible = v129 ~= "",
		lastInputType = if not FFlagEnableAppNavGamepadRemoval then Enum.UserInputType.None else nil,
		cancelButtonWidth = v107
	}
	p2.searchBoxBackgroundRef = Roact.createRef()
	p2.searchBoxRef = Roact.createRef()
	p2.clearRef = Roact.createRef()
	p2.cancelRef = Roact.createRef()
	p2.listPickerRef = if not FFlagSearchOmniAutocompletePage then Roact.createRef() else p2.props.listPickerRef or Roact.createRef()
	p2.listPickerContainerRef = if not v86 then nil else Roact.createRef()
	p2.lastSearchBoxText = v129 or ""
	p2.lastAutocompleteUpdateTime = 0
	p2.lastAutocompleteCached = false
	p2.lastAutocompleteEventKeyword = ""
	p2.lastStoredListPickerItems = {}
	p2.customEventHandlers = if not v86 then nil else {
		[FocusNavigationUtils.FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p3) -- line: 298
				-- upvalues: p2 (copy)
				local isSearching = p2.props.isSearching
				local listPickerShown = p2.state.listPickerShown

				if isSearching then
					if listPickerShown then
						local current = p2.listPickerRef.current
						local current2 = p2.listPickerContainerRef.current
						local focusedGuiObject = p2.props.focusedGuiObject

						if current2 and focusedGuiObject and current and focusedGuiObject:IsDescendantOf(current2) then
							p2.doCancelSearch()

							if p2.props.focusGuiObject and p2.searchBoxRef then
								p2.props.focusGuiObject(p2.searchBoxRef.current)
							end
						end
					else
						p2.doCancelSearch()
					end

					p3:cancel()
				end
			end)
		}
	}

	function p2.requestAutocompleteSuggestion(p4) -- line: 327
		-- upvalues: p2 (copy)
		local networking = p2.props.networking

		p2.props.fetchAutocompleteSuggestion(networking, p4, p2.props.autocompleteIXPConfigTbl, p2.props.searchType)
	end
	function p2.requestRichSuggestionIcons(p5) -- line: 334
		-- upvalues: p2 (copy), AutocompleteSuggestion (copy)
		local networking = p2.props.networking
		local fetchGameIcons = p2.props.fetchGameIcons
		local t2 = {}

		for i = 1, #p5.entries do
			local v199 = p5.entries[i]

			if v199.type == AutocompleteSuggestion.EntryType.Rich then
				table.insert(t2, v199.universeId)
			end
		end

		if #t2 > 0 then
			fetchGameIcons(networking, t2)
		end
	end
	function p2.updateAutocomplete(p6) -- line: 349
		-- upvalues: p2 (copy), GetFIntLuaAppAutocompleteSearchTextMaxLen (copy), v110 (copy)
		if p6 == p2.state.autocompleteKeyword then
			return
		end

		if GetFIntLuaAppAutocompleteSearchTextMaxLen() < string.len(p6) then
			return
		end

		local v201 = p2.getCachedAutocompleteSuggestion(p6)
		local v202 = v201 ~= nil and tick() < v201.expirationTime

		p2.lastAutocompleteUpdateTime = tick()
		p2.lastAutocompleteCached = v202
		p2:setState({
			autocompleteKeyword = p6
		})

		if p6 == "" or v202 then
			if v202 and v201.preloadedCache then
				p2.requestRichSuggestionIcons(v201)
			end

			return
		end

		local timestamp = tick()

		spawn(function() -- line: 377
			-- upvalues: p6 (copy), timestamp (copy), v110 (copy), p2 (copy)
			local v313 = p6
			local v314 = timestamp + v110 - tick()

			if v314 > 0 then
				wait(v314)
			end

			if v313 == p2.state.autocompleteKeyword then
				p2.requestAutocompleteSuggestion(v313)
			end
		end)
	end
	function p2.doConfirmSearch(p7, p8, p9) -- line: 389
		-- upvalues: p2 (copy), DiscoveryUtils (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy)
		if not p2.isMounted then
			return
		end

		local current = p2.searchBoxRef.current

		if current and current:IsFocused() then
			current:ReleaseFocus()
		end

		if DiscoveryUtils.isSearchTypeInOmniSearch(p2.props.searchType) and p7 == "" then
			return
		end

		if p7 == p2.props.initialSearchText then
			if p2.props.shouldShowRecentSearchTerms then
				if p2.searchBoxRef and p2.searchBoxRef.current then
					p2.searchBoxRef.current.Text = p7
				end

				if p2.props.onSameTermConfirmSearch then
					p2.props.onSameTermConfirmSearch()
				end
			end

			return
		end

		local confirmSearch = p2.props.confirmSearch

		if confirmSearch then
			if GetFFlagAvatarAutocompleteEnabledForAll() then
				confirmSearch(p7, p8, p9)

				return
			end

			confirmSearch(p7, p8)
		end
	end
	function p2.doCancelSearch() -- line: 432
		-- upvalues: p2 (copy), FFlagSearchOmniAutocompletePage (copy)
		if not p2.isMounted then
			return
		end

		local current = p2.searchBoxRef.current

		if current and current:IsFocused() then
			current:ReleaseFocus()
		end

		local cancelSearch = p2.props.cancelSearch
		local v211 = if not FFlagSearchOmniAutocompletePage then nil else p2.props.onExitSearch

		if FFlagSearchOmniAutocompletePage and p2.props.searchPageOverlayEnabled then
			if v211 then
				v211()
			end
		elseif cancelSearch then
			cancelSearch()
		end

		if current then
			p2.searchBoxRef.current.Text = p2.props.initialSearchText
		end
	end
	function p2.onFocused() -- line: 460
		-- upvalues: p2 (copy), IXPService (copy), AppUserLayers (copy), v93 (copy), v96 (copy), FFlagSearchOmniAutocompletePage (copy)
		if not p2.isMounted then
			return
		end

		p2.props.setSearchBarFocused(true)
		IXPService:LogUserLayerExposure(AppUserLayers.SearchLandingPageLayer)

		if v93 then
			IXPService:LogFlagLinkedUserLayerExposure(v96)
		end

		if FFlagSearchOmniAutocompletePage and p2.props.searchPageOverlayEnabled then
			local current = p2.searchBoxRef.current

			if current and current:IsFocused() then
				p2.doCancelSearch()
			end

			p2.props.dispatchSearchPageOverlay(p2.props.initialSearchText, p2.props.searchType, p2.props.placeholderText)

			return
		end

		if p2.props.onFocused then
			p2.props.onFocused()
		end
	end
	function p2.onFocusLost(p10, p11, p12) -- line: 489
		-- upvalues: p2 (copy), v119 (copy), FFlagEnableLeftNavOnConsole (copy), v117 (copy), v116 (copy), IsVRAppBuild (copy), FFlagUsesCancelSearchAppPolicy (copy), getAppFeaturePolicies (copy), v86 (copy), v118 (copy), RunService (copy)
		if not p2.isMounted then
			return
		end

		p2.props.setSearchBarFocused(false)

		if p12 == nil and ((v119 or (if not FFlagEnableLeftNavOnConsole then v116 else v117)) and not IsVRAppBuild()) then
			if not FFlagUsesCancelSearchAppPolicy then
				p2.doCancelSearch()

				return
			end

			local getCancelSearchOnLostFocus = getAppFeaturePolicies().getCancelSearchOnLostFocus

			if getCancelSearchOnLostFocus == nil or getCancelSearchOnLostFocus() then
				p2.doCancelSearch()

				return
			end
		elseif v86 and p12 ~= nil and p12.KeyCode == Enum.KeyCode.Return or p11 and (not v118 or RunService:IsStudio()) then
			p2.doConfirmSearch(p10.Text)
		end
	end
	function p2.onReturnPressedFromOnScreenKeyboard(p13) -- line: 522
		-- upvalues: p2 (copy)
		p2.doConfirmSearch(p13.Text)
	end
	function p2.onCancelButtonActivated() -- line: 526
		-- upvalues: p2 (copy), SessionType (copy)
		if p2.isMounted then
			p2.doCancelSearch()

			local sessionService = p2.props.sessionService

			if sessionService:SessionExists(SessionType.StructuralIdentifier.GameSearchAutocomplete) then
				sessionService:RemoveSession(SessionType.StructuralIdentifier.GameSearchAutocomplete)
			end
		end
	end
	function p2.onClearText() -- line: 537
		-- upvalues: p2 (copy), searchClear (copy), FFlagSearchOmniAutocompletePage (copy), FFlagEnableAppNavGamepadRemoval (copy), v114 (copy)
		if not p2.isMounted then
			return
		end

		if p2.searchBoxRef.current then
			local eventIngest = p2.props.eventIngest
			local currentText = p2.searchBoxRef.current.Text
			local searchType = p2.props.searchType

			searchClear(eventIngest, p2.getEventContext(), currentText, searchType)

			if FFlagSearchOmniAutocompletePage and p2.props.searchPageOverlayEnabled then
				p2.props.dispatchSearchPageOverlay("", p2.props.searchType, p2.props.placeholderText)
			else
				p2.searchBoxRef.current.Text = ""
				p2.searchBoxRef.current:captureFocus()
			end

			if not FFlagEnableAppNavGamepadRemoval and v114[p2.state.lastInputType] and p2.props.focusController then
				p2.props.focusController.moveFocusTo(p2.searchBoxRef)
			end
		end
	end
	function p2.onTextChanged(p14) -- line: 565
		-- upvalues: p2 (copy), SearchUtil (copy), searchTextTrim (copy), FFlagSearchOmniAutocompletePage (copy)
		if not p2.isMounted then
			return
		end

		if not p14 then
			return
		end

		local p14Text = p14.Text
		local v224 = p14Text ~= ""

		if v224 ~= p2.state.clearButtonVisible then
			p2:setState({
				clearButtonVisible = v224
			})
		end

		if p2.props.autocomplete and not p2.props.ixpDisableGamesAutocomplete then
			local v225 = p14Text:lower()
			local v226 = SearchUtil.KeywordNormalize(v225)

			p2.updateAutocomplete(v226)
		end

		if p14:IsFocused() then
			local lastSearchBoxText = p2.lastSearchBoxText

			if string.len(p14Text) < string.len(lastSearchBoxText) then
				local searchType = p2.props.searchType
				local eventIngest = p2.props.eventIngest

				searchTextTrim(eventIngest, p2.getEventContext(), lastSearchBoxText, p14Text, searchType)
			end
		end

		p2.lastSearchBoxText = p14Text

		if p14Text == "" then
			local onTextCleared = p2.props.onTextCleared

			if onTextCleared then
				onTextCleared()
			end
		end

		if FFlagSearchOmniAutocompletePage and p2.props.onTextChanged then
			p2.props.onTextChanged(p14Text)
		end
	end
	function p2.onCancelButtonSizeChanged(p15) -- line: 616
		-- upvalues: p2 (copy)
		if p15 then
			p2:setState({
				cancelButtonWidth = p15.AbsoluteSize.X
			})
		end
	end
	function p2.getListPickerItems() -- line: 624
		-- upvalues: p2 (copy), RecentSearchTermsAppStorage (copy), RetrievalStatus (copy), AutocompleteSuggestion (copy), searchSuggestionClicked (copy), FFlagSearchOmniAutocompletePage (copy)
		local t3 = {}
		local autocompleteKeyword = p2.state.autocompleteKeyword

		if autocompleteKeyword == "" then
			p2.lastStoredListPickerItems = t3

			return t3
		end

		local v234 = p2.getCachedAutocompleteSuggestion(autocompleteKeyword)
		local t4 = {}

		if p2.props.shouldShowRecentSearchTerms then
			for _, v237 in (RecentSearchTermsAppStorage.findTermsForQuery(autocompleteKeyword)) do
				t4[v237] = true
				table.insert(t3, {
					isRichItem = false,
					isRecentCatalogSearchItem = true,
					displayIcon = nil,
					text = v237,
					onSelect = function() -- line: 649
						-- upvalues: p2 (copy), v237 (copy), v234 (copy)
						p2.doConfirmSearch(v237, false, if not v234 then nil else v234.entries)
					end
				})
			end
		end

		if not v234 then
			local v238 = p2.props.getAutocompleteFetchingStatus(autocompleteKeyword, p2.props.searchType)

			if v238 == RetrievalStatus.NotStarted or v238 == RetrievalStatus.Fetching then
				return p2.lastStoredListPickerItems
			end
		end

		if v234 then
			local gameIcons = p2.props.gameIcons

			for i = 1, #v234.entries do
				local v241 = v234.entries[i]
				local v242 = false
				local url = nil
				local s1 = ""
				local s2 = ""

				if v241.type == AutocompleteSuggestion.EntryType.Rich then
					v242 = true

					local v246 = gameIcons[tostring(v241.universeId)]

					if v246 then
						url = v246.url
					end

					s1 = v241.canonicalTitle
					s2 = v241.canonicalTitle
				elseif v241.type == AutocompleteSuggestion.EntryType.Keyword then
					s1 = v241.searchQuery:lower()
					s2 = s1
				end

				if not p2.props.shouldShowRecentSearchTerms or not t4[s1] then
					table.insert(t3, {
						isRichItem = v242,
						displayIcon = url,
						text = s1,
						onSelect = function() -- line: 700
							-- upvalues: searchSuggestionClicked (copy), p2 (copy), autocompleteKeyword (copy), v234 (copy), i (copy), v241 (copy), s2 (ref), FFlagSearchOmniAutocompletePage (copy)
							searchSuggestionClicked(p2.props.eventIngest, p2.getEventContext(), autocompleteKeyword, p2.props.searchType, v234.entries, i, v241)
							p2.doConfirmSearch(s2, true, v234.entries)

							if FFlagSearchOmniAutocompletePage and not p2.getCachedAutocompleteSuggestion(s2) then
								p2.requestAutocompleteSuggestion(s2)
							end
						end
					})
				end
			end
		end

		p2.lastStoredListPickerItems = t3

		return t3
	end
	function p2.getCachedAutocompleteSuggestion(p16) -- line: 725
		-- upvalues: p2 (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), SearchTypes (copy)
		local autocompleteSuggestions = p2.props.autocompleteSuggestions

		if GetFFlagAvatarAutocompleteEnabledForAll() and p2.props.searchType == SearchTypes.Catalog then
			autocompleteSuggestions = p2.props.avatarAutocompleteSuggestions
		end

		return autocompleteSuggestions[p16]
	end
	function p2.getEventContext() -- line: 737
		-- upvalues: GetFFlagAvatarAutocompleteEnabledForAll (copy), p2 (copy), SearchTypes (copy)
		if GetFFlagAvatarAutocompleteEnabledForAll() and p2.props.searchType == SearchTypes.Catalog then
			return "AvatarShopSearch"
		end

		return "GameSearch"
	end
	function p2.updateAutocompleteEvent() -- line: 745
		-- upvalues: p2 (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), searchAutocompleteEventNew (copy), searchAutocomplete (copy)
		if p2.props.autocomplete and not p2.props.ixpDisableGamesAutocomplete then
			local autocompleteKeyword = p2.state.autocompleteKeyword

			if autocompleteKeyword ~= p2.lastAutocompleteEventKeyword then
				local v250 = p2.getCachedAutocompleteSuggestion(autocompleteKeyword)

				if v250 then
					local eventIngest = p2.props.eventIngest
					local currentPage = p2.props.currentPage
					local v253 = (tick() - p2.lastAutocompleteUpdateTime) * 1000

					if GetFFlagAvatarAutocompleteEnabledForAll() then
						searchAutocompleteEventNew(eventIngest, p2.getEventContext(), autocompleteKeyword, p2.lastAutocompleteEventKeyword, v250, currentPage, v253, p2.lastAutocompleteCached, p2.props.searchType)
					else
						searchAutocomplete(eventIngest, "GameSearch", autocompleteKeyword, p2.lastAutocompleteEventKeyword, v250, currentPage, v253, p2.lastAutocompleteCached)
					end

					p2.lastAutocompleteEventKeyword = autocompleteKeyword
				end
			end
		end
	end
	function p2.onSearchIconActivated() -- line: 787
		-- upvalues: p2 (copy)
		local current = p2.searchBoxRef.current
		local isSearching = p2.props.isSearching

		if current and (isSearching and not current:IsFocused()) then
			current:CaptureFocus()
		end
	end
end

if FFlagQRInSearchScanner then
	function v121.openQrCodeScanner(p17) -- line: 798
		-- upvalues: default (copy)
		default.default:checkOrRequestPermissions({ default.Permissions.CAMERA_ACCESS }):andThen(function(p18) -- line: 803
			-- upvalues: default (copy), p17 (copy)
			if p18 == default.Status.AUTHORIZED then
				p17.props.navigateToScanQrCode()

				return
			end

			p17.props.navigateToCameraPermissionOverlay()
		end)
	end
end

function v121.didUpdate(p19, _) -- line: 813
	-- upvalues: FFlagSearchOmniAutocompletePage (copy)
	local current = p19.searchBoxRef.current

	if current then
		local isSearching = p19.props.isSearching
		local listPickerShown = p19.state.listPickerShown

		if isSearching then
			local autocompleteKeyword = p19.state.autocompleteKeyword

			if not listPickerShown and autocompleteKeyword ~= "" then
				p19:setState({
					listPickerShown = true
				})
			end
		elseif listPickerShown then
			p19:setState({
				listPickerShown = false
			})
		end
	end

	if p19.cancelRef.current and p19.state.cancelButtonWidth ~= p19.cancelRef.current.AbsoluteSize.X then
		p19:setState({
			cancelButtonWidth = p19.cancelRef.current.AbsoluteSize.X
		})
	end

	if current and current:IsFocused() then
		p19.updateAutocompleteEvent()
	end

	if FFlagSearchOmniAutocompletePage and p19.props.onPickerItemsChanged then
		if not p19.previousPickerItems then
			p19.previousPickerItems = {}
		end

		local previousPickerItems = p19.previousPickerItems
		local lastStoredListPickerItems = p19.lastStoredListPickerItems
		local v139 = true

		if #previousPickerItems ~= #lastStoredListPickerItems then
			v139 = false
		else
			for i = 1, #lastStoredListPickerItems do
				if previousPickerItems[i].text ~= lastStoredListPickerItems[i].text then
					v139 = false

					break
				end
			end
		end

		if not v139 then
			p19.previousPickerItems = lastStoredListPickerItems
			p19.props.onPickerItemsChanged(lastStoredListPickerItems)
		end
	end
end
function v121.didMount(p21) -- line: 874
	-- upvalues: Otter (copy), SearchConstants (copy), v108 (copy), v107 (copy), FFlagSearchOmniAutocompletePage (copy), SearchUtil (copy)
	p21.isMounted = true

	if p21.animationMotor then
		p21.animationMotor:destroy()
	end

	p21.animationMotor = Otter.createSingleMotor(0)
	p21.animationMotor:onStep(function(p22) -- line: 881
		-- upvalues: p21 (copy), SearchConstants (copy), v108 (copy), v107 (copy)
		if p21.isMounted then
			local current = p21.searchBoxBackgroundRef.current

			if current then
				if p21.props.animationSettings and p21.props.animationSettings.animationStyle == SearchConstants.SearchBarAnimationStyle.ExpandFromCenter then
					local v259 = p21.props.animationSettings.originalWidth or 0
					local v260 = v108 + v107

					current.Size = UDim2.new(p22, v259 * (1 - p22), 1, 0)
					current.Position = UDim2.new(0.5, v260 / 2 * (1 - p22), 0, 0)

					return
				end

				current.Size = UDim2.new(p22, 0, 1, 0)
				current.Position = UDim2.new(1 - p22, 0, 0, 0)
			end
		end
	end)

	if p21.props.animated then
		p21.animationMotor:setGoal(Otter.spring(1, {
			dampingRatio = 1,
			frequency = 4
		}))
	end

	local current = p21.searchBoxRef.current

	if current and p21.props.isSearching and not current:IsFocused() then
		current:CaptureFocus()
	end

	if FFlagSearchOmniAutocompletePage and p21.props.updateAutocompleteOnMount and (p21.props.autocomplete and not p21.props.ixpDisableGamesAutocomplete) and current then
		local v143 = current.Text:lower()
		local v144 = SearchUtil.KeywordNormalize(v143)

		p21.updateAutocomplete(v144)
	end

	if p21.cancelRef.current then
		p21:setState({
			cancelButtonWidth = p21.cancelRef.current.AbsoluteSize.X
		})
	end
end
function v121.willUnmount(p23) -- line: 931
	p23.isMounted = false

	if p23.animationMotor then
		p23.animationMotor:destroy()
	end
end
function v121.renderWithProviders(p24, p25, p26) -- line: 939
	-- upvalues: v98 (copy), v99 (copy), v100 (copy), v103 (copy), v102 (copy), v106 (copy), v107 (copy), FFlagSearchOmniAutocompletePage (copy), FFlagQRInSearchScanner (copy), FFlagQRInSearchProfileQR (copy), getAppFeaturePolicies (copy), withStyle (copy), Roact (copy), DEPRECATED_ImageSetButton (copy), v101 (copy), Focusable (copy), CursorKind (copy), ImageSetLabel (copy), v104 (copy), v105 (copy), v112 (copy), TelemetryService (copy), v113 (copy), Sources (copy), React (copy), View (copy), FoundationImage (copy), StateLayerAffordance (copy), v91 (copy), RoactGamepad (copy), v108 (copy), DEPRECATED_ImageSetLabel (copy), SearchConstants (copy), t1 (copy), v86 (copy), FitChildren (copy), SearchBarListPicker (copy), v109 (copy), FFlagBoldSearchListPickerSuggestions (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), SearchTypes (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), Images (copy), FFlagEnableAppNavGamepadRemoval (copy), ExternalEventConnection (copy), UserInputService (copy)
	local propsSize = p24.props.Size
	local isCompactView = p24.props.isCompactView
	local modernUI = p24.props.modernUI
	local clearButtonVisible = p24.state.clearButtonVisible
	local u153 = v98
	local u154 = v99
	local u155 = v100
	local u156 = isCompactView and v103 or v102
	local u157 = clearButtonVisible and u156 + v106 or u156
	local _ = v107
	local u159 = not isCompactView

	if isCompactView or modernUI then
		u153 = 36
		u154 = p24.props.searchBarPadding
		u155 = 24
		u156 = 9 + u155 + 9
		u157 = clearButtonVisible and u156 + v106 or u156
		u159 = true
	end

	local v160 = p24.props.autocomplete and not p24.props.ixpDisableGamesAutocomplete
	local isSearching = p24.props.isSearching
	local listPickerShown = p24.state.listPickerShown
	local uDim = UDim.new(1, 0)
	local v164 = if not FFlagSearchOmniAutocompletePage then v160 and listPickerShown else v160 and (listPickerShown and not p24.props.disableListPicker)
	local v165 = isSearching or p24.props.forceShowCancelButton
	local cancelButtonWidth = p24.state.cancelButtonWidth
	local v167 = v165 and cancelButtonWidth or 0
	local animated = p24.props.animated
	local v169 = (FFlagQRInSearchScanner or FFlagQRInSearchProfileQR) and (not clearButtonVisible and getAppFeaturePolicies().getFriendCodeQrCodeScannerEnabled())

	return withStyle(function(p27) -- line: 981
		-- upvalues: u159 (ref), Roact (copy), DEPRECATED_ImageSetButton (copy), u155 (ref), v101 (copy), p24 (copy), FFlagQRInSearchScanner (copy), FFlagQRInSearchProfileQR (copy), v169 (copy), Focusable (copy), u157 (ref), u156 (ref), clearButtonVisible (copy), v165 (copy), v164 (copy), p25 (copy), CursorKind (copy), v106 (copy), isCompactView (copy), ImageSetLabel (copy), v104 (copy), v105 (copy), v112 (copy), TelemetryService (copy), v113 (copy), Sources (copy), React (copy), View (copy), FoundationImage (copy), StateLayerAffordance (copy), v91 (copy), RoactGamepad (copy), v108 (copy), v167 (copy), u153 (ref), DEPRECATED_ImageSetLabel (copy), SearchConstants (copy), animated (copy), t1 (copy), p26 (copy), v86 (copy), FitChildren (copy), SearchBarListPicker (copy), uDim (copy), FFlagSearchOmniAutocompletePage (copy), v109 (copy), FFlagBoldSearchListPickerSuggestions (copy), GetFFlagAvatarAutocompleteEnabledForAll (copy), SearchTypes (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), propsSize (copy), u154 (ref), Images (copy), FFlagEnableAppNavGamepadRemoval (copy), ExternalEventConnection (copy), UserInputService (copy)
		local TextEmphasis = p27.Theme.TextEmphasis
		local v263 = u159

		if v263 then
			local createElement = Roact.createElement
			local v265 = DEPRECATED_ImageSetButton
			local t5 = {}
			local new = UDim2.new
			local v268 = u155
			local Tokens = p27.Tokens
			local v270 = v268 * (Tokens.Stroke and Tokens.Stroke.Standard or (Tokens.Global and Tokens.Stroke.Standard or 1))
			local v271 = u155
			local Tokens2 = p27.Tokens

			t5.Size = new(0, v270, 0, v271 * (Tokens2.Stroke and Tokens2.Stroke.Standard or (Tokens2.Global and Tokens2.Stroke.Standard or 1)))
			t5.Position = UDim2.new(0, v101, 0.5, 0)
			t5.Selectable = false
			t5.Image = "LuaApp/icons/ic-search-new"
			t5.BackgroundTransparency = 1
			t5.AnchorPoint = Vector2.new(0, 0.5)
			t5.ImageColor3 = p27.Theme.IconEmphasis.Color
			t5.ImageTransparency = p27.Theme.IconEmphasis.Transparency
			t5[Roact.Event.Activated] = p24.onSearchIconActivated
			v263 = createElement(v265, t5)
		end

		local v273 = p24.getListPickerItems()
		local v274 = u155
		local Tokens = p27.Tokens
		local v276 = v274 * (Tokens.Stroke and Tokens.Stroke.Standard or (Tokens.Global and Tokens.Stroke.Standard or 1)) - u155
		local v277 = (not FFlagQRInSearchScanner and not FFlagQRInSearchProfileQR or not v169) and 0 or 30
		local v278 = Roact.createElement(Focusable.TextBox, {
			Size = UDim2.new(1, -u157 - v276 - (not FFlagQRInSearchScanner and not FFlagQRInSearchProfileQR and 0 or v277), 1, 0),
			Position = UDim2.new(0, u156 + v276, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = p24.props.initialSearchText or "",
			Font = p27.Font.Body.Font,
			TextSize = p27.Font.BaseSize * p27.Font.Body.RelativeSize,
			TextColor3 = TextEmphasis.Color,
			TextTransparency = TextEmphasis.Transparency,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClipsDescendants = true,
			PlaceholderText = p24.props.placeholderText,
			PlaceholderColor3 = TextEmphasis.Color,
			OverlayNativeInput = true,
			TextInputType = Enum.TextInputType.NoSuggestions,
			ReturnKeyType = Enum.ReturnKeyType.Search,
			ClearTextOnFocus = false,
			[Roact.Ref] = p24.searchBoxRef,
			[Roact.Event.FocusLost] = p24.onFocusLost,
			[Roact.Event.Focused] = p24.onFocused,
			[Roact.Change.Text] = p24.onTextChanged,
			[Roact.Event.ReturnPressedFromOnScreenKeyboard] = p24.onReturnPressedFromOnScreenKeyboard,
			NextSelectionRight = if not clearButtonVisible then if not v165 then nil else p24.cancelRef else p24.clearRef,
			NextSelectionDown = if not (#v273 > 0) then if not v164 then nil else p24.searchBoxRef else p24.listPickerRef,
			SelectionImageObject = p25(CursorKind.InputFields)
		})
		local v279 = Roact.createElement(Focusable[DEPRECATED_ImageSetButton], {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, v106, 1, 0),
			Position = UDim2.new(1, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Visible = clearButtonVisible,
			[Roact.Event.Activated] = p24.onClearText,
			[Roact.Ref] = p24.clearRef,
			NextSelectionLeft = p24.searchBoxRef,
			NextSelectionDown = if not (#v273 > 0) then if not v164 then nil else p24.searchBoxRef else p24.listPickerRef,
			NextSelectionRight = not (not v165 and not isCompactView) and p24.cancelRef or nil,
			SelectionImageObject = p25(CursorKind.RoundedRectNoInset)
		}, {
			ClearImage = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, v104, 0, v104),
				Position = UDim2.new(1, -v105, 0.5, 0),
				Image = v112,
				ImageColor3 = p27.Theme.IconEmphasis.Color,
				ImageTransparency = p27.Theme.IconEmphasis.Transparency
			})
		})
		local v280 = if not FFlagQRInSearchScanner then if not FFlagQRInSearchProfileQR then nil else function() -- line: 1089
			-- upvalues: TelemetryService (copy), v113 (copy), p24 (copy), Sources (copy)
			TelemetryService:LogEvent(v113, {
				customFields = {
					btn = "myQR",
					page = p24.props.searchType
				},
				eventContext = Sources.OmniSearchBar
			})
			p24.props.navigateToProfileQrCode()
		end else function() -- line: 1082
			-- upvalues: TelemetryService (copy), v113 (copy), p24 (copy), Sources (copy)
			TelemetryService:LogEvent(v113, {
				customFields = {
					btn = "scanQR",
					page = p24.props.searchType
				},
				eventContext = Sources.OmniSearchBar
			})

			return p24:openQrCodeScanner()
		end
		local v281 = if not FFlagQRInSearchScanner and not FFlagQRInSearchProfileQR or not v169 then nil else React.createElement(View, {
			tag = "anchor-center-right position-center-right grow auto-xy padding-right-xxsmall",
			ZIndex = 3
		}, { React.createElement(FoundationImage, {
			tag = "size-700 content-emphasis",
			Image = not FFlagQRInSearchScanner and "icons/menu/scanqr" or "icons/actions/scan",
			onActivated = v280,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}) })
		local forwardRef = p24.props.forwardRef
		local createElement = Roact.createElement
		local Frame = Focusable.Frame
		local t6 = {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Ref] = forwardRef,
			NextSelectionDown = if not v164 then p24.props.NextSelectionDown else p24.searchBoxRef,
			NextSelectionRight = p24.props.NextSelectionRight,
			defaultChild = p24.searchBoxRef,
			inputBindings = if not v91 then {
				CancelSearch = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p24.doCancelSearch)
			} else nil
		}
		local t7 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v108)
			})
		}
		local createElement2 = Roact.createElement
		local t8 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}
		local new = UDim2.new
		local v290 = -v167
		local v291 = u153
		local Tokens3 = p27.Tokens

		t8.Size = new(1, v290, 0, v291 * (Tokens3.Stroke and Tokens3.Stroke.Standard or (Tokens3.Global and Tokens3.Stroke.Standard or 1)))
		t7.SearchBoxContainer = createElement2("Frame", t8, {
			SearchBoxBackground = Roact.createElement(DEPRECATED_ImageSetLabel, {
				AnchorPoint = if not p24.props.animationSettings or p24.props.animationSettings.animationStyle ~= SearchConstants.SearchBarAnimationStyle.ExpandFromCenter then nil else Vector2.new(0.5, 0),
				Size = animated and UDim2.new(0, 0, 0, 0) or UDim2.new(1, 0, 1, 0),
				Position = if not p24.props.animationSettings or p24.props.animationSettings.animationStyle ~= SearchConstants.SearchBarAnimationStyle.ExpandFromCenter then UDim2.new(0, 0, 0, 0) else UDim2.fromScale(0.5, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = t1.Image,
				ImageColor3 = p27.Theme.UIDefault.Color,
				ImageTransparency = p27.Theme.UIDefault.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = t1.SliceCenter,
				[Roact.Ref] = p24.searchBoxBackgroundRef,
				ClipsDescendants = true
			}, {
				SearchIcon = v263,
				SearchBox = v278,
				ClearButton = v279,
				QRCodeButton = if not FFlagQRInSearchScanner and not FFlagQRInSearchProfileQR then nil else v281
			})
		})
		t7.CancelButton = v165 and Roact.createElement(Focusable.TextButton, {
			Size = UDim2.new(0, 0, 0, u153),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = p26.cancelButtonText,
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = p27.Font.Body.Font,
			TextSize = p27.Font.BaseSize * p27.Font.Body.RelativeSize,
			TextColor3 = p27.Theme.TextEmphasis.Color,
			TextTransparency = p27.Theme.TextEmphasis.Transparency,
			LayoutOrder = 2,
			[Roact.Event.Activated] = p24.onCancelButtonActivated,
			[Roact.Ref] = p24.cancelRef,
			[Roact.Change.AbsoluteSize] = p24.onCancelButtonSizeChanged,
			NextSelectionLeft = clearButtonVisible and p24.clearRef or p24.searchBoxRef,
			NextSelectionDown = if not (#v273 > 0) then nil else p24.listPickerRef,
			NextSelectionRight = p24.cancelRef,
			SelectionImageObject = p25(CursorKind.RoundedRectNoInset)
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v108),
				PaddingLeft = UDim.new(0, v108),
				PaddingTop = UDim.new(0, v108),
				PaddingBottom = UDim.new(0, v108)
			})
		})

		local v293 = createElement(Frame, t6, t7)
		local v294 = v164 and Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Ref] = if not v86 then nil else p24.listPickerContainerRef
		}, {
			Picker = Roact.createElement(FitChildren.FitFrame, {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, {
				SearchBarListPicker = Roact.createElement(Focusable[SearchBarListPicker], {
					items = v273,
					width = uDim,
					height = not isCompactView and (if not FFlagSearchOmniAutocompletePage then v109 else UDim.new(0, v109)) or nil,
					[Roact.Ref] = p24.listPickerRef,
					currentKeyword = if not FFlagBoldSearchListPickerSuggestions then nil else p24.state.autocompleteKeyword,
					NextSelectionUp = p24.searchBoxRef,
					inputBindings = if not v91 then {
						CancelSearch = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p24.doCancelSearch)
					} else nil
				})
			})
		})
		local v295 = v294 and not isCompactView

		if GetFFlagAvatarAutocompleteEnabledForAll() then
			v295 = v294 and (not isCompactView or p24.props.searchType == SearchTypes.Catalog)
		end

		return Roact.createElement(FocusNavigableSurfaceWrapper, {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.SearchBar,
			frameProps = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = if not FFlagSearchOmniAutocompletePage then nil else p24.props.layoutOrder,
				Position = p24.props.position or nil,
				AnchorPoint = p24.props.anchorPoint or nil,
				Size = propsSize
			},
			customEventHandlers = if not v86 then nil else p24.customEventHandlers
		}, {
			Shadow = v295 and Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = -1,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, -19),
				Size = UDim2.new(1, 28 + u154 * 2, 1, propsSize.Y.Offset + v109 + 28 + 5 + 12),
				Image = Images["component_assets/dropshadow_16_20"],
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(28, 28, 29, 29),
				ImageColor3 = p27.Theme.DropShadow.Color,
				ImageTransparency = p27.Theme.DropShadow.Transparency
			}, {
				Background = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Position = UDim2.new(0, 14, 0, 14),
					Size = UDim2.new(1, -28, 1, -28),
					BackgroundColor3 = p27.Theme.BackgroundDefault.Color,
					BackgroundTransparency = p27.Theme.BackgroundDefault.Transparency
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 14)
					})
				})
			}),
			Bar = v293,
			Picker = v294,
			LastInputChangedListener = if not FFlagEnableAppNavGamepadRemoval then Roact.createElement(ExternalEventConnection, {
				event = UserInputService.LastInputTypeChanged,
				callback = function(p28) -- line: 1297
					-- upvalues: p24 (copy)
					p24:setState({
						lastInputType = p28
					})
				end
			}) else nil
		})
	end)
end
function v121.render(p29) -- line: 1307
	-- upvalues: withSelectionCursorProvider (copy), withLocalization (copy)
	return withSelectionCursorProvider(function(p30) -- line: 1308
		-- upvalues: withLocalization (copy), p29 (copy)
		return withLocalization({
			cancelButtonText = "Feature.GamePage.LabelCancelField"
		})(function(p31) -- line: 1311
			-- upvalues: p29 (copy), p30 (copy)
			return p29:renderWithProviders(p30, p31)
		end)
	end)
end

local function getAutocompleteFetchingStatus(p32, p33) -- line: 1317
	-- upvalues: FetchAutocompleteSuggestion (copy)
	return function(p34) -- line: 1318
		-- upvalues: FetchAutocompleteSuggestion (copy), p32 (copy), p33 (copy)
		return FetchAutocompleteSuggestion.GetFetchingStatus(p34:getState(), p32, p33)
	end
end

local v123 = RoactRodux.connect(function(p35, _) -- line: 1323
	-- upvalues: GameIconReducer (copy), FFlagSignalsNavP3hMisc (copy), getCurrentPage (copy)
	return {
		gameIcons = p35[GameIconReducer.key],
		autocompleteSuggestions = p35.AutocompleteSuggestions,
		avatarAutocompleteSuggestions = p35.AvatarExperience.AvatarAutocompleteSuggestions,
		currentPage = if FFlagSignalsNavP3hMisc then nil else getCurrentPage(p35)
	}
end, function(p37) -- line: 1330
	-- upvalues: FFlagQRInSearchScanner (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v95 (copy), NavigateDown (copy), SettingsRoute (copy), Sources (copy), FFlagQRInSearchProfileQR (copy), NavigateDownTo3DQRCodePage (copy), FetchAutocompleteSuggestion (copy), ApiFetchGameIcons (copy), FFlagUseSignalsForSearchBar (copy), GetSearchBarStore (copy), SetSearchBarFocused (copy), FFlagSearchOmniAutocompletePage (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	return {
		navigateToScanQrCode = if not FFlagQRInSearchScanner then nil else function() -- line: 1333
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v95 (copy), p37 (copy), NavigateDown (copy)
			local t9 = {
				name = AppPage.ScanQrCode
			}

			if FFlagSignalsNavP3Dispatch then
				v95.down(v95.fromLegacyPage(t9))

				return
			end

			p37(NavigateDown(t9))
		end,
		navigateToCameraPermissionOverlay = if not FFlagQRInSearchScanner then nil else function() -- line: 1345
			-- upvalues: AppPage (copy), SettingsRoute (copy), Sources (copy), FFlagSignalsNavP3Dispatch (copy), v95 (copy), p37 (copy), NavigateDown (copy)
			local t10 = {
				name = AppPage.SettingsPermissionInteractiveAlert,
				settingsRoute = SettingsRoute.Camera,
				source = Sources.OmniSearchBar
			}

			if FFlagSignalsNavP3Dispatch then
				v95.down(v95.fromLegacyPage(t10))

				return
			end

			p37(NavigateDown(t10))
		end,
		navigateToProfileQrCode = if not FFlagQRInSearchProfileQR then nil else function() -- line: 1359
			-- upvalues: p37 (copy), NavigateDownTo3DQRCodePage (copy), Sources (copy)
			p37(NavigateDownTo3DQRCodePage({
				source = Sources.OmniSearchBar
			}))
		end,
		getAutocompleteFetchingStatus = function(p38, p39) -- line: 1363
			-- upvalues: p37 (copy), FetchAutocompleteSuggestion (copy)
			return p37(function(p40) -- line: 1318
				-- upvalues: FetchAutocompleteSuggestion (copy), p38 (copy), p39 (copy)
				return FetchAutocompleteSuggestion.GetFetchingStatus(p40:getState(), p38, p39)
			end)
		end,
		fetchAutocompleteSuggestion = function(p41, p42, p43, p44) -- line: 1366
			-- upvalues: p37 (copy), FetchAutocompleteSuggestion (copy)
			p37(FetchAutocompleteSuggestion.Fetch(p41, p42, p43, p44))
		end,
		fetchGameIcons = function(p45, p46) -- line: 1369
			-- upvalues: p37 (copy), ApiFetchGameIcons (copy)
			p37(ApiFetchGameIcons(p45, p46))
		end,
		setSearchBarFocused = function(p47) -- line: 1372
			-- upvalues: FFlagUseSignalsForSearchBar (copy), GetSearchBarStore (copy), p37 (copy), SetSearchBarFocused (copy)
			if FFlagUseSignalsForSearchBar then
				GetSearchBarStore(false).setFocused(p47)

				return
			end

			return p37(SetSearchBarFocused(p47))
		end,
		dispatchSearchPageOverlay = if not FFlagSearchOmniAutocompletePage then nil else function(p48, p49, p50) -- line: 1380
			-- upvalues: p37 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
			local t11 = {
				isFocused = true,
				initialSearchText = p48,
				searchType = p49,
				placeholderText = p50
			}

			p37(SetCentralOverlay(CentralOverlayType.SearchPageOverlay, t11))
		end
	}
end)(v121)

if FFlagSignalsNavP3hMisc then
	local v124 = v123

	function v123(p51) -- line: 1395
		-- upvalues: v77 (copy), useSignalState (copy), React (copy), v124 (copy), Cryo (copy)
		local v177 = v77(false)
		local name = useSignalState(v177.getCurrentPage).name

		return React.createElement(v124, Cryo.Dictionary.join(p51, {
			currentPage = name
		}))
	end
end

if GetFFlagLuaAppAutocompleteIXPConfig() then
	v123 = RoactAppExperiment.connectUserLayer({ AppUserLayers.SearchAutocompleteLayer }, function(p52, _) -- line: 1411
		-- upvalues: AppUserLayers (copy)
		local v181 = p52[AppUserLayers.SearchAutocompleteLayer] or {}

		return {
			autocompleteIXPConfigTbl = v181,
			ixpDisableGamesAutocomplete = v181.ixpDisableGamesAutocomplete == "true"
		}
	end)(v123)
end

local u125 = RoactServices.connect({
	networking = RoactNetworking,
	eventIngest = AppEventIngestService,
	sessionService = AppSessionService
})(v123)

return Roact.forwardRef(function(p54, p55) -- line: 1426
	-- upvalues: v86 (copy), ReactFocusNavigation (copy), Roact (copy), u125 (ref), Cryo (copy)
	local v184 = if not v86 then nil else ReactFocusNavigation.useFocusGuiObject()
	local v185 = if not v86 then nil else ReactFocusNavigation.useFocusedGuiObject()

	return Roact.createElement(u125, Cryo.Dictionary.join(p54, {
		forwardRef = p55,
		focusGuiObject = v184,
		focusedGuiObject = v185
	}))
end)
