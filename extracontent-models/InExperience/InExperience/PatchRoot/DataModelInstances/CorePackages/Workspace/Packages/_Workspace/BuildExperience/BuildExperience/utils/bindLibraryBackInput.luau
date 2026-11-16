local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local function bindLibraryBackInput(callback)
	local buildLibraryBack = Instance.new("InputContext")
	buildLibraryBack.Name = "BuildLibraryBack"
	buildLibraryBack.Priority = 2000
	buildLibraryBack.Sink = true
	local back = Instance.new("InputAction")
	back.Name = "Back"
	back.Type = Enum.InputActionType.Bool

	for _, keyCode in { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB } do
		local inputBinding = Instance.new("InputBinding")
		inputBinding.KeyCode = keyCode
		inputBinding.Parent = back
	end

	back.Parent = buildLibraryBack

	local v = false

	local v2 = false

	local v3 = false
	local function update() -- 3 equivalent calls inferred from this helper
		local enabled = not (v or v2) and UserInputService:GetFocusedTextBox() == nil

		if not enabled then
			v3 = false
		end

		buildLibraryBack.Enabled = enabled
	end

	local enabled = not v and not v2 and UserInputService:GetFocusedTextBox() == nil

	if not enabled then
		v3 = false
	end

	buildLibraryBack.Enabled = enabled

	local v4 = {
		back.Pressed:Connect(function()
			v3 = buildLibraryBack.Enabled
		end),
		back.Released:Connect(function()
			if v3 then
				v3 = false
				callback()
			end
		end),
		UserInputService.TextBoxFocused:Connect(update),
		UserInputService.TextBoxFocusReleased:Connect(function()
			v2 = UserInputService:IsKeyDown(Enum.KeyCode.Escape)
				or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonB)
			update() -- inferred equivalent call
		end),
		UserInputService.InputEnded:Connect(function(input)
			if v2 and (input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB) then
				v2 = false
				update() -- inferred equivalent call
			end
		end)
	}

	buildLibraryBack.Parent = CoreGui
	return {
		setChatOpen = function(flag: boolean)
			v = flag
			update() -- inferred equivalent call
		end,
		unbind = function()
			for _, connection in v4 do
				connection:Disconnect()
			end

			buildLibraryBack:Destroy()
		end
	}
end

return bindLibraryBackInput
