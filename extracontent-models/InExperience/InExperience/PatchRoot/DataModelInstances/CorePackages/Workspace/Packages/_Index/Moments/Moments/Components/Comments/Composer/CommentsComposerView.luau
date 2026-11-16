local parent = script:FindFirstAncestor("Moments").Parent

local Composer = require(parent.AppBlox.Composer)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local useLocalization = Localization.Hooks.useLocalization

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local v = { placeholder = "Feature.Moments.Label.WriteComment" }

local function CommentsComposerView(props)
	local v2 = useLocalization(v)

	local createElement = React.createElement
	local v3 = {
		width = UDim.new(1, 0),
		size = InputSize.Medium,
		minLines = 1,
		maxLines = 5,
		label = "",
		placeholder = v2.placeholder,
		text = props.text,
		hint = props.errorMessage,
		hasError = props.errorMessage ~= nil,
		isDisabled = props.isInputDisabled,
		onChanged = props.onTextChanged,
		onReturnPressed = props.onSubmit,
		testId = "moments-comments-composer",
		trailingElement = 0
	}

	local createElement2 = React.createElement
	local view = Foundation.View

	local createElement3 = React.createElement
	local view2 = Foundation.View
	local v4 = {
		tag = "position-center-center anchor-center-center size-1000-1000",
		isDisabled = not props.isSubmitEnabled,
		onActivated = props.onSubmit,
		selection = { Selectable = false },
		stateLayer = { affordance = StateLayerAffordance.None },
		testId = "moments-comments-composer-submit-hit-area"
	}

	local createElement4 = React.createElement
	local iconButton = Foundation.IconButton
	local v5 = {
		icon = IconName.ArrowMediumUp,
		variant = 0,
		size = 0,
		isCircular = true,
		isDisabled = 0,
		onActivated = 0,
		AnchorPoint = 0,
		Position = 0,
		testId = "moments-comments-composer-submit"
	}
	local variant

	if props.isSubmitEnabled then
		variant = ButtonVariant.Emphasis
	else
		variant = ButtonVariant.Standard
	end

	v5.variant = variant
	v5.size = InputSize.XSmall

	v5.isDisabled = not props.isSubmitEnabled
	v5.onActivated = props.onSubmit
	v5.AnchorPoint = Vector2.new(0.5, 0.5)
	v5.Position = UDim2.fromScale(0.5, 0.5)
	v3.trailingElement = createElement2(view, { tag = "size-800-1000" }, {
		SubmitHitArea = createElement3(view2, v4, { SubmitButton = createElement4(iconButton, v5) })
	})
	return createElement(Composer, v3)
end

return CommentsComposerView
