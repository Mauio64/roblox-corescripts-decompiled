local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/UIBlox")
local modalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local buttonStack = UIBlox.App.Button.ButtonStack
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function isFullWidth(p2): boolean
	return p2.X <= 540
end

local function AXPartialPageModal(props)
	local v5 = useTokens()
	local screenSize = props.screenSize
	local medium = v5.Margin.Medium
	local large = v5.Margin.Large
	local v6 = props.bottomPadding or UDim.new(0, medium)

	if not (screenSize.X <= 540) then
		v6 = UDim.new(0, medium)
	end

	return React.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[React.Event.Activated] = function() end,
		ZIndex = 3
	}, {
		PartialPageModal = React.createElement(
			modalWindow,
			{
				isFullHeight = false,
				screenSize = screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint
			},
			{
				ContentContainer = React.createElement(view, {
					tag = "auto-y size-full-0 align-x-left col padding-top-medium padding-x-xxlarge padding-top-xxlarge",
					Position = UDim2.new(0, 0, 0, large),
					backgroundStyle = v5.Color.Surface.Surface_100,
					padding = { bottom = v6 }
				}, {
					Content = React.createElement(view, { tag = "auto-y size-full-0" }, props.children),
					Buttons = props.buttonStackProps and React.createElement(buttonStack, props.buttonStackProps)
				})
			}
		)
	})
end

return AXPartialPageModal
