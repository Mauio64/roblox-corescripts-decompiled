local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell
local fFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceInstanceSelection
	and FFlagBuildExperienceInGameShell
	and SharedFlags.FFlagBuildExperienceChatResourceAttachments
local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)
local v

if SharedFlags.FFlagBuildExperienceInGameCaptureToChat and FFlagBuildExperienceChatImageAttachments then
	v = require(BuildExperience.utils.isImageAttachmentSupported)
end

local v2 = SharedFlags.FFlagBuildExperienceInGameCaptureToChat and FFlagBuildExperienceChatImageAttachments and v()
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

if fFlagBuildExperienceChatResourceAttachments then
	InstanceSelectionProtocol = require(BuildExperience.Components.ChatSheet.InstanceSelectionProtocol)
else
	InstanceSelectionProtocol = nil
end

local LibraryTypes

if fFlagBuildExperienceChatResourceAttachments then
	LibraryTypes = require(BuildExperience.Components.Library.LibraryTypes)
else
	LibraryTypes = nil
end

local clientDataModelCollector

if fFlagBuildExperienceChatResourceAttachments then
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
local FFlagBuildExperienceChatSheetReversedContent = require(BuildExperience.Flags.FFlagBuildExperienceChatSheetReversedContent)
local LocalizationProvider = Localization.LocalizationProvider

local RobloxAppInteractionFeedbackConfig = require(parent.RobloxAppInteractionFeedbackConfig)
local AppInteractionFeedbackProvider = RobloxAppInteractionFeedbackConfig.AppInteractionFeedbackProvider

local function createAppLocalization(robloxLocaleId: string) -- 1 equivalent call inferred from this helper
	local InExperienceLocales = require(parent.InExperienceLocales)
	return InExperienceLocales.Localization.new(robloxLocaleId)
end

local defineFastInt = game:DefineFastInt("FIntInGameBuildChatSheetSnapPoint", 50)

local v3 = { defineFastInt / 100 }

local v4 = { defineFastInt / 100, 1 }

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
	local v5

	if v2 then
		v5 = useCaptureToChat(function()
			playButtonStore.setIsActive(true)
		end, p.takeCapture)
	end

	local viewer = teamCreateUtils.isViewer()
	local topBarPillMenuTarget = {
		universeId = game.GameId,
		placeId = game.PlaceId,
		isNewGameTarget = false
	}

	local v6 = playButtonStore.useResumeTarget()
	local sessionId

	if v6 then
		sessionId = v6.sessionId
	end

	if viewer and v6 == nil then
		sessionId = BuildModeLaunch:getChatSessionId(game.PlaceId)
	end

	if FFlagReportBuildUIVisibility then
		trackBuildOpenSafetyService(isOpen)
	end

	local onClose = React.useCallback(function()
		playButtonStore.setIsActive(false)
	end, { playButtonStore })

	local createElement = React.createElement
	local v7

	if viewer then
		v7 = require(BuildExperience.Components.Library.LibraryChatSheet)
	else
		v7 = ChatSheet
	end

	local snapPoints

	if viewer then
		snapPoints = v3
	elseif FFlagBuildExperienceChatSheetReversedContent then
		snapPoints = v4
	else
		snapPoints = { defineFastInt / 100 }
	end

	if not isOpen or viewer then
		topBarPillMenuTarget = nil
	end

	local universeId

	if v6 then
		universeId = v6.universeId
	end

	local placeId

	if v6 then
		placeId = v6.placeId
	end

	local captureToAttach

	if v5 ~= nil then
		captureToAttach = v5.captureToAttach
	end

	local onCaptureAttached

	if v5 ~= nil then
		onCaptureAttached = v5.onCaptureAttached
	end

	local element = createElement(v7, {
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
	local v8 = {
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

	if v5 ~= nil then
		onCaptureActivated = v5.onCaptureActivated
	end

	v8.onCaptureActivated = onCaptureActivated
	v8.onInsetsChanged = onInsetsChanged
	local onSelectionActivated

	if fFlagBuildExperienceChatResourceAttachments and not viewer then
		onSelectionActivated = beginInstanceSelection
	end

	v8.onSelectionActivated = onSelectionActivated
	return createElement2(fragment, nil, {
		ChatSheet = element,
		Shell = createElement3(InGameBuildShell, v8)
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
	local v5 = {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Sheet = React.createElement(lazyComponent, p)
	}
	local foundationProvider

	if teamCreateUtils.isViewer() then
		foundationProvider = React.createElement(LibraryThemeProvider, { displayOrder = 9 }, v5)
	else
		foundationProvider = React.createElement(Foundation.FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark,
			overlayGui = { DisplayOrder = 9 }
		}, v5)
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
