local TextService = game:GetService("TextService")
local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local UIBlox = require(Parent.UIBlox)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local KeyLabel = UIBlox.App.Menu.KeyLabel
local KeyLabelUtilities = UIBlox.App.Menu.KeyLabelUtilities
local StateLayer = UIBlox.Core.Control.StateLayer
local Shortcut = UIBlox.App.Navigation.Shortcut
local IconWithHoldAnimation = require(script.Parent.IconWithHoldAnimation)
local v15 = game:DefineFastFlag("ShortcutUseDispatchSyntheticEvent", false)

local function getKeyLabelsWidth(p1, p2) -- line: 25
	-- upvalues: KeyLabelUtilities (copy)
	local n1 = 0

	for _, v22 in p1 do
		n1 += KeyLabelUtilities.getKeyLabelWidth(v22, p2)
	end

	return n1
end
local function useOnShortcutActivated(p3) -- line: 33
	-- upvalues: v15 (copy), React (copy), ReactFocusNavigation (copy)
	if v15 then
		local v24 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
		local v25 = ReactFocusNavigation.useDispatchSyntheticEvent()

		return (React.useCallback(function() -- line: 38
			-- upvalues: p3 (copy), v25 (copy), v24 (copy)
			if p3.hasProgress then
				v25(p3.eventName, v24.focusedGuiObject:getValue(), {
					immediateDispatch = true,
					UserInputState = Enum.UserInputState.Begin,
					KeyCode = p3.inputKeyCode,
					UserInputType = Enum.UserInputType.None
				})

				return
			end

			v25(p3.eventName, v24.focusedGuiObject:getValue(), {
				immediateDispatch = true,
				UserInputState = Enum.UserInputState.End,
				KeyCode = p3.inputKeyCode,
				UserInputType = Enum.UserInputType.None
			})
		end, {
			p3.hasProgress,
			p3.eventName,
			p3.inputKeyCode,
			v24,
			v25
		}))
	end

	local v26 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	return (React.useMemo(function() -- line: 59
		-- upvalues: v26 (copy), p3 (copy)
		return function() -- line: 60
			-- upvalues: v26 (copy), p3 (copy)
			local v53 = v26._engineInterface.getSelection()

			if not v53 then
				return
			end

			local v54 = v26.activeEventMap:getValue()[p3.inputKeyCode]

			if v54 ~= p3.eventName then
				return
			end

			v26._eventPropagationService:propagateEvent(v53, v54, {
				KeyCode = p3.inputKeyCode,
				UserInputState = Enum.UserInputState.Begin
			}, false)
			task.wait(0.1)
			v26._eventPropagationService:propagateEvent(v53, v54, {
				KeyCode = p3.inputKeyCode,
				UserInputState = Enum.UserInputState.End
			}, false)
		end
	end, {
		v26,
		p3.inputKeyCode,
		p3.eventName
	}))
end

function AppShortcut(p4) -- line: 83
	-- upvalues: useStyle (copy), useTokens (copy), KeyLabelUtilities (copy), React (copy), TextService (copy), KeyLabel (copy), IconWithHoldAnimation (copy), Icon (copy), useOnShortcutActivated (copy), Shortcut (copy), StateLayer (copy)
	local layoutOrder = p4.layoutOrder
	local item = p4.item
	local v30 = useStyle()
	local v31 = useTokens()
	local v32 = typeof(item.icon) == "table"
	local u33, u34

	if item.hasProgress then
		u33 = v31.Size.Size_1300 / 2
		u34 = v31.Size.Size_1300 / 2
	elseif v32 then
		local icon = item.icon
		local Font = v30.Font
		local n2 = 0

		for _, v39 in icon do
			n2 += KeyLabelUtilities.getKeyLabelWidth(v39, Font)
		end

		u33 = n2
		u34 = v31.Size.Size_900
	else
		u33 = v31.Size.Size_600
		u34 = v31.Size.Size_600
	end

	local v40 = React.useMemo(function() -- line: 105
		-- upvalues: v31 (copy), TextService (copy), item (copy), u33 (ref)
		local XSmall = v31.Gap.XSmall
		local LabelMedium = v31.Typography.LabelMedium
		local TextSize = TextService:GetTextSize(item.text, math.floor(LabelMedium.FontSize), LabelMedium.Font, Vector2.new(1e999, 1e999))
		local v48 = u33 + XSmall + TextSize.X

		return UDim2.new(0, v48, 1, 0)
	end, {
		v31,
		u33,
		item.text
	})
	local v41 = React.useMemo(function() -- line: 118
		-- upvalues: v40 (copy), v31 (copy)
		return v40 + UDim2.fromOffset(v31.Size.Size_100 * 2, 0)
	end, {
		v40,
		v31
	})
	local v42 = React.useMemo(function() -- line: 122
		-- upvalues: v32 (copy), React (copy), item (copy), KeyLabel (copy)
		if v32 then
			local t1 = {
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center
				})
			}

			for v50, v51 in item.icon do
				t1["KeyLabel_" .. tostring(v50)] = React.createElement(KeyLabel, {
					iconThemeKey = "IconEmphasis",
					LayoutOrder = v50,
					keyCode = v51
				})
			end

			return t1
		end

		return nil
	end, {
		v32,
		item.icon,
		v31
	})
	local v43 = React.useCallback(function(p5) -- line: 144
		-- upvalues: item (copy), React (copy), IconWithHoldAnimation (copy), u33 (ref), u34 (ref), v31 (copy), v32 (copy), v42 (copy), Icon (copy)
		if item.hasProgress then
			return React.createElement(IconWithHoldAnimation, {
				layoutOrder = p5.layoutOrder,
				size = UDim2.fromOffset(u33, u34),
				progress = item.progress,
				icon = item.icon,
				iconSize = v31.Size.Size_900 / 2
			})
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p5.layoutOrder,
			Size = UDim2.fromOffset(u33, u34)
		}, if not v32 then {
			Icon = React.createElement(Icon, {
				name = item.icon,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		} else v42)
	end, {
		item.hasProgress,
		item.progress,
		item.icon,
		u33,
		u34,
		v32,
		v42
	})
	local v44 = useOnShortcutActivated(item)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Size = v40
	}, {
		ShortcutFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1)
		}, {
			Shortcut = React.createElement(Shortcut, {
				size = UDim2.fromScale(1, 1),
				automaticSize = Enum.AutomaticSize.None,
				iconLabelGap = v31.Gap.XSmall,
				publicProps = item,
				labelTextSize = v31.Typography.LabelMedium.FontSize,
				labelColorStyle = v31.Color.Label,
				labelFontStyle = v31.Typography.LabelMedium,
				renderIcon = v43
			})
		}),
		StateLayer = React.createElement(StateLayer, {
			selectable = false,
			zIndex = 1,
			cornerRadius = UDim.new(0, v31.Radius.Medium),
			size = v41,
			onActivated = v44
		})
	})
end

return React.memo(AppShortcut)
