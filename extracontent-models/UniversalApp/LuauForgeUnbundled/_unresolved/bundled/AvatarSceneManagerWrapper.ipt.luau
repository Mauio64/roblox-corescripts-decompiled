local CorePackages = game:GetService("CorePackages")

local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/gJz")
local module2 = require("@luauforge/bundled/ecq")
local module3 = require("@luauforge/bundled/fDf")

local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module4 = require("@luauforge/bundled/egx")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module6 = require("@luauforge/bundled/dSw")

local module7 = require("@luauforge/bundled/gSD")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local module8 = require("@luauforge/bundled/ipu")
local module9 = require("@luauforge/bundled/ipy")
local module10 = require("@luauforge/bundled/ipB")
local module11 = require("@luauforge/bundled/ipQ")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local appPage = RobloxAppEnums.AppPage
local switchTab = RobloxAppEnums.SwitchTab

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module13 = require("@luauforge/bundled/dPN")
local module14 = require("@luauforge/bundled/dGJ")
local module15 = require("@luauforge/bundled/ipW")
local module16 = require("@luauforge/bundled/ipV")
local module17 = require("@luauforge/bundled/gTh")
local module18 = require("@luauforge/bundled/hcC")
local module19 = require("@luauforge/bundled/hGe")
local module20 = require("@luauforge/bundled/gJS")
local Cryo = require(CorePackages.Packages.Cryo)
local module21 = require("@luauforge/bundled/ipX")

local module22 = require("@luauforge/bundled/ipY")

local module23 = require("@luauforge/bundled/ipZ")
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = RobloxAppEnums.UiMode

local module24 = require("@luauforge/bundled/gRA")

local module25 = require("@luauforge/bundled/dPR")
local module26 = require("@luauforge/bundled/gVh")

local module27 = require("@luauforge/bundled/gVi")

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.scene")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local useNavigation = Navigation.useNavigation
local getCurrentRouteState = Navigation.getCurrentRouteState

local defineFastFlag = game:DefineFastFlag("AXDebugCreateHumanoidModelError", false)
local v5 = AvatarExperienceFlags.FFlagAXEnableManualSaving and game:DefineFastFlag("AXDisableSaveManager2", false)
local fFlagAXBackgroundsCycloramaVR = AvatarExperienceFlags.FFlagAXBackgroundsCycloramaVR
local fFlagAXBringingItBack = AvatarExperienceFlags.FFlagAXBringingItBack
local fFlagAXAvatarLoadWithRetry = AvatarExperienceFlags.FFlagAXAvatarLoadWithRetry
local defineFastInt = game:DefineFastInt("AXAvatarLoadRetryCount", 5)
local defineFastInt2 = game:DefineFastInt("AXAvatarLoadRetryDelayMs", 500)

local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local fFlagAXFavoritesManagerSdui = SharedFlags.FFlagAXFavoritesManagerSdui
local fFlagAXSaveManagerOutsideAX = SharedFlags.FFlagAXSaveManagerOutsideAX

local module30 = require("@luauforge/bundled/dSW")

local favoritesActiveTabStore = require("@luauforge/bundled/dTf").System.FavoritesActiveTabStore
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local fFlagAXPauseSceneWhenSplitPaneCollapsed = SharedFlags.FFlagAXPauseSceneWhenSplitPaneCollapsed
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay

local splitPaneStore = if fFlagEnableSplitPaneAvatarOverlay then require("@luauforge/bundled/dIW").SplitPaneStore else nil
local splitPaneSlot

if fFlagEnableSplitPaneAvatarOverlay then
	splitPaneSlot = require("@luauforge/bundled/dGL").Enums.SplitPaneSlot
else
	splitPaneSlot = nil
end

local function setupCharacterModels()
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return {
				r6 = Players:CreateHumanoidModelFromDescriptionAsync(
					Instance.new("HumanoidDescription"),
					Enum.HumanoidRigType.R6
				),
				r15 = Players:CreateHumanoidModelFromDescriptionAsync(
					Instance.new("HumanoidDescription"),
					Enum.HumanoidRigType.R15
				)
			}
		end)

		if success then
			callback(result)
		else
			callback2(result)
		end
	end)
end

local extended = Roact.PureComponent:extend("AvatarSceneManager")

local v6 = {
	renderSky = true,
	shouldManageBackground = true,
	isSpatial = false,
	isClassicTheme = if fFlagAXBringingItBack then false else nil,
	alternateAvatarLandingScreenFullscreenEnabled = 0,
	allowCameraMovements = true
}

local v8 = if not module27() then false else nil
v6.alternateAvatarLandingScreenFullscreenEnabled = v8
extended.defaultProps = v6

function extended:init()
	local analytics = self.props.analytics
	local appAnalytics = self.props.appAnalytics
	local avatarExperienceAnalytics = self.props.avatarExperienceAnalytics
	local setBodyColors = self.props.setBodyColors
	local setAvatarScales = self.props.setAvatarScales
	local networking = self.props.networking
	local interactionEvents = self.props.interactionEvents
	local store = self.props.store
	local avatarRoute = self.props.avatarRoute
	local shouldManageBackground = self.props.shouldManageBackground
	local isSpatial = self.props.isSpatial
	local isClassicTheme = if fFlagAXBringingItBack then self.props.isClassicTheme else nil
	local catalogAnalytics = self.props.catalogAnalytics
	self.running = false
	self.characterManagerRunning = false
	self.finishedInitializing = false
	self.modelLoadPromise = nil

	if fFlagAXAvatarLoadWithRetry then
		self.modelLoadPromise = Promise.retryWithDelay(
			setupCharacterModels,
			defineFastInt,
			defineFastInt2 * 0.001
		):andThen(function(p2)
			self.characterMover = module8.new(
				store,
				avatarExperienceAnalytics,
				avatarRoute,
				interactionEvents,
				self.props.allowCameraMovements
			)

			self.characterManager = module10.new(
				store,
				networking,
				appAnalytics,
				avatarRoute,
				self.characterMover,
				{
					bodyColorsChangedEvent = setBodyColors,
					adjustmentChangedEvent = self.props.setAdjustments,
					avatarScalesChangedEvent = setAvatarScales
				},
				{ setAppliedDescription = self.props.setAppliedDescription },
				catalogAnalytics,
				p2
			)

			if shouldManageBackground then
				local v9 = self
				local new = module11.new
				local v13 = if fFlagAXBringingItBack then isSpatial else fFlagAXBackgroundsCycloramaVR and isSpatial
				local v14 = if fFlagAXBringingItBack then isClassicTheme else nil
				v9.backgroundSceneManager = new(store, networking, avatarRoute, v13, v14)
			end

			if not v5 then
				self.saveManager = module9.new(store, networking, analytics)
			end

			self.finishedInitializing = true

			if self.destroyed then
				self:onDestroy()
			else
				self:updateManagers()
			end
		end):catch(function(p2)
			local function fn()
				if not self.props.routeHistory or typeof(self.props.routeHistory) ~= "table" then
					return `no route history got {typeof(self.props.routeHistory)}`
				end

				local v9 = self.props.routeHistory[#self.props.routeHistory]

				if not v9 or typeof(v9) ~= "table" then
					return `no route, got {typeof(v9)}`
				end

				local v10 = v9[#v9]

				if v10 and typeof(v10) == "table" then
					return v10.name
				end

				return "no page"
			end

			mutedError(`{tostring(p2)} on page: {fn()}, with receivedAvatarData: {self.props.receivedAvatarData}`)
		end)
	else
		task.spawn(function()
			if defineFastFlag then
				local success, result = pcall(function()
					self.characterMover = module8.new(
						store,
						avatarExperienceAnalytics,
						avatarRoute,
						interactionEvents,
						self.props.allowCameraMovements
					)

					self.characterManager = module10.new(
						store,
						networking,
						appAnalytics,
						avatarRoute,
						self.characterMover,
						{
							bodyColorsChangedEvent = setBodyColors,
							adjustmentChangedEvent = self.props.setAdjustments,
							avatarScalesChangedEvent = setAvatarScales
						},
						{ setAppliedDescription = self.props.setAppliedDescription },
						catalogAnalytics
					)

					if shouldManageBackground then
						local v9 = self
						local new = module11.new
						local v13 = if fFlagAXBringingItBack then isSpatial else fFlagAXBackgroundsCycloramaVR and isSpatial
						local v14 = if fFlagAXBringingItBack then isClassicTheme else nil
						v9.backgroundSceneManager = new(store, networking, avatarRoute, v13, v14)
					end

					if not v5 then
						self.saveManager = module9.new(store, networking, analytics)
					end

					self.finishedInitializing = true

					if self.destroyed then
						self:onDestroy()
					else
						self:updateManagers()
					end
				end)

				if not success then
					mutedError(`{result} on page: {(function()
						if not self.props.routeHistory or typeof(self.props.routeHistory) ~= "table" then
							return `no route history got {typeof(self.props.routeHistory)}`
						end

						local v9 = self.props.routeHistory[#self.props.routeHistory]

						if not v9 or typeof(v9) ~= "table" then
							return `no route, got {typeof(v9)}`
						end

						local v10 = v9[#v9]

						if v10 and typeof(v9) == "table" then
							return v10.name
						end

						return `no page, got {typeof(v9)}`
					end)()}, with receivedAvatarData: {self.props.receivedAvatarData}`)
				end
			else
				self.characterMover = module8.new(
					store,
					avatarExperienceAnalytics,
					avatarRoute,
					interactionEvents,
					self.props.allowCameraMovements
				)

				self.characterManager = module10.new(
					store,
					networking,
					appAnalytics,
					avatarRoute,
					self.characterMover,
					{
						bodyColorsChangedEvent = setBodyColors,
						adjustmentChangedEvent = self.props.setAdjustments,
						avatarScalesChangedEvent = setAvatarScales
					},
					{ setAppliedDescription = self.props.setAppliedDescription },
					catalogAnalytics
				)

				local v9 = self
				local new = module11.new
				local v13 = if fFlagAXBringingItBack then isSpatial else fFlagAXBackgroundsCycloramaVR and isSpatial
				local v14 = if fFlagAXBringingItBack then isClassicTheme else nil
				v9.backgroundSceneManager = new(store, networking, avatarRoute, v13, v14)

				if not v5 then
					self.saveManager = module9.new(store, networking, analytics)
				end

				self.finishedInitializing = true

				if self.destroyed then
					self:onDestroy()
				else
					self:updateManagers()
				end
			end
		end)
	end
end

local set = {
	[avatarScreen.AvatarEditor] = true,
	[avatarScreen.MySharedAvatars] = true,
	[avatarScreen.Catalog] = true,
	[avatarScreen.FavoritesSaved] = true,
	[avatarScreen.AvatarExperienceLandingPage] = true,
	[avatarScreen.AvatarBackground] = true,
	[avatarScreen.AvatarExperienceRoot] = true,
	[avatarScreen.ProfilePictureEditorEmotes] = true,
	[avatarScreen.TryOnItem] = true,
	[appPage.AvatarExperienceWrapper] = true,
	[appPage.AvatarExperienceWrapperTransparent] = true,
	[switchTab.AvatarExperienceTab] = true
}

local function shouldRunManagers(p2, p3): boolean
	if set[p2.name] then
		return true
	end

	if fFlagEnableSplitPaneAvatarOverlay then
		local v9 = module14[p2.name]

		if
			v9
			and v9.splitPaneEligibility == splitPaneSlot.Content
			and splitPaneStore.isSplitEnabledNow()
			and (not fFlagAXPauseSceneWhenSplitPaneCollapsed or p3 == true)
		then
			return true
		end
	end

	return false
end

local function checkShouldRunManagers(list, p2): boolean
	if not list then
		return false
	end

	local v9 = fFlagEnableSplitPaneAvatarOverlay and splitPaneStore.isSplitEnabledNow()
	local v10 = if fFlagAXPauseSceneWhenSplitPaneCollapsed then p2 == true else nil

	for i = #list, 1, -1 do
		local item = list[i]
		local v11 = if fFlagAXPauseSceneWhenSplitPaneCollapsed then p2 else nil
		local v12

		if set[item.name] then
			v12 = true
		elseif fFlagEnableSplitPaneAvatarOverlay then
			local v13 = module14[item.name]

			if
				v13
				and v13.splitPaneEligibility == splitPaneSlot.Content
				and splitPaneStore.isSplitEnabledNow()
			then
				v12 = not fFlagAXPauseSceneWhenSplitPaneCollapsed or v11 == true
			else
				v12 = false
			end
		else
			v12 = false
		end

		if v12 then
			return true
		end

		if module14[item.name] and module14[item.name].renderUnderlyingPage then
			continue
		end

		local v13 = if fFlagAXPauseSceneWhenSplitPaneCollapsed then v10 else v9

		if not v13 then
			return false
		end
	end

	return false
end

local function checkShouldRunSaveManager(p2): boolean
	if p2 and p2.params then
		return p2.params.runAvatarSaveManager == true
	end

	return false
end

function extended:updateManagers()
	if not self.finishedInitializing then
		return
	end

	local routeHistory = self.props.routeHistory
	local v9 = routeHistory[#routeHistory]
	local v10

	if self.props.shouldStart == nil then
		v10 = self.props.avatarRoute.isVisible

		if not v10 then
			local v12

			if fFlagAXPauseSceneWhenSplitPaneCollapsed then
				v12 = self.props.isSplitPaneAvatarVisible
			end

			v10 = checkShouldRunManagers(v9, v12)
		end
	else
		v10 = self.props.shouldStart
	end

	if v10 and not self.running then
		self:start()
	elseif not v10 and self.running then
		self:stop()
	end

	if fFlagAXSaveManagerOutsideAX then
		if not v10 then
			local currentRoute = self.props.currentRoute

			if currentRoute and currentRoute.params then
				v10 = currentRoute.params.runAvatarSaveManager == true
			else
				v10 = false
			end
		end

		local running = self.saveManager and self.saveManager.running

		if v10 and not running then
			self:maybeStartSaveManager()
		elseif not v10 and running then
			self:stopSaveManager()
		end
	end
end

function extended:didMount()
	self:updateManagers()
end

function extended:willUnmount()
	if fFlagAXAvatarLoadWithRetry and self.modelLoadPromise then
		self.modelLoadPromise:cancel()
	end

	if self.running then
		self:stop()
	end

	if fFlagAXSaveManagerOutsideAX then
		self:stopSaveManager()
	end

	if self.finishedInitializing then
		self:onDestroy()
	end

	self.destroyed = true
end

function extended:callUpdateAvatarRoute(object, p3, p4)
	if object then
		object:updateAvatarRoute(p3, p4)
	end
end

function extended:callUpdateCategorySelection(object)
	if object then
		object:updateCategorySelection()
	end
end

function extended.shouldResetFullViewForPage(p2, p3): boolean
	if p2.props.fullView[p3] == nil then
		return false
	end

	return p2.props.fullView[p3] ~= fullView.None
end

function extended.resetFullView(p2, p3)
	local v9 = module13.FullViewPageDefaults[p3]

	if v9 == nil then
		return
	end

	if (p3 == avatarScreen.Catalog or p3 == avatarScreen.CatalogSearch) and p2.props.isPortrait then
		local v10 = p2.props.alternateAvatarLandingScreenFullscreenEnabled

		if module27() then
			v10 = not p2.props.is10ftUI
		end

		v9 = if v10 then fullView.UIFullView else fullView.None
	end

	if p2.props.fullView[p3] ~= v9 then
		p2.props.setFullView(p2.props.avatarExperienceAnalytics, p3, v9)
	end
end

function extended:onAvatarDataReady()
	if self.running then
		self:maybeStartCharacterAndSaveManager()
	elseif self.finishedInitializing then
		self.characterManager:maybeInitializeModel(self.props.store:getState())
	end
end

function extended:updateClassicAvatarSceneContext()
	if not self.backgroundSceneManager then
		return
	end

	self.backgroundSceneManager:setClassicAvatarSceneContext(
		self.props.isSpatial,
		self.props.isClassicTheme
	)

	if self.running then
		self.backgroundSceneManager:syncClassicAvatarScene(self.props.store:getState())
	end
end

function extended:didUpdate(data)
	if self.props.receivedAvatarData and not data.receivedAvatarData then
		self:onAvatarDataReady()
	end

	if
		fFlagAXBringingItBack
		and (self.props.isSpatial ~= data.isSpatial or self.props.isClassicTheme ~= data.isClassicTheme)
	then
		self:updateClassicAvatarSceneContext()
	end

	self:updateManagers()

	local avatarRoute = self.props.avatarRoute
	local avatarRoute2 = data.avatarRoute

	if avatarRoute ~= avatarRoute2 then
		self:callUpdateAvatarRoute(self.characterMover, avatarRoute, avatarRoute2)

		if self.backgroundSceneManager then
			self:callUpdateAvatarRoute(self.backgroundSceneManager, avatarRoute, avatarRoute2)
		end

		self:callUpdateAvatarRoute(self.characterManager, avatarRoute, avatarRoute2)

		if not v5 then
			self:callUpdateAvatarRoute(self.saveManager, avatarRoute, avatarRoute2)
		end
	end

	local catalogCategoryId = data.catalogCategoryId
	local catalogCategoryId2 = self.props.catalogCategoryId

	local catalogSubcategoryId = data.catalogSubcategoryId
	local catalogSubcategoryId2 = self.props.catalogSubcategoryId

	local catalogSearchCategoryId = data.catalogSearchCategoryId
	local catalogSearchCategoryId2 = self.props.catalogSearchCategoryId

	local catalogSearchSubcategoryId = data.catalogSearchSubcategoryId
	local catalogSearchSubcategoryId2 = self.props.catalogSearchSubcategoryId

	local v9 = fFlagAXFavoritesManagerSdui and self.props.favoritesCategoryId ~= data.favoritesCategoryId

	if
		catalogCategoryId2 ~= catalogCategoryId
		or catalogSubcategoryId2 ~= catalogSubcategoryId
		or catalogSearchCategoryId2 ~= catalogSearchCategoryId
		or catalogSearchSubcategoryId2 ~= catalogSearchSubcategoryId
		or v9
	then
		self:callUpdateCategorySelection(self.characterMover)
		self:callUpdateAvatarRoute(self.characterManager, avatarRoute, avatarRoute2)

		if v9 then
			local cameraManager = self.characterMover and self.characterMover.cameraManager

			if cameraManager and cameraManager.started then
				self:callUpdateCategorySelection(cameraManager)
			end
		end
	end
end

function extended.render(p2)
	if p2.props.renderSky then
		return Roact.createElement(module16)
	end
end

function extended:maybeStartCharacterAndSaveManager()
	if self.characterManagerRunning or not self.props.receivedAvatarData then
		return
	end

	self.characterManager:start()

	if
		fFlagEnableSplitPaneAvatarOverlay
		and fFlagAXPauseSceneWhenSplitPaneCollapsed
		and splitPaneStore.isSplitEnabledNow()
		and not self.props.avatarRoute.isVisible
	then
		self.characterManager:onSceneStartedOutsideAvatarRoute(self.props.avatarRoute)
	end

	if not (fFlagAXSaveManagerOutsideAX or v5) then
		self.saveManager:start()
	end

	self.characterManagerRunning = true
end

function extended:stopCharacterAndSaveManager()
	if not self.characterManagerRunning then
		return
	end

	self.characterManager:stop()

	if not (fFlagAXSaveManagerOutsideAX or v5) then
		self.saveManager:stop()
	end

	self.characterManagerRunning = false
end

function extended:maybeStartSaveManager()
	if v5 or not self.saveManager or self.saveManager.running or not self.props.receivedAvatarData then
		return
	end

	self.saveManager:start()
end

function extended:stopSaveManager()
	if self.saveManager and self.saveManager.running then
		self.saveManager:stop()
	end
end

function extended:start()
	logger:info("AvatarSceneManager:start()")

	if self.running then
		return
	end

	if self.backgroundSceneManager then
		self.props.setThrottleFramerateEnabled(false)

		self.backgroundSceneManager:start()
	end

	self.running = true
	self:maybeStartCharacterAndSaveManager()

	self.characterMover:start()

	self.props.setPageLoaded()
	local notificationService = self.props.notificationService

	if
		fFlagEnableSplitPaneAvatarOverlay
		and fFlagAXPauseSceneWhenSplitPaneCollapsed
		and splitPaneStore.isSplitEnabledNow()
	then
		if self.props.avatarRoute.isVisible then
			notificationService:ActionEnabled(Enum.AppShellActionType.AvatarEditorPageLoaded)
		end
	else
		notificationService:ActionEnabled(Enum.AppShellActionType.AvatarEditorPageLoaded)
	end
end

function extended:stop()
	logger:info("AvatarSceneManager:stop()")

	if not self.running then
		return
	end

	self.props.setThrottleFramerateEnabled(true)

	self.running = false
	self:stopCharacterAndSaveManager()

	if self.backgroundSceneManager then
		self.backgroundSceneManager:stop()
	end

	self.characterMover:stop()
end

function extended:onDestroy()
	self.characterManager:onDestroy()

	if self.backgroundSceneManager then
		self.backgroundSceneManager:onDestroy()
	end

	self.characterMover:onDestroy()

	if not v5 then
		self.saveManager:onDestroy()
	end
end

local v9 = roactServices.connect({
	catalogAnalytics = module3,
	analytics = module,
	appAnalytics = module2,
	avatarExperienceAnalytics = avatarExperienceAnalyticsService,
	networking = module4,
	notificationService = appNotificationService
})(extended)

local v10 = RoactRodux.connect(function(p2, p3)
	local v11 = {
		isPortrait = module20(p2),
		fullView = p2.AvatarExperience.Common.FullView,
		avatarPageLoaded = p2.AvatarExperience.AvatarEditor.PageLoaded,
		receivedAvatarData = module18(p2),
		routeHistory = 0
	}
	local v12

	if not fFlagSignalsNavP3gAvatarExperience then
		if fFlagUseNavigationSelectors then
			v12 = selectors.selectLegacyHistory(p2)
		else
			v12 = p2.Navigation.history
		end
	end

	v11.routeHistory = v12
	return v11
end, function(callback)
	return {
		setPageLoaded = function()
			callback(module6(true))
		end,
		setFullView = function(p2, p3, p4)
			callback(module7(p2, p3, p4))
		end
	}
end)(v9)

if fFlagSignalsNavP3gAvatarExperience then
	local v11 = v10

	local function AvatarSceneManagerWithSignals(p2)
		local v12 = useSignalState(getLegacyNavigationStore(false).getHistory)
		return React.createElement(v11, Cryo.Dictionary.union(p2, { routeHistory = v12 }))
	end

	v10 = React.memo(AvatarSceneManagerWithSignals)
end

local v11 = module17((module15(v10)))

if not module27() and module26 then
	v11 = module25.connectTestVariables({
		alternateAvatarLandingScreenFullscreenEnabled = module26.GetFullScreenEnabled
	})(v11)
end

local v12 = module24(v11, false)

local v13 = module19((roactAppPolicy.connect(function(p2)
	return { allowCameraMovements = p2.getAllowCameraMovements() }
end)(v12)))

local function AvatarSceneManagerWrapper(p2)
	local v14 = module21()
	local joined = Cryo.Dictionary.join(v14, p2)

	local v15 = module22()
	local v16 = module23()
	local joined2 = Cryo.Dictionary.join(v15, joined, v16)

	local catalogSelectionStore = module30.getCatalogSelectionStore()
	local v17 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v18 = useSignalState(catalogSelectionStore.selectedSubcategoryId)
	joined2.catalogCategoryId = v17
	joined2.catalogSubcategoryId = v18

	local catalogSearchSelectionStore = module30.getCatalogSearchSelectionStore()
	local v19 = useSignalState(catalogSearchSelectionStore.selectedCategoryId)
	local v20 = useSignalState(catalogSearchSelectionStore.selectedSubcategoryId)
	joined2.catalogSearchCategoryId = v19
	joined2.catalogSearchSubcategoryId = v20

	if fFlagAXFavoritesManagerSdui then
		joined2.favoritesCategoryId = useSignalState(favoritesActiveTabStore.getActiveLeafId)
	end

	if module27() then
		joined2.is10ftUI = useUiModeInfo().uiMode == uiMode.TenFoot
	end

	if fFlagAXSaveManagerOutsideAX then
		joined2.currentRoute = getCurrentRouteState((useNavigation()))
	end

	if fFlagEnableSplitPaneAvatarOverlay and fFlagAXPauseSceneWhenSplitPaneCollapsed then
		local store = splitPaneStore.getStore()
		local v21 = useSignalState(store.getIsSplitPaneCollapsedOrNotActive)
		local v22 = useSignalState(store.getHasSupportRoute)
		joined2.isSplitPaneAvatarVisible = not (v21 or v22)
	end

	return React.createElement(v13, joined2)
end

return AvatarSceneManagerWrapper
