local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)

local function AudioDeviceInputDebugger(p)
	local state, setState = React.useState(true)
	local instances = p.instances
	local mutedPlayers = p.mutedPlayers

	local mapped = Cryo.List.map(Cryo.Dictionary.keys(instances), function(props, layoutOrder: number)
		local active = props.Active
		local name = props.Player and props.Player.Name or "(no player)"

		local v = props.Player and mutedPlayers[props.Player.UserId] and "muted" or "unmuted"
		local v2 = props.MutedByLocalUser and "mutedByLocalUser" or "not-mutedByLocalUser"
		return React.createElement("TextLabel", {
			Text = string.format("<b>%s</b>: %s, %s, %s", name, active and "active" or "inactive", v, v2),
			Size = UDim2.fromOffset(20, 25),
			RichText = true,
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = layoutOrder,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSans,
			TextSize = 18
		})
	end)

	mapped.Title = React.createElement("TextButton", {
		Text = "<b>AudioDeviceInputs</b>",
		[React.Event.Activated] = function()
			setState(not state)
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

	mapped.UIListLayout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 3)
	})

	mapped.UIPadding = React.createElement("UIPadding", {
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
		Size = UDim2.new(1 / 3, 0, state and 1 / 3 or 0, state and 0 or 25),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, #Cryo.Dictionary.keys(instances) * 28),
		ScrollBarThickness = 6,
		BackgroundTransparency = state and 0.2 or 1
	}, mapped))
end

return AudioDeviceInputDebugger
