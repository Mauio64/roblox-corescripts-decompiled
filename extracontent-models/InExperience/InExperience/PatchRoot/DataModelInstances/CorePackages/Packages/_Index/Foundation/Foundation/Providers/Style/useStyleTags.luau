local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local TagsContext = require(scriptParent.TagsContext)
local getFormattedTags = require(Foundation.Utility.getFormattedTags)

require(Foundation.Components.Types)

local function useStyleTags(p1) -- line: 12
	-- upvalues: getFormattedTags (copy), React (copy), TagsContext (copy)
	local v9 = getFormattedTags(p1)
	local v10 = React.useContext(TagsContext)

	React.useLayoutEffect(function() -- line: 16
		-- upvalues: v9 (copy), v10 (copy)
		if v9 ~= nil then
			v10(string.split(v9, " "))
		end
	end, {
		v9,
		v10
	})

	return v9
end

return useStyleTags
