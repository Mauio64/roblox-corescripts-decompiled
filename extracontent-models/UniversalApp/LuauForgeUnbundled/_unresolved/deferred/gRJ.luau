local module = require("@luauforge/deferred/gQM")
local module2 = require("@luauforge/deferred/gQN")
local module3 = require("@luauforge/deferred/gRc")
local module4 = require("@luauforge/deferred/gRd")
require("@luauforge/deferred/gRe")
local backHandlerRegistry = require("@luauforge/deferred/gRf").BackHandlerRegistry

local fFlagAXFixBackgroundGenerationResultMenuNavigation = require("@luauforge/deferred/gQK").FFlagAXFixBackgroundGenerationResultMenuNavigation

local sheet = module2.Sheet
local dialogSize = module2.Enums.DialogSize
local fillBehavior = module2.Enums.FillBehavior
local buttonVariant = module2.Enums.ButtonVariant
local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
local useAppFocusRoot = module3.useAppFocusRoot

local function PublishBackgroundSheet(props)
	local v5

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		v5 = module.useMemo(function()
			local v6 = {}
			v6[focusNavigationEventNameEnum.NavigateBack] = {
				handler = module4.onRelease(function(object)
					object:cancel()
					props.onClose()
				end)
			}

			return v6
		end, { props.onClose })
	end

	local v6

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		v6 = useAppFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			customEventHandlers = v5,
			isAutoFocusRoot = true,
			isFocusable = props.isOpen and props.isFocusNavigationEnabled ~= false
		})
	end

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		module.useLayoutEffect(function()
			if props.isOpen then
				return backHandlerRegistry.register(props.onClose)
			end

			return nil
		end, { props.isOpen, props.onClose })
	end

	local createElement = module.createElement
	local root = sheet.Root
	local v7 = {
		isOpen = props.isOpen,
		preferCenterSheet = true,
		size = dialogSize.Medium,
		onClose = props.onClose,
		ref = v6,
		testId = "publish-background-sheet"
	}

	local children = {
		Header = module.createElement(sheet.Header, nil, {
			Title = module.createElement(module2.Text, {
				tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
				Text = props.title,
				testId = "publish-background-title"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = module.createElement
	local content = sheet.Content

	local createElement3 = module.createElement
	local view = module2.View

	local v11 = if props.hasError then module.createElement(module2.Text, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-action-alert",
		Text = props.errorMessage,
		testId = "publish-background-error",
		LayoutOrder = 0
	}) else nil
	children.Content = createElement2(content, { testId = "publish-background-content" }, {
		Form = createElement3(view, { tag = "col gap-small size-full-0 auto-y" }, {
			ErrorBanner = v11,
			NameField = module.createElement(
				module2.View,
				{ tag = "col gap-xxsmall size-full-0 auto-y", LayoutOrder = 1 },
				{
					Label = module.createElement(module2.Text, {
						tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
						Text = props.nameLabel,
						LayoutOrder = 1
					}),
					Input = module.createElement(module2.TextInput, {
						label = "",
						text = props.displayName,
						onChanged = props.onDisplayNameChanged,
						width = UDim.new(1, 0),
						testId = "publish-background-name",
						LayoutOrder = 2
					}),
					Counter = module.createElement(module2.Text, {
						tag = "size-full-0 auto-y text-caption-small text-align-x-right content-muted",
						Text = props.displayNameCountText,
						testId = "publish-background-name-counter",
						LayoutOrder = 3
					})
				}
			),
			DescriptionField = module.createElement(
				module2.View,
				{ tag = "col gap-xxsmall size-full-0 auto-y", LayoutOrder = 2 },
				{
					Label = module.createElement(module2.Text, {
						tag = "size-full-0 auto-y text-title-medium text-align-x-left content-emphasis",
						Text = props.descriptionLabel,
						LayoutOrder = 1
					}),
					Input = module.createElement(module2.TextArea, {
						label = "",
						text = props.description,
						onChanged = props.onDescriptionChanged,
						numLines = 3,
						width = UDim.new(1, 0),
						testId = "publish-background-description",
						LayoutOrder = 2
					}),
					Counter = module.createElement(module2.Text, {
						tag = "size-full-0 auto-y text-caption-small text-align-x-right content-muted",
						Text = props.descriptionCountText,
						testId = "publish-background-description-counter",
						LayoutOrder = 3
					})
				}
			)
		})
	})

	children.Actions = module.createElement(sheet.Actions, nil, {
		PublishButton = module.createElement(module2.Button, {
			text = props.publishLabel,
			isLoading = props.isPublishing,
			isDisabled = not props.isPublishEnabled,
			onActivated = props.onPublish,
			variant = buttonVariant.Emphasis,
			testId = "publish-background-submit",
			fillBehavior = fillBehavior.Fill
		})
	})
	return createElement(root, v7, children)
end

return module.memo(PublishBackgroundSheet)
