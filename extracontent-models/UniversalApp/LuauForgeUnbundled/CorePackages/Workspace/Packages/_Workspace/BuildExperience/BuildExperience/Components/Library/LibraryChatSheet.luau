local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local ChatSheetView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/ChatSheetView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useChatSheetViewModel")
local GetLibraryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetLibraryStore")
local LibraryChatSheetOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryChatSheetOverlay")
local useLibraryChatSheetViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/useLibraryChatSheetViewModel")

local v5 = { ["Color.Common.Backdrop"] = "Color.None" }

local function onBoundsChanged(p2, p3)
	local v6 = GetLibraryStore()
	v6.setWorldChatTop(p2)
	v6.setWorldChatLeft(p3)
end

local computed = Signals.createComputed(function(p2)
	local worldViewportRect = GetLibraryStore().getWorldViewportRect(p2)

	if worldViewportRect == nil then
		return nil
	end

	return worldViewportRect.Min.Y
end)

local function ViewportTopOverlay(p2)
	local v6 = SignalsReact.useSignalState(computed)
	local clone = table.clone(p2)
	clone.top = v6
	return React.createElement(LibraryChatSheetOverlay, clone)
end

local function LibraryChatSheet(p2)
	local v6 = RoactUtils.Hooks.useSelectedTheme()
	local v7 = Foundation.Hooks.useOverlay()
	local screenGui = if v7 ~= nil then v7:FindFirstAncestorWhichIsA("ScreenGui") else nil
	local v8 = useLibraryChatSheetViewModel(p2)
	local createElement = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local v10 = if v6 == "light" then Foundation.Enums.ColorMode.Light else Foundation.Enums.ColorMode.Dark
	local v12 = if screenGui ~= nil then screenGui.DisplayOrder else nil
	return createElement(foundationProvider, {
		colorMode = v10,
		overlayGui = { DisplayOrder = v12 },
		tokenOverrides = v5
	}, {
		Overlay = React.createElement(ViewportTopOverlay, {
			isOpen = v8.isOpen,
			snapPoints = v8.snapPoints,
			onBoundsChanged = onBoundsChanged,
			renderSheet = function(snapPoints, onFramesChanged, onSnapPointChanged)
				local clone = table.clone(v8)
				clone.snapPoints = snapPoints
				clone.onFramesChanged = onFramesChanged
				clone.onSnapPointChanged = onSnapPointChanged
				return React.createElement(ChatSheetView, clone)
			end
		})
	})
end

return LibraryChatSheet
