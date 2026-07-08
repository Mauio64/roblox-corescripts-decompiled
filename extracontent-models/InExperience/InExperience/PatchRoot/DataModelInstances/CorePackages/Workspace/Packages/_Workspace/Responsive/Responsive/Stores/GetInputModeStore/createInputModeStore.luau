local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local InputMode = require(ParentParent.InputMode)

return function() -- line: 14
	-- upvalues: Signals (copy), InputMode (copy)
	local v5, v6 = Signals.createSignal((InputMode.last()))
	local v7, v8 = Signals.createSignal((InputMode.preferred()))

	InputMode.connect(function() -- line: 18
		-- upvalues: v6 (copy), InputMode (copy), v8 (copy)
		v6((InputMode.last()))
		v8((InputMode.preferred()))
	end)

	return {
		getLastInputType = v5,
		getPreferredInputType = v7
	}
end
