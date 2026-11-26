local UserInputService = game:GetService("UserInputService")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Responsive")

local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local FFlagBuildExperienceModelPickerChipHash = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPickerChipHash")

local v5 = if FFlagBuildExperienceModelPicker then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat") else nil

local v6 = FFlagBuildExperienceModelPicker and v5.experimentOverride.isEnabled()
local v7 = if v6 then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals") else nil
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local useClosableFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useClosableFocusRoot")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerView")

local function useModelPickerViewModel(data)
	local internalTesting = if v6 then data.internalTesting else nil
	local useLocalization = Localization.Hooks.useLocalization
	local v8 = {
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
	local v9 = if internalTesting then LocalizationStrings.MODEL_PICKER_INTERNAL_LABEL else nil
	v8.internalLabel = v9
	local v10 = if internalTesting then LocalizationStrings.MODEL_PICKER_INTERNAL_DESCRIPTION else nil
	v8.internalDescription = v10
	local v11 = if internalTesting then LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_LABEL else nil
	v8.internalSpecLabel = v11

	local v12 = if internalTesting then LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_PLACEHOLDER else nil
	v8.internalSpecPlaceholder = v12

	local v13 = if internalTesting then LocalizationStrings.MODEL_PICKER_INTERNAL_SPEC_HINT else nil
	v8.internalSpecHint = v13
	local v14 = useLocalization(v8)

	local state, setState = React.useState(nil)
	local v15 = not (internalTesting == nil) and internalTesting.isSelected
	local v16 = state == "picker"
	local v17 = state == "spec" and v15

	if v6 then
		React.useEffect(function()
			if v16 then
				return v7.createEffect(function(p2)
					v5.PreviewSpecs.getPreviewSpecsStore(false).getAndFetchPreviewSpecs(p2)
				end)
			end

			return nil
		end, { v16 })
	end

	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			if state ~= nil and (data.isDisabled or state == "spec" and not v15) then
				setState(nil)
			end
		end, { state, v15, data.isDisabled })
	end

	local v18 = React.useCallback(function()
		if v16 and not data.isDisabled and internalTesting then
			internalTesting.onSelect()
		end
	end, { v16, data.isDisabled, internalTesting })
	local v19 = React.useCallback(function()
		if v16 and v15 and not data.isDisabled and internalTesting then
			setState("spec")
		end
	end, { v16, v15, data.isDisabled, internalTesting })
	local v20 = React.useCallback(function()
		if
			v16
			and v15
			and not data.isDisabled
			and internalTesting
			and internalTesting.previewHash ~= nil
			and internalTesting.previewHash ~= ""
		then
			internalTesting.onSaveSpec(nil, internalTesting.previewSpecName)
		end
	end, { v16, v15, data.isDisabled, internalTesting })
	local v21 = React.useCallback(function(p2, p3)
		if v17 and not data.isDisabled and internalTesting then
			internalTesting.onSaveSpec(p2, p3)
		end
	end, { v17, data.isDisabled, internalTesting })
	local v22 = React.useCallback(function()
		setState("picker")
	end, {})
	local v23 = React.useCallback(function()
		if not data.isDisabled then
			local focusedTextBox = FFlagBuildExperienceModelPicker and UserInputService:GetFocusedTextBox()

			if focusedTextBox then
				focusedTextBox:ReleaseFocus()
			end

			setState("picker")
		end
	end, { data.isDisabled })
	local v24 = React.useCallback(function()
		setState(nil)
	end, {})
	local v25 = React.useCallback(function(p2)
		if not v16 or data.isDisabled then
			return
		end

		for k, option in data.data.options do
			if option.id == p2 and option.isAvailable then
				setState(nil)
				data.onSelect(p2)
				break
			end
		end
	end, { v16, data.isDisabled, data.data, data.onSelect })

	local v29 = useClosableFocusRoot({
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
		isOpen = v16 or v17,
		onClose = if v17 then v22 else v24
	})

	local v30 = Responsive.usePreferredInput()

	local v31 = {}

	for k, option in data.data.options do
		local v32 = v14.unavailable
		local v33 = nil

		if option.model == "Default" then
			v32 = v14.defaultLabel
			v33 = v14.defaultDescription
		elseif option.model == "Advanced" then
			v32 = v14.advancedLabel
			v33 = v14.advancedDescription
		end

		table.insert(v31, {
			id = option.id,
			model = option.model,
			isAvailable = option.isAvailable,
			label = v32,
			description = v33
		})
	end

	local v32 = v14.title

	if data.selectedId ~= nil then
		v32 = v14.unavailable

		for k, v34 in v31 do
			if v34.id == data.selectedId then
				v32 = v34.label
				break
			end
		end
	end

	if FFlagBuildExperienceModelPickerChipHash and v15 and internalTesting then
		v32 = internalTesting.previewHash ~= "" and internalTesting.previewHash or v14.internalLabel
	elseif v15 then
		v32 = v14.internalLabel
	end

	return {
		internalTesting = internalTesting and {
			isSelected = v15,
			previewHash = internalTesting.previewHash,
			previewSpecName = internalTesting.previewSpecName,
			onSelect = v18,
			onSaveSpec = v21,
			onOpenSpec = v19,
			onClearSpec = v20,
			label = v14.internalLabel,
			description = v14.internalDescription,
			specLabel = v14.internalSpecLabel,
			placeholder = v14.internalSpecPlaceholder,
			hint = v14.internalSpecHint
		} or nil,
		isSpecOpen = v17,
		onCloseSpec = v22,
		data = { options = v31 },
		selectedId = data.selectedId,
		isDisabled = data.isDisabled,
		LayoutOrder = data.LayoutOrder,
		label = v32,
		title = v14.title,
		unavailableText = v14.unavailable,
		isOpen = v16,
		onOpen = v23,
		onClose = v24,
		onSelect = v25,
		focusRootRef = v29,
		hasCloseAffordance = v30 ~= Responsive.Input.Directional
	}
end

return useModelPickerViewModel
