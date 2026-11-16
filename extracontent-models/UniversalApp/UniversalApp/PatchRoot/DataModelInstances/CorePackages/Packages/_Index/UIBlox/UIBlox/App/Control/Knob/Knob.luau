local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local Cryo = require(parent4.Cryo)

local BaseKnob = require(parent.BaseKnob)
local ControlState = require(parent3.Core.Control.Enum.ControlState)
local Colors = require(parent2.Style.Colors)

local v = {
	contextual = {
		[ControlState.Default] = { Color = Colors.White, Transparency = 0 },
		[ControlState.Hover] = { Color = Colors.White, Transparency = 0 },
		[ControlState.Pressed] = { Color = Colors.Green, Transparency = 0 },
		[ControlState.Disabled] = { Color = Colors.Pumice, Transparency = 0 },
		[ControlState.Selected] = { Color = Colors.White, Transparency = 0 },
		[ControlState.SelectedPressed] = { Color = Colors.White, Transparency = 0 }
	},
	system = {
		[ControlState.Default] = { Color = Colors.White, Transparency = 0 },
		[ControlState.Hover] = { Color = Colors.White, Transparency = 0 },
		[ControlState.Pressed] = { Color = Colors.Pumice, Transparency = 0 },
		[ControlState.Disabled] = { Color = Colors.Pumice, Transparency = 0 },
		[ControlState.Selected] = { Color = Colors.White, Transparency = 0 },
		[ControlState.SelectedPressed] = { Color = Colors.White, Transparency = 0 }
	}
}

local function buildKnob(p) -- 2 equivalent calls inferred from this helper
	return Roact.forwardRef(function(p2, forwardedRef)
		local colorMap = v[p]
		local joined = Cryo.Dictionary.join({}, p2, {
			colorMap = colorMap,
			forwardedRef = forwardedRef
		})

		return Roact.createElement(BaseKnob, joined)
	end)
end

return { ContextualKnob = buildKnob("contextual"), SystemKnob = buildKnob("system") } -- inferred equivalent call
