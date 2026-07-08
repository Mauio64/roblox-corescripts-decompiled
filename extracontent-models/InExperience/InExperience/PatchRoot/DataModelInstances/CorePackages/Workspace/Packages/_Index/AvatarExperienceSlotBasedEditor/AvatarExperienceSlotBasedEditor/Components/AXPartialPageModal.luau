local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local ButtonStack = UIBlox.App.Button.ButtonStack
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function isFullWidth(vector2: Vector2) -- line: 36
	return vector2.X <= 540
end
local function AXPartialPageModal(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), React (copy), ModalWindow (copy), View (copy), ButtonStack (copy)
	local v13 = useTokens()
	local screenSize = t1.screenSize
	local Medium = v13.Margin.Medium
	local Large = v13.Margin.Large
	local v17 = t1.bottomPadding or UDim.new(0, Medium)

	if not (screenSize.X <= 540) then
		v17 = UDim.new(0, Medium)
	end

	return React.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[React.Event.Activated] = function() -- line: 64
		end,
		ZIndex = 3
	}, {
		PartialPageModal = React.createElement(ModalWindow, {
			isFullHeight = false,
			screenSize = screenSize,
			position = t1.position,
			anchorPoint = t1.anchorPoint
		}, {
			ContentContainer = React.createElement(View, {
				tag = "auto-y size-full-0 align-x-left col padding-top-medium padding-x-xxlarge padding-top-xxlarge",
				Position = UDim2.new(0, 0, 0, Large),
				backgroundStyle = v13.Color.Surface.Surface_100,
				padding = {
					bottom = v17
				}
			}, {
				Content = React.createElement(View, {
					tag = "auto-y size-full-0"
				}, t1.children),
				Buttons = t1.buttonStackProps and React.createElement(ButtonStack, t1.buttonStackProps)
			})
		})
	})
end

return AXPartialPageModal
