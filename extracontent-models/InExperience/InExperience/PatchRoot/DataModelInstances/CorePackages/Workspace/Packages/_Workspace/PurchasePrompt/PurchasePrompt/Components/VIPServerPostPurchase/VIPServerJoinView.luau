local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Button = Foundation.Button
local Sheet = Foundation.Sheet
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior

local function VIPServerJoinView(props)
	local createElement = React.createElement
	local root = Sheet.Root
	local v = {
		onClose = props.onClose,
		preferCenterSheet = true,
		ref = props.focusRootRef,
		testId = "VIPServerJoinView"
	}

	local children = {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(Text, {
				Text = props.locales.title,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-default"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local createElement3 = React.createElement

	local v2 = {
		Server = React.createElement(
			View,
			{ tag = "row align-y-center gap-medium size-full-0 auto-y", LayoutOrder = 1 },
			{
				Thumbnail = React.createElement(Image, {
					testId = "--purchase-prompt-image-game-thumbnail",
					Image = props.thumbnailUrl,
					ScaleType = Enum.ScaleType.Crop,
					tag = "size-2400-2400 radius-medium clip bg-surface-200",
					LayoutOrder = 1
				}),
				Names = React.createElement(View, {
					tag = "col fill gap-xsmall auto-y",
					LayoutOrder = 2
				}, {
					ServerName = React.createElement(Text, {
						testId = "--purchase-prompt-text-server-name",
						Text = props.serverName,
						tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end content-emphasis",
						LayoutOrder = 1
					}),
					GameName = React.createElement(Text, {
						testId = "--purchase-prompt-text-game-name",
						Text = props.gameName,
						tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-muted",
						LayoutOrder = 2
					})
				})
			}
		),
		Error = 0
	}
	local err

	if props.hasError then
		err = React.createElement(Text, {
			testId = "--purchase-prompt-text-error",
			Text = props.locales.somethingWentWrong,
			tag = "auto-xy text-body-medium content-system-alert",
			LayoutOrder = 2
		})
	end

	v2.Error = err
	children.Content = createElement2(content, nil, {
		Body = createElement3(View, { tag = "col gap-large size-full-0 auto-y" }, v2)
	})

	children.Actions = React.createElement(Sheet.Actions, nil, {
		Join = React.createElement(Button, {
			testId = "--purchase-prompt-button-join",
			text = props.locales.join,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			onActivated = props.onJoin,
			isLoading = props.isJoining,
			ref = props.joinButtonRef
		})
	})
	return createElement(root, v, children)
end

return VIPServerJoinView
