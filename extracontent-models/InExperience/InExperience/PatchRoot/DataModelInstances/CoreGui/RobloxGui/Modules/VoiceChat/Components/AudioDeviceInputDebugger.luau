local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)

local function AudioDeviceInputDebugger(t1: {[any]: any}) -- line: 5
	-- upvalues: React (copy), Cryo (copy)
	local v6, v7 = React.useState(true)
	local instances = t1.instances
	local mutedPlayers = t1.mutedPlayers
	local v10 = Cryo.List.map(Cryo.Dictionary.keys(instances), function(p1, n1: number) -- line: 15
		-- upvalues: mutedPlayers (copy), React (copy)
		local p1Active = p1.Active
		local v14 = p1.Player and p1.Player.Name or "(no player)"
		local v15 = not p1Active and "inactive" or "active"
		local v16 = (not p1.Player or not mutedPlayers[p1.Player.UserId]) and "unmuted" or "muted"
		local v17 = not p1.MutedByLocalUser and "not-mutedByLocalUser" or "mutedByLocalUser"

		return React.createElement("TextLabel", {
			RichText = true,
			BackgroundTransparency = 1,
			TextSize = 18,
			Text = string.format("<b>%s</b>: %s, %s, %s", v14, v15, v16, v17),
			Size = UDim2.fromOffset(20, 25),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = n1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.SourceSans
		})
	end)

	v10.Title = React.createElement("TextButton", {
		Text = "<b>AudioDeviceInputs</b>",
		[React.Event.Activated] = function() -- line: 37
			-- upvalues: v7 (copy), v6 (copy)
			v7(not v6)
		end,
		TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
		TextStrokeTransparency = 0.5,
		Size = UDim2.fromOffset(20, 25),
		RichText = true,
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Font = Enum.Font.SourceSansBold,
		TextSize = 20
	})
	v10.UIListLayout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 3)
	})
	v10.UIPadding = React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, 3),
		PaddingBottom = UDim.new(0, 3),
		PaddingLeft = UDim.new(0, 3),
		PaddingRight = UDim.new(0, 3)
	})

	return React.createElement("ScreenGui", {
		AutoLocalize = false,
		DisplayOrder = 100,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, React.createElement("ScrollingFrame", {
		Active = true,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		Size = UDim2.new(0.3333333333333333, 0, not v6 and 0 or 0.3333333333333333, not v6 and 25 or 0),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		CanvasSize = UDim2.new(0, 0, 0, #Cryo.Dictionary.keys(instances) * 28),
		BackgroundTransparency = not v6 and 1 or 0.2
	}, v10))
end

return AudioDeviceInputDebugger
