local LogReporterService = game:GetService("LogReporterService")
local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("VideoServerScreen").Parent
local React = require(Parent.React)
local Roact = require(Parent.Roact)

local function StratusBugReportPanel() -- line: 14
	-- upvalues: React (copy), Roact (copy), Players (copy), LogReporterService (copy)
	local v7, v8 = React.useState(false)
	local v9, v10 = React.useState("")
	local v11, v12 = React.useState(false)
	local v13, v14 = React.useState(false)

	return Roact.createElement(React.Fragment, {}, {
		BugButton = Roact.createElement("TextButton", {
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
			[React.Event.Activated] = function() -- line: 34
				-- upvalues: v8 (copy), v10 (copy), v14 (copy)
				v8(true)
				v10("")
				v14(false)
			end
		}, {
			BugIcon = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/VideoServerScreen/bug.png",
				ZIndex = 5,
				Size = UDim2.fromOffset(48, 48),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				ScaleType = Enum.ScaleType.Fit
			})
		}),
		Dialog = v7 and Roact.createElement("Frame", {
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			ZIndex = 5,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0)
		}, {
			Panel = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 5,
				Size = UDim2.new(0, 360, 0, 280),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			}, {
				Title = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = "Report a Bug",
					TextSize = 18,
					ZIndex = 6,
					Size = UDim2.new(1, 0, 0, 40),
					TextColor3 = Color3.new(1, 1, 1),
					Font = Enum.Font.GothamBold
				}),
				InputContainer = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 6,
					Size = UDim2.new(1, -20, 0, 140),
					Position = UDim2.new(0, 10, 0, 45),
					BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				}, {
					Input = Roact.createElement("TextBox", {
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
						Text = v9,
						[React.Event.Changed] = function(p1) -- line: 104
							-- upvalues: v10 (copy)
							v10(p1.Text)
						end
					})
				}),
				SubmitButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 140, 0, 40),
					Position = UDim2.new(0, 10, 1, -50),
					BackgroundColor3 = Color3.fromRGB(0, 120, 215),
					TextColor3 = Color3.new(1, 1, 1),
					Text = if not v11 then not v13 and "Submit" or "Sent!" else "Sending...",
					TextSize = 16,
					ZIndex = 6,
					[React.Event.Activated] = function() -- line: 118
						-- upvalues: v11 (copy), v13 (copy), v12 (copy), Players (copy), LogReporterService (copy), v9 (copy), v14 (copy), v8 (copy)
						if v11 or v13 then
							return
						end

						v12(true)
						task.spawn(function() -- line: 123
							-- upvalues: Players (copy), LogReporterService (copy), v9 (copy), v12 (copy), v14 (copy), v8 (copy)
							local LocalPlayer = Players.LocalPlayer
							local v17 = LocalPlayer and LocalPlayer.Name or ""

							LogReporterService:SubmitStratusBugReport(v9, v17)
							v12(false)
							v14(true)
							task.wait(1.5)
							v8(false)
						end)
					end
				}),
				CancelButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 140, 0, 40),
					Position = UDim2.new(1, -150, 1, -50),
					BackgroundColor3 = Color3.fromRGB(80, 80, 80),
					TextColor3 = Color3.new(1, 1, 1),
					Text = "Cancel",
					TextSize = 16,
					ZIndex = 6,
					[React.Event.Activated] = function() -- line: 143
						-- upvalues: v8 (copy)
						v8(false)
					end
				})
			})
		}) or nil
	})
end

return StratusBugReportPanel
