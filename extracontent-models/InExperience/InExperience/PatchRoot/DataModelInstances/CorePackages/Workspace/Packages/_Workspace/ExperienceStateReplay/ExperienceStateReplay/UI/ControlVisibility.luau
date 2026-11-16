local Players = game:GetService("Players")
local mouse = Players.LocalPlayer:GetMouse()

local TweenService = game:GetService("TweenService")
return {
	setupControl = function(data)
		local lastTime = os.time()
		local v = false
		local flag = false

		mouse.Move:Connect(function()
			lastTime = os.time()
		end)

		data.ControlBarContainer.MouseEnter:Connect(function()
			v = true
		end)

		data.ControlBarContainer.MouseLeave:Connect(function()
			v = false
		end)

		local v2 = nil
		local function createTween()
			v2 = TweenService:Create(data.ControlBarContainer, TweenInfo.new(2), {
				Position = data.ControlBarContainerNonVisiblePosition
			})

			if v2 then
				v2.Completed:Connect(function()
					createTween()
				end)
			else
				error("Failed to create tween for control visibility")
			end
		end
		createTween()

		task.spawn(function()
			while true do
				if not v2 then
					error("No current tween for control visibility")
				end

				if v or not (os.time() - lastTime > 2) then
					if flag then
						flag = false
						v2:Cancel()
						data.ControlBarContainer.Position = data.ControlBarContainerVisiblePosition
					end
				elseif not flag then
					flag = true
					v2:Play()
				end

				task.wait(0.1)
			end
		end)
	end
}
