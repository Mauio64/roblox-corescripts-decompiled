local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useForwardRef = ReactUtils.useForwardRef
local ControlState = require(Foundation.Enums.ControlState)
require(Foundation.Enums.ControlStateEvent)
local Flags = require(Foundation.Utility.Flags)
require(Foundation.Components.Types)

local v = {
	[Enum.GuiState.Idle] = ControlState.Default,
	[Enum.GuiState.Hover] = ControlState.Hover,
	[Enum.GuiState.Press] = ControlState.Pressed,
	[Enum.GuiState.NonInteractable] = ControlState.Disabled
}

local function useGuiControlState_DEPRECATED(p, callback)
	local ref = React.useRef(false)
	local ref2 = React.useRef(ControlState.Initialize)

	local v2 = React.useCallback(function(current)
		local current2 = ref2.current

		if ref.current then
			if current == ControlState.Default or current == ControlState.Hover then
				current = ControlState.Selected
			elseif current == ControlState.Pressed then
				current = ControlState.SelectedPressed
			end
		end

		if current2 == current then
			return
		end

		ref2.current = current

		if callback ~= nil then
			callback(current)
		end
	end, { callback })

	return useForwardRef(p, (React.useCallback(function(instance)
		local connections = {}

		if instance then
			v2(v[instance.GuiState])

			table.insert(connections, instance:GetPropertyChangedSignal("GuiState"):Connect(function()
				v2(v[instance.GuiState])
			end))

			table.insert(connections, instance.SelectionGained:Connect(function()
				ref.current = true
				v2(ref2.current)
			end))

			table.insert(connections, instance.SelectionLost:Connect(function()
				ref.current = false
				v2(ref2.current)
			end))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v2 })))
end

local function assignRef(callback, current) -- 1 equivalent call inferred from this helper
	if typeof(callback) == "function" then
		callback(current)
	elseif callback ~= nil then
		callback.current = current
	end
end

local function setControlState(current, controlState) -- 4 equivalent calls inferred from this helper
	if current.isSelected then
		if controlState == ControlState.Default or controlState == ControlState.Hover then
			controlState = ControlState.Selected
		elseif controlState == ControlState.Pressed then
			controlState = ControlState.SelectedPressed
		end
	end

	if current.controlState == controlState then
		return
	end

	current.controlState = controlState

	if current.onStateChanged ~= nil then
		current.onStateChanged(controlState)
	end
end

local function useGuiControlState(callback, onStateChanged)
	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = {
			isSelected = false,
			controlState = ControlState.Initialize,
			onStateChanged = onStateChanged,
			connections = nil
		}
	end

	ref.current.onStateChanged = onStateChanged

	return React.useCallback(function(instance)
		local current = ref.current
		assignRef(callback, instance) -- inferred equivalent call
		local connections = current.connections

		if connections ~= nil then
			for _, connection in connections do
				connection:Disconnect()
			end

			current.connections = nil
		end

		if instance == nil then
			return
		end

		setControlState(current, v[instance.GuiState]) -- inferred equivalent call

		current.connections = {
			instance:GetPropertyChangedSignal("GuiState"):Connect(function()
				setControlState(current, v[instance.GuiState]) -- inferred equivalent call
			end),
			instance.SelectionGained:Connect(function()
				current.isSelected = true
				setControlState(current, current.controlState) -- inferred equivalent call
			end),
			instance.SelectionLost:Connect(function()
				current.isSelected = false
				setControlState(current, current.controlState) -- inferred equivalent call
			end)
		}
	end, { callback })
end

if Flags.FoundationLightweightGuiControlState then
	return useGuiControlState
end

return useGuiControlState_DEPRECATED
