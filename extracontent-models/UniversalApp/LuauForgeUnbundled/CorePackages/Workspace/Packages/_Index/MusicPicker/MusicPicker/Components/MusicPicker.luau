local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")

local MusicPickerContext = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Context/MusicPickerContext")
local MusicPickerView = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Components/MusicPickerView")
local useMusicPickerViewModel = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Hooks/useMusicPickerViewModel")
local useMusicPickerAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Hooks/useMusicPickerAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

local function MusicPickerBase(props)
	local v5 = useMusicPickerViewModel({
		tabs = props.tabs,
		onQueryChanged = props.onQueryChanged,
		onTabChanged = props.onTabChanged,
		initialQuery = props.initialQuery
	})

	return React.createElement(MusicPickerView, {
		titleText = props.titleText,
		searchPlaceholder = props.searchPlaceholder,
		searchText = v5.searchText,
		mode = v5.mode,
		showTabs = props.showTabs,
		tabs = props.tabs,
		activeTabId = v5.activeTabId,
		searchContent = props.searchContent,
		onSearchChanged = v5.onSearchChanged,
		onSubmitSearch = v5.onSubmitSearch,
		onTabSelected = v5.onTabSelected,
		onClose = props.onClose,
		onSelect = props.onSelect,
		safeAreaInsets = props.safeAreaInsets
	})
end

local function MusicPicker(props)
	local v5 = React.useMemo(function()
		local result = {}

		for k, tab in props.tabs do
			for k2, item in tab.content.items do
				result[item.id] = item
			end
		end

		for k, item in props.searchContent.items do
			result[item.id] = item
		end

		return result
	end, { props.tabs, props.searchContent })

	local v6 = React.useContext(MusicPickerContext)
	local v7 = useMusicPickerAnalytics({
		source = props.source,
		previewingId = v6.previewingId,
		savedIds = v6.savedIds,
		itemsById = v5
	})

	local v8 = React.useMemo(function()
		return {
			previewingId = v6.previewingId,
			togglePreview = function(p2)
				if v6.previewingId == p2 then
					v7(p2)
				end

				v6.togglePreview(p2)
			end,
			savedIds = v6.savedIds,
			toggleSaved = v6.toggleSaved,
			showSaveButton = v6.showSaveButton
		}
	end, { v6, v7 })

	return React.createElement(MusicPickerContext.Provider, { value = v8 }, {
		Picker = React.createElement(MusicPickerBase, props)
	})
end

return MusicPicker
