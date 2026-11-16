local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local IdentityKind = require(ViewRecycler.Core.Enums.IdentityKind)
local PinnedPosition = require(ViewRecycler.Core.Enums.PinnedPosition)

return table.freeze({
	IdentityKind = IdentityKind,
	ITEM_PLACEMENT_KEYS = table.freeze({
		"mainAxisOffset",
		"mainAxisLength",
		"mainAxisEndLimit",
		"zIndex"
	}),
	PinnedPosition = PinnedPosition
})
