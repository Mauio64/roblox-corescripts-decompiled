local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local fFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell
local v5 = SharedFlags.FFlagBuildExperienceInstanceSelection and fFlagBuildExperienceInGameShell
local v6 = if SharedFlags.FFlagBuildExperienceInGameCaptureToChat then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/isImageAttachmentSupported") else nil

local v7 = SharedFlags.FFlagBuildExperienceInGameCaptureToChat and v6()
local v8 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display") else nil
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils")
local v9 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact") else nil

local BuildExperienceCompositionStyleSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildExperienceCompositionStyleSheet")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPortal")
local BuildModeLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/BuildModeLaunch")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/ChatSheet")

local v10 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/InGameBuildShell") else nil

local v11 = if v5 then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/InstanceSelectionProtocol") else nil

local v12 = if v5 then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryTypes") else nil

local v13 = if v5 then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientDataModelCollector") else nil

local useCaptureToChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useCaptureToChat")

local v14 = if fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAssistantBuildStore") else nil

local GetPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore")
local LibraryThemeProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryThemeProvider")
local teamCreateUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/teamCreateUtils")
local trackBuildOpenSafetyService = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/trackBuildOpenSafetyService")
local FFlagReportBuildUIVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagReportBuildUIVisibility")
local clientLogsCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/clientLogsCollector")
local localizationProvider = Localization.LocalizationProvider

local appInteractionFeedbackProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RobloxAppInteractionFeedbackConfig").AppInteractionFeedbackProvider

local function createAppLocalization(p2)
	return require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/InExperienceLocales").Localization.new(p2)
end

local defineFastInt = game:DefineFastInt("FIntInGameBuildChatSheetSnapPoint", 50)

local v15 = { defineFastInt / 100 }

local v16 = { defineFastInt / 100, 1 }

local function beginInstanceSelection()
	v11.beginSelection(function(data)
		if data.status ~= "selected" or data.path == nil or data.className == nil then
			return
		end

		local instancePath = v13.resolveInstancePath(data.path, data.className)

		if instancePath == nil then
			return
		end

		local v17 = GetPlayButtonStore()
		v17.setPendingResourceAttachment(v12.toResourceAttachment({
			path = instancePath,
			displayName = data.displayName or instancePath,
			className = data.className
		}))

		v17.setIsActive(true)
	end)
end

local function ConnectedChatSheet(p2)
	local v17 = GetPlayButtonStore()
	local v18 = v17.useIsActive()
	local v19

	if v7 then
		v19 = useCaptureToChat(function()
			v17.setIsActive(true)
		end, p2.takeCapture)
	end

	local viewer = teamCreateUtils.isViewer()
	local v20 = {
		universeId = game.GameId,
		placeId = game.PlaceId,
		isNewGameTarget = false
	}

	local v21 = v17.useResumeTarget()
	local v22 = if v21 then v21.sessionId else nil

	if viewer and v21 == nil then
		v22 = BuildModeLaunch:getChatSessionId(game.PlaceId)
	end

	if FFlagReportBuildUIVisibility then
		trackBuildOpenSafetyService(v18)
	end

	local v23 = React.useCallback(function()
		v17.setIsActive(false)
	end, { v17 })

	local createElement = React.createElement
	local v24 = if viewer then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryChatSheet") else module9
	local v25 = {
		isOpen = v18,
		onClose = v23,
		snapPoints = if viewer then v15 else v16,
		defaultSnapPointIndex = 1,
		topBarPillMenuTarget = nil,
		universeId = 0,
		placeId = 0,
		sessionId = 0,
		captureToAttach = 0,
		onCaptureAttached = 0
	}

	if not v18 or viewer then
		v20 = nil
	end

	v25.topBarPillMenuTarget = v20
	local v27 = if v21 then v21.universeId else nil
	v25.universeId = v27
	local v28 = if v21 then v21.placeId else nil
	v25.placeId = v28
	v25.sessionId = v22
	local v29 = if v19 ~= nil then v19.captureToAttach else nil
	v25.captureToAttach = v29
	local v30 = if v19 ~= nil then v19.onCaptureAttached else nil
	v25.onCaptureAttached = v30
	local element = createElement(v24, v25)

	if not fFlagBuildExperienceInGameShell then
		return element
	end

	local v31 = v14()
	local displayStore = v8.GetDisplayStore(false)
	local v32 = v9.useSignalState(v31.getIsOverlayVisible)
	local v33 = React.useCallback(function(p3, p4, p5)
		displayStore.setGuiInset(function(p6)
			return { left = p3, top = p6.top, right = p4, bottom = p5 }
		end)
	end, { displayStore })

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local createElement3 = React.createElement
	local v37 = {
		isVisible = v32,
		isLibraryMode = viewer,
		onActivated = function()
			v17.setIsActive(true)
		end,
		onCaptureActivated = 0,
		onInsetsChanged = 0,
		onSelectionActivated = 0
	}
	local v38 = if v19 ~= nil then v19.onCaptureActivated else nil
	v37.onCaptureActivated = v38
	v37.onInsetsChanged = v33
	local v39 = if v5 and not viewer then beginInstanceSelection else nil
	v37.onSelectionActivated = v39
	return createElement2(fragment, nil, {
		ChatSheet = element,
		Shell = createElement3(v10, v37)
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

	local v17 = {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Sheet = React.createElement(lazyComponent, p2)
	}
	local v18

	if teamCreateUtils.isViewer() then
		v18 = React.createElement(LibraryThemeProvider, { displayOrder = 9 }, v17)
	else
		v18 = React.createElement(Foundation.FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark,
			overlayGui = { DisplayOrder = 9 }
		}, v17)
	end

	local element = React.createElement(appInteractionFeedbackProvider, nil, {
		FoundationProvider = v18
	})

	root:render(React.createElement(localizationProvider, {
		localization = localization
	}, {
		ChatSheet = element
	}))

	return root
end

return mountChatSheet
