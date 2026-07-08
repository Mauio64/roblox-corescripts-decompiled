local ancestor = script:FindFirstAncestor("ultimate-list")

require(ancestor.Parent.React)

return {
	byState = function(p1: ((...any) -> ...any), t1: {[any]: any}?) -- line: 20
		return {
			type = "byState",
			callback = p1,
			config = t1 or {}
		}
	end,
	byBinding = function(p2: ((...any) -> ...any)) -- line: 28
		return {
			type = "byBinding",
			callback = p2
		}
	end
}
