local UserInputService = game:GetService("UserInputService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.useChatSessionCore)

local function getInputPosition(p1) -- line: 15
	return Vector2.new(p1.Position.X, p1.Position.Y)
end
local function isPositionHorizontallyInsideGuiObject(vector2: Vector2, p2) -- line: 19
	local v13 = vector2.X - p2.AbsolutePosition.X

	return v13 >= 0 and v13 <= p2.AbsoluteSize.X
end
local function isDownSwipe(vector2: Vector2) -- line: 24
	return vector2.Y >= 24 and vector2.Y > math.abs(vector2.X)
end
local function didDownSwipeCrossGuiObject(vector2: Vector2, vector2_2: Vector2, p3) -- line: 28
	local v18 = vector2_2 - vector2

	if not (v18.Y >= 24) or not (v18.Y > math.abs(v18.X)) then
		return false
	end

	local AbsolutePositionX = p3.AbsolutePosition.X
	local v20 = AbsolutePositionX + p3.AbsoluteSize.X
	local v21 = math.min(vector2.X, vector2_2.X)
	local v22 = math.max(vector2.X, vector2_2.X)
	local AbsolutePositionY = p3.AbsolutePosition.Y
	local v24 = AbsolutePositionY + p3.AbsoluteSize.Y

	return AbsolutePositionX <= v22 and (v21 <= v20 and (v24 >= vector2.Y and AbsolutePositionY <= vector2_2.Y))
end
local function useReleaseFocusOnDownSwipe(p4, p5) -- line: 51
	-- upvalues: React (copy), didDownSwipeCrossGuiObject (copy), UserInputService (copy)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = React.useRef(nil)
	local v30 = React.useCallback(function() -- line: 56
		-- upvalues: v29 (copy), v27 (copy), v28 (copy)
		if v29.current then
			v29.current:Disconnect()
			v29.current = nil
		end

		v27.current = nil
		v28.current = nil
	end, {})
	local v31 = React.useCallback(function() -- line: 65
		-- upvalues: p5 (copy)
		local v32 = if not p5 then nil else p5.current

		if v32 then
			v32.releaseFocus()
		end
	end, { p5 })

	React.useEffect(function() -- line: 72
		-- upvalues: v28 (copy), v27 (copy), p4 (copy), didDownSwipeCrossGuiObject (copy), v30 (copy), v31 (copy), UserInputService (copy), p5 (copy), v29 (copy)
		local function maybeReleaseFocus(p6) -- line: 73
			-- upvalues: v28 (copy), v27 (copy), p4 (copy), didDownSwipeCrossGuiObject (copy), v30 (copy), v31 (copy)
			local current = v28.current

			if p6 ~= v27.current or current == nil then
				return false
			end

			local current2 = p4.current
			local vector2 = Vector2.new(p6.Position.X, p6.Position.Y)

			if current2 ~= nil and didDownSwipeCrossGuiObject(current, vector2, current2) then
				v30()
				v31()

				return true
			end

			return false
		end
		local function handleInputChanged(p7) -- line: 91
			-- upvalues: v28 (copy), v27 (copy), p4 (copy), didDownSwipeCrossGuiObject (copy), v30 (copy), v31 (copy)
			local current = v28.current
			local v43

			if p7 ~= v27.current or current == nil then
				v43 = false
			else
				local current3 = p4.current
				local vector2 = Vector2.new(p7.Position.X, p7.Position.Y)

				if current3 ~= nil and didDownSwipeCrossGuiObject(current, vector2, current3) then
					v30()
					v31()
					v43 = true
				else
					v43 = false
				end
			end

			if v43 then
				return
			end

			if p7.UserInputState == Enum.UserInputState.End or p7.UserInputState == Enum.UserInputState.Cancel then
				v30()
			end
		end

		local connection = UserInputService.TouchStarted:Connect(function(p8) -- line: 102
			-- upvalues: v30 (copy), p4 (copy), p5 (copy), v27 (copy), v28 (copy), v29 (copy), didDownSwipeCrossGuiObject (copy), v31 (copy)
			v30()

			local current = p4.current
			local v48 = if not p5 then nil else p5.current

			if current == nil or v48 == nil then
				return
			end

			local vector2 = Vector2.new(p8.Position.X, p8.Position.Y)
			local v50 = vector2.X - current.AbsolutePosition.X

			if not (v50 >= 0) or not (v50 <= current.AbsoluteSize.X) or vector2.Y > current.AbsolutePosition.Y + current.AbsoluteSize.Y then
				return
			end

			v27.current = p8
			v28.current = vector2
			v29.current = p8.Changed:Connect(function() -- line: 121
				-- upvalues: p8 (copy), v28 (copy), v27 (copy), p4 (copy), didDownSwipeCrossGuiObject (copy), v30 (copy), v31 (copy)
				local v56 = p8
				local current4 = v28.current
				local v58

				if v56 ~= v27.current or current4 == nil then
					v58 = false
				else
					local current5 = p4.current
					local vector2_3 = Vector2.new(v56.Position.X, v56.Position.Y)

					if current5 ~= nil and didDownSwipeCrossGuiObject(current4, vector2_3, current5) then
						v30()
						v31()
						v58 = true
					else
						v58 = false
					end
				end

				if v58 then
					return
				end

				if v56.UserInputState == Enum.UserInputState.End or v56.UserInputState == Enum.UserInputState.Cancel then
					v30()
				end
			end)
		end)
		local connection2 = UserInputService.TouchEnded:Connect(function(part) -- line: 126
			-- upvalues: v27 (copy), v28 (copy), p4 (copy), didDownSwipeCrossGuiObject (copy), v30 (copy), v31 (copy)
			if part == v27.current then
				local current = v28.current
				local v53

				if part ~= v27.current or current == nil then
					v53 = false
				else
					local current6 = p4.current
					local vector2 = Vector2.new(part.Position.X, part.Position.Y)

					if current6 ~= nil and didDownSwipeCrossGuiObject(current, vector2, current6) then
						v30()
						v31()
						v53 = true
					else
						v53 = false
					end
				end

				if not v53 then
					v30()
				end
			end
		end)

		return function() -- line: 134
			-- upvalues: connection (copy), connection2 (copy), v30 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			v30()
		end
	end, {
		p4,
		p5,
		v30,
		v31
	})
end

return useReleaseFocusOnDownSwipe
