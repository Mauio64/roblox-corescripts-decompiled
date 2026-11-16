local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/eVC")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module4 = require("@luauforge/deferred/ehb")

local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = module3.useFocusNavigableSurfaceRegistryConnection

local sheet = Foundation.Sheet
local text = Foundation.Text
local button = Foundation.Button
local textInput = Foundation.TextInput
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function SchoolInterestSheet(props)
	local v5 = useLocalization({
		title = module4.SchoolInterestSheetTitle,
		body = module4.SchoolInterestSheetBody,
		placeholder = module4.SchoolInterestSheetPlaceholder,
		sendAction = module4.SchoolInterestSheetSendAction,
		errorGeneric = module4.SomethingWentWrong
	})

	local state, setState = module.useState(nil)
	useFocusNavigableSurfaceRegistryConnection(
		state,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		props.isOpen
	)

	local v6 = props.schoolName:match("%S") ~= nil

	local createElement = module.createElement
	local root = sheet.Root
	local v7 = {
		isOpen = props.isOpen,
		onClose = props.onClose,
		preferCenterSheet = true,
		ref = setState,
		testId = "schools-school-interest-sheet"
	}

	local children = {
		Header = module.createElement(sheet.Header, { hasCloseAffordance = true }, {
			Title = module.createElement(text, {
				Text = v5.title,
				tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = module.createElement
	local content = sheet.Content
	local createElement3 = module.createElement

	local v12 = {
		Description = module.createElement(text, {
			LayoutOrder = 1,
			Text = v5.body,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		}),
		SchoolNameInput = 0
	}

	local createElement4 = module.createElement
	local v14 = {
		LayoutOrder = 2,
		label = "",
		text = props.schoolName,
		placeholder = v5.placeholder,
		width = UDim.new(1, 0),
		size = inputSize.Medium,
		hasError = props.hasError,
		hint = 0,
		hasClearButton = true,
		onChanged = 0,
		onReturnPressed = 0
	}
	local v15 = if props.hasError then v5.errorGeneric else nil
	v14.hint = v15

	v14.onChanged = props.onSchoolNameChanged
	v14.onReturnPressed = props.onSend
	v12.SchoolNameInput = createElement4(textInput, v14)
	children.Content = createElement2(content, nil, {
		Body = createElement3(view, {
			LayoutOrder = 1,
			tag = "col gap-large size-full-0 auto-y"
		}, v12)
	})

	children.Actions = module.createElement(sheet.Actions, nil, {
		Send = module.createElement(button, {
			LayoutOrder = 1,
			text = v5.sendAction,
			size = inputSize.Large,
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill,
			isLoading = props.isSubmitting,
			isDisabled = props.isSubmitting or not v6,
			onActivated = props.onSend,
			testId = "schools-school-interest-sheet-send"
		})
	})
	return createElement(root, v7, children)
end

return SchoolInterestSheet
