local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local TextService = game:GetService("TextService")
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Responsive = require(Parent.Responsive)
local useTokens = Foundation.Hooks.useTokens
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput

return function(s1: string?, n1: number, n2: number) -- line: 11
	-- upvalues: useTokens (copy), useIsSpatial (copy), usePreferredInput (copy), Responsive (copy), React (copy), TextService (copy)
	local v12 = useTokens()
	local BodyMedium = v12.Typography.BodyMedium
	local v14 = useIsSpatial()
	local v15 = usePreferredInput() == Responsive.Input.Directional
	local v16 = v14 or v15
	local v17, v18 = React.useMemo(function() -- line: 19
		-- upvalues: s1 (copy), TextService (copy), BodyMedium (copy), v16 (copy), n1 (copy), v12 (copy)
		local v19 = string.gsub(s1 or "", "[\r\n]+", " ")
		local Y = TextService:GetTextSize(v19, BodyMedium.FontSize, BodyMedium.Font, Vector2.new(1e999, 1e999)).Y
		local v21 = Y * ((not v16 and 1 or 1.3) * BodyMedium.LineHeight) + Y

		if s1 and s1 ~= "" then
			local TextSize = TextService:GetTextSize(s1, BodyMedium.FontSize, BodyMedium.Font, Vector2.new(n1, 1e999))

			return if not (v21 < TextSize.Y) then TextSize.Y else v21 + Y + v12.Gap.XSmall, v21
		end

		return 0, v21
	end, {
		s1,
		BodyMedium.FontSize,
		BodyMedium.Font,
		n1,
		n2,
		v16,
		v12.Gap.XSmall
	})

	return v17, v18
end
