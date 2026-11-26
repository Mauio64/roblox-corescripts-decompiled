local LogReporterService = game:GetService("LogReporterService")
local Players = game:GetService("Players")

local module = require("@luauforge/deferred/fEI")
local module2 = require("@luauforge/deferred/fEZ")

local function StratusBugReportPanel()
	local state, setState = module.useState(false)
	local state2, setState2 = module.useState("")
	local state3, setState3 = module.useState(false)
	local state4, setState4 = module.useState(false)

	local createElement = module2.createElement
	local fragment = module.Fragment
	local v6 = {
		BugButton = module2.createElement("TextButton", {
			Size = UDim2.new(0, 52, 0, 52),
			Position = UDim2.new(1, -10, 0, 10),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Color3.fromRGB(205, 204, 0),
			BackgroundTransparency = 0.12,
			BorderColor3 = Color3.fromRGB(204, 51, 0),
			BorderSizePixel = 2,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 24,
			ZIndex = 4,
			[module.Event.Activated] = function()
				setState(true)
				setState2("")
				setState4(false)
			end
		}, {
			BugIcon = module2.createElement("ImageLabel", {
				Size = UDim2.fromOffset(48, 48),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/VideoServerScreen/bug.png",
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 5
			})
		}),
		Dialog = 0
	}
	local v8

	if state then
		local createElement3 = module2.createElement
		local v9 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			ZIndex = 5
		}

		local createElement4 = module2.createElement
		local v11 = {
			Size = UDim2.new(0, 360, 0, 280),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			ZIndex = 5
		}

		local children = {
			Title = module2.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
				Text = "Report a Bug",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 18,
				Font = Enum.Font.GothamBold,
				ZIndex = 6
			}),
			InputContainer = module2.createElement("Frame", {
				Size = UDim2.new(1, -20, 0, 140),
				Position = UDim2.new(0, 10, 0, 45),
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 6
			}, {
				Input = module2.createElement("TextBox", {
					Size = UDim2.new(1, 0, 0, 140),
					AutomaticSize = Enum.AutomaticSize.Y,
					Position = UDim2.new(0, 4, 0, 0),
					BackgroundTransparency = 1,
					TextColor3 = Color3.new(1, 1, 1),
					PlaceholderText = "Describe the issue...",
					MultiLine = true,
					TextWrapped = true,
					ClearTextOnFocus = false,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					ZIndex = 7,
					Text = state2,
					[module.Event.Changed] = function(p2)
						setState2(p2.Text)
					end
				})
			}),
			SubmitButton = module2.createElement("TextButton", {
				Size = UDim2.new(0, 140, 0, 40),
				Position = UDim2.new(0, 10, 1, -50),
				BackgroundColor3 = Color3.fromRGB(0, 120, 215),
				TextColor3 = Color3.new(1, 1, 1),
				Text = state3 and "Sending..." or state4 and "Sent!" or "Submit",
				TextSize = 16,
				ZIndex = 6,
				[module.Event.Activated] = function()
					if state3 or state4 then
						return
					end

					setState3(true)
					task.spawn(function()
						local localPlayer = Players.LocalPlayer
						local name = localPlayer and localPlayer.Name or ""
						LogReporterService:SubmitStratusBugReport(state2, name)
						setState3(false)
						setState4(true)
						task.wait(1.5)
						setState(false)
					end)
				end
			}),
			CancelButton = module2.createElement("TextButton", {
				Size = UDim2.new(0, 140, 0, 40),
				Position = UDim2.new(1, -150, 1, -50),
				BackgroundColor3 = Color3.fromRGB(80, 80, 80),
				TextColor3 = Color3.new(1, 1, 1),
				Text = "Cancel",
				TextSize = 16,
				ZIndex = 6,
				[module.Event.Activated] = function()
					setState(false)
				end
			})
		}
		v8 = createElement3("Frame", v9, {
			Panel = createElement4("Frame", v11, children)
		}) or nil
	end

	v6.Dialog = v8
	return createElement(fragment, {}, v6)
end

return StratusBugReportPanel
