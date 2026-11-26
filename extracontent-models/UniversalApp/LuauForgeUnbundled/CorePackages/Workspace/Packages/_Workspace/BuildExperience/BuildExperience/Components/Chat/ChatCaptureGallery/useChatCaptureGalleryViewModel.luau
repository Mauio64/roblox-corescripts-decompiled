local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureGalleryView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureToolbarIllustration")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled")

local v5 = if FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display") else nil

local useLocalization = Localization.Hooks.useLocalization

local function cloneCaptures(initialCaptures)
	return table.clone(initialCaptures)
end

local function getToolbarLayout(p2, p3): string
	if p2 ~= nil and p2 ~= Enum.DisplaySize.Small then
		return "floating"
	end

	if p3.X > p3.Y then
		return "sideRail"
	end

	return "bottomBar"
end

local function useChatCaptureGalleryViewModel(data)
	local v6 = SignalsReact.useSignalState(data.captureSource.getCaptures)
	local v7 = SignalsReact.useSignalState(data.captureSource.getIsFinished)
	local v8 = React.useMemo(function()
		local result = {}

		for k, v9 in v6 do
			if v9.CaptureType == Enum.CaptureType.Screenshot then
				table.insert(result, v9)
			end
		end

		return result
	end, { v6 })
	local state, setState = React.useState(function()
		return cloneCaptures(data.initialCaptures)
	end)

	local ref = React.useRef(data.isOpen)
	local v9 = useLocalization({
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

	local v10 = React.useCallback(function(p2): boolean
		return table.find(state, p2) ~= nil
	end, { state })

	local v11 = React.useCallback(function(p2)
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

	local v12 = React.useCallback(function()
		data.onConfirm(state)
	end, { data.onConfirm, state })
	local v13

	if FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled then
		local displayStore = v5.GetDisplayStore(false)
		local v14 = SignalsReact.useSignalState(displayStore.getDisplaySize)
		local v15 = SignalsReact.useSignalState(displayStore.getViewportSize)
		local v16 = useLocalization({
			description = LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY_DESCRIPTION,
			dismiss = LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY_DISMISS,
			step1 = LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_1,
			step2 = LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_2,
			step3 = LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_3
		})
		v13 = {
			descriptionText = v16.description,
			dismissText = v16.dismiss,
			howToSteps = { v16.step1, v16.step2, v16.step3 },
			isShown = v7 and #v8 == 0,
			toolbarLayout = (v14 == nil or v14 == Enum.DisplaySize.Small) and (v15.X > v15.Y and "sideRail" or "bottomBar") or "floating"
		}
	end

	return {
		addText = v9.add,
		captures = v8,
		education = v13,
		emptyText = v9.empty,
		isFinished = v7,
		isLoading = #v6 == 0 and not v7,
		isOpen = data.isOpen,
		maxSelections = data.maxSelections,
		selectedCount = #state,
		selectionCountText = v9.selectionCount,
		showMoreText = v9.showMore,
		titleText = v9.title,
		isSelected = v10,
		onCaptureToggled = v11,
		onClose = data.onClose,
		onConfirm = v12,
		onShowMore = data.captureSource.fetchMore,
		shouldProgressivelyLoad = data.shouldProgressivelyLoad
	}
end

return useChatCaptureGalleryViewModel
