local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local AutoScrollPolicy = require(ViewRecycler.Core.Enums.AutoScrollPolicy)
local ReachedThreshold = require(ViewRecycler.Core.ViewportBehavior.ReachedThreshold)
local ScrollAlignment = require(ViewRecycler.Core.Enums.ScrollAlignment)

return table.freeze({
	create = function(data)
		local startReachedThreshold = data == nil and 0 or data.startReachedThreshold or 0
		local endReachedThreshold = data == nil and 1 or data.endReachedThreshold or 1
		ReachedThreshold.validate(startReachedThreshold, "ChatPreset: startReachedThreshold")
		local autoScrollThreshold = data == nil and 1 or data.autoScrollThreshold or 1
		ReachedThreshold.validate(endReachedThreshold, "ChatPreset: endReachedThreshold")
		ReachedThreshold.validate(autoScrollThreshold, "ChatPreset: autoScrollThreshold")
		return table.freeze({
			initialScrollAlignment = ScrollAlignment.End,
			contentAlignment = ScrollAlignment.End,
			autoScrollOnChange = AutoScrollPolicy.WhenAtEnd,
			autoScrollThreshold = autoScrollThreshold,
			preserveScrollPositionOnChange = true,
			startReachedThreshold = startReachedThreshold,
			endReachedThreshold = endReachedThreshold
		})
	end
})
