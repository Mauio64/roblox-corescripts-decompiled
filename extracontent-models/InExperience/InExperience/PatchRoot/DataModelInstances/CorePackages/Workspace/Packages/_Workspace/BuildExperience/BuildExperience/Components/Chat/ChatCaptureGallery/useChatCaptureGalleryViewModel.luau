local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.ChatCaptureGalleryView)

local FFlagBuildExperienceChatCaptureGalleryNewestFirst = require(BuildExperience.Flags.FFlagBuildExperienceChatCaptureGalleryNewestFirst)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local useLocalization = Localization.Hooks.useLocalization

local function cloneCaptures(initialCaptures)
	return table.clone(initialCaptures)
end

local function sortCapturesOldestFirst(items)
	local v = {}

	for k, item in items do
		local captureTime = item.CaptureTime
		table.insert(v, {
			capture = item,
			index = k,
			timestamp = typeof(captureTime) ~= "DateTime" and 0 or captureTime.UnixTimestampMillis
		})
	end

	table.sort(v, function(a, b): boolean
		if a.timestamp == b.timestamp then
			return a.index < b.index
		end

		return a.timestamp < b.timestamp
	end)

	local captures = {}

	for _, v2 in v do
		table.insert(captures, v2.capture)
	end

	return captures
end

local function useChatCaptureGalleryViewModel(data)
	local v = SignalsReact.useSignalState(data.captureSource.getCaptures)
	local isFinished = SignalsReact.useSignalState(data.captureSource.getIsFinished)
	local captures = React.useMemo(function()
		local result = {}

		for _, v2 in v do
			if v2.CaptureType == Enum.CaptureType.Screenshot then
				table.insert(result, v2)
			end
		end

		if FFlagBuildExperienceChatCaptureGalleryNewestFirst then
			return result
		end

		return sortCapturesOldestFirst(result)
	end, { v })
	local state, setState = React.useState(function()
		return cloneCaptures(data.initialCaptures)
	end)

	local ref = React.useRef(data.isOpen)
	local v2 = useLocalization({
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

	local isSelected = React.useCallback(function(p): boolean
		return table.find(state, p) ~= nil
	end, { state })

	local onCaptureToggled = React.useCallback(function(p)
		setState(function(list)
			local index = table.find(list, p)

			if index == nil then
				if #list >= data.maxSelections then
					return list
				end

				local clone = table.clone(list)
				table.insert(clone, p)
				return clone
			else
				local clone = table.clone(list)
				table.remove(clone, index)
				return clone
			end
		end)
	end, { data.maxSelections })

	local onConfirm = React.useCallback(function()
		data.onConfirm(state)
	end, { data.onConfirm, state })

	return {
		addText = v2.add,
		captures = captures,
		emptyText = v2.empty,
		isFinished = isFinished,
		isLoading = #v == 0 and not isFinished,
		isOpen = data.isOpen,
		maxSelections = data.maxSelections,
		selectedCount = #state,
		selectionCountText = v2.selectionCount,
		showMoreText = v2.showMore,
		titleText = v2.title,
		isSelected = isSelected,
		onCaptureToggled = onCaptureToggled,
		onClose = data.onClose,
		onConfirm = onConfirm,
		onShowMore = data.captureSource.fetchMore,
		shouldProgressivelyLoad = data.shouldProgressivelyLoad
	}
end

return useChatCaptureGalleryViewModel
