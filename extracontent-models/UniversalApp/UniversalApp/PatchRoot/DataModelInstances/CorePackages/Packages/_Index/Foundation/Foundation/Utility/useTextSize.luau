local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Components = Foundation.Components

require(Components.Types)

local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local TextService = require(Foundation.Utility.Wrappers.Services).TextService

local function useTextSize(s1: string?, p1, vector2: Vector2?) -- line: 14
	-- upvalues: React (copy), usePreferences (copy), TextService (copy)
	local v11, v12 = React.useState(nil)
	local preferredTextSize = usePreferences().preferredTextSize

	React.useEffect(function() -- line: 18
		-- upvalues: s1 (copy), v12 (copy), TextService (copy), p1 (copy), vector2 (copy)
		if s1 == nil then
			v12(nil)

			return
		end

		v12(TextService:GetTextSize(s1, p1.FontSize, p1.Font, if not vector2 then Vector2.new(1e999, 1e999) else vector2))
	end, {
		s1,
		p1,
		vector2,
		preferredTextSize
	})

	return v11
end

return useTextSize
