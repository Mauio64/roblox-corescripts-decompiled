local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactOtter = require(parent.ReactOtter)

local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)

require(AvatarExperienceControlBar.ControlBarTypes)
local IconTextButton = require(AvatarExperienceControlBar.Components.Buttons.IconTextButton)
local ColorTextButton = require(AvatarExperienceControlBar.Components.Buttons.ColorTextButton)

local defineFastFlag = game:DefineFastFlag("AXDisableControlBarMenuAnimation", false)

local v = { dampingRatio = 1, frequency = 5 }

local function IconTextMenu(props)
	local v2 = useSemanticTokens()

	local v3, v4 = React.useBinding(0)
	local v5, v6 = ReactOtter.useAnimatedBinding(0)
	local v7 = #props.items > 0

	local ref = React.useRef(nil)

	local radius = props.radius or v2.defaultIconTextMenuRadius

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		local absoluteSize = p.AbsoluteSize
		v4(absoluteSize.X)
		v6(ReactOtter.spring(not v7 and 0 or absoluteSize.Y, v))
	end, { v7 })

	local v8 = React.useMemo(function()
		local children = {}

		for k, item in props.items do
			if item.type == "icon" then
				children[`IconTextMenuItem-{item.id}`] = React.createElement(IconTextButton, {
					icon = item.icon,
					text = item.text,
					iconSize = item.iconSize,
					disabled = item.disabled,
					onActivated = function()
						if props.onItemActivated then
							props.onItemActivated(item.id)
						end

						if item.onActivated then
							item.onActivated()
						end
					end,
					Visible = item.visible,
					LayoutOrder = k
				})
			elseif item.type == "color" then
				children[`IconTextMenuItem-{item.id}`] = React.createElement(ColorTextButton, {
					colors = item.colors,
					colorSize = item.colorSize,
					size = item.size,
					text = item.text,
					disabled = item.disabled,
					onActivated = function()
						if props.onItemActivated then
							props.onItemActivated(item.id)
						end

						if item.onActivated then
							item.onActivated()
						end
					end,
					Visible = item.visible,
					LayoutOrder = k
				})
			end
		end

		return children
	end, { props.items, props.onItemActivated })

	local createElement = React.createElement
	local view = Foundation.View
	local size

	if not defineFastFlag then
		size = React.joinBindings({ X = v3, Y = v5 }):map(function(p)
			return UDim2.fromOffset(p.X, (math.round(p.Y)))
		end)
	end

	local automaticSize

	if defineFastFlag then
		automaticSize = Enum.AutomaticSize.XY
	end

	local iconTextMenuAnimationContainer = {
		tag = "clip",
		Name = "IconTextMenu-Animation-Container",
		Size = size,
		AutomaticSize = automaticSize,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder
	}
	local menuContent

	if #props.items > 0 then
		menuContent = React.createElement(Foundation.View, {
			tag = "auto-xy clip col clip padding-xsmall gap-xsmall",
			backgroundStyle = v2.menuBackgroundStyle,
			cornerRadius = UDim.new(0, radius),
			ref = ref,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		}, v8)
	end

	return createElement(view, iconTextMenuAnimationContainer, { MenuContent = menuContent })
end

return IconTextMenu
