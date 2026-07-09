local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local v2 = require(Parent.AppCommonLib).Signal.new()

return {
	switchTab = function(s1: string, s2: string) -- line: 22
		-- upvalues: v2 (copy)
		v2:fire(s1, s2)
	end,
	connect = function(p1: ((...any) -> ...any)) -- line: 26
		-- upvalues: v2 (copy)
		return v2:connect(p1)
	end
}
