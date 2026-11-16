local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local TextOverlayPreviewGestureUtils = require(MomentsCommon.Utils.TextOverlayPreviewGestureUtils)

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local function shapeScale(current: number, p: number) -- 2 equivalent calls inferred from this helper
	local v

	if p >= 1 then
		v = (p - 1) ^ 1.5 + 1
	else
		v = 1 - (1 - p) ^ 1.5
	end

	return (math.max(0.3, current * v))
end

local function touchesStartOnOverlay(p, p2) -- 2 equivalent calls inferred from this helper
	if p2 == nil then
		return false
	end

	return TextOverlayPreviewGestureUtils.touchGestureStartsOnOverlay(p, p2.AbsolutePosition, p2.AbsoluteSize)
end

local function useTextOverlayPreviewGestures(data)
	local userInputService = data.userInputService or UserInputService
	local guiService = data.guiService or GuiService
	local v = Responsive.useDeviceInsets()

	local v2 = useRef(data.scale)
	v2.current = data.scale
	local v3 = useRef(data.rotation)
	v3.current = data.rotation
	local v4 = useRef(data.onScaleChanged)
	v4.current = data.onScaleChanged
	local v5 = useRef(data.onRotationChanged)
	v5.current = data.onRotationChanged

	local v6 = useRef(1)
	local v7 = useRef(0)
	local v8 = useRef(0)
	local v9 = useRef(0)
	local v10 = useRef(false)
	local v11 = useRef(false)

	local v12 = useCallback(function()
		return guiService:GetGuiInset() + Vector2.new(v.left, v.top)
	end, { v, guiService })

	local v13 = useCallback(function()
		local current

		if data.containerRef then
			current = data.containerRef.current
		end

		if current == nil then
			return nil
		end

		return current.AbsolutePosition + current.AbsoluteSize / 2
	end, { data.containerRef })

	local v14 = data.enabled

	if v14 then
		if data.selected == true then
			v14 = data.preferredInput == Responsive.Input.Touch
		else
			v14 = false
		end
	end

	local v15 = data.enabled

	if v15 then
		if data.selected == true then
			v15 = data.preferredInput == Responsive.Input.Pointer
		else
			v15 = false
		end
	end

	useEffect(function()
		if not v14 then
			return nil
		end

		local function overlayContainer() -- 2 equivalent calls inferred from this helper
			if data.containerRef then
				return data.containerRef.current
			end

			return nil
		end

		local touchPinchConnection = userInputService.TouchPinch:Connect(function(...)
			local v16, v17, _, v18 = ...
			local current = v4.current

			if v18 == Enum.UserInputState.Begin then
				v10.current = false

				if current ~= nil and touchesStartOnOverlay(v16, overlayContainer()) then -- inferred equivalent call
					v6.current = v2.current
					v10.current = true
				end
			elseif v18 == Enum.UserInputState.Change then
				if #v16 < 2 then
					v10.current = false
				elseif v10.current and current then
					current(shapeScale(v6.current, v17)) -- inferred equivalent call
				end
			else
				v10.current = false
			end
		end)

		local touchRotateConnection = userInputService.TouchRotate:Connect(function(...)
			local v16, _, _, v17 = ...
			local current = v5.current
			local touchLineAngleDegrees = TextOverlayPreviewGestureUtils.getTouchLineAngleDegrees(v16)

			if v17 == Enum.UserInputState.Begin then
				v11.current = false

				if
					current ~= nil
					and touchLineAngleDegrees ~= nil
					and touchesStartOnOverlay(v16, overlayContainer()) -- inferred equivalent call
				then
					v8.current = v3.current
					v9.current = touchLineAngleDegrees
					v11.current = true
				end
			elseif v17 == Enum.UserInputState.Change then
				if touchLineAngleDegrees == nil then
					v11.current = false
				elseif v11.current and current then
					v8.current += TextOverlayPreviewGestureUtils.getTouchRotationStepDegrees(
						v9.current,
						touchLineAngleDegrees
					)

					v9.current = touchLineAngleDegrees
					current(v8.current)
				end
			else
				v11.current = false
			end
		end)

		return function()
			touchPinchConnection:Disconnect()
			touchRotateConnection:Disconnect()
			v10.current = false
			v11.current = false
		end
	end, { v14, data.containerRef, userInputService })

	local v16 = useRef(nil)
	local v17 = useRef(false)
	local v18 = useRef(1)
	local v19 = useRef(0)
	local v20 = useRef(nil)
	local v21 = useRef(nil)

	local v22 = useCallback(function()
		v16.current = nil
		v17.current = false

		if v20.current then
			v20.current:Disconnect()
			v20.current = nil
		end

		if v21.current then
			v21.current:Disconnect()
			v21.current = nil
		end
	end, {})

	local v23 = useCallback(function(current: string)
		if not v15 then
			return
		end

		v22()
		v16.current = current
		v17.current = true
		v6.current = v2.current
		v7.current = v3.current

		v20.current = userInputService.InputChanged:Connect(function(_)
			if v16.current == nil then
				return
			end

			local v23 = v13()

			if v23 == nil then
				return
			end

			local v24 = userInputService:GetMouseLocation() - v12()

			if v17.current then
				v18.current = math.max((v24 - v23).Magnitude, 1)
				v19.current = math.atan2(v24.Y - v23.Y, v24.X - v23.X)
				v17.current = false
			elseif v16.current == "resize" then
				local current2 = v4.current

				if current2 then
					current2(shapeScale(v6.current, (v24 - v23).Magnitude / v18.current)) -- inferred equivalent call
				end
			else
				local current2 = v5.current

				if current2 then
					local v25 = math.atan2(v24.Y - v23.Y, v24.X - v23.X)
					current2(v7.current + math.deg(v25 - v19.current))
				end
			end
		end)

		v21.current = userInputService.InputEnded:Connect(function()
			if #userInputService:GetMouseButtonsPressed() == 0 then
				v22()
			end
		end)
	end, { v15, v13, v12, v22, userInputService })

	useEffect(function()
		if not v15 then
			v22()
		end

		return function()
			v22()
		end
	end, { v15, v22 })

	return {
		onResizeHandleInputBegan = useCallback(function(_)
			v23("resize")
		end, { v23 }),
		onRotateHandleInputBegan = useCallback(function(_)
			v23("rotate")
		end, { v23 })
	}
end

return useTextOverlayPreviewGestures
