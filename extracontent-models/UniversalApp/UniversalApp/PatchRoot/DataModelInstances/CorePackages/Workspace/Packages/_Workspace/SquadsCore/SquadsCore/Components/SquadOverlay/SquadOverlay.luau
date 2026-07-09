local Parent = script:FindFirstAncestor("SquadsCore").Parent
local Cryo = require(Parent.Cryo)
local SquadPrompt = require(script.Parent.SquadPrompt)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens

function SquadOverlay() -- line: 17
	-- upvalues: useTokens (copy), React (copy), useSelector (copy), SquadPrompt (copy), Cryo (copy)
	local v8 = useTokens()
	local v9, v10 = React.useState(Vector2.new(0, 0))
	local v11 = useSelector(function(p1) -- line: 21
		return p1.Squad.SquadPrompt.arguments
	end)

	return React.createElement("ScreenGui", {
		Enabled = true,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 12,
		[React.Change.AbsoluteSize] = function(p2) -- line: 30
			-- upvalues: v10 (copy)
			v10(p2.AbsoluteSize)
		end
	}, {
		Overlay = React.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = v8.Color.Extended.Black.Black_70.Color3,
			BackgroundTransparency = v8.Color.Extended.Black.Black_70.Transparency,
			Size = UDim2.new(1, 0, 1, 0)
		}),
		SquadPrompt = React.createElement(SquadPrompt, Cryo.Dictionary.join(v11, {
			screenSize = v9
		}))
	})
end

return SquadOverlay
