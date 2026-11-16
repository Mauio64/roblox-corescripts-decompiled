local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local Components = Foundation.Components
require(Components.Types)

local Flags = require(Foundation.Utility.Flags)
local getTextBoundsAsync = require(Foundation.Utility.getTextBoundsAsync)
local normalizeFontFace = require(Foundation.Utility.normalizeFontFace)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)

local Services = require(Foundation.Utility.Wrappers.Services)
local TextService = Services.TextService

local function useTextSize(p: string?, p2, vector2: Vector2?)
	if Flags.FoundationFontFaceMigration then
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
	else
		local state, setState = React.useState(nil)
		local v = { p, p2, vector2, usePreferences().preferredTextSize }
		React.useEffect(function()
			if p == nil then
				setState(nil)
				return
			end

			local fontSize = p2.FontSize
			local font = p2.Font
			local v2

			if vector2 then
				v2 = vector2
			else
				v2 = Vector2.new(1e999, 1e999)
			end

			setState(TextService:GetTextSize(p, fontSize, font, v2))
		end, v)

		return state
	end
end

return useTextSize
