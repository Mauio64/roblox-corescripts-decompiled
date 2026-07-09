local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Promise = require(CorePackages.Packages.Promise)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local Analytics2 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SetPageLoaded = require(Modules.AvatarExperience.AvatarEditor.Actions.SetPageLoaded)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local CharacterMover = require(Modules.AvatarExperience.Common.Managers.CharacterMover)
local SaveManager = require(Modules.AvatarExperience.Common.Managers.SaveManager)
local CharacterManager = require(Modules.AvatarExperience.Common.Managers.CharacterManager)
local BackgroundSceneManager = require(Modules.AvatarExperience.Common.Managers.BackgroundSceneManager)
local BackgroundSceneManager_DEPRECATED = require(Modules.AvatarExperience.Common.Managers.BackgroundSceneManager_DEPRECATED)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SwitchTab = RobloxAppEnums.SwitchTab
local Analytics3 = require(Modules.AvatarExperience.Common.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local wrapWithSceneInteractionEvents = require(Modules.AvatarExperience.Common.Context.wrapWithSceneInteractionEvents)
local AvatarSceneSky = require(Modules.AvatarExperience.Common.Managers.AvatarSceneSky)
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local selectHasAvatarData = require(Modules.AvatarExperience.Common.Selectors.selectHasAvatarData)
local withThrottleFramerateGivenPolicy = require(Modules.LuaApp.Common.withThrottleFramerateGivenPolicy)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local Cryo = require(CorePackages.Packages.Cryo)
local useBodyDataEventsContext = require(Modules.AvatarExperience.Common.Context.useBodyDataEventsContext)
local useAdjustmentDataEventsContext = require(Modules.AvatarExperience.Common.Context.AdjustmentData.useAdjustmentDataEventsContext)
local useAppliedDescriptionCallbackContext = require(Modules.AvatarExperience.Common.Context.AppliedDescription.useAppliedDescriptionCallbackContext)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = RobloxAppEnums.UiMode
local AfterAvatarExperienceLoaded = require(Modules.AvatarExperience.Common.Components.AfterAvatarExperienceLoaded)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXAlternateLandingPageIXP = require(Modules.AvatarExperience.Flags.AXAlternateLandingPageIXP)
local GetFFlagCleanUpAXAlternativeLandingPageIXP = require(Modules.AvatarExperience.Flags.GetFFlagCleanUpAXAlternativeLandingPageIXP)
local FFlagAXFixBodyScaleReduxUpdates = require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates)
local v50 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.scene")
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local v52 = game:DefineFastFlag("AXDebugCreateHumanoidModelError", false)
local v53 = AvatarExperienceFlags.FFlagAXEnableManualSaving and game:DefineFastFlag("AXDisableSaveManager2", false)
local FFlagAXBackgroundSceneManagerRevamp = AvatarExperienceFlags.FFlagAXBackgroundSceneManagerRevamp
local FFlagAXBackgroundsCycloramaVR = AvatarExperienceFlags.FFlagAXBackgroundsCycloramaVR
local FFlagAXAvatarLoadWithRetry = AvatarExperienceFlags.FFlagAXAvatarLoadWithRetry
local v57 = game:DefineFastInt("AXAvatarLoadRetryCount", 5)
local v58 = game:DefineFastInt("AXAvatarLoadRetryDelayMs", 500)
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v63 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore

local function setupCharacterModels() -- line: 92
	-- upvalues: Promise (copy), Players (copy)
	return Promise.new(function(resolve, reject) -- line: 93
		-- upvalues: Players (copy)
		local ok, result = pcall(function() -- line: 94
			-- upvalues: Players (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return {
					r6 = Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6),
					r15 = Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
				}
			end

			return {
				r6 = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6),
				r15 = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
			}
		end)

		if ok then
			resolve(result)

			return
		end

		reject(result)
	end)
end

local v65 = Roact.PureComponent:extend("AvatarSceneManager")

v65.defaultProps = {
	renderSky = true,
	shouldManageBackground = true,
	isSpatial = false,
	allowCameraMovements = true,
	alternateAvatarLandingScreenFullscreenEnabled = not not GetFFlagCleanUpAXAlternativeLandingPageIXP() and nil
}

function v65.init(p1) -- line: 137
	-- upvalues: FFlagAXFixBodyScaleReduxUpdates (copy), FFlagAXAvatarLoadWithRetry (copy), Promise (copy), setupCharacterModels (copy), v57 (copy), v58 (copy), CharacterMover (copy), CharacterManager (copy), FFlagAXBackgroundSceneManagerRevamp (copy), BackgroundSceneManager (copy), FFlagAXBackgroundsCycloramaVR (copy), BackgroundSceneManager_DEPRECATED (copy), v53 (copy), SaveManager (copy), mutedError (copy), v52 (copy)
	local analytics = p1.props.analytics
	local appAnalytics = p1.props.appAnalytics
	local avatarExperienceAnalytics = p1.props.avatarExperienceAnalytics
	local setBodyColors = p1.props.setBodyColors
	local v81 = if not FFlagAXFixBodyScaleReduxUpdates then nil else p1.props.setAvatarScales
	local networking = p1.props.networking
	local interactionEvents = p1.props.interactionEvents
	local store = p1.props.store
	local avatarRoute = p1.props.avatarRoute
	local shouldManageBackground = p1.props.shouldManageBackground
	local isSpatial = p1.props.isSpatial
	local catalogAnalytics = p1.props.catalogAnalytics

	p1.running = false
	p1.characterManagerRunning = false
	p1.finishedInitializing = false
	p1.modelLoadPromise = nil

	if FFlagAXAvatarLoadWithRetry then
		p1.modelLoadPromise = Promise.retryWithDelay(setupCharacterModels, v57, v58 * 0.001):andThen(function(p2) -- line: 161
			-- upvalues: p1 (copy), CharacterMover (copy), store (copy), avatarExperienceAnalytics (copy), avatarRoute (copy), interactionEvents (copy), CharacterManager (copy), networking (copy), appAnalytics (copy), setBodyColors (copy), FFlagAXFixBodyScaleReduxUpdates (copy), v81 (copy), catalogAnalytics (copy), shouldManageBackground (copy), FFlagAXBackgroundSceneManagerRevamp (copy), BackgroundSceneManager (copy), FFlagAXBackgroundsCycloramaVR (copy), isSpatial (copy), BackgroundSceneManager_DEPRECATED (copy), v53 (copy), SaveManager (copy), analytics (copy)
			p1.characterMover = CharacterMover.new(store, avatarExperienceAnalytics, avatarRoute, interactionEvents, p1.props.allowCameraMovements)
			p1.characterManager = CharacterManager.new(store, networking, appAnalytics, avatarRoute, p1.characterMover, {
				bodyColorsChangedEvent = setBodyColors,
				adjustmentChangedEvent = p1.props.setAdjustments,
				avatarScalesChangedEvent = if not FFlagAXFixBodyScaleReduxUpdates then nil else v81
			}, {
				setAppliedDescription = p1.props.setAppliedDescription
			}, catalogAnalytics, p2)

			if shouldManageBackground then
				if FFlagAXBackgroundSceneManagerRevamp then
					p1.backgroundSceneManager = BackgroundSceneManager.new(store, networking, avatarRoute, FFlagAXBackgroundsCycloramaVR and isSpatial)
				else
					p1.backgroundSceneManager = BackgroundSceneManager_DEPRECATED.new(store, networking, avatarRoute, FFlagAXBackgroundsCycloramaVR and isSpatial)
				end
			end

			if not v53 then
				p1.saveManager = SaveManager.new(store, networking, analytics)
			end

			p1.finishedInitializing = true

			if p1.destroyed then
				p1:onDestroy()

				return
			end

			p1:updateManagers()
		end):catch(function(p3) -- line: 218
			-- upvalues: p1 (copy), mutedError (copy)
			mutedError(`{ tostring(p3) } on page: { (function() -- line: 219
				-- upvalues: p1 (copy)
				if not p1.props.routeHistory or typeof(p1.props.routeHistory) ~= "table" then
					return `no route history got { typeof(p1.props.routeHistory) }`
				end

				local v160 = p1.props.routeHistory[#p1.props.routeHistory]

				if not v160 or typeof(v160) ~= "table" then
					return `no route, got { typeof(v160) }`
				end

				local v161 = v160[#v160]

				if not v161 or typeof(v161) ~= "table" then
					return "no page"
				end

				return v161.name
			end)() }, with receivedAvatarData: { p1.props.receivedAvatarData }`)
		end)

		return
	end

	task.spawn(function() -- line: 240
		-- upvalues: v52 (copy), p1 (copy), CharacterMover (copy), store (copy), avatarExperienceAnalytics (copy), avatarRoute (copy), interactionEvents (copy), CharacterManager (copy), networking (copy), appAnalytics (copy), setBodyColors (copy), FFlagAXFixBodyScaleReduxUpdates (copy), v81 (copy), catalogAnalytics (copy), shouldManageBackground (copy), FFlagAXBackgroundSceneManagerRevamp (copy), BackgroundSceneManager (copy), FFlagAXBackgroundsCycloramaVR (copy), isSpatial (copy), BackgroundSceneManager_DEPRECATED (copy), v53 (copy), SaveManager (copy), analytics (copy), mutedError (copy)
		if v52 then
			local ok, result = pcall(function() -- line: 242
				-- upvalues: p1 (copy), CharacterMover (copy), store (copy), avatarExperienceAnalytics (copy), avatarRoute (copy), interactionEvents (copy), CharacterManager (copy), networking (copy), appAnalytics (copy), setBodyColors (copy), FFlagAXFixBodyScaleReduxUpdates (copy), v81 (copy), catalogAnalytics (copy), shouldManageBackground (copy), FFlagAXBackgroundSceneManagerRevamp (copy), BackgroundSceneManager (copy), FFlagAXBackgroundsCycloramaVR (copy), isSpatial (copy), BackgroundSceneManager_DEPRECATED (copy), v53 (copy), SaveManager (copy), analytics (copy)
				p1.characterMover = CharacterMover.new(store, avatarExperienceAnalytics, avatarRoute, interactionEvents, p1.props.allowCameraMovements)
				p1.characterManager = CharacterManager.new(store, networking, appAnalytics, avatarRoute, p1.characterMover, {
					bodyColorsChangedEvent = setBodyColors,
					adjustmentChangedEvent = p1.props.setAdjustments,
					avatarScalesChangedEvent = if not FFlagAXFixBodyScaleReduxUpdates then nil else v81
				}, {
					setAppliedDescription = p1.props.setAppliedDescription
				}, catalogAnalytics)

				if shouldManageBackground then
					if FFlagAXBackgroundSceneManagerRevamp then
						p1.backgroundSceneManager = BackgroundSceneManager.new(store, networking, avatarRoute, FFlagAXBackgroundsCycloramaVR and isSpatial)
					else
						p1.backgroundSceneManager = BackgroundSceneManager_DEPRECATED.new(store, networking, avatarRoute, FFlagAXBackgroundsCycloramaVR and isSpatial)
					end
				end

				if not v53 then
					p1.saveManager = SaveManager.new(store, networking, analytics)
				end

				p1.finishedInitializing = true

				if p1.destroyed then
					p1:onDestroy()

					return
				end

				p1:updateManagers()
			end)

			if not ok then
				mutedError(`{ result } on page: { (function() -- line: 300
					-- upvalues: p1 (copy)
					if not p1.props.routeHistory or typeof(p1.props.routeHistory) ~= "table" then
						return `no route history got { typeof(p1.props.routeHistory) }`
					end

					local v162 = p1.props.routeHistory[#p1.props.routeHistory]

					if not v162 or typeof(v162) ~= "table" then
						return `no route, got { typeof(v162) }`
					end

					local v163 = v162[#v162]

					if not v163 or typeof(v162) ~= "table" then
						return `no page, got { typeof(v162) }`
					end

					return v163.name
				end)() }, with receivedAvatarData: { p1.props.receivedAvatarData }`)

				return
			end
		else
			p1.characterMover = CharacterMover.new(store, avatarExperienceAnalytics, avatarRoute, interactionEvents, p1.props.allowCameraMovements)
			p1.characterManager = CharacterManager.new(store, networking, appAnalytics, avatarRoute, p1.characterMover, {
				bodyColorsChangedEvent = setBodyColors,
				adjustmentChangedEvent = p1.props.setAdjustments,
				avatarScalesChangedEvent = if not FFlagAXFixBodyScaleReduxUpdates then nil else v81
			}, {
				setAppliedDescription = p1.props.setAppliedDescription
			}, catalogAnalytics)

			if FFlagAXBackgroundSceneManagerRevamp then
				p1.backgroundSceneManager = BackgroundSceneManager.new(store, networking, avatarRoute, FFlagAXBackgroundsCycloramaVR and isSpatial)
			else
				p1.backgroundSceneManager = BackgroundSceneManager_DEPRECATED.new(store, networking, avatarRoute, FFlagAXBackgroundsCycloramaVR and isSpatial)
			end

			if not v53 then
				p1.saveManager = SaveManager.new(store, networking, analytics)
			end

			p1.finishedInitializing = true

			if p1.destroyed then
				p1:onDestroy()

				return
			end

			p1:updateManagers()
		end
	end)
end

local t1 = {
	[AvatarScreen.AvatarEditor] = true,
	[AvatarScreen.MySharedAvatars] = true,
	[AvatarScreen.Catalog] = true,
	[AvatarScreen.FavoritesSaved] = true,
	[AvatarScreen.AvatarExperienceLandingPage] = true,
	[AvatarScreen.AvatarBackground] = true,
	[AvatarScreen.AvatarExperienceRoot] = true,
	[AvatarScreen.ProfilePictureEditorEmotes] = true,
	[AvatarScreen.TryOnItem] = true,
	[AppPage.AvatarExperienceWrapper] = true,
	[AppPage.AvatarExperienceWrapperTransparent] = true,
	[SwitchTab.AvatarExperienceTab] = true
}

local function shouldRunManagers(p4) -- line: 399
	-- upvalues: t1 (copy)
	return t1[p4.name] or false
end
local function checkShouldRunManagers(p5) -- line: 403
	-- upvalues: t1 (copy), AppPageProperties (copy)
	if not p5 then
		return false
	end

	for i = #p5, 1, -1 do
		local v92 = p5[i]

		if t1[v92.name] or false then
			return true
		end

		if not AppPageProperties[v92.name] or not AppPageProperties[v92.name].renderUnderlyingPage then
			return false
		end
	end

	return false
end

function v65.updateManagers(p6) -- line: 424
	-- upvalues: checkShouldRunManagers (copy)
	if not p6.finishedInitializing then
		return
	end

	local routeHistory = p6.props.routeHistory
	local v95 = routeHistory[#routeHistory]
	local v96 = if p6.props.shouldStart == nil then p6.props.avatarRoute.isVisible or checkShouldRunManagers(v95) else p6.props.shouldStart

	if v96 and not p6.running then
		p6:start()

		return
	end

	if not v96 and p6.running then
		p6:stop()
	end
end
function v65.didMount(p7) -- line: 447
	p7:updateManagers()
end
function v65.willUnmount(p8) -- line: 451
	-- upvalues: FFlagAXAvatarLoadWithRetry (copy)
	if FFlagAXAvatarLoadWithRetry and p8.modelLoadPromise then
		p8.modelLoadPromise:cancel()
	end

	if p8.running then
		p8:stop()
	end

	if p8.finishedInitializing then
		p8:onDestroy()
	end

	p8.destroyed = true
end
function v65.callUpdateAvatarRoute(_, p10, p11, p12) -- line: 465
	if p10 then
		p10:updateAvatarRoute(p11, p12)
	end
end
function v65.callUpdateCategorySelection(_, p14) -- line: 471
	if p14 then
		p14:updateCategorySelection()
	end
end
function v65.shouldResetFullViewForPage(p15, p16) -- line: 477
	-- upvalues: FullView (copy)
	if p15.props.fullView[p16] == nil then
		return false
	end

	return p15.props.fullView[p16] ~= FullView.None
end
function v65.resetFullView(p17, p18) -- line: 489
	-- upvalues: Constants (copy), AvatarScreen (copy), GetFFlagCleanUpAXAlternativeLandingPageIXP (copy), FullView (copy)
	local v109 = Constants.FullViewPageDefaults[p18]

	if v109 == nil then
		return
	end

	if (p18 == AvatarScreen.Catalog or p18 == AvatarScreen.CatalogSearch) and p17.props.isPortrait then
		local alternateAvatarLandingScreenFullscreenEnabled = p17.props.alternateAvatarLandingScreenFullscreenEnabled

		if GetFFlagCleanUpAXAlternativeLandingPageIXP() then
			alternateAvatarLandingScreenFullscreenEnabled = not p17.props.is10ftUI
		end

		v109 = if not alternateAvatarLandingScreenFullscreenEnabled then FullView.None else FullView.UIFullView
	end

	if v109 ~= p17.props.fullView[p18] then
		p17.props.setFullView(p17.props.avatarExperienceAnalytics, p18, v109)
	end
end
function v65.onAvatarDataReady(p19) -- line: 511
	if p19.running then
		p19:maybeStartCharacterAndSaveManager()

		return
	end

	if p19.finishedInitializing then
		p19.characterManager:maybeInitializeModel(p19.props.store:getState())
	end
end
function v65.didUpdate(p20, p21) -- line: 524
	-- upvalues: v53 (copy)
	if p20.props.receivedAvatarData and not p21.receivedAvatarData then
		p20:onAvatarDataReady()
	end

	p20:updateManagers()

	local avatarRoute = p20.props.avatarRoute
	local avatarRoute2 = p21.avatarRoute

	if avatarRoute ~= avatarRoute2 then
		p20:callUpdateAvatarRoute(p20.characterMover, avatarRoute, avatarRoute2)

		if p20.backgroundSceneManager then
			p20:callUpdateAvatarRoute(p20.backgroundSceneManager, avatarRoute, avatarRoute2)
		end

		p20:callUpdateAvatarRoute(p20.characterManager, avatarRoute, avatarRoute2)

		if not v53 then
			p20:callUpdateAvatarRoute(p20.saveManager, avatarRoute, avatarRoute2)
		end
	end

	local catalogCategoryId = p21.catalogCategoryId
	local catalogCategoryId2 = p20.props.catalogCategoryId
	local catalogSubcategoryId = p21.catalogSubcategoryId
	local catalogSubcategoryId2 = p20.props.catalogSubcategoryId
	local catalogSearchCategoryId = p21.catalogSearchCategoryId
	local catalogSearchCategoryId2 = p20.props.catalogSearchCategoryId
	local catalogSearchSubcategoryId = p21.catalogSearchSubcategoryId
	local catalogSearchSubcategoryId2 = p20.props.catalogSearchSubcategoryId

	if catalogCategoryId2 ~= catalogCategoryId or catalogSubcategoryId2 ~= catalogSubcategoryId or catalogSearchCategoryId2 ~= catalogSearchCategoryId or catalogSearchSubcategoryId2 ~= catalogSearchSubcategoryId then
		p20:callUpdateCategorySelection(p20.characterMover)
		p20:callUpdateAvatarRoute(p20.characterManager, avatarRoute, avatarRoute2)
	end
end
function v65.render(p22) -- line: 569
	-- upvalues: Roact (copy), AvatarSceneSky (copy)
	if p22.props.renderSky then
		return Roact.createElement(AvatarSceneSky)
	end
end
function v65.maybeStartCharacterAndSaveManager(p23) -- line: 575
	-- upvalues: v53 (copy)
	if p23.characterManagerRunning or not p23.props.receivedAvatarData then
		return
	end

	p23.characterManager:start()

	if not v53 then
		p23.saveManager:start()
	end

	p23.characterManagerRunning = true
end
function v65.stopCharacterAndSaveManager(p24) -- line: 587
	-- upvalues: v53 (copy)
	if not p24.characterManagerRunning then
		return
	end

	p24.characterManager:stop()

	if not v53 then
		p24.saveManager:stop()
	end

	p24.characterManagerRunning = false
end
function v65.start(p25) -- line: 599
	-- upvalues: v50 (copy)
	v50:info("AvatarSceneManager:start()")

	if p25.running then
		return
	end

	if p25.backgroundSceneManager then
		p25.props.setThrottleFramerateEnabled(false)
		p25.backgroundSceneManager:start()
	end

	p25.running = true
	p25:maybeStartCharacterAndSaveManager()
	p25.characterMover:start()
	p25.props.setPageLoaded()
	p25.props.notificationService:ActionEnabled(Enum.AppShellActionType.AvatarEditorPageLoaded)
end
function v65.stop(p26) -- line: 622
	-- upvalues: v50 (copy)
	v50:info("AvatarSceneManager:stop()")

	if not p26.running then
		return
	end

	p26.props.setThrottleFramerateEnabled(true)
	p26.running = false
	p26:stopCharacterAndSaveManager()

	if p26.backgroundSceneManager then
		p26.backgroundSceneManager:stop()
	end

	p26.characterMover:stop()
end
function v65.onDestroy(p27) -- line: 640
	-- upvalues: v53 (copy)
	p27.characterManager:onDestroy()

	if p27.backgroundSceneManager then
		p27.backgroundSceneManager:onDestroy()
	end

	p27.characterMover:onDestroy()

	if not v53 then
		p27.saveManager:onDestroy()
	end
end

local v69 = RoactServices.connect({
	catalogAnalytics = Analytics2,
	analytics = Analytics,
	appAnalytics = RoactAnalytics,
	avatarExperienceAnalytics = Analytics3,
	networking = RoactNetworking,
	notificationService = AppNotificationService
})(v65)
local v70 = RoactRodux.connect(function(p28, _) -- line: 660
	-- upvalues: selectIsPortrait (copy), selectHasAvatarData (copy), FFlagSignalsNavP3gAvatarExperience (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	return {
		isPortrait = selectIsPortrait(p28),
		fullView = p28.AvatarExperience.Common.FullView,
		avatarPageLoaded = p28.AvatarExperience.AvatarEditor.PageLoaded,
		receivedAvatarData = selectHasAvatarData(p28),
		routeHistory = if not FFlagSignalsNavP3gAvatarExperience then if not FFlagUseNavigationSelectors then p28.Navigation.history else Selectors.selectLegacyHistory(p28) else nil
	}
end, function(p30) -- line: 672
	-- upvalues: SetPageLoaded (copy), SetFullView (copy)
	return {
		setPageLoaded = function() -- line: 674
			-- upvalues: p30 (copy), SetPageLoaded (copy)
			p30(SetPageLoaded(true))
		end,
		setFullView = function(p31, p32, p33) -- line: 677
			-- upvalues: p30 (copy), SetFullView (copy)
			p30(SetFullView(p31, p32, p33))
		end
	}
end)(v69)

if FFlagSignalsNavP3gAvatarExperience then
	local v71 = v70

	function v70(p34) -- line: 685
		-- upvalues: v63 (copy), useSignalState (copy), React (copy), v71 (copy), Cryo (copy)
		local v134 = v63(false)
		local v135 = useSignalState(v134.getHistory)

		return React.createElement(v71, Cryo.Dictionary.union(p34, {
			routeHistory = v135
		}))
	end
end

local v72 = withAppRoute((wrapWithSceneInteractionEvents(v70)))

if not GetFFlagCleanUpAXAlternativeLandingPageIXP() and AXAlternateLandingPageIXP then
	v72 = IxpUtils.connectTestVariables({
		alternateAvatarLandingScreenFullscreenEnabled = AXAlternateLandingPageIXP.GetFullScreenEnabled
	})(v72)
end

local v73 = AfterAvatarExperienceLoaded(v72, false)
local u74 = withThrottleFramerateGivenPolicy((RoactAppPolicy.connect(function(p35) -- line: 712
	return {
		allowCameraMovements = p35.getAllowCameraMovements()
	}
end)(v73)))

local function AvatarSceneManagerWrapper(p36) -- line: 720
	-- upvalues: useBodyDataEventsContext (copy), Cryo (copy), useAdjustmentDataEventsContext (copy), useAppliedDescriptionCallbackContext (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), GetFFlagCleanUpAXAlternativeLandingPageIXP (copy), useUiModeInfo (copy), UiMode (copy), React (copy), u74 (ref)
	local v138 = useBodyDataEventsContext()
	local v139 = Cryo.Dictionary.join(v138, p36)
	local v140 = useAdjustmentDataEventsContext()
	local v141 = useAppliedDescriptionCallbackContext()
	local v142 = Cryo.Dictionary.join(v140, v139, v141)
	local v143 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v144 = useSignalState(v143.selectedCategoryId)
	local v145 = useSignalState(v143.selectedSubcategoryId)

	v142.catalogCategoryId = v144
	v142.catalogSubcategoryId = v145

	local v146 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
	local v147 = useSignalState(v146.selectedCategoryId)
	local v148 = useSignalState(v146.selectedSubcategoryId)

	v142.catalogSearchCategoryId = v147
	v142.catalogSearchSubcategoryId = v148

	if GetFFlagCleanUpAXAlternativeLandingPageIXP() then
		v142.is10ftUI = useUiModeInfo().uiMode == UiMode.TenFoot
	end

	return React.createElement(u74, v142)
end

return AvatarSceneManagerWrapper
