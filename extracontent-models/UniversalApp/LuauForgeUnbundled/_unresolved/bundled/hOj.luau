local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/bundled/hOh")
local constants = module.Constants
local getTextFilterEducationLocalizationKeys = module.getTextFilterEducationLocalizationKeys

local function TextFilterEducationPopup(props)
	local v5 = useTokens()
	local v6 = v5.Size.Size_400 + v5.Gap.XSmall

	local textFilterEducationLocalizationKeys, v7 = getTextFilterEducationLocalizationKeys(
		props.experimentVariant,
		props.contentVariant,
		props.isKids
	)

	local v8 = useLocalization({
		sharedBody = v7,
		reminderTitle = textFilterEducationLocalizationKeys,
		buttonText = constants.LocalizationKeys.OkButtonText
	})

	local createElement = React.createElement
	local root = dialog.Root
	local v9 = { size = dialogSize.Small, hasBackdrop = true }

	local children = {
		DialogTitle = React.createElement(
			view,
			{ LayoutOrder = 1, tag = "size-full-0 auto-y padding-top-large" },
			{
				Title = React.createElement(text, {
					tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
					Text = v8.reminderTitle
				})
			}
		),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content
	local v12

	if props.isKids then
		v12 = React.createElement(view, { tag = "size-full-0 auto-y" }, {
			Leading = React.createElement(icon, {
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.fromScale(0, 0),
				name = iconName.ShieldCheck,
				size = iconSize.Small,
				variant = iconVariant.Regular,
				testId = "KidsEducationBodyIcon"
			}),
			Description = React.createElement(text, {
				Position = UDim2.fromOffset(v6, 0),
				Size = UDim2.new(1, -v6, 0, 0),
				tag = "auto-y text-body-medium text-wrap text-align-x-left",
				Text = v8.sharedBody
			})
		})
	else
		v12 = React.createElement(text, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			Text = v8.sharedBody
		})
	end

	children.DialogContent = createElement2(content, { LayoutOrder = 2 }, { Body = v12 })

	children.DialogActions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				variant = buttonVariant.Emphasis,
				text = v8.buttonText,
				onActivated = props.onClose
			}
		}
	})
	return createElement(root, v9, children)
end

return React.memo(TextFilterEducationPopup)
