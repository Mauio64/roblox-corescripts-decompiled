local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local RunService = game:GetService("RunService")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local Otter = require(AvatarExperienceCommonParent.Otter)
local React = require(AvatarExperienceCommonParent.React)
local Constants = require(AvatarExperienceCommon.Constants)
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}

local function useArrowNavScrollBehavior(t2: {[any]: any}) -- line: 42
	-- upvalues: React (copy), Otter (copy), Constants (copy), t1 (copy), RunService (copy)
	local v10 = React.useRef(nil)
	local v11 = React.useRef(nil)
	local v12 = React.useRef(0)

	if t2.defaultUseProps then
		if t2.defaultUseProps.buttonRefs ~= nil then
			if t2.defaultUseProps.buttonWidth ~= nil then
				error("Cannot set both buttonWidth and buttonRefs")
			end

			if t2.defaultUseProps.numButtons ~= nil then
				error("Cannot set both numButtons and buttonRefs")
			end
		end

		if t2.defaultUseProps.buttonWidth ~= nil and t2.defaultUseProps.numButtons == nil then
			error("If setting buttonWidth must also set numButtons")
		end

		if t2.defaultUseProps.buttonWidth == nil and t2.defaultUseProps.numButtons ~= nil then
			error("If setting numButtons must also set buttonWidth")
		end

		if t2.defaultUseProps.buttonRefs == nil and t2.defaultUseProps.buttonWidth == nil and t2.defaultUseProps.numButtons == nil then
			error("Must set either buttonRefs or (buttonWidth and numButtons)")
		end
	end

	local function getNewCanvasPosition(n1: number) -- line: 86
		-- upvalues: t2 (copy)
		return t2.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(n1, 0)
	end
	local function setMotor(n2: number) -- line: 91
		-- upvalues: v11 (copy), Otter (copy), t2 (copy)
		if v11.current then
			v11.current:destroy()
		end

		v11.current = Otter.createSingleMotor(n2)

		if v11.current then
			v11.current:onStep(function(n3: number) -- line: 97
				-- upvalues: t2 (copy)
				t2.defaultUseProps.updateCanvasPosition(Vector2.new(n3, 0))
			end)
			v11.current:onComplete(function(n4: number) -- line: 100
				-- upvalues: t2 (copy)
				t2.defaultUseProps.updateCanvasPosition(Vector2.new(n4, 0))
			end)
		end
	end
	local function getScrollToLocation(s1: string) -- line: 106
		-- upvalues: t2 (copy), Constants (copy)
		local t3 = {}
		local buttonRefs = t2.defaultUseProps.buttonRefs
		local buttonWidth = t2.defaultUseProps.buttonWidth
		local numButtons = t2.defaultUseProps.numButtons

		if buttonWidth and numButtons then
			t3 = table.create(numButtons, buttonWidth)
		elseif buttonRefs then
			for _, v27 in buttonRefs do
				if v27 and v27.current then
					local v28 = v27.current.Size.X.Offset or 0

					if v28 == 0 then
						v28 = v27.current.AbsoluteSize.X
					end

					table.insert(t3, v28)
				end
			end
		end

		local current = t2.defaultUseProps.scrollingFrameRef.current
		local buttonPadding = t2.defaultUseProps.buttonPadding

		if s1 == Constants.NAVIGATION_DIRECTION.IS_LEFT then
			local n5 = 0

			for _, v33 in t3 do
				if not (n5 + v33 + buttonPadding <= current.CanvasPosition.X) then
					break
				end

				n5 = n5 + v33 + buttonPadding
			end

			local n6 = 0

			for _, v36 in t3 do
				if not (n6 + v36 + buttonPadding <= current.AbsoluteSize.X * 0.8) then
					return (math.max(0, n5))
				end

				n6 = n6 + v36 + buttonPadding
				n5 = n5 - v36 - buttonPadding
			end

			return (math.max(0, n5))
		end

		local n7 = 0

		for _, v39 in t3 do
			if not (n7 + v39 + buttonPadding <= current.CanvasPosition.X) then
				break
			end

			n7 = n7 + v39 + buttonPadding
		end

		local n8 = 0

		for _, v42 in t3 do
			if not (n8 + v42 + buttonPadding <= current.AbsoluteSize.X * 0.8) then
				return n7
			end

			n8 = n8 + v42 + buttonPadding
			n7 = n7 + v42 + buttonPadding
		end

		return n7
	end
	local function getGoal(s2: string) -- line: 193
		-- upvalues: Otter (copy), getScrollToLocation (copy), t1 (copy)
		return Otter.spring(getScrollToLocation(s2), t1)
	end
	local function onPressHoldInputBegan(p1, s3: string) -- line: 197
		-- upvalues: v12 (copy), v10 (copy), RunService (copy), Constants (copy), t2 (copy)
		if p1.UserInputState ~= Enum.UserInputState.Begin then
			return
		end

		v12.current = tick()

		if v10.current then
			v10.current:Disconnect()
			v10.current = nil
		end

		v10.current = RunService.RenderStepped:Connect(function(dt) -- line: 203
			-- upvalues: v12 (copy), Constants (copy), s3 (copy), t2 (copy)
			local v58 = tick() - v12.current
			local v59 = (Constants.NAVIGATION_DIRECTION.IS_LEFT ~= s3 and 1 or -1) * 500 * dt * v58 ^ 2
			local v60 = t2.defaultUseProps.scrollingFrameRef.current.CanvasPosition + Vector2.new(v59, 0)

			t2.defaultUseProps.updateCanvasPosition(v60)
		end)
	end
	local function onPressHoldInputEnded(p2, s4: string) -- line: 212
		-- upvalues: t2 (copy), v12 (copy), v11 (copy), setMotor (copy), getGoal (copy), Otter (copy), v10 (copy)
		if p2.UserInputState ~= Enum.UserInputState.End then
			return
		end

		local current = t2.defaultUseProps.scrollingFrameRef.current

		if tick() - v12.current <= 0.5 then
			if v11.current then
				v11.current:destroy()
			end

			setMotor(current.CanvasPosition.X)

			if v11.current then
				v11.current:setGoal(getGoal(s4))
			end
		elseif v11.current then
			v11.current:setGoal(Otter.instant(current.CanvasPosition.X))
		end

		if v10.current then
			v10.current:Disconnect()
			v10.current = nil
		end
	end

	React.useEffect(function() -- line: 248
		-- upvalues: t2 (copy), setMotor (copy), v10 (copy), v11 (copy)
		if t2.defaultUseProps then
			setMotor(0)
		end

		return function() -- line: 254
			-- upvalues: v10 (copy), v11 (copy)
			if v10.current then
				v10.current:Disconnect()
				v10.current = nil
			end

			if v11.current then
				v11.current:destroy()
				v11.current = nil
			end
		end
	end, {})

	return {
		holdConnRef = v10,
		motorRef = v11,
		timeOfInputBeganRef = v12,
		handleInputBegan = function(_, p4) -- line: 233
			-- upvalues: t2 (copy), onPressHoldInputBegan (copy)
			local v51 = t2.onPressHoldInputBegan or onPressHoldInputBegan

			if v51 then
				v51(p4, t2.navDirection or "")
			end
		end,
		handleInputEnded = function(_, p6) -- line: 240
			-- upvalues: t2 (copy), onPressHoldInputEnded (copy)
			local v54 = t2.onPressHoldInputEnded or onPressHoldInputEnded

			if v54 then
				v54(p6, t2.navDirection or "")
			end
		end,
		disconnectHoldConn = function() -- line: 79
			-- upvalues: v10 (copy)
			if v10.current then
				v10.current:Disconnect()
				v10.current = nil
			end
		end
	}
end

return useArrowNavScrollBehavior
