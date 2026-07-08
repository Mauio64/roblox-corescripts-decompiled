local t1 = {}
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local TweenService = game:GetService("TweenService")

function t1.setupControl(p1) -- line: 10
	-- upvalues: Mouse (copy), TweenService (copy)
	local timestamp = os.time()
	local u6 = false
	local u7 = false

	Mouse.Move:Connect(function() -- line: 15
		-- upvalues: timestamp (ref)
		timestamp = os.time()
	end)
	p1.ControlBarContainer.MouseEnter:Connect(function() -- line: 19
		-- upvalues: u6 (ref)
		u6 = true
	end)
	p1.ControlBarContainer.MouseLeave:Connect(function() -- line: 23
		-- upvalues: u6 (ref)
		u6 = false
	end)

	local tween = nil

	local function createTween() -- line: 29
		-- upvalues: tween (ref), TweenService (copy), p1 (copy), createTween (copy)
		tween = TweenService:Create(p1.ControlBarContainer, TweenInfo.new(2), {
			Position = p1.ControlBarContainerNonVisiblePosition
		})

		if tween then
			tween.Completed:Connect(function() -- line: 36
				-- upvalues: createTween (copy)
				createTween()
			end)

			return
		end

		error("Failed to create tween for control visibility")
	end

	createTween()
	task.spawn(function() -- line: 45
		-- upvalues: tween (ref), u6 (ref), timestamp (ref), u7 (ref), p1 (copy)
		while true do
			if not tween then
				error("No current tween for control visibility")
			end

			if not u6 and os.time() - timestamp > 2 then
				if not u7 then
					u7 = true
					tween:Play()
				end
			elseif u7 then
				u7 = false
				tween:Cancel()
				p1.ControlBarContainer.Position = p1.ControlBarContainerVisiblePosition
			end

			task.wait(0.1)
		end
	end)
end

return t1
