local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.ChatCaptureGalleryView)
require(script.Parent.ChatCaptureToolbarIllustration)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled = require(BuildExperience.Flags.FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled)
local Display

if FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled then
	Display = require(parent.Display)
else
	Display = nil
end

local useLocalization = Localization.Hooks.useLocalization

local function cloneCaptures(initialCaptures)
	return table.clone(initialCaptures)
end

local function getToolbarLayout(p, vector2: Vector2): string -- 1 equivalent call inferred from this helper
	if p ~= nil and p ~= Enum.DisplaySize.Small then
		return "floating"
	end

	return if vector2.X > vector2.Y then "sideRail" else "bottomBar"
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

		return result
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
	local education

	if FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled then
		local displayStore = Display.GetDisplayStore(false)
		local v3 = SignalsReact.useSignalState(displayStore.getDisplaySize)
		local v4 = SignalsReact.useSignalState(displayStore.getViewportSize)
		local v5 = useLocalization({
			description = LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY_DESCRIPTION,
			dismiss = LocalizationStrings.CHAT_CAPTURE_GALLERY_EMPTY_DISMISS,
			step1 = LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_1,
			step2 = LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_2,
			step3 = LocalizationStrings.CHAT_CAPTURE_GALLERY_HOW_TO_STEP_3
		})

		education = {
			descriptionText = v5.description,
			dismissText = v5.dismiss,
			howToSteps = { v5.step1, v5.step2, v5.step3 },
			isShown = isFinished and #captures == 0,
			toolbarLayout = getToolbarLayout(v3, v4) -- inferred equivalent call
		}
	end

	return {
		addText = v2.add,
		captures = captures,
		education = education,
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
