local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local ControlState = Foundation.Enums.ControlState
local FoundationImage = Foundation.Image
local View = Foundation.View
local Constants = require(ParentParent.Constants)

local function ReactionPicker(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), Constants (copy), FoundationImage (copy), ControlState (copy), View (copy)
	local v11 = React.useMemo(function() -- line: 18
		-- upvalues: Constants (copy), React (copy), FoundationImage (copy), ControlState (copy), t1 (copy)
		local t2 = {}
		local n1 = 1

		for v14, v15 in Constants.ReactionIconMappings do
			t2[v14] = React.createElement(FoundationImage, {
				ZIndex = 2,
				tag = "anchor-center-center position-center-center size-900-900",
				Image = v15,
				LayoutOrder = n1,
				onStateChanged = function(p1) -- line: 27
					-- upvalues: ControlState (copy), t1 (copy), v14 (copy)
					if p1 == ControlState.Pressed then
						t1.reactToContent(v14)
					end
				end
			})
			n1 += 1
		end

		return t2
	end, { t1.reactToContent })

	return React.createElement(View, {
		tag = "radius-medium bg-over-media-0 padding-medium gap-medium auto-xy row"
	}, v11)
end

return ReactionPicker
