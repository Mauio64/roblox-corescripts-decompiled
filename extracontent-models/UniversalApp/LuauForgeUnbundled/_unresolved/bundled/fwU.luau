local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Cryo = require(CorePackages.Packages.Cryo)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local module = require("@luauforge/bundled/ehL")
local focusNavigableSurfaceWrapper = module.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local sessionType = require("@luauforge/bundled/fwa").SessionType
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local module2 = require("@luauforge/bundled/dSY")
local dataStatus = module2.DataStatus
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").CentralOverlayType
local module4 = require("@luauforge/bundled/egz")
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local view = Foundation.View
local image = Foundation.Image
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local default = require("@luauforge/bundled/bZh").PermissionsProtocol.default
local settingsRoute = require("@luauforge/bundled/bZe").Enums.SettingsRoute
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local module5 = require("@luauforge/bundled/ecs")
local eventTypes = module5.Analytics.Enums.EventTypes
local supportedTelemetryBackends = module5.Analytics.Enums.SupportedTelemetryBackends
local sources = module5.Analytics.Enums.Sources

local searchConstants = require("@luauforge/bundled/dtb").Modules.Personalization.Search.SearchConstants

local module6 = require("@luauforge/bundled/fwX")
local module7 = require("@luauforge/bundled/egF")
local module8 = require("@luauforge/bundled/egM")
local module9 = require("@luauforge/bundled/fwY")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local module11 = require("@luauforge/bundled/fxa")
local module12 = require("@luauforge/bundled/dCM")
local module13 = require("@luauforge/bundled/egx")
local module14 = require("@luauforge/bundled/fwO")
local module15 = require("@luauforge/bundled/fyz")
local module16 = require("@luauforge/bundled/fyB")
local module17 = require("@luauforge/bundled/fyC")
local module18 = require("@luauforge/bundled/fyD")
local module19 = require("@luauforge/bundled/fyE")
local module20 = require("@luauforge/bundled/fyF")
local module21 = require("@luauforge/bundled/ehB")
local module22 = require("@luauforge/bundled/eia")
local module23 = require("@luauforge/bundled/dFu")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local getSearchBarStore = require("@luauforge/bundled/fyG").GetSearchBarStore

local module25 = require("@luauforge/bundled/fyA")

local module26 = require("@luauforge/bundled/fyL")

local module27 = require("@luauforge/bundled/fyM")
local module28 = require("@luauforge/bundled/dXj")
local fFlagUseSignalsForSearchBar = SharedFlags.FFlagUseSignalsForSearchBar
local fFlagUsesCancelSearchAppPolicy = SharedFlags.FFlagUsesCancelSearchAppPolicy
local fFlagQRInSearchScanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRInSearchScanner
local fFlagQRInSearchProfileQR = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRInSearchProfileQR
local defineFastFlag = game:DefineFastFlag("AXMigrateSearchBarToFocusNavigation", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppNewSlpEndpointIxpEnabled", false)
local fFlagSduiSearchClientTemplateCache = game:DefineFastFlag("SearchSduiTemplatePrewarm", false)
	and SharedFlags.FFlagSduiSearchClientTemplateCache
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local defineFastString = game:DefineFastString(
	"LuaAppNewSlpEndpointIxpLayer",
	"Growth.Omnisearch.SearchLandingPage"
)
local defineFastFlag3 = game:DefineFastFlag("LuaAppSduiSearchAutocompleteIxpEnabled", false)

local defineFastString2 = game:DefineFastString(
	"LuaAppSduiSearchAutocompleteIxpLayer",
	"Growth.Omnisearch.SearchLandingPage.Autocomplete"
)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXFixEmptyCatalogSearchChrome = AvatarExperienceFlags.FFlagAXFixEmptyCatalogSearchChrome
local fFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete
local openSearchResultsWithQueryBridge

if fFlagLuaAppSduiSearchAutocomplete then
	openSearchResultsWithQueryBridge = require("@luauforge/bundled/dDZ").OpenSearchResultsWithQueryBridge
else
	openSearchResultsWithQueryBridge = nil
end

local v5 = if fFlagLuaAppSduiSearchAutocomplete then require("@luauforge/bundled/fwb") else nil

local v6 = if fFlagLuaAppSduiSearchAutocomplete then require("@luauforge/bundled/dXB") else nil

local sduiSearchAutocomplete = if fFlagLuaAppSduiSearchAutocomplete then v5.SduiSearchAutocomplete else nil

local fetchSearchAutocompleteIfNeeded = if fFlagLuaAppSduiSearchAutocomplete then v5.fetchSearchAutocompleteIfNeeded else nil

local prewarmSearchAutocompleteTemplates = if fFlagLuaAppSduiSearchAutocomplete then v5.prewarmSearchAutocompleteTemplates else nil

local toLegacyAutocompleteSuggestion = if fFlagLuaAppSduiSearchAutocomplete then v5.toLegacyAutocompleteSuggestion else nil
local createSearchAutocompleteRequestContext

if fFlagLuaAppSduiSearchAutocomplete then
	createSearchAutocompleteRequestContext = v5.createSearchAutocompleteRequestContext
else
	createSearchAutocompleteRequestContext = nil
end

local sduiLoadTimer = if fFlagLuaAppSduiSearchAutocomplete then v6.SduiLoadTimer else nil

local module30 = require("@luauforge/bundled/fxg")

local recentSearchTermsAppStorage = module30.Utils.RecentSearchTermsAppStorage
local fFlagAXUnifiedAutocompleteEndpoint = AvatarExperienceFlags.FFlagAXUnifiedAutocompleteEndpoint
local getAutocompleteQueryKey = module30.Utils.getAutocompleteQueryKey

local SEARCH_BAR_HEIGHT = searchConstants.SEARCH_BAR_HEIGHT
local SEARCH_BAR_PADDING = searchConstants.SEARCH_BAR_PADDING
local SEARCH_BAR_TEXT_SIZE = searchConstants.SEARCH_BAR_TEXT_SIZE
local SEARCH_BAR_ICON_PADDING = searchConstants.SEARCH_BAR_ICON_PADDING
local SEARCH_BAR_TEXT_PADDING_WITH_ICON = searchConstants.SEARCH_BAR_TEXT_PADDING_WITH_ICON
local SEARCH_BAR_TEXT_PADDING_WITHOUT_ICON = searchConstants.SEARCH_BAR_TEXT_PADDING_WITHOUT_ICON
local CLEAR_IMAGE_SIZE = searchConstants.CLEAR_IMAGE_SIZE
local CLEAR_IMAGE_PADDING = searchConstants.CLEAR_IMAGE_PADDING
local v7 = CLEAR_IMAGE_PADDING * 2 + CLEAR_IMAGE_SIZE
local CANCEL_BUTTON_WIDTH = searchConstants.CANCEL_BUTTON_WIDTH
local CANCEL_BUTTON_PADDING = searchConstants.CANCEL_BUTTON_PADDING
local TABLET_LIST_PICKER_HEIGHT = searchConstants.TABLET_LIST_PICKER_HEIGHT
local v8 = module25() / 1000

local v9 = { Image = "LuaApp/buttons/buttonFill", SliceCenter = Rect.new(8, 8, 9, 9) }

local iconsactionseditclear_small = images["icons/actions/edit/clear_small"]

local v10 = (fFlagQRInSearchScanner or fFlagQRInSearchProfileQR) and {
	eventName = eventTypes.ButtonClick,
	backends = { supportedTelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("QRClickInOmniSearchThrottlingPercentage", 10000),
	lastUpdated = { 25, 11, 6 },
	description = "QR code button in SearchBar",
	links = ""
} or nil

local platform = UserInputService:GetPlatform()
local tenFootInterface = isTenFootInterface()
local v11 = platform == Enum.Platform.IOS or platform == Enum.Platform.Android
local v12 = platform == Enum.Platform.Android

local function applyTokenScaling(p2, p3)
	return p2 * (p3.Stroke and p3.Stroke.Standard or 1)
end

local extended = Roact.PureComponent:extend("SearchBar")

local strictInterface = t.strictInterface
local v13 = {
	["Size"] = nil,
	["Size"] = nil,
	["Size"] = nil,
	["Size"] = nil,
	Size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	cancelSearch = t.optional(t.callback),
	confirmSearch = t.optional(t.callback),
	onTextCleared = t.optional(t.callback),
	onClearButtonActivated = t.optional(t.callback),
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
	forceShowCancelButton = t.optional(t.boolean),
	onSameTermConfirmSearch = t.optional(t.callback),
	searchPageOverlayEnabled = t.optional(t.boolean),
	disableListPicker = t.optional(t.boolean),
	onTextChanged = t.optional(t.callback),
	listPickerRef = t.optional(t.table)
}
local v14 = if fFlagLuaAppSduiSearchAutocomplete then t.optional(t.table) else nil
v13.searchBoxRef = v14
local v15 = if fFlagLuaAppSduiSearchAutocomplete then t.optional(t.number) else nil
v13.screenHeight = v15
local v16 = if fFlagLuaAppSduiSearchAutocomplete then t.optional(t.number) else nil
v13.topBarHeight = v16
local v17 = if fFlagLuaAppSduiSearchAutocomplete then t.optional(t.table) else nil
v13.globalGuiInset = v17
v13.onPickerItemsChanged = t.optional(t.callback)
v13.layoutOrder = t.optional(t.integer)
v13.updateAutocompleteOnMount = t.optional(t.boolean)
v13.onExitSearch = t.optional(t.callback)
local v18 = if fFlagLuaAppSduiSearchAutocomplete then t.optional(t.callback) else nil
v13.onSduiAutocompleteChanged = v18

v13.focusGuiObject = t.optional(t.callback)
v13.focusedGuiObject = t.optional(t.Instance)

v13.gameIcons = t.optional(t.table)
v13.autocompleteSuggestions = t.optional(t.table)
v13.avatarAutocompleteSuggestions = t.optional(t.table)
local v19 = if fFlagSignalsNavP3dRouteGated then t.optional(t.string) else t.string
v13.currentPage = v19
v13.getAutocompleteFetchingStatus = t.callback

v13.fetchAutocompleteSuggestion = t.callback
v13.fetchGameIcons = t.callback
v13.setSearchBarFocused = t.callback
v13.dispatchSearchPageOverlay = t.callback
local v20 = if fFlagQRInSearchScanner then t.callback else nil
v13.navigateToScanQrCode = v20
local v21 = if fFlagQRInSearchScanner then t.callback else nil
v13.navigateToCameraPermissionOverlay = v21
local v22 = if fFlagQRInSearchProfileQR then t.callback else nil
v13.navigateToProfileQrCode = v22

v13.networking = t.callback
v13.eventIngest = t.table
v13.sessionService = t.optional(t.union(t.Instance, t.table))

v13.shouldShowRecentSearchTerms = t.optional(t.boolean)
extended.validateProps = strictInterface(v13)

extended.defaultProps = {
	Size = UDim2.new(1, 0, 1, 0),
	cancelSearch = nil,
	confirmSearch = nil,
	onTextCleared = nil,
	onClearButtonActivated = nil,
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
	forceShowCancelButton = false
}

function extended:init()
	local initialSearchText = self.props.initialSearchText or ""
	function self.getRichSuggestionUniverseIds()
		local universeIds = {}
		local function collect(items)
			if type(items) ~= "table" then
				return
			end

			for k, item in items do
				if not (type(item) == "table" and type(item.entries) == "table") then
					continue
				end

				for k2, entry in item.entries do
					if entry.type == module14.EntryType.Rich and entry.universeId then
						table.insert(universeIds, (tostring(entry.universeId)))
					end
				end
			end
		end
		collect(self.props.autocompleteSuggestions)
		collect(self.props.avatarAutocompleteSuggestions)
		return universeIds
	end

	self.gameIconsSubscription = GameHydrationReact.subscribeGameIcons({
		universeIds = self.getRichSuggestionUniverseIds(),
		onChange = function(p2)
			self:setState({ gameIcons = p2 })
		end
	})

	self.state = {
		clearButtonVisible = initialSearchText ~= "",
		autocompleteKeyword = "",
		listPickerShown = false,
		cancelButtonWidth = CANCEL_BUTTON_WIDTH,
		gameIcons = self.gameIconsSubscription.getCurrent()
	}

	self.searchBoxBackgroundRef = Roact.createRef()

	local v23 = if fFlagLuaAppSduiSearchAutocomplete then self.props.searchBoxRef or Roact.createRef() else Roact.createRef()
	self.searchBoxRef = v23

	self.clearRef = Roact.createRef()
	self.cancelRef = Roact.createRef()
	self.listPickerRef = self.props.listPickerRef or Roact.createRef()
	self.listPickerContainerRef = Roact.createRef()

	self.lastSearchBoxText = initialSearchText or ""
	self.lastAutocompleteUpdateTime = 0
	self.lastAutocompleteCached = false

	self.lastAutocompleteEventKeyword = ""
	self.lastStoredListPickerItems = {}

	self.customEventHandlers = {
		[module.FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object2)
				local isSearching = self.props.isSearching
				local listPickerShown = self.state.listPickerShown

				if isSearching then
					if listPickerShown then
						local current = self.listPickerRef.current
						local current2 = self.listPickerContainerRef.current
						local focusedGuiObject = self.props.focusedGuiObject

						if
							current2
							and focusedGuiObject
							and current
							and focusedGuiObject:IsDescendantOf(current2)
						then
							self.doCancelSearch()

							if self.props.focusGuiObject and self.searchBoxRef then
								self.props.focusGuiObject(self.searchBoxRef.current)
							end
						end
					else
						self.doCancelSearch()
					end

					object2:cancel()
				end
			end)
		}
	}

	function self.reportSduiAutocompleteSuggestion(lastAutocompleteEventKeyword, p2, p3)
		if self.lastAutocompleteEventKeyword == lastAutocompleteEventKeyword then
			return
		end

		local v25 = toLegacyAutocompleteSuggestion((v6.getSduiApiStore().getInputData(
			v5.getSearchAutocompleteConfigKey(lastAutocompleteEventKeyword),
			v5.SearchAutocompleteInputDataIdentifier
		)))

		if v25 == nil then
			return
		end

		local v26

		if fFlagSignalsNavP3dRouteGated then
			v26 = getLegacyNavigationStore(false).getCurrentPage(false).name
		else
			v26 = self.props.currentPage
		end

		local v27 = (tick() - self.lastAutocompleteUpdateTime) * 1000

		if module27() then
			module16(
				self.props.eventIngest,
				self.getEventContext(),
				lastAutocompleteEventKeyword,
				self.lastAutocompleteEventKeyword,
				v25,
				v26,
				v27,
				p3,
				p2
			)
		else
			module15(
				self.props.eventIngest,
				self.getEventContext(),
				lastAutocompleteEventKeyword,
				self.lastAutocompleteEventKeyword,
				v25,
				v26,
				v27,
				p3
			)
		end

		self.lastAutocompleteEventKeyword = lastAutocompleteEventKeyword
	end

	function self.requestAutocompleteSuggestion(p2)
		if
			fFlagLuaAppSduiSearchAutocomplete
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
		then
			local searchType = self.props.searchType
			local searchAutocompleteRequestContext, v25 = createSearchAutocompleteRequestContext(
				p2,
				searchType,
				function()
					return self.isMounted, self.state.autocompleteKeyword, self.props.searchType
				end
			)

			fetchSearchAutocompleteIfNeeded(p2, sduiLoadTimer.createLoadTimer("SearchAutocomplete"), v25):andThen(function(p3)
				if
					not v25()
					or fFlagLuaAppSduiSearchAutocomplete
					and not self:isActiveSduiAutocompleteHost(searchAutocompleteRequestContext)
				then
					return
				end

				self.reportSduiAutocompleteSuggestion(p2, searchType, p3)
			end):catch(function() end)
		else
			local networking = self.props.networking
			self.props.fetchAutocompleteSuggestion(networking, p2, nil, self.props.searchType)
		end
	end

	function self.requestRichSuggestionIcons(p2)
		local networking = self.props.networking
		local fetchGameIcons = self.props.fetchGameIcons
		local universeIds = {}

		for i = 1, #p2.entries do
			local entry = p2.entries[i]

			if entry.type == module14.EntryType.Rich then
				table.insert(universeIds, entry.universeId)
			end
		end

		if #universeIds > 0 then
			fetchGameIcons(networking, universeIds)
		end
	end

	function self.updateAutocomplete(value)
		if value == self.state.autocompleteKeyword or module26() < string.len(value) then
			return
		end

		local v25

		if not (fFlagLuaAppSduiSearchAutocomplete and module4.isSearchTypeInOmniSearch(self.props.searchType)) then
			v25 = self.getCachedAutocompleteSuggestion(value)
		end

		local v26 = not (fFlagLuaAppSduiSearchAutocomplete and module4.isSearchTypeInOmniSearch(self.props.searchType))

		if v26 then
			v26 = not (v25 == nil) and tick() < v25.expirationTime
		end

		self.lastAutocompleteUpdateTime = tick()
		self.lastAutocompleteCached = v26

		if
			fFlagLuaAppSduiSearchAutocomplete
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
			and value ~= ""
			and self.searchBoxRef.current ~= nil
			and self.searchBoxRef.current:IsFocused()
		then
			local sduiApiStore = v6.getSduiApiStore()
			local searchAutocompleteConfigKey = v5.getSearchAutocompleteConfigKey(value)
			local data, v27 = sduiApiStore.getData(searchAutocompleteConfigKey)

			if
				data.status(false) == dataStatus.Ready
				and not (v27 or sduiApiStore.isInFlight(searchAutocompleteConfigKey))
			then
				self.reportSduiAutocompleteSuggestion(value, self.props.searchType, true)
			end
		end

		self:setState({ autocompleteKeyword = value })

		if
			fFlagLuaAppSduiSearchAutocomplete
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
			and self.props.onSduiAutocompleteChanged
		then
			self.props.onSduiAutocompleteChanged(value)
		end

		if value == "" or v26 then
			if v26 and v25.preloadedCache then
				self.requestRichSuggestionIcons(v25)
			end
		elseif
			fFlagLuaAppSduiSearchAutocomplete
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
		then
			local searchType = self.props.searchType
			task.delay(v8, function()
				if
					self.isMounted
					and value == self.state.autocompleteKeyword
					and searchType == self.props.searchType
				then
					self.requestAutocompleteSuggestion(value)
				end
			end)
		else
			local now = tick()
			spawn(function()
				local v27 = value
				local v28 = now + v8 - tick()

				if v28 > 0 then
					wait(v28)
				end

				if not self.isMounted then
					return
				end

				if v27 == self.state.autocompleteKeyword then
					self.requestAutocompleteSuggestion(v27)
				end
			end)
		end
	end

	function self.doConfirmSearch(text, p2, p3, p4)
		if not self.isMounted then
			return
		end

		local current = self.searchBoxRef.current

		if current and current:IsFocused() then
			if fFlagLuaAppSduiSearchAutocomplete and p2 and p4 ~= nil then
				self.confirmingSduiSuggestion = true
			end

			current:ReleaseFocus()
		end

		if module4.isSearchTypeInOmniSearch(self.props.searchType) and text == "" then
			return
		end

		if
			fFlagAXFixEmptyCatalogSearchChrome
			and self.props.searchType == searchTypes.Catalog
			and (typeof(text) ~= "string" or text:match("%S") == nil)
		then
			if current then
				current.Text = self.props.initialSearchText or ""
			end

			if self.props.onSameTermConfirmSearch then
				self.props.onSameTermConfirmSearch()
			end
		elseif
			self.props.initialSearchText == text
			and (not fFlagLuaAppSduiSearchAutocomplete or p4 == nil or p4 == self.props.searchType)
		then
			if self.props.shouldShowRecentSearchTerms then
				if self.searchBoxRef and self.searchBoxRef.current then
					self.searchBoxRef.current.Text = text
				end

				if self.props.onSameTermConfirmSearch then
					self.props.onSameTermConfirmSearch()
				end
			end
		else
			local confirmSearch = self.props.confirmSearch

			if confirmSearch then
				if fFlagLuaAppSduiSearchAutocomplete and p4 ~= nil then
					confirmSearch(text, p2, p3, p4)
				elseif module27() then
					confirmSearch(text, p2, p3)
				else
					confirmSearch(text, p2)
				end
			end
		end
	end

	function self.doCancelSearch()
		if not self.isMounted then
			return
		end

		local current = self.searchBoxRef.current

		if current and current:IsFocused() then
			current:ReleaseFocus()
		end

		local cancelSearch = self.props.cancelSearch
		local onExitSearch = self.props.onExitSearch

		if self.props.searchPageOverlayEnabled then
			if onExitSearch then
				onExitSearch()
			end
		elseif cancelSearch then
			cancelSearch()
		end

		if current then
			self.searchBoxRef.current.Text = self.props.initialSearchText
		end
	end

	function self.onFocused()
		if not self.isMounted then
			return
		end

		if
			fFlagSduiSearchClientTemplateCache
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
		then
			require("@luauforge/bundled/fwb").prewarmSearchResultsTemplates()
		end

		if
			fFlagLuaAppSduiSearchAutocomplete
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
		then
			prewarmSearchAutocompleteTemplates():catch(function() end)
		end

		self.props.setSearchBarFocused(true)
		IXPService:LogUserLayerExposure(appUserLayers.SearchLandingPageLayer)

		if defineFastFlag2 then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end

		if defineFastFlag3 and module4.isSearchTypeInOmniSearch(self.props.searchType) then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString2)
		end

		if self.props.searchPageOverlayEnabled then
			local current = self.searchBoxRef.current

			if current and current:IsFocused() then
				self.doCancelSearch()
			end

			self.props.dispatchSearchPageOverlay(
				self.props.initialSearchText,
				self.props.searchType,
				self.props.placeholderText
			)
		elseif self.props.onFocused then
			self.props.onFocused()
		end
	end

	function self.onFocusLost(p2, p3, p4)
		if not self.isMounted then
			return
		end

		self.props.setSearchBarFocused(false)

		if fFlagLuaAppSduiSearchAutocomplete and self.confirmingSduiSuggestion then
			self.confirmingSduiSuggestion = false
		elseif p4 == nil and (v12 or tenFootInterface) and not isVRAppBuild() then
			if not fFlagUsesCancelSearchAppPolicy then
				self.doCancelSearch()
				return
			end

			local getCancelSearchOnLostFocus = getAppFeaturePolicies().getCancelSearchOnLostFocus

			if getCancelSearchOnLostFocus == nil or getCancelSearchOnLostFocus() then
				self.doCancelSearch()
			end
		elseif
			p4 ~= nil and p4.KeyCode == Enum.KeyCode.Return
			or p3 and (not v11 or RunService:IsStudio())
		then
			self.doConfirmSearch(p2.Text)
		end
	end

	function self.onReturnPressedFromOnScreenKeyboard(p2)
		self.doConfirmSearch(p2.Text)
	end

	function self.onCancelButtonActivated()
		if self.isMounted then
			self.doCancelSearch()
			local sessionService = self.props.sessionService

			if sessionService:SessionExists(sessionType.StructuralIdentifier.GameSearchAutocomplete) then
				sessionService:RemoveSession(sessionType.StructuralIdentifier.GameSearchAutocomplete)
			end
		end
	end

	function self.onClearText()
		if not self.isMounted then
			return
		end

		if self.searchBoxRef.current then
			local eventIngest = self.props.eventIngest
			local text = self.searchBoxRef.current.Text
			local searchType = self.props.searchType

			module18(eventIngest, self.getEventContext(), text, searchType)

			if module28 and self.props.onClearButtonActivated then
				self.props.onClearButtonActivated()
			elseif self.props.searchPageOverlayEnabled then
				self.props.dispatchSearchPageOverlay("", self.props.searchType, self.props.placeholderText)
			else
				self.searchBoxRef.current.Text = ""
				self.searchBoxRef.current:captureFocus()
			end
		end
	end

	function self.onTextChanged(object2)
		if not (self.isMounted and object2) then
			return
		end

		local text = object2.Text
		local v25 = text ~= ""

		if v25 ~= self.state.clearButtonVisible then
			self:setState({ clearButtonVisible = v25 })
		end

		if self.props.autocomplete then
			local lower = text:lower()
			local keywordNormalize = module6.KeywordNormalize(lower)

			local v26 = fFlagAXUnifiedAutocompleteEndpoint
				and self.props.searchType == searchTypes.Catalog
				and (getAutocompleteQueryKey(text) or "")
				or keywordNormalize

			self.updateAutocomplete(v26)
		end

		if object2:IsFocused() then
			local lastSearchBoxText = self.lastSearchBoxText

			if string.len(text) < string.len(lastSearchBoxText) then
				local searchType = self.props.searchType
				module17(
					self.props.eventIngest,
					self.getEventContext(),
					lastSearchBoxText,
					text,
					searchType
				)
			end
		end

		self.lastSearchBoxText = text

		local onTextCleared = text == "" and self.props.onTextCleared

		if onTextCleared then
			onTextCleared()
		end

		if self.props.onTextChanged then
			self.props.onTextChanged(text)
		end
	end

	function self.onCancelButtonSizeChanged(p2)
		if p2 then
			self:setState({ cancelButtonWidth = p2.AbsoluteSize.X })
		end
	end

	function self.getListPickerItems()
		local result = {}
		local autocompleteKeyword = self.state.autocompleteKeyword

		if autocompleteKeyword == "" then
			self.lastStoredListPickerItems = result
			return result
		end

		if
			fFlagLuaAppSduiSearchAutocomplete
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
		then
			self.lastStoredListPickerItems = result
			return result
		end

		local cachedAutocompleteSuggestion = self.getCachedAutocompleteSuggestion(autocompleteKeyword)

		local set = {}

		if self.props.shouldShowRecentSearchTerms then
			local v25

			if fFlagAXUnifiedAutocompleteEndpoint and self.props.searchType == searchTypes.Catalog then
				v25 = recentSearchTermsAppStorage.findTermsForAutocompleteKey(autocompleteKeyword)
			else
				v25 = recentSearchTermsAppStorage.findTermsForQuery(autocompleteKeyword)
			end

			for k, v26 in v25 do
				set[v26] = true
				table.insert(result, {
					isRichItem = false,
					isRecentCatalogSearchItem = true,
					displayIcon = nil,
					text = v26,
					onSelect = function()
						local doConfirmSearch = self.doConfirmSearch
						local v27 = v26

						local v29 = if cachedAutocompleteSuggestion then cachedAutocompleteSuggestion.entries else nil
						doConfirmSearch(v27, false, v29)
					end
				})
			end
		end

		if not cachedAutocompleteSuggestion then
			local autocompleteFetchingStatus = self.props.getAutocompleteFetchingStatus(
				autocompleteKeyword,
				self.props.searchType
			)

			if
				autocompleteFetchingStatus == retrievalStatus.NotStarted
				or autocompleteFetchingStatus == retrievalStatus.Fetching
			then
				return self.lastStoredListPickerItems
			end
		end

		if cachedAutocompleteSuggestion then
			local gameIcons = self.state.gameIcons

			for i = 1, #cachedAutocompleteSuggestion.entries do
				local entry = cachedAutocompleteSuggestion.entries[i]
				local v25 = false
				local url = nil
				local v26 = ""
				local v27 = ""

				if entry.type == module14.EntryType.Rich then
					v25 = true
					local gameIcon = gameIcons[tostring(entry.universeId)]

					if gameIcon then
						url = gameIcon.url
					end

					v26 = entry.canonicalTitle
					v27 = entry.canonicalTitle
				elseif entry.type == module14.EntryType.Keyword then
					v26 = entry.searchQuery:lower()
					v27 = v26
				end

				if not (self.props.shouldShowRecentSearchTerms and set[v26]) then
					table.insert(result, {
						isRichItem = v25,
						displayIcon = url,
						text = v26,
						onSelect = function()
							module19(
								self.props.eventIngest,
								self.getEventContext(),
								autocompleteKeyword,
								self.props.searchType,
								cachedAutocompleteSuggestion.entries,
								i,
								entry
							)

							self.doConfirmSearch(v27, true, cachedAutocompleteSuggestion.entries)

							if
								fFlagAXUnifiedAutocompleteEndpoint
								and self.props.searchType == searchTypes.Catalog
							then
								local autocompleteQueryKey = getAutocompleteQueryKey(v27)

								if
									autocompleteQueryKey
									and not self.getCachedAutocompleteSuggestion(autocompleteQueryKey)
								then
									self.requestAutocompleteSuggestion(autocompleteQueryKey)
								end
							elseif not self.getCachedAutocompleteSuggestion(v27) then
								self.requestAutocompleteSuggestion(v27)
							end
						end
					})
				end
			end
		end

		self.lastStoredListPickerItems = result
		return result
	end

	function self.getCachedAutocompleteSuggestion(p2)
		local v25 = self.props.autocompleteSuggestions

		if module27() and self.props.searchType == searchTypes.Catalog then
			v25 = self.props.avatarAutocompleteSuggestions
		end

		return v25[p2]
	end

	function self.getEventContext(): string
		if module27() and self.props.searchType == searchTypes.Catalog then
			return "AvatarShopSearch"
		end

		return "GameSearch"
	end

	function self.updateAutocompleteEvent()
		local autocomplete = self.props.autocomplete

		if
			fFlagLuaAppSduiSearchAutocomplete
			and module4.isSearchTypeInOmniSearch(self.props.searchType)
		then
			return
		end

		if autocomplete then
			local autocompleteKeyword = self.state.autocompleteKeyword
			local v25 = self.lastAutocompleteEventKeyword ~= autocompleteKeyword
				and self.getCachedAutocompleteSuggestion(autocompleteKeyword)

			if v25 then
				local eventIngest = self.props.eventIngest
				local v26

				if fFlagSignalsNavP3dRouteGated then
					v26 = getLegacyNavigationStore(false).getCurrentPage(false).name
				else
					v26 = self.props.currentPage
				end

				local v27 = (tick() - self.lastAutocompleteUpdateTime) * 1000

				if module27() then
					module16(
						eventIngest,
						self.getEventContext(),
						autocompleteKeyword,
						self.lastAutocompleteEventKeyword,
						v25,
						v26,
						v27,
						self.lastAutocompleteCached,
						self.props.searchType
					)
				else
					module15(
						eventIngest,
						"GameSearch",
						autocompleteKeyword,
						self.lastAutocompleteEventKeyword,
						v25,
						v26,
						v27,
						self.lastAutocompleteCached
					)
				end

				self.lastAutocompleteEventKeyword = autocompleteKeyword
			end
		end
	end

	function self.onSearchIconActivated()
		local current = self.searchBoxRef.current
		local isSearching = self.props.isSearching

		if current and isSearching and not current:IsFocused() then
			current:CaptureFocus()
		end
	end
end

if fFlagQRInSearchScanner then
	function extended.openQrCodeScanner(p2)
		default.default:checkOrRequestPermissions({ default.Permissions.CAMERA_ACCESS }):andThen(function(p3)
			if p3 == default.Status.AUTHORIZED then
				p2.props.navigateToScanQrCode()
			else
				p2.props.navigateToCameraPermissionOverlay()
			end
		end)
	end
end

function extended:didUpdate(p2)
	if
		p2.autocompleteSuggestions ~= self.props.autocompleteSuggestions
		or p2.avatarAutocompleteSuggestions ~= self.props.avatarAutocompleteSuggestions
	then
		self.gameIconsSubscription.update(self.getRichSuggestionUniverseIds())
	end

	local current = self.searchBoxRef.current

	if current then
		local isSearching = self.props.isSearching
		local listPickerShown = self.state.listPickerShown

		if isSearching then
			local autocompleteKeyword = self.state.autocompleteKeyword

			if not listPickerShown and autocompleteKeyword ~= "" then
				self:setState({ listPickerShown = true })
			end
		elseif listPickerShown then
			self:setState({ listPickerShown = false })
		end
	end

	if self.cancelRef.current and self.state.cancelButtonWidth ~= self.cancelRef.current.AbsoluteSize.X then
		self:setState({ cancelButtonWidth = self.cancelRef.current.AbsoluteSize.X })
	end

	if current and current:IsFocused() then
		self.updateAutocompleteEvent()
	end

	if self.props.onPickerItemsChanged then
		if not self.previousPickerItems then
			self.previousPickerItems = {}
		end

		local previousPickerItems = self.previousPickerItems
		local lastStoredListPickerItems = self.lastStoredListPickerItems

		local v23 = true

		if #previousPickerItems == #lastStoredListPickerItems then
			for i = 1, #lastStoredListPickerItems do
				if previousPickerItems[i].text ~= lastStoredListPickerItems[i].text then
					v23 = false
					break
				end
			end
		else
			v23 = false
		end

		if not v23 then
			self.previousPickerItems = lastStoredListPickerItems
			self.props.onPickerItemsChanged(lastStoredListPickerItems)
		end
	end
end

function extended:isActiveSduiAutocompleteHost(value)
	local v23 = self.isMounted
		and self.props.autocomplete
		and self.props.isSearching
		and self.state.listPickerShown

	if not v23 then
		return v23
	end

	if self.props.disableListPicker and self.props.onSduiAutocompleteChanged == nil then
		v23 = false
	else
		v23 = module4.isSearchTypeInOmniSearch(self.props.searchType)

		if v23 then
			if self.state.autocompleteKeyword == "" or self.props.confirmSearch == nil then
				v23 = false
			else
				v23 = value:match("^SearchAutocomplete%-") ~= nil
			end
		end
	end

	return v23
end

function extended:didMount()
	self.isMounted = true

	if fFlagLuaAppSduiSearchAutocomplete then
		self.autocompleteHostConnection = openSearchResultsWithQueryBridge.connectAutocompleteHost(
			function(p2, p3, p4): boolean
				if not self:isActiveSduiAutocompleteHost(p4) then
					return false
				end

				self.doConfirmSearch(p2, true, {}, p3)
				return true
			end,
			function(p2, p3, p4, p5): boolean
				if not self:isActiveSduiAutocompleteHost(p2) then
					return false
				end

				local clickedSuggestion = v5.getClickedSuggestion(
					v6.getSduiApiStore().getInputData(p2, v5.SearchAutocompleteInputDataIdentifier),
					toLegacyAutocompleteSuggestion,
					p3,
					p4,
					p5
				)

				if clickedSuggestion then
					module19(
						self.props.eventIngest,
						self.getEventContext(),
						p3,
						self.props.searchType,
						clickedSuggestion.entries,
						p5,
						clickedSuggestion.entry
					)
				end

				return true
			end
		)
	end

	if self.animationMotor then
		self.animationMotor:destroy()
	end

	self.animationMotor = Otter.createSingleMotor(0)
	self.animationMotor:onStep(function(p2)
		local current = self.isMounted and self.searchBoxBackgroundRef.current

		if current then
			if
				self.props.animationSettings
				and self.props.animationSettings.animationStyle == searchConstants.SearchBarAnimationStyle.ExpandFromCenter
			then
				local originalWidth = self.props.animationSettings.originalWidth or 0
				local v23 = CANCEL_BUTTON_PADDING + CANCEL_BUTTON_WIDTH

				current.Size = UDim2.new(p2, originalWidth * (1 - p2), 1, 0)
				current.Position = UDim2.new(0.5, v23 / 2 * (1 - p2), 0, 0)
			else
				current.Size = UDim2.new(p2, 0, 1, 0)
				current.Position = UDim2.new(1 - p2, 0, 0, 0)
			end
		end
	end)

	if self.props.animated then
		self.animationMotor:setGoal(Otter.spring(1, { dampingRatio = 1, frequency = 4 }))
	end

	local current = self.searchBoxRef.current

	if current and self.props.isSearching and not current:IsFocused() then
		current:CaptureFocus()
	end

	if self.props.updateAutocompleteOnMount and self.props.autocomplete and current then
		local text = current.Text:lower()
		local keywordNormalize = module6.KeywordNormalize(text)
		local v23 = fFlagAXUnifiedAutocompleteEndpoint
			and self.props.searchType == searchTypes.Catalog
			and (getAutocompleteQueryKey(current.Text) or "")
			or keywordNormalize

		self.updateAutocomplete(v23)
	end

	if self.cancelRef.current then
		self:setState({ cancelButtonWidth = self.cancelRef.current.AbsoluteSize.X })
	end
end

function extended:willUnmount()
	self.isMounted = false

	if fFlagLuaAppSduiSearchAutocomplete and self.autocompleteHostConnection then
		self.autocompleteHostConnection:disconnect()
	end

	self.gameIconsSubscription.dispose()

	if self.animationMotor then
		self.animationMotor:destroy()
	end
end

function extended:renderWithProviders(callback, p2)
	local size = self.props.Size
	local isCompactView = self.props.isCompactView
	local modernUI = self.props.modernUI
	local clearButtonVisible = self.state.clearButtonVisible

	local v23 = SEARCH_BAR_HEIGHT
	local v24 = SEARCH_BAR_PADDING
	local v25 = SEARCH_BAR_TEXT_SIZE
	local v26 = isCompactView and SEARCH_BAR_TEXT_PADDING_WITHOUT_ICON or SEARCH_BAR_TEXT_PADDING_WITH_ICON
	local v27 = if clearButtonVisible then v26 + v7 or v26 else v26
	local v28

	if isCompactView or modernUI then
		v23 = 36
		v24 = self.props.searchBarPadding
		v25 = 24
		v26 = 9 + v25 + 9
		v27 = if clearButtonVisible then v26 + v7 or v26 else v26
		v28 = true
	else
		v28 = not isCompactView
	end

	local autocomplete = self.props.autocomplete
	local isSearching = self.props.isSearching
	local listPickerShown = self.state.listPickerShown

	local udim = UDim.new(1, 0)
	local v29 = autocomplete and listPickerShown and not self.props.disableListPicker
	local v30 = fFlagLuaAppSduiSearchAutocomplete

	if v30 then
		if autocomplete then
			if listPickerShown then
				if
					self.props.disableListPicker and self.props.onSduiAutocompleteChanged == nil
					or self.state.autocompleteKeyword == ""
				then
					v30 = false
				else
					v30 = module4.isSearchTypeInOmniSearch(self.props.searchType)
				end
			else
				v30 = listPickerShown
			end
		else
			v30 = autocomplete
		end
	end

	local v31 = not fFlagLuaAppSduiSearchAutocomplete and 0
		or math.max(
			0,
			(self.props.screenHeight or TABLET_LIST_PICKER_HEIGHT) - (self.props.topBarHeight or 0) - (self.props.globalGuiInset and self.props.globalGuiInset.top or 0) - (self.props.globalGuiInset and self.props.globalGuiInset.bottom or 0)
		)

	if fFlagLuaAppSduiSearchAutocomplete then
		if not isCompactView then
			v31 = math.min(TABLET_LIST_PICKER_HEIGHT, v31)
		end
	else
		v31 = 0
	end

	local v32 = isSearching or self.props.forceShowCancelButton

	local cancelButtonWidth = self.state.cancelButtonWidth
	local v33 = v32 and cancelButtonWidth or 0
	local animated = self.props.animated

	local v34 = (fFlagQRInSearchScanner or fFlagQRInSearchProfileQR)
		and not clearButtonVisible
		and getAppFeaturePolicies().getFriendCodeQrCodeScannerEnabled()

	return withStyle(function(props)
		local textEmphasis = props.Theme.TextEmphasis

		local v35 = v28

		if v35 then
			local createElement = Roact.createElement
			local newUDim2 = UDim2.new

			local tokens = props.Tokens
			local v38 = v25 * (tokens.Stroke and tokens.Stroke.Standard or 1)

			local tokens2 = props.Tokens
			v35 = createElement(module8, {
				Size = newUDim2(0, v38, 0, v25 * (tokens2.Stroke and tokens2.Stroke.Standard or 1)),
				Position = UDim2.new(0, SEARCH_BAR_ICON_PADDING, 0.5, 0),
				Selectable = false,
				Image = "LuaApp/icons/ic-search-new",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				ImageColor3 = props.Theme.IconEmphasis.Color,
				ImageTransparency = props.Theme.IconEmphasis.Transparency,
				[Roact.Event.Activated] = self.onSearchIconActivated
			})
		end

		local listPickerItems = self.getListPickerItems()

		local tokens = props.Tokens
		local v37 = v25 * (tokens.Stroke and tokens.Stroke.Standard or 1) - v25

		local createElement = Roact.createElement
		local textBox = focusable.TextBox
		local v39 = {
			Size = UDim2.new(
				1,
				-v27 - v37 - (not (fFlagQRInSearchScanner or fFlagQRInSearchProfileQR) and 0 or (fFlagQRInSearchScanner or fFlagQRInSearchProfileQR) and v34 and 30 or 0),
				1,
				0
			),
			Position = UDim2.new(0, v26 + v37, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = self.props.initialSearchText or "",
			FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
			TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize,
			TextColor3 = textEmphasis.Color,
			TextTransparency = textEmphasis.Transparency,
			TextWrapped = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClipsDescendants = true,
			PlaceholderText = self.props.placeholderText,
			PlaceholderColor3 = textEmphasis.Color,
			OverlayNativeInput = true,
			TextInputType = Enum.TextInputType.NoSuggestions,
			ReturnKeyType = Enum.ReturnKeyType.Search,
			ClearTextOnFocus = false,
			[Roact.Ref] = self.searchBoxRef,
			[Roact.Event.FocusLost] = self.onFocusLost,
			[Roact.Event.Focused] = self.onFocused,
			[Roact.Change.Text] = self.onTextChanged,
			[Roact.Event.ReturnPressedFromOnScreenKeyboard] = self.onReturnPressedFromOnScreenKeyboard
		}

		local v40 = if clearButtonVisible then self.clearRef elseif v32 then self.cancelRef else nil
		v39.NextSelectionRight = v40
		local v41

		if fFlagLuaAppSduiSearchAutocomplete and v30 then
			v41 = self.listPickerRef
		elseif #listPickerItems > 0 then
			v41 = self.listPickerRef
		elseif v29 then
			v41 = self.searchBoxRef
		end

		v39.NextSelectionDown = v41

		v39.SelectionImageObject = callback(cursorKind.InputFields)
		local tag = React.Tag
		local v42 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-search-input") else nil
		v39[tag] = v42
		local element = createElement(textBox, v39)

		local createElement2 = Roact.createElement
		local v43 = focusable[module8]
		local v44 = {
			["AnchorPoint"] = nil,
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, v7, 1, 0),
			Position = UDim2.new(1, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Visible = clearButtonVisible,
			[Roact.Event.Activated] = self.onClearText,
			[Roact.Ref] = self.clearRef,
			NextSelectionLeft = self.searchBoxRef
		}
		local v45

		if fFlagLuaAppSduiSearchAutocomplete and v30 then
			v45 = self.listPickerRef
		elseif #listPickerItems > 0 then
			v45 = self.listPickerRef
		elseif v29 then
			v45 = self.searchBoxRef
		end

		v44.NextSelectionDown = v45

		local v46 = if v32 or isCompactView then self.cancelRef or nil else nil
		v44.NextSelectionRight = v46
		v44.SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		local element2 = createElement2(v43, v44, {
			ClearImage = Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(1, 0.5),
				Size = UDim2.new(0, CLEAR_IMAGE_SIZE, 0, CLEAR_IMAGE_SIZE),
				Position = UDim2.new(1, -CLEAR_IMAGE_PADDING, 0.5, 0),
				Image = iconsactionseditclear_small,
				ImageColor3 = props.Theme.IconEmphasis.Color,
				ImageTransparency = props.Theme.IconEmphasis.Transparency,
				BackgroundTransparency = 1
			})
		})
		local onActivated

		if fFlagQRInSearchScanner then
			onActivated = function()
				TelemetryService:LogEvent(v10, {
					customFields = { btn = "scanQR", page = self.props.searchType },
					eventContext = sources.OmniSearchBar
				})

				return self:openQrCodeScanner()
			end
		else
			onActivated = fFlagQRInSearchProfileQR and function()
				TelemetryService:LogEvent(v10, {
					customFields = { btn = "myQR", page = self.props.searchType },
					eventContext = sources.OmniSearchBar
				})

				self.props.navigateToProfileQrCode()
			end or nil
		end

		local v47

		if (fFlagQRInSearchScanner or fFlagQRInSearchProfileQR) and v34 then
			v47 = React.createElement(
				view,
				{
					tag = "anchor-center-right position-center-right grow auto-xy padding-right-xxsmall",
					ZIndex = 3
				},
				{ React.createElement(image, {
						tag = "size-700 content-emphasis",
						Image = fFlagQRInSearchScanner and "icons/actions/scan" or "icons/menu/scanqr",
						onActivated = onActivated,
						stateLayer = { affordance = stateLayerAffordance.None }
					}) }
			)
		end

		local forwardRef = self.props.forwardRef

		local createElement3 = Roact.createElement
		local frame = focusable.Frame
		local forwardRefsByRef = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Ref] = forwardRef
		}

		local v48 = if v29 or fFlagLuaAppSduiSearchAutocomplete and v30 then self.searchBoxRef else self.props.NextSelectionDown
		forwardRefsByRef.NextSelectionDown = v48

		forwardRefsByRef.NextSelectionRight = self.props.NextSelectionRight
		forwardRefsByRef.defaultChild = self.searchBoxRef

		forwardRefsByRef.inputBindings = not defineFastFlag
			and {
				CancelSearch = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.doCancelSearch)
			}
			or nil

		local v49 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, CANCEL_BUTTON_PADDING)
			}),
			SearchBoxContainer = 0,
			CancelButton = 0
		}

		local createElement4 = Roact.createElement
		local newUDim2 = UDim2.new
		local v52 = -v33
		local tokens2 = props.Tokens
		local v51 = {
			Size = newUDim2(1, v52, 0, v23 * (tokens2.Stroke and tokens2.Stroke.Standard or 1)),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		}

		local createElement5 = Roact.createElement
		local v56 = if self.props.animationSettings and self.props.animationSettings.animationStyle == searchConstants.SearchBarAnimationStyle.ExpandFromCenter then Vector2.new(0.5, 0) else nil
		local searchBoxBackgroundRefsByRef = {}
		searchBoxBackgroundRefsByRef.AnchorPoint = v56
		searchBoxBackgroundRefsByRef.Size = animated and UDim2.new(0, 0, 0, 0) or UDim2.new(1, 0, 1, 0)
		local v57 = if self.props.animationSettings and self.props.animationSettings.animationStyle == searchConstants.SearchBarAnimationStyle.ExpandFromCenter then UDim2.fromScale(0.5, 0) else UDim2.new(0, 0, 0, 0)
		searchBoxBackgroundRefsByRef.Position = v57

		searchBoxBackgroundRefsByRef.BackgroundTransparency = 1
		searchBoxBackgroundRefsByRef.BorderSizePixel = 0
		searchBoxBackgroundRefsByRef.Image = v9.Image
		searchBoxBackgroundRefsByRef.ImageColor3 = props.Theme.UIDefault.Color
		searchBoxBackgroundRefsByRef.ImageTransparency = props.Theme.UIDefault.Transparency
		searchBoxBackgroundRefsByRef.ScaleType = Enum.ScaleType.Slice
		searchBoxBackgroundRefsByRef.SliceCenter = v9.SliceCenter
		searchBoxBackgroundRefsByRef[Roact.Ref] = self.searchBoxBackgroundRef
		searchBoxBackgroundRefsByRef.ClipsDescendants = true

		if not (fFlagQRInSearchScanner or fFlagQRInSearchProfileQR) then
			v47 = nil
		end

		v49.SearchBoxContainer = createElement4("Frame", v51, {
			SearchBoxBackground = createElement5(module7, searchBoxBackgroundRefsByRef, {
				SearchIcon = v35,
				SearchBox = element,
				ClearButton = element2,
				QRCodeButton = v47
			})
		})

		local v59 = v32

		if v59 then
			local createElement6 = Roact.createElement
			local textButton = focusable.TextButton
			local v60 = {
				["Size"] = nil,
				["Size"] = nil,
				Size = UDim2.new(0, 0, 0, v23),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = p2.cancelButtonText,
				TextXAlignment = Enum.TextXAlignment.Center,
				FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
				TextSize = props.Font.BaseSize * props.Font.Body.RelativeSize,
				TextColor3 = props.Theme.TextEmphasis.Color,
				TextTransparency = props.Theme.TextEmphasis.Transparency,
				LayoutOrder = 2,
				[Roact.Event.Activated] = self.onCancelButtonActivated,
				[Roact.Ref] = self.cancelRef,
				[Roact.Change.AbsoluteSize] = self.onCancelButtonSizeChanged,
				NextSelectionLeft = clearButtonVisible and self.clearRef or self.searchBoxRef
			}
			local listPickerRef

			if fFlagLuaAppSduiSearchAutocomplete and v30 then
				listPickerRef = self.listPickerRef
			elseif #listPickerItems > 0 then
				listPickerRef = self.listPickerRef
			end

			v60.NextSelectionDown = listPickerRef

			v60.NextSelectionRight = self.cancelRef
			v60.SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
			local tag2 = React.Tag
			local v61 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-search-cancel") else nil
			v60[tag2] = v61
			v59 = createElement6(textButton, v60, {
				Padding = Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, CANCEL_BUTTON_PADDING),
					PaddingLeft = UDim.new(0, CANCEL_BUTTON_PADDING),
					PaddingTop = UDim.new(0, CANCEL_BUTTON_PADDING),
					PaddingBottom = UDim.new(0, CANCEL_BUTTON_PADDING)
				})
			})
		end

		v49.CancelButton = v59
		local element3 = createElement3(frame, forwardRefsByRef, v49)

		local v60 = v29

		if v60 then
			local createElement6 = Roact.createElement
			local listPickerContainerRefsByRef = {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[Roact.Ref] = self.listPickerContainerRef
			}

			local createElement7 = Roact.createElement
			local fitFrame = FitChildren.FitFrame
			local v63 = {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				BorderSizePixel = 0
			}
			local v65

			if
				fFlagLuaAppSduiSearchAutocomplete
				and module4.isSearchTypeInOmniSearch(self.props.searchType)
			then
				local createElement8 = Roact.createElement
				local v67 = {
					prefix = self.state.autocompleteKeyword,
					Size = UDim2.new(1, 0, 0, 0),
					maxHeight = v31,
					nextSelectionUp = self.searchBoxRef,
					onCancel = 0,
					ref = 0
				}
				local v68 = if not defineFastFlag then self.doCancelSearch else nil
				v67.onCancel = v68
				v67.ref = self.listPickerRef
				v65 = createElement8(sduiSearchAutocomplete, v67)
			else
				local createElement8 = Roact.createElement
				local v66 = focusable[module9]
				local listPickerRefsByRef = {}
				listPickerRefsByRef.items = listPickerItems
				listPickerRefsByRef.width = udim
				local v67 = if not isCompactView then UDim.new(0, TABLET_LIST_PICKER_HEIGHT) or nil else nil
				listPickerRefsByRef.height = v67
				listPickerRefsByRef[Roact.Ref] = self.listPickerRef

				listPickerRefsByRef.NextSelectionUp = self.searchBoxRef

				listPickerRefsByRef.inputBindings = not defineFastFlag
					and {
						CancelSearch = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.doCancelSearch)
					}
					or nil
				v65 = createElement8(v66, listPickerRefsByRef)
			end

			v60 = createElement6("Frame", listPickerContainerRefsByRef, {
				Picker = createElement7(fitFrame, v63, { SearchBarListPicker = v65 })
			})
		end

		local v61 = v60 and not isCompactView

		if module27() then
			v61 = v60 and (not isCompactView or self.props.searchType == searchTypes.Catalog)
		end

		return Roact.createElement(focusNavigableSurfaceWrapper, {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.SearchBar,
			frameProps = {
				LayoutOrder = self.props.layoutOrder,
				Position = self.props.position or nil,
				AnchorPoint = self.props.anchorPoint or nil,
				Size = size,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			customEventHandlers = self.customEventHandlers
		}, {
			Shadow = v61 and Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, -19),
				Size = UDim2.new(
					1,
					28 + v24 * 2,
					1,
					size.Y.Offset + TABLET_LIST_PICKER_HEIGHT + 28 + 5 + 12
				),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = -1,
				Image = images["component_assets/dropshadow_16_20"],
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(28, 28, 29, 29),
				ImageColor3 = props.Theme.DropShadow.Color,
				ImageTransparency = props.Theme.DropShadow.Transparency
			}, {
				Background = Roact.createElement("Frame", {
					Position = UDim2.new(0, 14, 0, 14),
					Size = UDim2.new(1, -28, 1, -28),
					BorderSizePixel = 0,
					BackgroundColor3 = props.Theme.BackgroundDefault.Color,
					BackgroundTransparency = props.Theme.BackgroundDefault.Transparency
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 14)
					})
				})
			}),
			Bar = element3,
			Picker = v60
		})
	end)
end

function extended:render()
	return withSelectionCursorProvider(function(p2)
		return withLocalization({
			cancelButtonText = "Feature.GamePage.LabelCancelField"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local function getAutocompleteFetchingStatus(p2, p3)
	return function(object)
		return module11.GetFetchingStatus(object:getState(), p2, p3)
	end
end

local v23 = RoactRodux.connect(function(data, p2)
	local v24 = {
		autocompleteSuggestions = data.AutocompleteSuggestions,
		avatarAutocompleteSuggestions = data.AvatarExperience.AvatarAutocompleteSuggestions,
		currentPage = 0,
		screenHeight = 0,
		topBarHeight = 0,
		globalGuiInset = 0
	}
	local v25 = if not fFlagSignalsNavP3dRouteGated then module20(data) else nil
	v24.currentPage = v25
	local v26

	if fFlagLuaAppSduiSearchAutocomplete then
		v26 = if data.ScreenSize then data.ScreenSize.Y else TABLET_LIST_PICKER_HEIGHT
	end

	v24.screenHeight = v26

	local v27 = if fFlagLuaAppSduiSearchAutocomplete then not data.TopBar and 0 or data.TopBar.topBarHeight else nil
	v24.topBarHeight = v27

	local v28 = if fFlagLuaAppSduiSearchAutocomplete then data.GlobalGuiInset else nil
	v24.globalGuiInset = v28
	return v24
end, function(callback)
	return {
		navigateToScanQrCode = fFlagQRInSearchScanner and function()
			local v24 = { name = module23.ScanQrCode }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v24))
			else
				callback(module21(v24))
			end
		end or nil,
		navigateToCameraPermissionOverlay = fFlagQRInSearchScanner and function()
			local v24 = {
				name = module23.SettingsPermissionInteractiveAlert,
				settingsRoute = settingsRoute.Camera,
				source = sources.OmniSearchBar
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v24))
			else
				callback(module21(v24))
			end
		end or nil,
		navigateToProfileQrCode = fFlagQRInSearchProfileQR and function()
			callback(module22({ source = sources.OmniSearchBar }))
		end or nil,
		getAutocompleteFetchingStatus = function(p2, p3)
			return callback(function(object)
				return module11.GetFetchingStatus(object:getState(), p2, p3)
			end)
		end,
		fetchAutocompleteSuggestion = function(p2, p3, p4, p5)
			callback(module11.Fetch(p2, p3, p4, p5))
		end,
		fetchGameIcons = function(p2, p3)
			module2.Game.getGameIconStore(false).getAndFetchGameIcons(p3)
		end,
		setSearchBarFocused = function(p2)
			if not fFlagUseSignalsForSearchBar then
				return callback(module12(p2))
			end

			getSearchBarStore(false).setFocused(p2)
		end,
		dispatchSearchPageOverlay = function(p2, p3, p4)
			callback(setCentralOverlay(centralOverlayType.SearchPageOverlay, {
				isFocused = true,
				initialSearchText = p2,
				searchType = p3,
				placeholderText = p4
			}))
		end
	}
end)(extended)

local v24 = roactServices.connect({
	networking = module13,
	eventIngest = appEventIngestService,
	sessionService = appSessionService
})(v23)

return Roact.forwardRef(function(p2, p3)
	local v25 = ReactFocusNavigation.useFocusGuiObject()
	local v26 = ReactFocusNavigation.useFocusedGuiObject()
	return Roact.createElement(
		v24,
		Cryo.Dictionary.join(p2, {
			forwardRef = p3,
			focusGuiObject = v25,
			focusedGuiObject = v26
		})
	)
end)
