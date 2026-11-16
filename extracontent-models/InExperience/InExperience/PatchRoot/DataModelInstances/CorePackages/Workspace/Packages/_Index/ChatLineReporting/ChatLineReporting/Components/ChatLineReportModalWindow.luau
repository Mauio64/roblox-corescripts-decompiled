local parent = script:FindFirstAncestor("ChatLineReporting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)

local ButtonStack = UIBlox.App.Button.ButtonStack
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = Foundation.IconButton
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local View = Foundation.View

local function ChatLineReportModalWindow(props)
	local paddingbottomxxlarge = props.buttonStackProps and true or false

	return React.createElement(
		ModalWindow,
		{
			isFullHeight = false,
			screenSize = props.screenSize,
			position = props.position,
			anchorPoint = props.anchorPoint
		},
		{
			Content = React.createElement(View, {
				tag = {
					["size-full-0 auto-y col"] = true,
					["padding-bottom-small"] = not paddingbottomxxlarge,
					["padding-bottom-xxlarge"] = paddingbottomxxlarge
				}
			}, {
				TitleContainer = React.createElement(HeaderBar, {
					title = props.title,
					renderLeft = function()
						return React.createElement(IconButton, {
							icon = "icons/navigation/close",
							onActivated = props.onCloseClicked
						})
					end,
					renderRight = function()
						return React.createElement(IconButton, {
							icon = "icons/actions/info",
							onActivated = props.onInfoClicked
						})
					end,
					backgroundTransparency = 1,
					margin = 10
				}),
				Underline = React.createElement(View, {
					tag = "size-full-0 stroke-standard stroke-default",
					LayoutOrder = 1
				}),
				MiddleContent = React.createElement(
					View,
					{ tag = "size-full-0 auto-y padding-x-xxlarge", LayoutOrder = 2 },
					props.children
				),
				Buttons = paddingbottomxxlarge and React.createElement(
					View,
					{ tag = "size-full-0 padding-x-xxlarge auto-y", LayoutOrder = 3 },
					React.createElement(ButtonStack, props.buttonStackProps)
				)
			})
		}
	)
end

return ChatLineReportModalWindow
