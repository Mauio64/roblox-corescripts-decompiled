local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Services = require(Foundation.Utility.Wrappers.Services)
local GuiService = Services.GuiService
local RunService = Services.RunService

local ControlState = require(Foundation.Enums.ControlState)

local InputMode = require(Foundation.Utility.Input.InputMode)

local getSelectionEntryDirection = require(Foundation.Components.Slider.getSelectionEntryDirection)
local useSliderCaptureKeys = require(Foundation.Components.Slider.useSliderCaptureKeys)

local useSliderDirectionalInput = require(script.Parent.useSliderDirectionalInput)
require(script.Parent.useSliderThumbs)

local function useSliderCapture(data)
	local count = #data.thumbs

	local state, setState = React.useState(ControlState.Initialize)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(1)
	local activeThumbIndex = math.min(state3, count)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(data.lastInputMode)

	local isSelected = state2 or state == ControlState.Selected or state == ControlState.SelectedPressed

	local v = React.useCallback(function()
		if not state2 then
			setState2(true)
		elseif count > 1 then
			setState3(activeThumbIndex % count + 1)
		end
	end, { state2, count, activeThumbIndex })
	useSliderCaptureKeys(isSelected and not data.isDisabled, v)

	local onExit = React.useCallback(function()
		setState2(false)
		GuiService.SelectedObject = ref.current
	end, {})

	React.useEffect(function()
		if data.isDisabled then
			setState2(false)
		end
	end, { data.isDisabled })

	React.useEffect(function()
		local v2 = data.lastInputMode ~= ref5.current
		ref5.current = data.lastInputMode

		if state2 and v2 and data.lastInputMode ~= nil and data.lastInputMode ~= InputMode.Directional then
			setState2(false)
		end
	end, { state2, data.lastInputMode })

	React.useEffect(function()
		if state2 == ref4.current then
			return
		end

		ref4.current = state2

		if state2 then
			if data.onCaptureStarted then
				data.onCaptureStarted()
			end
		elseif data.onCaptureEnded then
			data.onCaptureEnded()
		end
	end, { state2, data.onCaptureStarted, data.onCaptureEnded })

	local ref6 = React.useRef(data.onCaptureEnded)
	ref6.current = data.onCaptureEnded
	React.useEffect(function()
		return function()
			if ref4.current and ref6.current then
				ref6.current()
			end
		end
	end, {})

	React.useEffect(function()
		local function redirectDragSelection() -- 1 equivalent call inferred from this helper
			local selectedObject = GuiService.SelectedObject
			local v2

			if selectedObject == data.rootRef.current then
				v2 = true
			elseif selectedObject == nil or data.rootRef.current == nil then
				v2 = false
			else
				v2 = selectedObject:IsDescendantOf(data.rootRef.current)

				if v2 then
					if selectedObject == ref.current then
						v2 = false
					else
						v2 = selectedObject ~= ref2.current
					end
				end
			end

			if v2 then
				GuiService.SelectedObject = ref.current
			end
		end

		redirectDragSelection() -- inferred equivalent call
		local selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(redirectDragSelection)
		return function()
			selectedObjectChangedConnection:Disconnect()
		end
	end, { data.rootRef })

	React.useEffect(function()
		if not state2 then
			return
		end

		local current = ref2.current
		GuiService.SelectedObject = current

		local heartbeatConnection = nil

		if GuiService.SelectedObject ~= current then
			local count2 = 0
			heartbeatConnection = RunService.Heartbeat:Connect(function()
				count2 += 1
				GuiService.SelectedObject = current

				if (GuiService.SelectedObject == current or count2 >= 10) and heartbeatConnection then
					heartbeatConnection:Disconnect()
					heartbeatConnection = nil
				end
			end)
		end

		local selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
			if GuiService.SelectedObject ~= ref2.current and heartbeatConnection == nil then
				setState2(false)
			end
		end)
		return function()
			selectedObjectChangedConnection:Disconnect()

			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end

			if current ~= nil and GuiService.SelectedObject == current then
				GuiService.SelectedObject = ref.current
			end
		end
	end, { state2 })

	local v2 = React.useMemo(function()
		return {
			getValue = function()
				return data.thumbs[activeThumbIndex].value:getValue()
			end,
			onStep = function(p: number)
				data.updateThumbValue(activeThumbIndex, data.clampToNeighbors(activeThumbIndex, p))
			end,
			onExit = onExit
		}
	end, { data.thumbs, activeThumbIndex, data.updateThumbValue, data.clampToNeighbors, onExit })

	useSliderDirectionalInput(state2 and not data.isDisabled, data.step, data.range, data.isVertical, v2)

	return {
		controlState = state,
		isCaptured = state2,
		isSelected = isSelected,
		activeThumbIndex = activeThumbIndex,
		setActiveIndex = setState3,
		onStateChanged = React.useCallback(function(p)
			setState(p)

			local current = p == ControlState.Selected or p == ControlState.SelectedPressed

			if count > 1 and current and not ref3.current then
				setState3(not (getSelectionEntryDirection(data.isVertical) < 0) and 1 or count)
			end

			ref3.current = current
		end, { count, data.isVertical }),
		focusTargetRef = ref,
		captureTargetRef = ref2
	}
end

return useSliderCapture
