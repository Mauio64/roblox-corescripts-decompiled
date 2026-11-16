local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
require(Foundation.Components.Types)

local Dash = require(parent.Dash)
local React = require(parent.React)

local function useDefaultTags(value, p: string)
	return React.useMemo(function()
		if value == nil then
			return p
		end

		if type(value) == "string" then
			return `{p} {value}`
		end

		return (Dash.join(value, { [p] = true }))
	end, { value, p })
end

return useDefaultTags
