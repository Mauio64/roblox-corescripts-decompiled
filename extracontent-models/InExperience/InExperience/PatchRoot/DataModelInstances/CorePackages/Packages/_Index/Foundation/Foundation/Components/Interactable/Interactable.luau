local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Flags = require(Foundation.Utility.Flags)

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

local function Interactable(p1, p2) -- line: 49
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), useTokens (copy), useCursor (copy), ControlState (copy), color3 (copy), getOriginalBackgroundStyle (copy), StateLayerAffordance (copy), getStateLayerStyle (copy), blendColors (copy), joinBindables (copy), useGuiControlState (copy), mapBindable (copy), Flags (copy), Dash (copy)
	local v22 = withDefaults(p1, t1)
	local v23 = React.useRef(nil)
	local v24 = useTokens()
	local v25 = useCursor(v22.cursor)
	local v26, v27 = React.useBinding(ControlState.Initialize)
	local v28 = React.useRef(nil)
	local v29 = React.useCallback(function(p3) -- line: 57
		-- upvalues: v26 (copy), ControlState (copy), v23 (copy), color3 (copy), v28 (copy), v27 (copy), v22 (copy)
		if v26:getValue() == ControlState.Default and v23.current ~= nil then
			local Styled = v23.current:GetStyled("BackgroundColor3")
			local Styled2 = v23.current:GetStyled("BackgroundTransparency")

			if Styled ~= color3 or Styled2 ~= 0 then
				v28.current = {
					Color3 = Styled,
					Transparency = Styled2
				}
			end
		end

		v27(p3)

		if v22.onStateChanged ~= nil then
			v22.onStateChanged(p3)
		end
	end, { v22.onStateChanged })
	local v30 = React.useMemo(function() -- line: 74
		-- upvalues: getOriginalBackgroundStyle (copy), v22 (copy)
		return getOriginalBackgroundStyle(v22.BackgroundColor3, v22.BackgroundTransparency)
	end, {
		v22.BackgroundColor3,
		v22.BackgroundTransparency
	})
	local v31 = React.useCallback(function(p4, p5, p6, p7) -- line: 79
		-- upvalues: ControlState (copy), StateLayerAffordance (copy), v28 (copy), getStateLayerStyle (copy), v24 (copy), blendColors (copy)
		if p4 == ControlState.Initialize or (p4 == ControlState.Default or p4 == ControlState.Disabled or p7 == StateLayerAffordance.None) then
			return p5
		end

		local t2 = {
			Color3 = p5.Color3,
			Transparency = p5.Transparency
		}

		if p5.Color3 == nil then
			t2.Color3 = if not v28.current then nil else v28.current.Color3
		end

		if p5.Transparency == nil then
			t2.Transparency = if not v28.current then nil else v28.current.Transparency
		end

		local v44 = getStateLayerStyle(v24, p6, p4)

		return blendColors(t2, v44)
	end, {
		v24,
		v22.BackgroundColor3,
		v22.BackgroundTransparency
	})
	local v32 = React.useMemo(function() -- line: 122
		-- upvalues: joinBindables (copy), v26 (copy), v30 (copy), v22 (copy), v31 (copy)
		return joinBindables({
			controlState = v26,
			backgroundStyle = v30,
			mode = if not v22.stateLayer then nil else v22.stateLayer.mode,
			affordance = if not v22.stateLayer then nil else v22.stateLayer.affordance
		}, function(p8) -- line: 128
			-- upvalues: v31 (copy)
			return v31(p8.controlState, p8.backgroundStyle, p8.mode, p8.affordance)
		end)
	end, {
		v30,
		v26,
		v31,
		if not v22.stateLayer then nil else v22.stateLayer.mode,
		if not v22.stateLayer then nil else v22.stateLayer.affordance
	})
	local v33 = useGuiControlState(v23, v29)

	React.useImperativeHandle(p2, function() -- line: 143
		-- upvalues: v23 (copy)
		return v23.current
	end, {})

	local t3 = {
		BackgroundColor3 = mapBindable(v32, function(p9) -- line: 148
			return p9.Color3
		end),
		BackgroundTransparency = mapBindable(v32, function(p10) -- line: 151
			return p10.Transparency
		end),
		Active = not v22.isDisabled,
		Interactable = not v22.isDisabled,
		[React.Event.Activated] = if v22.isDisabled then nil else v22.onActivated,
		[React.Event.SecondaryActivated] = if not Flags.FoundationInteractableSecondaryActivated or v22.isDisabled then nil else v22.onSecondaryActivated,
		[React.Event.MouseButton2Click] = if Flags.FoundationInteractableSecondaryActivated or v22.isDisabled then nil else v22.onSecondaryActivated,
		ref = v33,
		SelectionImageObject = v22.SelectionImageObject or v25
	}
	local v35 = Dash.union(v22, t3)

	v35.component = nil
	v35.isDisabled = nil
	v35.onActivated = nil
	v35.onSecondaryActivated = nil
	v35.onStateChanged = nil
	v35.stateLayer = nil
	v35.cursor = nil

	return React.createElement(v22.component, v35)
end

return React.memo(React.forwardRef(Interactable))
