local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local RunService = game:GetService("RunService")

local parent = AvatarExperienceCommon.Parent

local Otter = require(parent.Otter)
local React = require(parent.React)

local Constants = require(AvatarExperienceCommon.Constants)

local v = { dampingRatio = 1, frequency = 3.5 }

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

	local function disconnectHoldConn() -- 3 equivalent calls inferred from this helper
		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end
	end

	local function getNewCanvasPosition(p: number) -- 1 equivalent call inferred from this helper
		return data.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(p, 0)
	end

	local function setMotor(p: number)
		if ref2.current then
			ref2.current:destroy()
		end

		ref2.current = Otter.createSingleMotor(p)

		if ref2.current then
			ref2.current:onStep(function(p2: number)
				data.defaultUseProps.updateCanvasPosition(Vector2.new(p2, 0))
			end)
			ref2.current:onComplete(function(p2: number)
				data.defaultUseProps.updateCanvasPosition(Vector2.new(p2, 0))
			end)
		end
	end

	local function getScrollToLocation(p: string)
		local v2 = {}
		local buttonRefs = data.defaultUseProps.buttonRefs
		local buttonWidth = data.defaultUseProps.buttonWidth
		local numButtons = data.defaultUseProps.numButtons

		if buttonWidth and numButtons then
			v2 = table.create(numButtons, buttonWidth)
		elseif buttonRefs then
			for _, buttonRef in buttonRefs do
				if not (buttonRef and buttonRef.current) then
					continue
				end

				local v3 = buttonRef.current.Size.X.Offset or 0

				if v3 == 0 then
					v3 = buttonRef.current.AbsoluteSize.X
				end

				table.insert(v2, v3)
			end
		end

		local current = data.defaultUseProps.scrollingFrameRef.current
		local buttonPadding = data.defaultUseProps.buttonPadding

		if p == Constants.NAVIGATION_DIRECTION.IS_LEFT then
			local v3 = 0

			for _, v4 in v2 do
				if v3 + v4 + buttonPadding <= current.CanvasPosition.X then
					v3 = v3 + v4 + buttonPadding
				else
					break
				end
			end

			local v4 = 0

			for _, v5 in v2 do
				if v4 + v5 + buttonPadding <= current.AbsoluteSize.X * 0.8 then
					v4 = v4 + v5 + buttonPadding
					v3 = v3 - v5 - buttonPadding
				else
					break
				end
			end

			return (math.max(0, v3))
		else
			local v3 = 0

			for _, v4 in v2 do
				if v3 + v4 + buttonPadding <= current.CanvasPosition.X then
					v3 = v3 + v4 + buttonPadding
				else
					break
				end
			end

			local v4 = 0

			for _, v5 in v2 do
				if v4 + v5 + buttonPadding <= current.AbsoluteSize.X * 0.8 then
					v4 = v4 + v5 + buttonPadding
					v3 = v3 + v5 + buttonPadding
				else
					break
				end
			end

			return v3
		end
	end

	local function getGoal(p: string)
		return Otter.spring(getScrollToLocation(p), v)
	end

	local function onPressHoldInputBegan(p, p2: string)
		if p.UserInputState ~= Enum.UserInputState.Begin then
			return
		end

		ref3.current = tick()
		disconnectHoldConn() -- inferred equivalent call
		ref.current = RunService.RenderStepped:Connect(function(dt)
			local v2 = tick() - ref3.current
			local newCanvasPosition = getNewCanvasPosition((p2 == Constants.NAVIGATION_DIRECTION.IS_LEFT and -1 or 1) * 500 * dt * v2 ^ 2) -- inferred equivalent call
			data.defaultUseProps.updateCanvasPosition(newCanvasPosition)
		end)
	end

	local function onPressHoldInputEnded(p, p2: string)
		if p.UserInputState ~= Enum.UserInputState.End then
			return
		end

		local current = data.defaultUseProps.scrollingFrameRef.current

		if tick() - ref3.current <= 0.5 then
			if ref2.current then
				ref2.current:destroy()
			end

			setMotor(current.CanvasPosition.X)

			if ref2.current then
				ref2.current:setGoal(getGoal(p2))
			end
		elseif ref2.current then
			ref2.current:setGoal(Otter.instant(current.CanvasPosition.X))
		end

		disconnectHoldConn() -- inferred equivalent call
	end

	React.useEffect(function()
		if data.defaultUseProps then
			setMotor(0)
		end

		return function()
			disconnectHoldConn() -- inferred equivalent call

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
		handleInputBegan = function(_, p)
			local onPressHoldInputBegan2 = data.onPressHoldInputBegan or onPressHoldInputBegan

			if onPressHoldInputBegan2 then
				onPressHoldInputBegan2(p, data.navDirection or "")
			end
		end,
		handleInputEnded = function(_, p)
			local onPressHoldInputEnded2 = data.onPressHoldInputEnded or onPressHoldInputEnded

			if onPressHoldInputEnded2 then
				onPressHoldInputEnded2(p, data.navDirection or "")
			end
		end,
		disconnectHoldConn = disconnectHoldConn
	}
end

return useArrowNavScrollBehavior
