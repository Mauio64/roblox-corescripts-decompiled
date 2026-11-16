local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local PaginationVariant = require(Foundation.Enums.PaginationVariant)

local withDefaults = require(Foundation.Utility.withDefaults)

local DirectionalPagination = require(script.Parent.Variants.DirectionalPagination)
local MultiPagePagination = require(script.Parent.Variants.MultiPagePagination)

local v = { variant = PaginationVariant.MultiPage, testId = "--foundation-pagination" }

local function Pagination(p, ref)
	local v2 = withDefaults(p, v)
	v2.ref = ref

	if v2.variant == PaginationVariant.MultiPage then
		return React.createElement(MultiPagePagination, v2)
	end

	return React.createElement(DirectionalPagination, v2)
end

return React.memo(React.forwardRef(Pagination))
