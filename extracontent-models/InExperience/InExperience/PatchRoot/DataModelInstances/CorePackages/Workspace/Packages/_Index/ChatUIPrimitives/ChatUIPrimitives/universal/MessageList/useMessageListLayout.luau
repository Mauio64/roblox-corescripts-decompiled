local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local ViewRecycler = require(parent.ViewRecycler)
local MessageInlineItemMetrics = require(script.Parent.Inline.MessageInlineItemMetrics)

local frozen = table.freeze({ accepted = false, geometryChanged = false })

local function rejectEmptyMeasurements(p) -- 1 equivalent call inferred from this helper
	local clone = table.clone(p)
	function clone.updateItemMeasurement(p2)
		if p2.length <= 0 then
			return frozen
		end

		return p.updateItemMeasurement(p2)
	end

	return clone
end

local function useMessageListLayout(estimatedItemLength: number?)
	if estimatedItemLength == nil then
		estimatedItemLength = MessageInlineItemMetrics.MIN_HEIGHT
	end

	local v = React.useMemo(function()
		return rejectEmptyMeasurements(ViewRecycler.Layout.measured({ -- inferred equivalent call
			estimatedItemLength = estimatedItemLength
		}))
	end, { estimatedItemLength })
	React.useEffect(function()
		return function()
			v.destroy()
		end
	end, { v })
	return v
end

return useMessageListLayout
