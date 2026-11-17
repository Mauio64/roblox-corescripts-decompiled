local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell
local v = SharedFlags.FFlagBuildExperienceInstanceSelection and FFlagBuildExperienceInGameShell
local v2

if SharedFlags.FFlagBuildExperienceInGameCaptureToChat then
	v2 = require(BuildExperience.utils.isImageAttachmentSupported)
end

local v3 = SharedFlags.FFlagBuildExperienceInGameCaptureToChat and v2()
local Display

if FFlagBuildExperienceInGameShell then
	Display = require(parent.Display)
else
	Display = nil
end

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local RoactUtils = require(parent.RoactUtils)
local SignalsReact

if FFlagBuildExperienceInGameShell then
	SignalsReact = require(parent.SignalsReact)
else
	SignalsReact = nil
end

local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)
local BuildModeLaunch = require(parent.BuildExperiencePlaytestLaunch.BuildModeLaunch)
local ChatSheet = require(BuildExperience.Components.ChatSheet.ChatSheet)
local InGameBuildShell

if FFlagBuildExperienceInGameShell then
	InGameBuildShell = require(BuildExperience.Components.ChatSheet.InGameBuildShell)
else
	InGameBuildShell = nil
end

local InstanceSelectionProtocol

if v then
	InstanceSelectionProtocol = require(BuildExperience.Components.ChatSheet.InstanceSelectionProtocol)
else
	InstanceSelectionProtocol = nil
end

local LibraryTypes

if v then
	LibraryTypes = require(BuildExperience.Components.Library.LibraryTypes)
else
	LibraryTypes = nil
end

local clientDataModelCollector

if v then
	clientDataModelCollector = require(BuildExperience.Chat.clientDataModelCollector)
else
	clientDataModelCollector = nil
end

local useCaptureToChat = require(BuildExperience.Components.ChatSheet.useCaptureToChat)
local GetAssistantBuildStore

if FFlagBuildExperienceInGameShell then
	GetAssistantBuildStore = require(BuildExperience.Stores.GetAssistantBuildStore)
else
	GetAssistantBuildStore = nil
end

local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local LibraryThemeProvider = require(BuildExperience.Components.Library.LibraryThemeProvider)
local teamCreateUtils = require(parent.BuildExperiencePlaytestLaunch.teamCreateUtils)
local trackBuildOpenSafetyService = require(BuildExperience.utils.trackBuildOpenSafetyService)
local FFlagReportBuildUIVisibility = require(BuildExperience.Flags.FFlagReportBuildUIVisibility)
local clientLogsCollector = require(BuildExperience.Chat.clientLogsCollector)
local LocalizationProvider = Localization.LocalizationProvider

local RobloxAppInteractionFeedbackConfig = require(parent.RobloxAppInteractionFeedbackConfig)
local AppInteractionFeedbackProvider = RobloxAppInteractionFeedbackConfig.AppInteractionFeedbackProvider

local function createAppLocalization(robloxLocaleId: string) -- 1 equivalent call inferred from this helper
	local InExperienceLocales = require(parent.InExperienceLocales)
	return InExperienceLocales.Localization.new(robloxLocaleId)
end

local defineFastInt = game:DefineFastInt("FIntInGameBuildChatSheetSnapPoint", 50)

local v4 = { defineFastInt / 100 }

local v5 = { defineFastInt / 100, 1 }

local function beginInstanceSelection()
	InstanceSelectionProtocol.beginSelection(function(data)
		if data.status ~= "selected" or data.path == nil or data.className == nil then
			return
		end

		local instancePath = clientDataModelCollector.resolveInstancePath(data.path, data.className)

		if instancePath == nil then
			return
		end

		local playButtonStore = GetPlayButtonStore()
		playButtonStore.setPendingResourceAttachment(LibraryTypes.toResourceAttachment({
			path = instancePath,
			displayName = data.displayName or instancePath,
			className = data.className
		}))

		playButtonStore.setIsActive(true)
	end)
end

local function ConnectedChatSheet(p)
	local playButtonStore = GetPlayButtonStore()
	local isOpen = playButtonStore.useIsActive()
	local v6

	if v3 then
		v6 = useCaptureToChat(function()
			playButtonStore.setIsActive(true)
		end, p.takeCapture)
	end

	local viewer = teamCreateUtils.isViewer()
	local topBarPillMenuTarget = {
		universeId = game.GameId,
		placeId = game.PlaceId,
		isNewGameTarget = false
	}

	local v7 = playButtonStore.useResumeTarget()
	local sessionId

	if v7 then
		sessionId = v7.sessionId
	end

	if viewer and v7 == nil then
		sessionId = BuildModeLaunch:getChatSessionId(game.PlaceId)
	end

	if FFlagReportBuildUIVisibility then
		trackBuildOpenSafetyService(isOpen)
	end

	local onClose = React.useCallback(function()
		playButtonStore.setIsActive(false)
	end, { playButtonStore })

	local createElement = React.createElement
	local v8

	if viewer then
		v8 = require(BuildExperience.Components.Library.LibraryChatSheet)
	else
		v8 = ChatSheet
	end

	local snapPoints = if viewer then v4 else v5

	if not isOpen or viewer then
		topBarPillMenuTarget = nil
	end

	local universeId

	if v7 then
		universeId = v7.universeId
	end

	local placeId

	if v7 then
		placeId = v7.placeId
	end

	local captureToAttach

	if v6 ~= nil then
		captureToAttach = v6.captureToAttach
	end

	local onCaptureAttached

	if v6 ~= nil then
		onCaptureAttached = v6.onCaptureAttached
	end

	local element = createElement(v8, {
		isOpen = isOpen,
		onClose = onClose,
		snapPoints = snapPoints,
		defaultSnapPointIndex = 1,
		topBarPillMenuTarget = topBarPillMenuTarget,
		universeId = universeId,
		placeId = placeId,
		sessionId = sessionId,
		captureToAttach = captureToAttach,
		onCaptureAttached = onCaptureAttached
	})

	if not FFlagBuildExperienceInGameShell then
		return element
	end

	local assistantBuildStore = GetAssistantBuildStore()
	local displayStore = Display.GetDisplayStore(false)
	local isVisible = SignalsReact.useSignalState(assistantBuildStore.getIsOverlayVisible)
	local onInsetsChanged = React.useCallback(function(left: number, right: number, bottom: number)
		displayStore.setGuiInset(function(p2)
			return { left = left, top = p2.top, right = right, bottom = bottom }
		end)
	end, { displayStore })

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local createElement3 = React.createElement
	local v9 = {
		isVisible = isVisible,
		isLibraryMode = viewer,
		onActivated = function()
			playButtonStore.setIsActive(true)
		end,
		onCaptureActivated = 0,
		onInsetsChanged = 0,
		onSelectionActivated = 0
	}
	local onCaptureActivated

	if v6 ~= nil then
		onCaptureActivated = v6.onCaptureActivated
	end

	v9.onCaptureActivated = onCaptureActivated
	v9.onInsetsChanged = onInsetsChanged
	local onSelectionActivated

	if v and not viewer then
		onSelectionActivated = beginInstanceSelection
	end

	v9.onSelectionActivated = onSelectionActivated
	return createElement2(fragment, nil, {
		ChatSheet = element,
		Shell = createElement3(InGameBuildShell, v9)
	})
end

local lazyComponent = RoactUtils.Components.createLazyComponent(function()
	return ConnectedChatSheet
end)

local function mountChatSheet(p)
	clientLogsCollector.startServerLogCollection()

	local buildExperienceChatSheet = Instance.new("ScreenGui")
	buildExperienceChatSheet.Name = "BuildExperienceChatSheet"
	buildExperienceChatSheet.IgnoreGuiInset = true
	buildExperienceChatSheet.ResetOnSpawn = false

	if FFlagBuildExperienceInGameShell then
		buildExperienceChatSheet.ClipToDeviceSafeArea = false
		buildExperienceChatSheet.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
		buildExperienceChatSheet.ScreenInsets = Enum.ScreenInsets.None
	end

	buildExperienceChatSheet.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	buildExperienceChatSheet.Parent = CoreGui
	buildExperienceChatSheet.DisplayOrder = 9

	local root = ReactRoblox.createRoot(buildExperienceChatSheet)
	local appLocalization = createAppLocalization(LocalizationService.RobloxLocaleId) -- inferred equivalent call
	local v6 = {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Sheet = React.createElement(lazyComponent, p)
	}
	local foundationProvider

	if teamCreateUtils.isViewer() then
		foundationProvider = React.createElement(LibraryThemeProvider, { displayOrder = 9 }, v6)
	else
		foundationProvider = React.createElement(Foundation.FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark,
			overlayGui = { DisplayOrder = 9 }
		}, v6)
	end

	local element = React.createElement(AppInteractionFeedbackProvider, nil, {
		FoundationProvider = foundationProvider
	})

	root:render(React.createElement(LocalizationProvider, { localization = appLocalization }, {
		ChatSheet = element
	}))

	return root
end

return mountChatSheet
