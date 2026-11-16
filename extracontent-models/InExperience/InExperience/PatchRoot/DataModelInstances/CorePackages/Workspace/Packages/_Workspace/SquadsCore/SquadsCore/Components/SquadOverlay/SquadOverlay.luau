local parent = script:FindFirstAncestor("SquadsCore").Parent

local Cryo = require(parent.Cryo)

local SquadPrompt = require(script.Parent.SquadPrompt)

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local useTokens = Foundation.Hooks.useTokens

function SquadOverlay()
	local v = useTokens()
	local state, setState = React.useState(Vector2.new(0, 0))

	local v2 = useSelector(function(p)
		return p.Squad.SquadPrompt.arguments
	end)

	return React.createElement("ScreenGui", {
		Enabled = true,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 12,
		[React.Change.AbsoluteSize] = function(p)
			setState(p.AbsoluteSize)
		end
	}, {
		Overlay = React.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = v.Color.Extended.Black.Black_70.Color3,
			BackgroundTransparency = v.Color.Extended.Black.Black_70.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Text = ""
		}),
		SquadPrompt = React.createElement(SquadPrompt, Cryo.Dictionary.join(v2, {
			screenSize = state
		}))
	})
end

return SquadOverlay
