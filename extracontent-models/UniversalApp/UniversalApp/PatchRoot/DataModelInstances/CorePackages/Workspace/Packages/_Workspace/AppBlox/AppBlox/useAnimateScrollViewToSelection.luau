local UserGameSettings = UserSettings():GetService("UserGameSettings")
local TweenService = game:GetService("TweenService")
local AppBlox = script:FindFirstAncestor("AppBlox")
local AppBloxParent = AppBlox.Parent
local React = require(AppBloxParent.React)
local GamepadService = game:GetService("GamepadService")
local FFlagUseAnimateScrollViewToSelectionHelper = require(AppBloxParent.SharedFlags).FFlagUseAnimateScrollViewToSelectionHelper
local AnimateScrollViewToSelectionHelper = require(AppBlox.AnimateScrollViewToSelectionHelper)

local function useAnimateScrollViewToSelection(t1: {[any]: any}, n1: number) -- line: 15
	-- upvalues: FFlagUseAnimateScrollViewToSelectionHelper (copy), React (copy), AnimateScrollViewToSelectionHelper (copy), GamepadService (copy), UserGameSettings (copy), TweenService (copy)
	if FFlagUseAnimateScrollViewToSelectionHelper then
		React.useEffect(function() -- line: 20
			-- upvalues: t1 (copy), AnimateScrollViewToSelectionHelper (copy), n1 (copy)
			local u12 = nil
			local t2 = {}

			if t1 then
				local v14, v15 = AnimateScrollViewToSelectionHelper(t1.current, n1)

				t2 = v14
				u12 = v15
			end

			return function() -- line: 27
				-- upvalues: t2 (ref), u12 (ref)
				for _, v22 in t2 do
					v22:Disconnect()
				end

				if u12 then
					u12:Cancel()
				end
			end
		end, {
			t1,
			n1
		})

		return
	end

	React.useEffect(function() -- line: 37
		-- upvalues: t1 (copy), GamepadService (copy), UserGameSettings (copy), TweenService (copy), n1 (copy)
		local t3 = {}
		local u17 = nil
		local n2 = 0
		local n3 = 0

		if t1 and t1.current ~= nil then
			local current = t1.current

			n2 = current.AbsolutePosition.Y
			n3 = current.AbsoluteWindowSize.Y
			table.insert(t3, current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 49
				-- upvalues: n2 (ref), current (copy)
				n2 = current.AbsolutePosition.Y
			end))
			table.insert(t3, current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 55
				-- upvalues: n3 (ref), current (copy)
				n3 = current.AbsoluteWindowSize.Y
			end))
			table.insert(t3, current.SelectionChanged:Connect(function(_, _, p3) -- line: 61
				-- upvalues: current (copy), GamepadService (copy), u17 (ref), n3 (ref), n2 (ref), UserGameSettings (copy), TweenService (copy), n1 (copy)
				if p3 == nil or (not p3:IsDescendantOf(current) or GamepadService.GamepadCursorEnabled) then
					return
				end

				if u17 then
					u17:Cancel()
					u17 = nil
				end

				local AbsoluteSizeY = p3.AbsoluteSize.Y
				local v27 = p3.AbsolutePosition.Y - (n3 * 0.5 - AbsoluteSizeY * 0.5 + n2)
				local CanvasPosition = current.CanvasPosition
				local vector2 = Vector2.new(CanvasPosition.X, CanvasPosition.Y + v27)

				if UserGameSettings.ReducedMotion then
					current.CanvasPosition = vector2

					return
				end

				u17 = TweenService:Create(current, TweenInfo.new(n1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					CanvasPosition = vector2
				})

				if u17 then
					u17:Play()
				end
			end))
		end

		return function() -- line: 101
			-- upvalues: t3 (copy), u17 (ref)
			for _, v31 in t3 do
				v31:Disconnect()
			end

			if u17 then
				u17:Cancel()
			end
		end
	end, {
		t1,
		n1
	})
end

return useAnimateScrollViewToSelection
