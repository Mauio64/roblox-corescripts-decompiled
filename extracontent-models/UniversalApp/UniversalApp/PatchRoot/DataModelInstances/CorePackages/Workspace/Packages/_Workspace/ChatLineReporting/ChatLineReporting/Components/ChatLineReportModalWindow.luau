local Parent = script:FindFirstAncestor("ChatLineReporting").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local UIBlox = require(Parent.UIBlox)
local ButtonStack = UIBlox.App.Button.ButtonStack
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = Foundation.IconButton
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local View = Foundation.View

local function ChatLineReportModalWindow(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), ModalWindow (copy), View (copy), HeaderBar (copy), IconButton (copy), ButtonStack (copy)
	local v12 = not not t1.buttonStackProps

	return React.createElement(ModalWindow, {
		isFullHeight = false,
		screenSize = t1.screenSize,
		position = t1.position,
		anchorPoint = t1.anchorPoint
	}, {
		Content = React.createElement(View, {
			tag = {
				["size-full-0 auto-y col"] = true,
				["padding-bottom-small"] = not v12,
				["padding-bottom-xxlarge"] = v12
			}
		}, {
			TitleContainer = React.createElement(HeaderBar, {
				backgroundTransparency = 1,
				margin = 10,
				title = t1.title,
				renderLeft = function() -- line: 56
					-- upvalues: React (copy), IconButton (copy), t1 (copy)
					return React.createElement(IconButton, {
						icon = "icons/navigation/close",
						onActivated = t1.onCloseClicked
					})
				end,
				renderRight = function() -- line: 62
					-- upvalues: React (copy), IconButton (copy), t1 (copy)
					return React.createElement(IconButton, {
						icon = "icons/actions/info",
						onActivated = t1.onInfoClicked
					})
				end
			}),
			Underline = React.createElement(View, {
				tag = "size-full-0 stroke-standard stroke-default",
				LayoutOrder = 1
			}),
			MiddleContent = React.createElement(View, {
				tag = "size-full-0 auto-y padding-x-xxlarge",
				LayoutOrder = 2
			}, t1.children),
			Buttons = v12 and React.createElement(View, {
				tag = "size-full-0 padding-x-xxlarge auto-y",
				LayoutOrder = 3
			}, React.createElement(ButtonStack, t1.buttonStackProps))
		})
	})
end

return ChatLineReportModalWindow
