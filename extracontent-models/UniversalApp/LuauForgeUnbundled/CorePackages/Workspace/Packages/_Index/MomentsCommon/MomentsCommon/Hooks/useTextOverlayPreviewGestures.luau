local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Responsive")
local TextOverlayPreviewGestureUtils = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/TextOverlayPreviewGestureUtils")

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local function shapeScale(p2, p3)
	local v5 = if p3 >= 1 then 1 + (p3 - 1) ^ 1.5 else 1 - (1 - p3) ^ 1.5
	return (math.max(0.3, p2 * v5))
end

local function touchesStartOnOverlay(p2, p3)
	if p3 == nil then
		return false
	end

	return TextOverlayPreviewGestureUtils.touchGestureStartsOnOverlay(p2, p3.AbsolutePosition, p3.AbsoluteSize)
end

local function useTextOverlayPreviewGestures(data)
	local userInputService = data.userInputService or UserInputService
	local guiService = data.guiService or GuiService
	local v5 = Responsive.useDeviceInsets()

	local v6 = useRef(data.scale)
	v6.current = data.scale
	local v7 = useRef(data.rotation)
	v7.current = data.rotation
	local v8 = useRef(data.onScaleChanged)
	v8.current = data.onScaleChanged
	local v9 = useRef(data.onRotationChanged)
	v9.current = data.onRotationChanged

	local v10 = useRef(1)
	local v11 = useRef(0)
	local v12 = useRef(0)
	local v13 = useRef(0)
	local v14 = useRef(false)
	local v15 = useRef(false)

	local v16 = useCallback(function()
		return guiService:GetGuiInset() + Vector2.new(v5.left, v5.top)
	end, { v5, guiService })

	local v17 = useCallback(function()
		local current = if data.containerRef then data.containerRef.current else nil

		if current == nil then
			return nil
		end

		return current.AbsolutePosition + current.AbsoluteSize / 2
	end, { data.containerRef })

	local v18 = data.enabled

	if v18 then
		v18 = data.selected == true and data.preferredInput == Responsive.Input.Touch
	end

	local v19 = data.enabled

	if v19 then
		v19 = data.selected == true and data.preferredInput == Responsive.Input.Pointer
	end

	useEffect(function()
		if not v18 then
			return nil
		end

		local function overlayContainer()
			if data.containerRef then
				return data.containerRef.current
			end

			return nil
		end

		local touchPinchConnection = userInputService.TouchPinch:Connect(function(...)
			local v20, v21, v22, v23 = ...
			local current = v8.current

			if v23 == Enum.UserInputState.Begin then
				v14.current = false

				if current ~= nil then
					local current2 = if data.containerRef then data.containerRef.current else nil
					local v24

					if current2 == nil then
						v24 = false
					else
						v24 = TextOverlayPreviewGestureUtils.touchGestureStartsOnOverlay(
							v20,
							current2.AbsolutePosition,
							current2.AbsoluteSize
						)
					end

					if v24 then
						v10.current = v6.current
						v14.current = true
					end
				end
			elseif v23 == Enum.UserInputState.Change then
				if #v20 < 2 then
					v14.current = false
				elseif v14.current and current then
					local current2 = v10.current
					local v24 = if v21 >= 1 then 1 + (v21 - 1) ^ 1.5 else 1 - (1 - v21) ^ 1.5
					current((math.max(0.3, current2 * v24)))
				end
			else
				v14.current = false
			end
		end)

		local touchRotateConnection = userInputService.TouchRotate:Connect(function(...)
			local v20, v21, v22, v23 = ...
			local current = v9.current
			local touchLineAngleDegrees = TextOverlayPreviewGestureUtils.getTouchLineAngleDegrees(v20)

			if v23 == Enum.UserInputState.Begin then
				v15.current = false

				if current ~= nil and touchLineAngleDegrees ~= nil then
					local current2 = if data.containerRef then data.containerRef.current else nil
					local v24

					if current2 == nil then
						v24 = false
					else
						v24 = TextOverlayPreviewGestureUtils.touchGestureStartsOnOverlay(
							v20,
							current2.AbsolutePosition,
							current2.AbsoluteSize
						)
					end

					if v24 then
						v12.current = v7.current
						v13.current = touchLineAngleDegrees
						v15.current = true
					end
				end
			elseif v23 == Enum.UserInputState.Change then
				if touchLineAngleDegrees == nil then
					v15.current = false
				elseif v15.current and current then
					v12.current += TextOverlayPreviewGestureUtils.getTouchRotationStepDegrees(v13.current, touchLineAngleDegrees)

					v13.current = touchLineAngleDegrees
					current(v12.current)
				end
			else
				v15.current = false
			end
		end)

		return function()
			touchPinchConnection:Disconnect()
			touchRotateConnection:Disconnect()
			v14.current = false
			v15.current = false
		end
	end, { v18, data.containerRef, userInputService })

	local v20 = useRef(nil)
	local v21 = useRef(false)
	local v22 = useRef(1)
	local v23 = useRef(0)
	local v24 = useRef(nil)
	local v25 = useRef(nil)

	local v26 = useCallback(function()
		v20.current = nil
		v21.current = false

		if v24.current then
			v24.current:Disconnect()
			v24.current = nil
		end

		if v25.current then
			v25.current:Disconnect()
			v25.current = nil
		end
	end, {})

	local v27 = useCallback(function(current)
		if not v19 then
			return
		end

		v26()
		v20.current = current
		v21.current = true
		v10.current = v6.current
		v11.current = v7.current

		v24.current = userInputService.InputChanged:Connect(function(input)
			if v20.current == nil then
				return
			end

			local v28 = v17()

			if v28 == nil then
				return
			end

			local v29 = userInputService:GetMouseLocation() - v16()

			if v21.current then
				v22.current = math.max((v29 - v28).Magnitude, 1)
				v23.current = math.atan2(v29.Y - v28.Y, v29.X - v28.X)
				v21.current = false
			elseif v20.current == "resize" then
				local current2 = v8.current

				if current2 then
					local current3 = v10.current
					local v30 = (v29 - v28).Magnitude / v22.current
					local v31 = if v30 >= 1 then 1 + (v30 - 1) ^ 1.5 else 1 - (1 - v30) ^ 1.5
					current2((math.max(0.3, current3 * v31)))
				end
			else
				local current2 = v9.current

				if current2 then
					local v30 = math.atan2(v29.Y - v28.Y, v29.X - v28.X)
					current2(v11.current + math.deg(v30 - v23.current))
				end
			end
		end)

		v25.current = userInputService.InputEnded:Connect(function()
			if #userInputService:GetMouseButtonsPressed() == 0 then
				v26()
			end
		end)
	end, { v19, v17, v16, v26, userInputService })

	useEffect(function()
		if not v19 then
			v26()
		end

		return function()
			v26()
		end
	end, { v19, v26 })

	return {
		onResizeHandleInputBegan = useCallback(function(p2)
			v27("resize")
		end, { v27 }),
		onRotateHandleInputBegan = useCallback(function(p2)
			v27("rotate")
		end, { v27 })
	}
end

return useTextOverlayPreviewGestures
