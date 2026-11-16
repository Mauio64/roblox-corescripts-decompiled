local musicPicker = script:FindFirstAncestor("MusicPicker")
local parent = musicPicker.Parent

local React = require(parent.React)

local MusicPickerContext = require(musicPicker.Context.MusicPickerContext)
local MusicPickerView = require(musicPicker.Components.MusicPickerView)
local useMusicPickerViewModel = require(musicPicker.Hooks.useMusicPickerViewModel)
local useMusicPickerAnalytics = require(musicPicker.Hooks.useMusicPickerAnalytics)
require(musicPicker.Types.MusicPickerTypes)

local function MusicPickerBase(props)
	local v = useMusicPickerViewModel({
		tabs = props.tabs,
		onQueryChanged = props.onQueryChanged,
		onTabChanged = props.onTabChanged,
		initialQuery = props.initialQuery
	})

	return React.createElement(MusicPickerView, {
		titleText = props.titleText,
		searchPlaceholder = props.searchPlaceholder,
		searchText = v.searchText,
		mode = v.mode,
		showTabs = props.showTabs,
		tabs = props.tabs,
		activeTabId = v.activeTabId,
		searchContent = props.searchContent,
		onSearchChanged = v.onSearchChanged,
		onSubmitSearch = v.onSubmitSearch,
		onTabSelected = v.onTabSelected,
		onClose = props.onClose,
		onSelect = props.onSelect,
		safeAreaInsets = props.safeAreaInsets
	})
end

local function MusicPicker(props)
	local itemsById = React.useMemo(function()
		local result = {}

		for _, tab in props.tabs do
			for _, item in tab.content.items do
				result[item.id] = item
			end
		end

		for _, item in props.searchContent.items do
			result[item.id] = item
		end

		return result
	end, { props.tabs, props.searchContent })

	local v = React.useContext(MusicPickerContext)
	local v2 = useMusicPickerAnalytics({
		source = props.source,
		previewingId = v.previewingId,
		savedIds = v.savedIds,
		itemsById = itemsById
	})

	local v3 = React.useMemo(function()
		return {
			previewingId = v.previewingId,
			togglePreview = function(p: number)
				if v.previewingId == p then
					v2(p)
				end

				v.togglePreview(p)
			end,
			savedIds = v.savedIds,
			toggleSaved = v.toggleSaved,
			showSaveButton = v.showSaveButton
		}
	end, { v, v2 })

	return React.createElement(MusicPickerContext.Provider, { value = v3 }, {
		Picker = React.createElement(MusicPickerBase, props)
	})
end

return MusicPicker
