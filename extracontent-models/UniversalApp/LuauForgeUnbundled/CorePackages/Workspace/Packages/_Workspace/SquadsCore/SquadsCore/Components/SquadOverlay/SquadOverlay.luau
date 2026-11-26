local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadOverlay/SquadPrompt")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector

local useTokens = Foundation.Hooks.useTokens

function LUAUFORGE_MODULE_GLOBALS_hlN_SquadOverlay()
	local v5 = useTokens()
	local state, setState = React.useState(Vector2.new(0, 0))

	local v6 = useSelector(function(p2)
		return p2.Squad.SquadPrompt.arguments
	end)

	return React.createElement("ScreenGui", {
		Enabled = true,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 12,
		[React.Change.AbsoluteSize] = function(p2)
			setState(p2.AbsoluteSize)
		end
	}, {
		Overlay = React.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = v5.Color.Extended.Black.Black_70.Color3,
			BackgroundTransparency = v5.Color.Extended.Black.Black_70.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Text = ""
		}),
		SquadPrompt = React.createElement(module2, Cryo.Dictionary.join(v6, {
			screenSize = state
		}))
	})
end

return LUAUFORGE_MODULE_GLOBALS_hlN_SquadOverlay
