local UserInputService = game:GetService("UserInputService")
local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hcT")

local fFlagAXFixBackgroundGenerationResultMenuNavigation = require("@luauforge/deferred/hcQ").FFlagAXFixBackgroundGenerationResultMenuNavigation

local fFlagAXBackgroundGenerationResultActionButtons = require("@luauforge/deferred/hcQ").FFlagAXBackgroundGenerationResultActionButtons

local module3 = require("@luauforge/deferred/hcZ")
local module4 = require("@luauforge/deferred/hdh")
local module5 = require("@luauforge/deferred/hdm")

local function BackgroundGenerationPage(props)
	local isLoading = props.isLoading

	local createElement = module.createElement
	local view = module2.View

	local createElement2 = module.createElement
	local view2 = module2.View
	local v6 = {
		tag = "col size-full-0 auto-y padding-bottom-small bg-over-media-100",
		testId = "BackgroundGenerationPage_TopBar",
		padding = {
			top = UDim.new(0, props.topInset or 0)
		}
	}

	local v7 = {
		Scrim = module.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.25),
				NumberSequenceKeypoint.new(1, 1)
			})
		}),
		Bar = 0
	}

	local createElement3 = module.createElement
	local view3 = module2.View

	local v9 = {
		BackButton = module.createElement(module2.IconButton, {
			icon = "chevron-large-left",
			onActivated = function()
				local focusedTextBox = UserInputService:GetFocusedTextBox()

				if focusedTextBox then
					focusedTextBox:ReleaseFocus()
				end

				props.onBackButtonPressed()
			end,
			testId = "BackgroundGenerationPage_BackButton",
			LayoutOrder = 1
		}),
		Title = module.createElement(module2.Text, {
			tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
			Text = props.title,
			LayoutOrder = 2
		}),
		GenerationResultMenu = 0,
		GenerationResultActions = 0
	}
	local v10

	if not (props.onPublishPressed == nil or fFlagAXBackgroundGenerationResultActionButtons) then
		local createElement4 = module.createElement
		local v12 = {
			publishLabel = props.menuPublishLabel,
			deleteLabel = props.menuDeleteLabel,
			onPublish = props.onPublishPressed,
			onDelete = props.onDeletePressed,
			isDisabled = not props.isResultReady,
			isVisible = 0,
			LayoutOrder = 3
		}
		local v13 = if fFlagAXFixBackgroundGenerationResultMenuNavigation then props.isVisible else nil
		v12.isVisible = v13
		v10 = createElement4(module4, v12)
	end

	v9.GenerationResultMenu = v10

	local v11 = if props.onPublishPressed ~= nil and not not fFlagAXBackgroundGenerationResultActionButtons then module.createElement(module5, {
		onPublish = props.onPublishPressed,
		onDelete = props.onDeletePressed,
		isDisabled = not props.isResultReady,
		LayoutOrder = 3
	}) else nil
	v9.GenerationResultActions = v11
	v7.Bar = createElement3(
		view3,
		{
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-y-small"
		},
		v9
	)
	local children = {
		TopBar = createElement2(view2, v6, v7),
		LoadingIndicator = 0,
		Composer = 0
	}
	local v12

	if isLoading then
		local createElement4 = module.createElement
		local view4 = module2.View

		local v14 = {
			Spinner = module.createElement(module2.Loading, {
				size = module2.Enums.IconSize.Large,
				LayoutOrder = 1
			}),
			Label = 0
		}

		local v15 = if props.loadingText then module.createElement(module2.Text, {
			tag = "auto-y text-body-large text-align-x-center content-emphasis",
			Text = props.loadingText,
			LayoutOrder = 2
		}) else nil
		v14.Label = v15
		v12 = createElement4(
			view4,
			{
				tag = "col align-x-center align-y-center gap-small position-center-center anchor-center-center auto-xy"
			},
			v14
		)
	end

	children.LoadingIndicator = v12

	children.Composer = module.createElement(module3, {
		prompt = props.prompt,
		onPromptChanged = props.onPromptChanged,
		onSubmit = props.onSubmit,
		isSubmitEnabled = props.isSubmitEnabled,
		isInputDisabled = props.isInputDisabled,
		placeholder = props.placeholder,
		hasError = props.hasError,
		errorMessage = props.errorMessage
	})
	return createElement(view, { tag = "size-full" }, children)
end

return BackgroundGenerationPage
