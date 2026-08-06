local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local PaginationVariant = require(Foundation.Enums.PaginationVariant)
local withDefaults = require(Foundation.Utility.withDefaults)
local DirectionalPagination = require(script.Parent.Variants.DirectionalPagination)
local MultiPagePagination = require(script.Parent.Variants.MultiPagePagination)
local t1 = {
	testId = "--foundation-pagination",
	variant = PaginationVariant.MultiPage
}

local function Pagination(p1, p2) -- line: 22
	-- upvalues: withDefaults (copy), t1 (copy), PaginationVariant (copy), React (copy), MultiPagePagination (copy), DirectionalPagination (copy)
	local v12 = withDefaults(p1, t1)

	v12.ref = p2

	if v12.variant == PaginationVariant.MultiPage then
		return React.createElement(MultiPagePagination, v12)
	end

	return React.createElement(DirectionalPagination, v12)
end

return React.memo(React.forwardRef(Pagination))
