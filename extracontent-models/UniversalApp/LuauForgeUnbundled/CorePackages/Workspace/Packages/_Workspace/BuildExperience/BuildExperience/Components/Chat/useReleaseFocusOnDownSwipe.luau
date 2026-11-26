local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")

local function getInputPosition(p2)
	return Vector2.new(p2.Position.X, p2.Position.Y)
end

local function isPositionHorizontallyInsideGuiObject(p2, p3): boolean
	local v5 = p2.X - p3.AbsolutePosition.X
	return v5 >= 0 and v5 <= p3.AbsoluteSize.X
end

local function isDownSwipe(p2): boolean
	return p2.Y >= 24 and p2.Y > math.abs(p2.X)
end

local function didDownSwipeCrossGuiObject(current, vector2, current2): boolean
	local v5 = vector2 - current
	local v6 = v5.Y >= 24 and v5.Y > math.abs(v5.X)

	if not v6 then
		return false
	end

	local x = current2.AbsolutePosition.X
	local v7 = x + current2.AbsoluteSize.X
	local v8 = math.min(current.X, vector2.X)
	local v9 = math.max(current.X, vector2.X)
	local y = current2.AbsolutePosition.Y
	local v10 = y + current2.AbsoluteSize.Y

	return x <= v9 and v8 <= v7 and current.Y <= v10 and y <= vector2.Y
end

local function useReleaseFocusOnDownSwipe(p2, p3)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v5 = React.useCallback(function()
		if ref3.current then
			ref3.current:Disconnect()
			ref3.current = nil
		end

		ref.current = nil
		ref2.current = nil
	end, {})

	local v6 = React.useCallback(function()
		local current = if p3 then p3.current else nil

		if current then
			current.releaseFocus()
		end
	end, { p3 })

	React.useEffect(function()
		local function maybeReleaseFocus(p4): boolean
			local current = ref2.current

			if ref.current ~= p4 or current == nil then
				return false
			end

			local current2 = p2.current
			local vector2 = Vector2.new(p4.Position.X, p4.Position.Y)

			if current2 == nil or not didDownSwipeCrossGuiObject(current, vector2, current2) then
				return false
			end

			v5()
			v6()
			return true
		end

		local function handleInputChanged(p4)
			local current = ref2.current
			local flag

			if ref.current == p4 and current ~= nil then
				local current2 = p2.current
				local vector2 = Vector2.new(p4.Position.X, p4.Position.Y)

				if current2 == nil or not didDownSwipeCrossGuiObject(current, vector2, current2) then
					flag = false
				else
					v5()
					v6()
					flag = true
				end
			else
				flag = false
			end

			if flag then
				return
			end

			if
				p4.UserInputState == Enum.UserInputState.End
				or p4.UserInputState == Enum.UserInputState.Cancel
			then
				v5()
			end
		end

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(current)
			v5()

			local current2 = p2.current
			local v7 = if p3 then p3.current else nil

			if current2 == nil or v7 == nil then
				return
			end

			local vector2 = Vector2.new(current.Position.X, current.Position.Y)

			local v8 = vector2.X - current2.AbsolutePosition.X
			local v9 = v8 >= 0 and v8 <= current2.AbsoluteSize.X

			if not v9 or vector2.Y > current2.AbsolutePosition.Y + current2.AbsoluteSize.Y then
				return
			end

			ref.current = current
			ref2.current = vector2
			ref3.current = current.Changed:Connect(function()
				local v10 = current
				local current3 = ref2.current
				local flag

				if ref.current == v10 and current3 ~= nil then
					local current4 = p2.current
					local vector2_2 = Vector2.new(v10.Position.X, v10.Position.Y)

					if current4 == nil or not didDownSwipeCrossGuiObject(current3, vector2_2, current4) then
						flag = false
					else
						v5()
						v6()
						flag = true
					end
				else
					flag = false
				end

				if flag then
					return
				end

				if
					v10.UserInputState == Enum.UserInputState.End
					or v10.UserInputState == Enum.UserInputState.Cancel
				then
					v5()
				end
			end)
		end)

		local touchEndedConnection = UserInputService.TouchEnded:Connect(function(otherPart)
			if ref.current == otherPart then
				local current = ref2.current
				local v7

				if ref.current == otherPart and current ~= nil then
					local current2 = p2.current
					local vector2 = Vector2.new(otherPart.Position.X, otherPart.Position.Y)

					if current2 == nil or not didDownSwipeCrossGuiObject(current, vector2, current2) then
						v7 = false
					else
						v5()
						v6()
						v7 = true
					end
				else
					v7 = false
				end

				if not v7 then
					v5()
				end
			end
		end)

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
			v5()
		end
	end, { p2, p3, v5, v6 })
end

return useReleaseFocusOnDownSwipe
