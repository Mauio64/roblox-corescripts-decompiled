local UserGameSettings = UserSettings():GetService("UserGameSettings")
local GamepadService = game:GetService("GamepadService")
local TweenService = game:GetService("TweenService")

function AnimateScrollViewToSelectionHelper(p1, n1: number, p2: ((...any) -> ...any)?) -- line: 5
	-- upvalues: GamepadService (copy), UserGameSettings (copy), TweenService (copy)
	local t1 = {}
	local u8 = nil

	if not p1 then
		return t1
	end

	local AbsolutePositionY = p1.AbsolutePosition.Y
	local AbsoluteWindowSizeY = p1.AbsoluteWindowSize.Y

	table.insert(t1, p1:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 21
		-- upvalues: AbsolutePositionY (ref), p1 (copy)
		AbsolutePositionY = p1.AbsolutePosition.Y
	end))
	table.insert(t1, p1:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 27
		-- upvalues: AbsoluteWindowSizeY (ref), p1 (copy)
		AbsoluteWindowSizeY = p1.AbsoluteWindowSize.Y
	end))
	table.insert(t1, p1.SelectionChanged:Connect(function(_, _, p5) -- line: 33
		-- upvalues: p1 (copy), GamepadService (copy), u8 (ref), AbsoluteWindowSizeY (ref), AbsolutePositionY (ref), UserGameSettings (copy), p2 (copy), TweenService (copy), n1 (copy)
		if not p5 or (not p5:IsDescendantOf(p1) or GamepadService.GamepadCursorEnabled) then
			return
		end

		if u8 then
			u8:Cancel()
			u8 = nil
		end

		local AbsoluteSizeY = p5.AbsoluteSize.Y
		local v15 = p5.AbsolutePosition.Y - (AbsoluteWindowSizeY * 0.5 - AbsoluteSizeY * 0.5 + AbsolutePositionY)
		local CanvasPosition = p1.CanvasPosition
		local vector2 = Vector2.new(CanvasPosition.X, CanvasPosition.Y + v15)

		if UserGameSettings.ReducedMotion or p2 and p2() then
			p1.CanvasPosition = vector2

			return
		end

		u8 = TweenService:Create(p1, TweenInfo.new(n1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			CanvasPosition = vector2
		})

		if u8 then
			u8:Play()
		end
	end))

	return t1, u8
end

return AnimateScrollViewToSelectionHelper
