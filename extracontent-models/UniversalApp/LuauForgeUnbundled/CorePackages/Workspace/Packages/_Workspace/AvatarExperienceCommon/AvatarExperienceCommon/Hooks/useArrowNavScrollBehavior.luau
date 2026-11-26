local RunService = game:GetService("RunService")

local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Otter")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local v5 = { dampingRatio = 1, frequency = 3.5 }

local function useArrowNavScrollBehavior(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(0)

	if data.defaultUseProps then
		if data.defaultUseProps.buttonRefs ~= nil then
			if data.defaultUseProps.buttonWidth ~= nil then
				error("Cannot set both buttonWidth and buttonRefs")
			end

			if data.defaultUseProps.numButtons ~= nil then
				error("Cannot set both numButtons and buttonRefs")
			end
		end

		if data.defaultUseProps.buttonWidth ~= nil and data.defaultUseProps.numButtons == nil then
			error("If setting buttonWidth must also set numButtons")
		end

		if data.defaultUseProps.buttonWidth == nil and data.defaultUseProps.numButtons ~= nil then
			error("If setting numButtons must also set buttonWidth")
		end

		if
			data.defaultUseProps.buttonRefs == nil
			and data.defaultUseProps.buttonWidth == nil
			and data.defaultUseProps.numButtons == nil
		then
			error("Must set either buttonRefs or (buttonWidth and numButtons)")
		end
	end

	local function getNewCanvasPosition(p2)
		return data.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(p2, 0)
	end

	local function setMotor(p2)
		if ref2.current then
			ref2.current:destroy()
		end

		ref2.current = Otter.createSingleMotor(p2)

		if ref2.current then
			ref2.current:onStep(function(p3)
				data.defaultUseProps.updateCanvasPosition(Vector2.new(p3, 0))
			end)
			ref2.current:onComplete(function(p3)
				data.defaultUseProps.updateCanvasPosition(Vector2.new(p3, 0))
			end)
		end
	end

	local function getScrollToLocation(p2)
		local v6 = {}
		local buttonRefs = data.defaultUseProps.buttonRefs
		local buttonWidth = data.defaultUseProps.buttonWidth
		local numButtons = data.defaultUseProps.numButtons

		if buttonWidth and numButtons then
			v6 = table.create(numButtons, buttonWidth)
		elseif buttonRefs then
			for k, buttonRef in buttonRefs do
				if not (buttonRef and buttonRef.current) then
					continue
				end

				local v7 = buttonRef.current.Size.X.Offset or 0

				if v7 == 0 then
					v7 = buttonRef.current.AbsoluteSize.X
				end

				table.insert(v6, v7)
			end
		end

		local current = data.defaultUseProps.scrollingFrameRef.current
		local buttonPadding = data.defaultUseProps.buttonPadding

		if p2 == Constants.NAVIGATION_DIRECTION.IS_LEFT then
			local v7 = 0

			for k, v8 in v6 do
				if v7 + v8 + buttonPadding <= current.CanvasPosition.X then
					v7 = v7 + v8 + buttonPadding
				else
					break
				end
			end

			local v8 = 0

			for k, v9 in v6 do
				if v8 + v9 + buttonPadding <= current.AbsoluteSize.X * 0.8 then
					v8 = v8 + v9 + buttonPadding
					v7 = v7 - v9 - buttonPadding
				else
					break
				end
			end

			return ((math.max)(0, v7))
		else
			local v7 = 0

			for k, v8 in v6 do
				if v7 + v8 + buttonPadding <= current.CanvasPosition.X then
					v7 = v7 + v8 + buttonPadding
				else
					break
				end
			end

			local v8 = 0

			for k, v9 in v6 do
				if v8 + v9 + buttonPadding <= current.AbsoluteSize.X * 0.8 then
					v8 = v8 + v9 + buttonPadding
					v7 = v7 + v9 + buttonPadding
				else
					break
				end
			end

			return v7
		end
	end

	local function getGoal(p2)
		return Otter.spring(getScrollToLocation(p2), v5)
	end

	local function onPressHoldInputBegan(p2, p3)
		if p2.UserInputState ~= Enum.UserInputState.Begin then
			return
		end

		ref3.current = tick()

		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end

		ref.current = RunService.RenderStepped:Connect(function(dt)
			local v6 = tick() - ref3.current
			local v7 = (p3 == Constants.NAVIGATION_DIRECTION.IS_LEFT and -1 or 1) * 500 * dt * v6 ^ 2
			local v8 = data.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(v7, 0)

			data.defaultUseProps.updateCanvasPosition(v8)
		end)
	end

	local function onPressHoldInputEnded(p2, p3)
		if p2.UserInputState ~= Enum.UserInputState.End then
			return
		end

		local current = data.defaultUseProps.scrollingFrameRef.current

		if tick() - ref3.current <= 0.5 then
			if ref2.current then
				ref2.current:destroy()
			end

			setMotor(current.CanvasPosition.X)

			if ref2.current then
				ref2.current:setGoal(getGoal(p3))
			end
		elseif ref2.current then
			ref2.current:setGoal(Otter.instant(current.CanvasPosition.X))
		end

		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end
	end

	React.useEffect(function()
		if data.defaultUseProps then
			setMotor(0)
		end

		return function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end

			if ref2.current then
				ref2.current:destroy()
				ref2.current = nil
			end
		end
	end, {})
	return {
		holdConnRef = ref,
		motorRef = ref2,
		timeOfInputBeganRef = ref3,
		handleInputBegan = function(p2, p3)
			local onPressHoldInputBegan2 = data.onPressHoldInputBegan or onPressHoldInputBegan

			if onPressHoldInputBegan2 then
				onPressHoldInputBegan2(p3, data.navDirection or "")
			end
		end,
		handleInputEnded = function(p2, p3)
			local onPressHoldInputEnded2 = data.onPressHoldInputEnded or onPressHoldInputEnded

			if onPressHoldInputEnded2 then
				onPressHoldInputEnded2(p3, data.navDirection or "")
			end
		end,
		disconnectHoldConn = function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end
		end
	}
end

return useArrowNavScrollBehavior
