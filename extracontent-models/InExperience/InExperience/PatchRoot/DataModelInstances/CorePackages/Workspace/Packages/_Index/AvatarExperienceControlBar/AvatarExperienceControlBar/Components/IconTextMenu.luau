local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local ReactOtter = require(AvatarExperienceControlBarParent.ReactOtter)
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)

require(AvatarExperienceControlBar.ControlBarTypes)

local IconTextButton = require(AvatarExperienceControlBar.Components.Buttons.IconTextButton)
local ColorTextButton = require(AvatarExperienceControlBar.Components.Buttons.ColorTextButton)
local v9 = game:DefineFastFlag("AXDisableControlBarMenuAnimation", false)
local t1 = {
	dampingRatio = 1,
	frequency = 5
}

local function IconTextMenu(t2: {[any]: any}) -- line: 30
	-- upvalues: useSemanticTokens (copy), React (copy), ReactOtter (copy), t1 (copy), IconTextButton (copy), ColorTextButton (copy), Foundation (copy), v9 (copy)
	local v13 = useSemanticTokens()
	local v14, v15 = React.useBinding(0)
	local v16, v17 = ReactOtter.useAnimatedBinding(0)
	local v18 = #t2.items > 0
	local v19 = React.useRef(nil)
	local v20 = t2.radius or v13.defaultIconTextMenuRadius
	local v21 = React.useCallback(function(p1) -- line: 41
		-- upvalues: v15 (copy), v17 (copy), ReactOtter (copy), v18 (copy), t1 (copy)
		local AbsoluteSize = p1.AbsoluteSize

		v15(AbsoluteSize.X)
		v17(ReactOtter.spring(not v18 and 0 or AbsoluteSize.Y, t1))
	end, { v18 })
	local v22 = React.useMemo(function() -- line: 47
		-- upvalues: t2 (copy), React (copy), IconTextButton (copy), ColorTextButton (copy)
		local t3 = {}

		for v26, v27 in t2.items do
			if v27.type == "icon" then
				t3[`IconTextMenuItem-{ v27.id }`] = React.createElement(IconTextButton, {
					icon = v27.icon,
					text = v27.text,
					iconSize = v27.iconSize,
					disabled = v27.disabled,
					onActivated = function() -- line: 56
						-- upvalues: t2 (copy), v27 (copy)
						if t2.onItemActivated then
							t2.onItemActivated(v27.id)
						end

						if v27.onActivated then
							v27.onActivated()
						end
					end,
					Visible = v27.visible,
					LayoutOrder = v26
				})
			elseif v27.type == "color" then
				t3[`IconTextMenuItem-{ v27.id }`] = React.createElement(ColorTextButton, {
					colors = v27.colors,
					colorSize = v27.colorSize,
					size = v27.size,
					text = v27.text,
					disabled = v27.disabled,
					onActivated = function() -- line: 74
						-- upvalues: t2 (copy), v27 (copy)
						if t2.onItemActivated then
							t2.onItemActivated(v27.id)
						end

						if v27.onActivated then
							v27.onActivated()
						end
					end,
					Visible = v27.visible,
					LayoutOrder = v26
				})
			end
		end

		return t3
	end, {
		t2.items,
		t2.onItemActivated
	})

	return React.createElement(Foundation.View, {
		tag = "clip",
		Name = "IconTextMenu-Animation-Container",
		Size = if not v9 then React.joinBindings({
			X = v14,
			Y = v16
		}):map(function(p2) -- line: 95
			return UDim2.fromOffset(p2.X, (math.round(p2.Y)))
		end) else nil,
		AutomaticSize = if not v9 then nil else Enum.AutomaticSize.XY,
		Position = t2.Position,
		AnchorPoint = t2.AnchorPoint,
		LayoutOrder = t2.LayoutOrder
	}, {
		MenuContent = if not (#t2.items > 0) then nil else React.createElement(Foundation.View, {
			tag = "auto-xy clip col clip padding-xsmall gap-xsmall",
			backgroundStyle = v13.menuBackgroundStyle,
			cornerRadius = UDim.new(0, v20),
			ref = v19,
			onAbsoluteSizeChanged = v21
		}, v22)
	})
end

return IconTextMenu
