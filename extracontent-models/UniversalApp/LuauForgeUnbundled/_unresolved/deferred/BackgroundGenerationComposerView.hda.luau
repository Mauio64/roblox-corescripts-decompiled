local module = require("@luauforge/deferred/hdb")
local module2 = require("@luauforge/deferred/hcT")
local module3 = require("@luauforge/deferred/hcS")

local composer = module.Composer

local function PromptComposer(props)
	local createElement = module3.createElement
	local v6 = {
		text = props.prompt,
		onChanged = props.onPromptChanged,
		label = "",
		placeholder = props.placeholder or "",
		hint = 0,
		hasError = 0,
		isDisabled = 0,
		width = 0,
		size = 0,
		minLines = 3,
		maxLines = 5,
		ref = 0,
		textBoxRef = 0,
		testId = "BackgroundGenerationPage_PassiveComposer",
		trailingElement = 0
	}
	local v7 = if props.hasError then props.errorMessage else nil
	v6.hint = v7
	v6.hasError = props.hasError
	v6.isDisabled = props.isInputDisabled
	v6.width = UDim.new(1, 0)
	v6.size = module2.Enums.InputSize.Large

	v6.ref = props.composerRef
	v6.textBoxRef = props.textBoxRef

	local createElement2 = module3.createElement
	local view = module2.View

	local createElement3 = module3.createElement
	local iconButton = module2.IconButton
	local v10 = {
		icon = "arrow-wide-short-up",
		onActivated = props.onSubmit,
		isDisabled = not props.isSubmitEnabled,
		isCircular = true,
		size = module2.Enums.InputSize.Small,
		variant = 0,
		testId = "BackgroundGenerationPage_SubmitButton"
	}
	local v11 = if props.isSubmitEnabled then module2.Enums.ButtonVariant.Emphasis else module2.Enums.ButtonVariant.Standard
	v10.variant = v11
	v6.trailingElement = createElement2(view, {
		tag = "auto-xy padding-x-xsmall padding-y-small"
	}, {
		SubmitButton = createElement3(iconButton, v10)
	})
	return createElement(composer, v6)
end

local function BackgroundGenerationComposerView(p2)
	return module3.createElement(PromptComposer, p2)
end

return BackgroundGenerationComposerView
