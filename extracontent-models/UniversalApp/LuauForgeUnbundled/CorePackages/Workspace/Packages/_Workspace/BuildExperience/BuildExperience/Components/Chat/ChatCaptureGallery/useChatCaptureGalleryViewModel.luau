local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureGalleryView")

local FFlagBuildExperienceChatCaptureGalleryNewestFirst = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCaptureGalleryNewestFirst")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local useLocalization = Localization.Hooks.useLocalization

local function cloneCaptures(initialCaptures)
	return table.clone(initialCaptures)
end

local function sortCapturesOldestFirst(items)
	local v5 = {}

	for k, item in items do
		local captureTime = item.CaptureTime
		table.insert(v5, {
			capture = item,
			index = k,
			timestamp = typeof(captureTime) ~= "DateTime" and 0 or captureTime.UnixTimestampMillis
		})
	end

	table.sort(v5, function(a, b): boolean
		if a.timestamp == b.timestamp then
			return a.index < b.index
		end

		return a.timestamp < b.timestamp
	end)

	local captures = {}

	for k, v6 in v5 do
		table.insert(captures, v6.capture)
	end

	return captures
end

local function useChatCaptureGalleryViewModel(data)
	local v5 = SignalsReact.useSignalState(data.captureSource.getCaptures)
	local v6 = SignalsReact.useSignalState(data.captureSource.getIsFinished)
	local v7 = React.useMemo(function()
		local result = {}

		for k, v8 in v5 do
			if v8.CaptureType == Enum.CaptureType.Screenshot then
				table.insert(result, v8)
			end
		end

		if FFlagBuildExperienceChatCaptureGalleryNewestFirst then
			return result
		end

		return sortCapturesOldestFirst(result)
	end, { v5 })
	local state, setState = React.useState(function()
		return cloneCaptures(data.initialCaptures)
	end)

	local ref = React.useRef(data.isOpen)
	local v8 = useLocalization({
		add = LocalizationStrings.CHAT_CAPTURE_GALLERY_ADD,
		empty = LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY,
		selectionCount = {
			LocalizationStrings.CHAT_CAPTURE_GALLERY_SELECTION_COUNT,
			SELECTED_COUNT = #state,
			MAX_SELECTIONS = data.maxSelections
		},
		showMore = LocalizationStrings.CHAT_CAPTURE_GALLERY_SHOW_MORE,
		title = LocalizationStrings.CHAT_CAPTURE_GALLERY_TITLE
	})

	React.useEffect(function()
		if data.isOpen and not ref.current then
			setState(cloneCaptures(data.initialCaptures))
		end

		ref.current = data.isOpen
	end, { data.isOpen, data.initialCaptures })

	local v9 = React.useCallback(function(p2): boolean
		return table.find(state, p2) ~= nil
	end, { state })

	local v10 = React.useCallback(function(p2)
		setState(function(list)
			local index = table.find(list, p2)

			if index == nil then
				if #list >= data.maxSelections then
					return list
				end

				local clone = table.clone(list)
				table.insert(clone, p2)
				return clone
			else
				local clone = table.clone(list)
				table.remove(clone, index)
				return clone
			end
		end)
	end, { data.maxSelections })

	local v11 = React.useCallback(function()
		data.onConfirm(state)
	end, { data.onConfirm, state })

	return {
		addText = v8.add,
		captures = v7,
		emptyText = v8.empty,
		isFinished = v6,
		isLoading = #v5 == 0 and not v6,
		isOpen = data.isOpen,
		maxSelections = data.maxSelections,
		selectedCount = #state,
		selectionCountText = v8.selectionCount,
		showMoreText = v8.showMore,
		titleText = v8.title,
		isSelected = v9,
		onCaptureToggled = v10,
		onClose = data.onClose,
		onConfirm = v11,
		onShowMore = data.captureSource.fetchMore,
		shouldProgressivelyLoad = data.shouldProgressivelyLoad
	}
end

return useChatCaptureGalleryViewModel
