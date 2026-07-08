local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Cryo = require(ParentParentParentParent.Cryo)
local BaseKnob = require(scriptParent.BaseKnob)
local ControlState = require(ParentParentParent.Core.Control.Enum.ControlState)
local Colors = require(ParentParent.Style.Colors)
local t1 = {
	contextual = {
		[ControlState.Default] = {
			Transparency = 0,
			Color = Colors.White
		},
		[ControlState.Hover] = {
			Transparency = 0,
			Color = Colors.White
		},
		[ControlState.Pressed] = {
			Transparency = 0,
			Color = Colors.Green
		},
		[ControlState.Disabled] = {
			Transparency = 0,
			Color = Colors.Pumice
		},
		[ControlState.Selected] = {
			Transparency = 0,
			Color = Colors.White
		},
		[ControlState.SelectedPressed] = {
			Transparency = 0,
			Color = Colors.White
		}
	},
	system = {
		[ControlState.Default] = {
			Transparency = 0,
			Color = Colors.White
		},
		[ControlState.Hover] = {
			Transparency = 0,
			Color = Colors.White
		},
		[ControlState.Pressed] = {
			Transparency = 0,
			Color = Colors.Pumice
		},
		[ControlState.Disabled] = {
			Transparency = 0,
			Color = Colors.Pumice
		},
		[ControlState.Selected] = {
			Transparency = 0,
			Color = Colors.White
		},
		[ControlState.SelectedPressed] = {
			Transparency = 0,
			Color = Colors.White
		}
	}
}

local function buildKnob(p1) -- line: 69
	-- upvalues: Roact (copy), t1 (copy), Cryo (copy), BaseKnob (copy)
	return Roact.forwardRef(function(p2, p3) -- line: 70
		-- upvalues: t1 (copy), p1 (copy), Cryo (copy), Roact (copy), BaseKnob (copy)
		local v26 = t1[p1]
		local v27 = Cryo.Dictionary.join({}, p2, {
			colorMap = v26,
			forwardedRef = p3
		})

		return Roact.createElement(BaseKnob, v27)
	end)
end

local t2 = {}
local s1 = "contextual"

t2.ContextualKnob = Roact.forwardRef(function(p4, p5) -- line: 70
	-- upvalues: t1 (copy), s1 (copy), Cryo (copy), Roact (copy), BaseKnob (copy)
	local v18 = t1[s1]
	local v19 = Cryo.Dictionary.join({}, p4, {
		colorMap = v18,
		forwardedRef = p5
	})

	return Roact.createElement(BaseKnob, v19)
end)

local s2 = "system"

t2.SystemKnob = Roact.forwardRef(function(p6, p7) -- line: 70
	-- upvalues: t1 (copy), s2 (copy), Cryo (copy), Roact (copy), BaseKnob (copy)
	local v22 = t1[s2]
	local v23 = Cryo.Dictionary.join({}, p6, {
		colorMap = v22,
		forwardedRef = p7
	})

	return Roact.createElement(BaseKnob, v23)
end)

return t2
