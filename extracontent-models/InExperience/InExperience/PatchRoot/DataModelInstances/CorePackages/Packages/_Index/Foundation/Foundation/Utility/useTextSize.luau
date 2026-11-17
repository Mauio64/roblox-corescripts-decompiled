local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local Components = Foundation.Components
require(Components.Types)

local getTextBoundsAsync = require(Foundation.Utility.getTextBoundsAsync)
local normalizeFontFace = require(Foundation.Utility.normalizeFontFace)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)

local function useTextSize(p: string?, p2, vector2: Vector2?)
	local preferredTextSize = usePreferences().preferredTextSize
	local fontFace = normalizeFontFace(p2.Font)
	local fontSize = p2.FontSize

	local v = ReactUtils.useAsync(function()
		if p == nil or fontSize == nil or typeof(fontFace) ~= "Font" then
			return nil
		end

		local v

		if vector2 then
			v = vector2.X
		end

		return getTextBoundsAsync(p, fontFace, fontSize, v)
	end, { p, p2.Font, fontSize, vector2, preferredTextSize })

	local ref = React.useRef(nil)
	React.useEffect(function()
		if v.status == "ok" then
			ref.current = v.value
		end
	end, { v })

	return if v.status == "ok" then v.value else ref.current
end

return useTextSize
