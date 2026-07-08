local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local TagsContext = require(scriptParent.TagsContext)
local getFormattedTags = require(Foundation.Utility.getFormattedTags)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Components.Types)

local function useStyleTags(p1) -- line: 14
	-- upvalues: getFormattedTags (copy), React (copy), TagsContext (copy), Flags (copy)
	local v10 = getFormattedTags(p1)
	local v11 = React.useContext(TagsContext)

	React.useLayoutEffect(function() -- line: 18
		-- upvalues: v10 (copy), Flags (copy), v11 (copy)
		if v10 ~= nil then
			if Flags.FoundationUseStyleSheetRegistry then
				v11(string.split(v10, " "))

				return
			end

			v11(v10)
		end
	end, {
		v10,
		if not Flags.FoundationUseStyleSheetRegistry then nil else v11
	})

	return v10
end

return useStyleTags
