local parent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local parent2 = Foundation.Parent

local React = require(parent2.React)
local TagsContext = require(parent.TagsContext)
local getFormattedTags = require(Foundation.Utility.getFormattedTags)

require(Foundation.Components.Types)

local function useStyleTags(p)
	local formattedTags = getFormattedTags(p)

	local v = React.useContext(TagsContext)
	React.useLayoutEffect(function()
		if formattedTags ~= nil then
			v(string.split(formattedTags, " "))
		end
	end, { formattedTags, v })
	return formattedTags
end

return useStyleTags
