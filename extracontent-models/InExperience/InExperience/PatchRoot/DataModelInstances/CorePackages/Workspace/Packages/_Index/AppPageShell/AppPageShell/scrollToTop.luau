local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local parent = script:FindFirstAncestor("AppPageShell").Parent
local Responsive = require(parent.Responsive)

local function scrollToTop(instance)
	if UserGameSettings.ReducedMotion then
		instance.CanvasPosition = Vector2.new(0, 0)
		return
	end

	if Responsive.GetInputModeStore(false).getLastInputType(false) ~= Responsive.Input.Directional then
		instance:ScrollToTop()

		return
	end

	local tween = TweenService:Create(instance, TweenInfo.new(0.3), {
		CanvasPosition = Vector2.new(0, 0)
	})

	tween:Play()
	tween.Completed:Connect(function()
		GuiService:Select(instance)

		task.defer(function()
			if instance.Parent ~= nil then
				GuiService:Select(instance)
			end
		end)
	end)
end

return scrollToTop
