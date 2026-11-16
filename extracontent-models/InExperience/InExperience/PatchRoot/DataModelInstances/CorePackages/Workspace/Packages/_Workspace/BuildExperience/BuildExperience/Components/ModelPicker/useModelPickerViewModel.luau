local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local UserInputService = game:GetService("UserInputService")

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Localization = require(parent.Localization)
local React = require(parent.React)
local Responsive = require(parent.Responsive)

local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local FFlagBuildExperienceModelPickerChipHash = require(BuildExperience.Flags.FFlagBuildExperienceModelPickerChipHash)
local CreatorAgentChat

if FFlagBuildExperienceModelPicker then
	CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
else
	CreatorAgentChat = nil
end

local v = FFlagBuildExperienceModelPicker and CreatorAgentChat.experimentOverride.isEnabled()
local Signals

if v then
	Signals = require(parent.Signals)
else
	Signals = nil
end

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local useClosableFocusRoot = require(BuildExperience.utils.useClosableFocusRoot)
require(script.Parent.ModelPickerTypes)
require(script.Parent.ModelPickerView)

local function useModelPickerViewModel(data)
	local internalTesting

	if v then
		internalTesting = data.internalTesting
	else
		internalTesting = nil
	end

	local useLocalization = Localization.Hooks.useLocalization
	local v2 = {
		title = LocalizationStrings.MODEL_PICKER_TITLE,
		unavailable = LocalizationStrings.MODEL_PICKER_UNAVAILABLE,
		defaultLabel = LocalizationStrings.MODEL_PICKER_DEFAULT_LABEL,
		defaultDescription = LocalizationStrings.MODEL_PICKER_DEFAULT_DESCRIPTION,
		advancedLabel = LocalizationStrings.MODEL_PICKER_ADVANCED_LABEL,
		advancedDescription = LocalizationStrings.MODEL_PICKER_ADVANCED_DESCRIPTION,
		internalLabel = 0,
		internalDescription = 0,
		internalSpecLabel = 0,
		internalSpecPlaceholder = 0,
		internalSpecHint = 0
	}
	local internalLabel

	if internalTesting then
		internalLabel = LocalizationStrings.MODEL_PICKER_INTERNAL_LABEL
	end

	v2.internalLabel = internalLabel
	local internalDescription

	if internalTesting then
		internalDescription = LocalizationStrings.MODEL_PICKER_INTERNAL_DESCRIPTION
	end

	v2.internalDescription = internalDescription
	local internalSpecLabel

	if internalTesting then
		internalSpecLabel = LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_LABEL
	end

	v2.internalSpecLabel = internalSpecLabel
	local internalSpecPlaceholder

	if internalTesting then
		internalSpecPlaceholder = LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_PLACEHOLDER
	end

	v2.internalSpecPlaceholder = internalSpecPlaceholder
	local internalSpecHint

	if internalTesting then
		internalSpecHint = LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_HINT
	end

	v2.internalSpecHint = internalSpecHint
	local v3 = useLocalization(v2)

	local state, setState = React.useState(nil)
	local isSelected

	if internalTesting == nil then
		isSelected = false
	else
		isSelected = internalTesting.isSelected
	end

	local isOpen = state == "picker"
	local isSpecOpen

	if state == "spec" then
		isSpecOpen = isSelected
	else
		isSpecOpen = false
	end

	if v then
		React.useEffect(function()
			if isOpen then
				return Signals.createEffect(function(p)
					CreatorAgentChat.PreviewSpecs.getPreviewSpecsStore(false).getAndFetchPreviewSpecs(p)
				end)
			end

			return nil
		end, { isOpen })
	end

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			if state ~= nil and (data.isDisabled or state == "spec" and not isSelected) then
				setState(nil)
			end
		end, { state, isSelected, data.isDisabled })
	end

	local onSelect = React.useCallback(function()
		if isOpen and not data.isDisabled and internalTesting then
			internalTesting.onSelect()
		end
	end, { isOpen, data.isDisabled, internalTesting })
	local onOpenSpec = React.useCallback(function()
		if isOpen and isSelected and not data.isDisabled and internalTesting then
			setState("spec")
		end
	end, { isOpen, isSelected, data.isDisabled, internalTesting })
	local onClearSpec = React.useCallback(function()
		if
			isOpen
			and isSelected
			and not data.isDisabled
			and internalTesting
			and internalTesting.previewHash ~= nil
			and internalTesting.previewHash ~= ""
		then
			internalTesting.onSaveSpec(nil)
		end
	end, { isOpen, isSelected, data.isDisabled, internalTesting })
	local onSaveSpec = React.useCallback(function(p: string?)
		if isSpecOpen and not data.isDisabled and internalTesting then
			internalTesting.onSaveSpec(p)
		end
	end, { isSpecOpen, data.isDisabled, internalTesting })
	local onCloseSpec = React.useCallback(function()
		setState("picker")
	end, {})
	local onOpen = React.useCallback(function()
		if not data.isDisabled then
			local focusedTextBox = FFlagBuildExperienceModelPicker and UserInputService:GetFocusedTextBox()

			if focusedTextBox then
				focusedTextBox:ReleaseFocus()
			end

			setState("picker")
		end
	end, { data.isDisabled })
	local onClose = React.useCallback(function()
		setState(nil)
	end, {})
	local onSelect2 = React.useCallback(function(p: string)
		if not isOpen or data.isDisabled then
			return
		end

		for _, option in data.data.options do
			if option.id == p and option.isAvailable then
				setState(nil)
				data.onSelect(p)
				break
			end
		end
	end, { isOpen, data.isDisabled, data.data, data.onSelect })

	local v4 = {
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
		isOpen = isOpen or isSpecOpen,
		onClose = 0
	}
	local onClose2 = if isSpecOpen then onCloseSpec else onClose
	v4.onClose = onClose2
	local focusRootRef = useClosableFocusRoot(v4)

	local v5 = Responsive.usePreferredInput()

	local options = {}

	for _, option in data.data.options do
		local label = v3.unavailable
		local description = nil

		if option.model == "Default" then
			label = v3.defaultLabel
			description = v3.defaultDescription
		elseif option.model == "Advanced" then
			label = v3.advancedLabel
			description = v3.advancedDescription
		end

		table.insert(options, {
			id = option.id,
			model = option.model,
			isAvailable = option.isAvailable,
			label = label,
			description = description
		})
	end

	local label = v3.title

	if data.selectedId ~= nil then
		label = v3.unavailable

		for _, v6 in options do
			if v6.id == data.selectedId then
				label = v6.label
				break
			end
		end
	end

	if FFlagBuildExperienceModelPickerChipHash and isSelected and internalTesting then
		label = internalTesting.previewHash ~= "" and internalTesting.previewHash or v3.internalLabel
	elseif isSelected then
		label = v3.internalLabel
	end

	return {
		internalTesting = internalTesting and {
			isSelected = isSelected,
			previewHash = internalTesting.previewHash,
			onSelect = onSelect,
			onSaveSpec = onSaveSpec,
			onOpenSpec = onOpenSpec,
			onClearSpec = onClearSpec,
			label = v3.internalLabel,
			description = v3.internalDescription,
			specLabel = v3.internalSpecLabel,
			placeholder = v3.internalSpecPlaceholder,
			hint = v3.internalSpecHint
		} or nil,
		isSpecOpen = isSpecOpen,
		onCloseSpec = onCloseSpec,
		data = { options = options },
		selectedId = data.selectedId,
		isDisabled = data.isDisabled,
		LayoutOrder = data.LayoutOrder,
		label = label,
		title = v3.title,
		unavailableText = v3.unavailable,
		isOpen = isOpen,
		onOpen = onOpen,
		onClose = onClose,
		onSelect = onSelect2,
		focusRootRef = focusRootRef,
		hasCloseAffordance = v5 ~= Responsive.Input.Directional
	}
end

return useModelPickerViewModel
