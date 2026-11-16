local Foundation = script:FindFirstAncestor("Foundation")

local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

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

local v = { component = "ImageButton", isDisabled = false }

local color = Color3.fromRGB(163, 162, 165)

local function Interactable(p, p2)
	local v2 = withDefaults(p, v)
	local ref = React.useRef(nil)
	local v3 = useTokens()
	local v4 = useCursor(v2.cursor)
	local controlState, v5 = React.useBinding(ControlState.Initialize)
	local ref2 = React.useRef(nil)

	local v6 = React.useCallback(function(p3)
		if controlState:getValue() == ControlState.Default and ref.current ~= nil then
			local styled = ref.current:GetStyled("BackgroundColor3")
			local styled2 = ref.current:GetStyled("BackgroundTransparency")

			if styled ~= color or styled2 ~= 0 then
				ref2.current = { Color3 = styled, Transparency = styled2 }
			end
		end

		v5(p3)

		if v2.onStateChanged ~= nil then
			v2.onStateChanged(p3)
		end
	end, { v2.onStateChanged })

	local backgroundStyle = React.useMemo(function()
		return getOriginalBackgroundStyle(v2.BackgroundColor3, v2.BackgroundTransparency)
	end, { v2.BackgroundColor3, v2.BackgroundTransparency })

	local v7 = React.useCallback(function(p3, p4, p5, p6)
		if
			p3 == ControlState.Initialize
			or p3 == ControlState.Default
			or p3 == ControlState.Disabled
			or p6 == StateLayerAffordance.None
		then
			return p4
		end

		local v7 = { Color3 = p4.Color3, Transparency = p4.Transparency }

		if p4.Color3 == nil then
			local color2

			if ref2.current then
				color2 = ref2.current.Color3
			end

			v7.Color3 = color2
		end

		if p4.Transparency == nil then
			local transparency

			if ref2.current then
				transparency = ref2.current.Transparency
			end

			v7.Transparency = transparency
		end

		return blendColors(v7, (getStateLayerStyle(v3, p5, p3)))
	end, { v3, v2.BackgroundColor3, v2.BackgroundTransparency })

	local useMemo = React.useMemo
	local function fn()
		local v8 = {
			controlState = controlState,
			backgroundStyle = backgroundStyle,
			mode = 0,
			affordance = 0
		}
		local mode

		if v2.stateLayer then
			mode = v2.stateLayer.mode
		end

		v8.mode = mode
		local affordance

		if v2.stateLayer then
			affordance = v2.stateLayer.affordance
		end

		v8.affordance = affordance
		return joinBindables(v8, function(data)
			return v7(data.controlState, data.backgroundStyle, data.mode, data.affordance)
		end)
	end

	local mode

	if v2.stateLayer then
		mode = v2.stateLayer.mode
	end

	local v8

	if v2.stateLayer then
		v8 = v2.stateLayer.affordance
	end

	local v9 = useMemo(fn, { backgroundStyle, controlState, v7, mode, v8 })

	local ref3 = useGuiControlState(ref, v6)

	React.useImperativeHandle(p2, function()
		return ref.current
	end, {})

	local v10 = {}
	v10.BackgroundColor3 = mapBindable(v9, function(p3)
		return p3.Color3
	end)

	v10.BackgroundTransparency = mapBindable(v9, function(p3)
		return p3.Transparency
	end)

	v10.Active = not v2.isDisabled
	v10.Interactable = not v2.isDisabled
	local activated = React.Event.Activated
	local v11

	if not v2.isDisabled then
		v11 = v2.onActivated
	end

	v10[activated] = v11
	local secondaryActivated = React.Event.SecondaryActivated
	local v12

	if not v2.isDisabled then
		v12 = v2.onSecondaryActivated
	end

	v10[secondaryActivated] = v12
	v10.ref = ref3
	v10.SelectionImageObject = v2.SelectionImageObject or v4

	local union = Dash.union(v2, v10)

	union.component = nil
	union.isDisabled = nil
	union.onActivated = nil
	union.onSecondaryActivated = nil
	union.onStateChanged = nil
	union.stateLayer = nil
	union.cursor = nil

	return React.createElement(v2.component, union)
end

return React.memo(React.forwardRef(Interactable))
