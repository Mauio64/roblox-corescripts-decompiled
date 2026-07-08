local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.HeaderBarSlot)

local v4 = React.createContext({
	testId = ""
})

local function HeaderBarProvider(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), v4 (copy)
	local v7 = React.useMemo(function() -- line: 26
		-- upvalues: t1 (copy)
		return {
			testId = t1.testId,
			slot = t1.slot
		}
	end, {
		t1.testId,
		t1.slot
	})

	return React.createElement(v4.Provider, {
		value = v7
	}, t1.children)
end

return {
	Context = v4,
	Provider = HeaderBarProvider
}
