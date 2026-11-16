local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/ReactOtter")

local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")
local IconTextButton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Buttons/IconTextButton")
local ColorTextButton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Buttons/ColorTextButton")

local defineFastFlag = game:DefineFastFlag("AXDisableControlBarMenuAnimation", false)

local v5 = { dampingRatio = 1, frequency = 5 }

local function IconTextMenu(props)
	local v6 = useSemanticTokens()

	local v7, v8 = React.useBinding(0)
	local v9, v10 = ReactOtter.useAnimatedBinding(0)
	local v11 = #props.items > 0

	local ref = React.useRef(nil)

	local radius = props.radius or v6.defaultIconTextMenuRadius

	local v12 = React.useCallback(function(p2)
		local absoluteSize = p2.AbsoluteSize
		v8(absoluteSize.X)
		v10(ReactOtter.spring(not v11 and 0 or absoluteSize.Y, v5))
	end, { v11 })

	local v13 = React.useMemo(function()
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
	local v14

	if not defineFastFlag then
		v14 = React.joinBindings({ X = v7, Y = v9 }):map(function(p2)
			return UDim2.fromOffset(p2.X, (math.round(p2.Y)))
		end)
	end

	local v15 = if defineFastFlag then Enum.AutomaticSize.XY else nil
	local iconTextMenuAnimationContainer = {
		tag = "clip",
		Name = "IconTextMenu-Animation-Container",
		Size = v14,
		AutomaticSize = v15,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder
	}

	local v17 = if #props.items > 0 then React.createElement(Foundation.View, {
		tag = "auto-xy clip col clip padding-xsmall gap-xsmall",
		backgroundStyle = v6.menuBackgroundStyle,
		cornerRadius = UDim.new(0, radius),
		ref = ref,
		onAbsoluteSizeChanged = v12
	}, v13) else nil
	return createElement(view, iconTextMenuAnimationContainer, { MenuContent = v17 })
end

return IconTextMenu
