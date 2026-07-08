local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local blendColors = require(Foundation.Utility.blendColors)
local getOriginalBackgroundStyle = require(script.Parent.getOriginalBackgroundStyle)
local getStateLayerStyle = require(script.Parent.getStateLayerStyle)
local joinBindables = require(Foundation.Utility.joinBindables)
local mapBindable = require(Foundation.Utility.mapBindable)
local useCursor = require(Foundation.Providers.Cursor.useCursor)
local useGuiControlState = require(Foundation.Utility.Control.useGuiControlState)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

require(Foundation.Enums.StateLayerMode)

local ControlState = require(Foundation.Enums.ControlState)
local t1 = {
	component = "ImageButton",
	isDisabled = false
}
local color3 = Color3.fromRGB(163, 162, 165)

local function Interactable(p1, p2) -- line: 48
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), useTokens (copy), useCursor (copy), ControlState (copy), color3 (copy), getOriginalBackgroundStyle (copy), StateLayerAffordance (copy), getStateLayerStyle (copy), blendColors (copy), joinBindables (copy), useGuiControlState (copy), mapBindable (copy), Dash (copy)
	local v21 = withDefaults(p1, t1)
	local v22 = React.useRef(nil)
	local v23 = useTokens()
	local v24 = useCursor(v21.cursor)
	local v25, v26 = React.useBinding(ControlState.Initialize)
	local v27 = React.useRef(nil)
	local v28 = React.useCallback(function(p3) -- line: 56
		-- upvalues: v25 (copy), ControlState (copy), v22 (copy), color3 (copy), v27 (copy), v26 (copy), v21 (copy)
		if v25:getValue() == ControlState.Default and v22.current ~= nil then
			local Styled = v22.current:GetStyled("BackgroundColor3")
			local Styled2 = v22.current:GetStyled("BackgroundTransparency")

			if Styled ~= color3 or Styled2 ~= 0 then
				v27.current = {
					Color3 = Styled,
					Transparency = Styled2
				}
			end
		end

		v26(p3)

		if v21.onStateChanged ~= nil then
			v21.onStateChanged(p3)
		end
	end, { v21.onStateChanged })
	local v29 = React.useMemo(function() -- line: 73
		-- upvalues: getOriginalBackgroundStyle (copy), v21 (copy)
		return getOriginalBackgroundStyle(v21.BackgroundColor3, v21.BackgroundTransparency)
	end, {
		v21.BackgroundColor3,
		v21.BackgroundTransparency
	})
	local v30 = React.useCallback(function(p4, p5, p6, p7) -- line: 78
		-- upvalues: ControlState (copy), StateLayerAffordance (copy), v27 (copy), getStateLayerStyle (copy), v23 (copy), blendColors (copy)
		if p4 == ControlState.Initialize or (p4 == ControlState.Default or p4 == ControlState.Disabled or p7 == StateLayerAffordance.None) then
			return p5
		end

		local t2 = {
			Color3 = p5.Color3,
			Transparency = p5.Transparency
		}

		if p5.Color3 == nil then
			t2.Color3 = if not v27.current then nil else v27.current.Color3
		end

		if p5.Transparency == nil then
			t2.Transparency = if not v27.current then nil else v27.current.Transparency
		end

		local v43 = getStateLayerStyle(v23, p6, p4)

		return blendColors(t2, v43)
	end, {
		v23,
		v21.BackgroundColor3,
		v21.BackgroundTransparency
	})
	local v31 = React.useMemo(function() -- line: 121
		-- upvalues: joinBindables (copy), v25 (copy), v29 (copy), v21 (copy), v30 (copy)
		return joinBindables({
			controlState = v25,
			backgroundStyle = v29,
			mode = if not v21.stateLayer then nil else v21.stateLayer.mode,
			affordance = if not v21.stateLayer then nil else v21.stateLayer.affordance
		}, function(p8) -- line: 127
			-- upvalues: v30 (copy)
			return v30(p8.controlState, p8.backgroundStyle, p8.mode, p8.affordance)
		end)
	end, {
		v29,
		v25,
		v30,
		if not v21.stateLayer then nil else v21.stateLayer.mode,
		if not v21.stateLayer then nil else v21.stateLayer.affordance
	})
	local v32 = useGuiControlState(v22, v28)

	React.useImperativeHandle(p2, function() -- line: 142
		-- upvalues: v22 (copy)
		return v22.current
	end, {})

	local t3 = {
		BackgroundColor3 = mapBindable(v31, function(p9) -- line: 147
			return p9.Color3
		end),
		BackgroundTransparency = mapBindable(v31, function(p10) -- line: 150
			return p10.Transparency
		end),
		Active = not v21.isDisabled,
		Interactable = not v21.isDisabled,
		[React.Event.Activated] = if v21.isDisabled then nil else v21.onActivated,
		[React.Event.MouseButton2Click] = if v21.isDisabled then nil else v21.onSecondaryActivated,
		ref = v32,
		SelectionImageObject = v21.SelectionImageObject or v24
	}
	local v34 = Dash.union(v21, t3)

	v34.component = nil
	v34.isDisabled = nil
	v34.onActivated = nil
	v34.onSecondaryActivated = nil
	v34.onStateChanged = nil
	v34.stateLayer = nil
	v34.cursor = nil

	return React.createElement(v21.component, v34)
end

return React.memo(React.forwardRef(Interactable))
