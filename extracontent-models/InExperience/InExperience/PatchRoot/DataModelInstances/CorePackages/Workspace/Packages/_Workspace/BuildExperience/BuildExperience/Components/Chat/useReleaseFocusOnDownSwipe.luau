local UserInputService = game:GetService("UserInputService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
require(BuildExperience.Chat.useChatSessionCore)

local function getInputPosition(p) -- 2 equivalent calls inferred from this helper
	return Vector2.new(p.Position.X, p.Position.Y)
end

local function isPositionHorizontallyInsideGuiObject(inputPosition: Vector2, current): boolean -- 1 equivalent call inferred from this helper
	local v = inputPosition.X - current.AbsolutePosition.X
	return v >= 0 and v <= current.AbsoluteSize.X
end

local function isDownSwipe(vector2: Vector2): boolean -- 1 equivalent call inferred from this helper
	return vector2.Y >= 24 and vector2.Y > math.abs(vector2.X)
end

local function didDownSwipeCrossGuiObject(current: Vector2, inputPosition: Vector2, current2): boolean
	if not isDownSwipe(inputPosition - current) then -- inferred equivalent call
		return false
	end

	local x = current2.AbsolutePosition.X
	local v = x + current2.AbsoluteSize.X
	local v2 = math.min(current.X, inputPosition.X)
	local v3 = math.max(current.X, inputPosition.X)
	local y = current2.AbsolutePosition.Y
	local v4 = y + current2.AbsoluteSize.Y

	return x <= v3 and v2 <= v and current.Y <= v4 and y <= inputPosition.Y
end

local function useReleaseFocusOnDownSwipe(p, p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v = React.useCallback(function()
		if ref3.current then
			ref3.current:Disconnect()
			ref3.current = nil
		end

		ref.current = nil
		ref2.current = nil
	end, {})

	local v2 = React.useCallback(function()
		local current

		if p2 then
			current = p2.current
		end

		if current then
			current.releaseFocus()
		end
	end, { p2 })

	React.useEffect(function()
		local function maybeReleaseFocus(p3): boolean -- 2 equivalent calls inferred from this helper
			local current = ref2.current

			if ref.current ~= p3 or current == nil then
				return false
			end

			local current2 = p.current
			local inputPosition = getInputPosition(p3) -- inferred equivalent call

			if current2 == nil or not didDownSwipeCrossGuiObject(current, inputPosition, current2) then
				return false
			end

			v()
			v2()
			return true
		end

		local function handleInputChanged(current) -- 1 equivalent call inferred from this helper
			if maybeReleaseFocus(current) then -- inferred equivalent call
				return
			end

			if
				current.UserInputState == Enum.UserInputState.End
				or current.UserInputState == Enum.UserInputState.Cancel
			then
				v()
			end
		end

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(current)
			v()

			local current2 = p.current
			local v3

			if p2 then
				v3 = p2.current
			end

			if current2 == nil or v3 == nil then
				return
			end

			local inputPosition = getInputPosition(current) -- inferred equivalent call

			if
				not isPositionHorizontallyInsideGuiObject(inputPosition, current2) -- inferred equivalent call
				or inputPosition.Y > current2.AbsolutePosition.Y + current2.AbsoluteSize.Y
			then
				return
			end

			ref.current = current
			ref2.current = inputPosition
			ref3.current = current.Changed:Connect(function()
				handleInputChanged(current) -- inferred equivalent call
			end)
		end)

		local touchEndedConnection = UserInputService.TouchEnded:Connect(function(otherPart)
			if ref.current == otherPart and not maybeReleaseFocus(otherPart) then -- inferred equivalent call
				v()
			end
		end)

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
			v()
		end
	end, { p, p2, v, v2 })
end

return useReleaseFocusOnDownSwipe
