local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local ChatSheetView = require(BuildExperience.Components.ChatSheet.ChatSheetView)
require(BuildExperience.Components.ChatSheet.useChatSheetViewModel)
local GetLibraryStore = require(BuildExperience.Stores.GetLibraryStore)
local LibraryChatSheetOverlay = require(script.Parent.LibraryChatSheetOverlay)
local useLibraryChatSheetViewModel = require(script.Parent.useLibraryChatSheetViewModel)

local tokenOverrides = { ["Color.Common.Backdrop"] = "Color.None" }

local function onBoundsChanged(p: number?, p2: number?)
	local libraryStore = GetLibraryStore()
	libraryStore.setWorldChatTop(p)
	libraryStore.setWorldChatLeft(p2)
end

local computed = Signals.createComputed(function(p)
	local worldViewportRect = GetLibraryStore().getWorldViewportRect(p)

	if worldViewportRect == nil then
		return nil
	end

	return worldViewportRect.Min.Y
end)

local function ViewportTopOverlay(p)
	local top = SignalsReact.useSignalState(computed)
	local clone = table.clone(p)
	clone.top = top
	return React.createElement(LibraryChatSheetOverlay, clone)
end

local function LibraryChatSheet(p)
	local v = RoactUtils.Hooks.useSelectedTheme()
	local v2 = Foundation.Hooks.useOverlay()
	local screenGui

	if v2 ~= nil then
		screenGui = v2:FindFirstAncestorWhichIsA("ScreenGui")
	end

	local v3 = useLibraryChatSheetViewModel(p)
	local createElement = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local colorMode

	if v == "light" then
		colorMode = Foundation.Enums.ColorMode.Light
	else
		colorMode = Foundation.Enums.ColorMode.Dark
	end

	local displayOrder

	if screenGui ~= nil then
		displayOrder = screenGui.DisplayOrder
	end

	return createElement(foundationProvider, {
		colorMode = colorMode,
		overlayGui = { DisplayOrder = displayOrder },
		tokenOverrides = tokenOverrides
	}, {
		Overlay = React.createElement(ViewportTopOverlay, {
			isOpen = v3.isOpen,
			snapPoints = v3.snapPoints,
			onBoundsChanged = onBoundsChanged,
			renderSheet = function(snapPoints, onFramesChanged, onSnapPointChanged)
				local clone = table.clone(v3)
				clone.snapPoints = snapPoints
				clone.onFramesChanged = onFramesChanged
				clone.onSnapPointChanged = onSnapPointChanged
				return React.createElement(ChatSheetView, clone)
			end
		})
	})
end

return LibraryChatSheet
