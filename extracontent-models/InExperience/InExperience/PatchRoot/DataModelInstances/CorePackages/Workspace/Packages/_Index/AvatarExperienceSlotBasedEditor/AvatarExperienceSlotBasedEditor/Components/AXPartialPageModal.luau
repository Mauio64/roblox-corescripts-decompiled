local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local ButtonStack = UIBlox.App.Button.ButtonStack
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function isFullWidth(screenSize: Vector2): boolean -- 1 equivalent call inferred from this helper
	return screenSize.X <= 540
end

local function AXPartialPageModal(props)
	local v = useTokens()
	local screenSize = props.screenSize
	local medium = v.Margin.Medium
	local large = v.Margin.Large
	local bottom = props.bottomPadding or UDim.new(0, medium)

	if not isFullWidth(screenSize) then -- inferred equivalent call
		bottom = UDim.new(0, medium)
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
			ModalWindow,
			{
				isFullHeight = false,
				screenSize = screenSize,
				position = props.position,
				anchorPoint = props.anchorPoint
			},
			{
				ContentContainer = React.createElement(View, {
					tag = "auto-y size-full-0 align-x-left col padding-top-medium padding-x-xxlarge padding-top-xxlarge",
					Position = UDim2.new(0, 0, 0, large),
					backgroundStyle = v.Color.Surface.Surface_100,
					padding = { bottom = bottom }
				}, {
					Content = React.createElement(View, { tag = "auto-y size-full-0" }, props.children),
					Buttons = props.buttonStackProps and React.createElement(ButtonStack, props.buttonStackProps)
				})
			}
		)
	})
end

return AXPartialPageModal
