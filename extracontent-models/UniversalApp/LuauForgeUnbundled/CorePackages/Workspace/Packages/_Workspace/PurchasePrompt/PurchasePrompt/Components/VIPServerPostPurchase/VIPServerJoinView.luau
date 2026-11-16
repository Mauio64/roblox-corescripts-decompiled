local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Foundation")
local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local button = Foundation.Button
local sheet = Foundation.Sheet
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior

local function VIPServerJoinView(props)
	local createElement = React.createElement
	local root = sheet.Root
	local v5 = {
		onClose = props.onClose,
		preferCenterSheet = true,
		testId = "VIPServerJoinView"
	}

	local children = {
		Header = React.createElement(sheet.Header, nil, {
			Title = React.createElement(text, {
				Text = props.locales.title,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-default"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content
	local createElement3 = React.createElement

	local v10 = {
		Server = React.createElement(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				LayoutOrder = 1
			},
			{
				Thumbnail = React.createElement(image, {
					testId = "--purchase-prompt-image-game-thumbnail",
					Image = props.thumbnailUrl,
					ScaleType = Enum.ScaleType.Crop,
					tag = "size-2400-2400 radius-medium clip bg-surface-200",
					LayoutOrder = 1
				}),
				Names = React.createElement(
					view,
					{ tag = "col fill gap-xsmall auto-y", LayoutOrder = 2 },
					{
						ServerName = React.createElement(text, {
							testId = "--purchase-prompt-text-server-name",
							Text = props.serverName,
							tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end content-emphasis",
							LayoutOrder = 1
						}),
						GameName = React.createElement(text, {
							testId = "--purchase-prompt-text-game-name",
							Text = props.gameName,
							tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-muted",
							LayoutOrder = 2
						})
					}
				)
			}
		),
		Error = 0
	}

	local v11 = if props.hasError then React.createElement(text, {
		testId = "--purchase-prompt-text-error",
		Text = props.locales.somethingWentWrong,
		tag = "auto-xy text-body-medium content-system-alert",
		LayoutOrder = 2
	}) else nil
	v10.Error = v11
	children.Content = createElement2(content, nil, {
		Body = createElement3(view, { tag = "col gap-large size-full-0 auto-y" }, v10)
	})

	children.Actions = React.createElement(sheet.Actions, nil, {
		Join = React.createElement(button, {
			testId = "--purchase-prompt-button-join",
			text = props.locales.join,
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill,
			onActivated = props.onJoin,
			isLoading = props.isJoining
		})
	})
	return createElement(root, v5, children)
end

return VIPServerJoinView
