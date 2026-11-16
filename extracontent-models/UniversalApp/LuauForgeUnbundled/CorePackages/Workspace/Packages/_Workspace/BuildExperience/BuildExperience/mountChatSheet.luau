local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local fFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell
local fFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceInstanceSelection
	and fFlagBuildExperienceInGameShell
	and SharedFlags.FFlagBuildExperienceChatResourceAttachments
local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")
local v5

if SharedFlags.FFlagBuildExperienceInGameCaptureToChat and FFlagBuildExperienceChatImageAttachments then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/isImageAttachmentSupported")
end

local v6 = SharedFlags.FFlagBuildExperienceInGameCaptureToChat and FFlagBuildExperienceChatImageAttachments and v5()
local v7 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display") else nil
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils")
local v8 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact") else nil

local BuildExperienceCompositionStyleSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildExperienceCompositionStyleSheet")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPortal")
local BuildModeLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/BuildModeLaunch")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/ChatSheet")

local v9 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/InGameBuildShell") else nil

local v10 = if fFlagBuildExperienceChatResourceAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/InstanceSelectionProtocol") else nil

local v11 = if fFlagBuildExperienceChatResourceAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryTypes") else nil

local v12 = if fFlagBuildExperienceChatResourceAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientDataModelCollector") else nil

local useCaptureToChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useCaptureToChat")

local v13 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAssistantBuildStore") else nil

local GetPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore")
local LibraryThemeProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryThemeProvider")
local teamCreateUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/teamCreateUtils")
local trackBuildOpenSafetyService = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/trackBuildOpenSafetyService")
local FFlagReportBuildUIVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagReportBuildUIVisibility")
local clientLogsCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientLogsCollector")
local FFlagBuildExperienceChatSheetReversedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatSheetReversedContent")
local localizationProvider = Localization.LocalizationProvider

local appInteractionFeedbackProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RobloxAppInteractionFeedbackConfig").AppInteractionFeedbackProvider

local function createAppLocalization(p2)
	return require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InExperienceLocales").Localization.new(p2)
end

local defineFastInt = game:DefineFastInt("FIntInGameBuildChatSheetSnapPoint", 50)

local v14 = { defineFastInt / 100 }

local v15 = { defineFastInt / 100, 1 }

local function beginInstanceSelection()
	v10.beginSelection(function(data)
		if data.status ~= "selected" or data.path == nil or data.className == nil then
			return
		end

		local instancePath = v12.resolveInstancePath(data.path, data.className)

		if instancePath == nil then
			return
		end

		local v16 = GetPlayButtonStore()
		v16.setPendingResourceAttachment(v11.toResourceAttachment({
			path = instancePath,
			displayName = data.displayName or instancePath,
			className = data.className
		}))

		v16.setIsActive(true)
	end)
end

local function ConnectedChatSheet(p2)
	local v16 = GetPlayButtonStore()
	local v17 = v16.useIsActive()
	local v18

	if v6 then
		v18 = useCaptureToChat(function()
			v16.setIsActive(true)
		end, p2.takeCapture)
	end

	local viewer = teamCreateUtils.isViewer()
	local v19 = {
		universeId = game.GameId,
		placeId = game.PlaceId,
		isNewGameTarget = false
	}

	local v20 = v16.useResumeTarget()
	local v21 = if v20 then v20.sessionId else nil

	if viewer and v20 == nil then
		v21 = BuildModeLaunch:getChatSessionId(game.PlaceId)
	end

	if FFlagReportBuildUIVisibility then
		trackBuildOpenSafetyService(v17)
	end

	local v22 = React.useCallback(function()
		v16.setIsActive(false)
	end, { v16 })

	local createElement = React.createElement
	local v23 = if viewer then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryChatSheet") else module10
	local v25

	if viewer then
		v25 = v14
	elseif FFlagBuildExperienceChatSheetReversedContent then
		v25 = v15
	else
		v25 = { defineFastInt / 100 }
	end

	if not v17 or viewer then
		v19 = nil
	end

	local v26 = if v20 then v20.universeId else nil
	local v27 = if v20 then v20.placeId else nil

	local v28 = if v18 ~= nil then v18.captureToAttach else nil
	local v29 = if v18 ~= nil then v18.onCaptureAttached else nil
	local element = createElement(v23, {
		isOpen = v17,
		onClose = v22,
		snapPoints = v25,
		defaultSnapPointIndex = 1,
		topBarPillMenuTarget = v19,
		universeId = v26,
		placeId = v27,
		sessionId = v21,
		captureToAttach = v28,
		onCaptureAttached = v29
	})

	if not fFlagBuildExperienceInGameShell then
		return element
	end

	local v30 = v13()
	local displayStore = v7.GetDisplayStore(false)
	local v31 = v8.useSignalState(v30.getIsOverlayVisible)
	local v32 = React.useCallback(function(p3, p4, p5)
		displayStore.setGuiInset(function(p6)
			return { left = p3, top = p6.top, right = p4, bottom = p5 }
		end)
	end, { displayStore })

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local createElement3 = React.createElement
	local v36 = {
		isVisible = v31,
		isLibraryMode = viewer,
		onActivated = function()
			v16.setIsActive(true)
		end,
		onCaptureActivated = 0,
		onInsetsChanged = 0,
		onSelectionActivated = 0
	}
	local v37 = if v18 ~= nil then v18.onCaptureActivated else nil
	v36.onCaptureActivated = v37
	v36.onInsetsChanged = v32
	local v38 = if fFlagBuildExperienceChatResourceAttachments and not viewer then beginInstanceSelection else nil
	v36.onSelectionActivated = v38
	return createElement2(fragment, nil, {
		ChatSheet = element,
		Shell = createElement3(v9, v36)
	})
end

local lazyComponent = RoactUtils.Components.createLazyComponent(function()
	return ConnectedChatSheet
end)

local function mountChatSheet(p2)
	clientLogsCollector.startServerLogCollection()

	local buildExperienceChatSheet = Instance.new("ScreenGui")
	buildExperienceChatSheet.Name = "BuildExperienceChatSheet"
	buildExperienceChatSheet.IgnoreGuiInset = true
	buildExperienceChatSheet.ResetOnSpawn = false

	if fFlagBuildExperienceInGameShell then
		buildExperienceChatSheet.ClipToDeviceSafeArea = false
		buildExperienceChatSheet.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
		buildExperienceChatSheet.ScreenInsets = Enum.ScreenInsets.None
	end

	buildExperienceChatSheet.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	buildExperienceChatSheet.Parent = CoreGui
	buildExperienceChatSheet.DisplayOrder = 9

	local root = ReactRoblox.createRoot(buildExperienceChatSheet)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InExperienceLocales").Localization.new(robloxLocaleId)

	local v16 = {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Sheet = React.createElement(lazyComponent, p2)
	}
	local v17

	if teamCreateUtils.isViewer() then
		v17 = React.createElement(LibraryThemeProvider, { displayOrder = 9 }, v16)
	else
		v17 = React.createElement(Foundation.FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark,
			overlayGui = { DisplayOrder = 9 }
		}, v16)
	end

	local element = React.createElement(appInteractionFeedbackProvider, nil, {
		FoundationProvider = v17
	})

	root:render(React.createElement(localizationProvider, {
		localization = localization
	}, {
		ChatSheet = element
	}))

	return root
end

return mountChatSheet
