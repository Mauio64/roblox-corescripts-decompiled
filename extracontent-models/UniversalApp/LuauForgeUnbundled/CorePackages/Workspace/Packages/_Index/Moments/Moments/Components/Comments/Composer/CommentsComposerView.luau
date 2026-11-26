local Composer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/AppBlox/Composer")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useLocalization = Localization.Hooks.useLocalization

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local v5 = { placeholder = "Feature.Moments.Label.WriteComment" }

local function CommentsComposerView(props)
	local v6 = useLocalization(v5)

	local createElement = React.createElement
	local v8 = {
		width = UDim.new(1, 0),
		size = inputSize.Medium,
		minLines = 1,
		maxLines = 5,
		label = "",
		placeholder = v6.placeholder,
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
	local v11 = {
		tag = "position-center-center anchor-center-center size-1000-1000",
		isDisabled = not props.isSubmitEnabled,
		onActivated = props.onSubmit,
		selection = { Selectable = false },
		stateLayer = { affordance = stateLayerAffordance.None },
		testId = "moments-comments-composer-submit-hit-area"
	}

	local createElement4 = React.createElement
	local iconButton = Foundation.IconButton
	local v13 = {
		icon = iconName.ArrowMediumUp,
		variant = 0,
		size = 0,
		isCircular = true,
		isDisabled = 0,
		onActivated = 0,
		AnchorPoint = 0,
		Position = 0,
		testId = "moments-comments-composer-submit"
	}
	local v14 = if props.isSubmitEnabled then buttonVariant.Emphasis else buttonVariant.Standard
	v13.variant = v14
	v13.size = inputSize.XSmall

	v13.isDisabled = not props.isSubmitEnabled
	v13.onActivated = props.onSubmit
	v13.AnchorPoint = Vector2.new(0.5, 0.5)
	v13.Position = UDim2.fromScale(0.5, 0.5)
	v8.trailingElement = createElement2(view, { tag = "size-800-1000" }, {
		SubmitHitArea = createElement3(view2, v11, {
			SubmitButton = createElement4(iconButton, v13)
		})
	})
	return createElement(Composer, v8)
end

return CommentsComposerView
