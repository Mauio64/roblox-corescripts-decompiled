local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Localization = require(BuildExperienceParent.Localization)
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local RobloxAppLocales = require(BuildExperienceParent.RobloxAppLocales)
local RoactUtils = require(BuildExperienceParent.RoactUtils)
local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)

require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)

local ChatSheet = require(BuildExperience.Components.ChatSheet.ChatSheet)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local clientLogsCollector = require(BuildExperience.Chat.clientLogsCollector)
local LocalizationProvider = Localization.LocalizationProvider
local Localization2 = RobloxAppLocales.Localization
local v17 = game:DefineFastInt("FIntInGameBuildChatSheetSnapPoint", 50)

local function ConnectedChatSheet() -- line: 27
	-- upvalues: GetPlayButtonStore (copy), React (copy), ChatSheet (copy), v17 (copy)
	local v21 = GetPlayButtonStore()
	local v22 = v21.useIsActive()
	local t1 = {
		isNewGameTarget = false,
		universeId = game.GameId,
		placeId = game.PlaceId
	}
	local v24 = v21.useResumeTarget()
	local v25 = React.useCallback(function() -- line: 37
		-- upvalues: v21 (copy)
		v21.setIsActive(false)
	end, { v21 })

	return React.createElement(ChatSheet, {
		defaultSnapPointIndex = 1,
		isOpen = v22,
		onClose = v25,
		snapPoints = {
			v17 / 100,
			1
		},
		topBarPillMenuTarget = if not v22 then nil else t1,
		universeId = if not v24 then nil else v24.universeId,
		placeId = if not v24 then nil else v24.placeId,
		sessionId = if not v24 then nil else v24.sessionId
	})
end

local v19 = RoactUtils.Components.createLazyComponent(function() -- line: 53
	-- upvalues: ConnectedChatSheet (copy)
	return ConnectedChatSheet
end)

local function mountChatSheet() -- line: 57
	-- upvalues: clientLogsCollector (copy), CoreGui (copy), ReactRoblox (copy), Localization2 (copy), LocalizationService (copy), React (copy), LocalizationProvider (copy), Foundation (copy), BuildExperienceCompositionStyleSheet (copy), v19 (copy)
	clientLogsCollector.startServerLogCollection()

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "BuildExperienceChatSheet"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local v27 = ReactRoblox.createRoot(ScreenGui)
	local v28 = Localization2.new(LocalizationService.RobloxLocaleId)

	v27:render(React.createElement(LocalizationProvider, {
		localization = v28
	}, {
		FoundationProvider = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
			Sheet = React.createElement(v19)
		})
	}))

	return v27
end

return mountChatSheet
