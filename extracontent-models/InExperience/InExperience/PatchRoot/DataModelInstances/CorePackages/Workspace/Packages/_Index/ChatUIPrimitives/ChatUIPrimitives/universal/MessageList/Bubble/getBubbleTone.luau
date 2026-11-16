local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
require(parent.Foundation)

local function fade(p) -- 2 equivalent calls inferred from this helper
	local v = (1 - (p.Transparency or 0)) * 0.5
	return {
		Color3 = p.Color3,
		Transparency = 1 - v
	}
end

local function getBubbleTone(flag: boolean, p, flag2: boolean?)
	local selected

	if flag then
		selected = {
			backgroundStyle = p.Color.System.Emphasis,
			textStyle = p.Color.ActionEmphasis.Foreground
		}
	else
		selected = {
			backgroundStyle = p.Color.Shift.Shift_400,
			textStyle = p.Color.Content.Emphasis
		}
	end

	if not flag2 then
		return selected
	end

	return {
		backgroundStyle = fade(selected.backgroundStyle), -- inferred equivalent call
		textStyle = fade(selected.textStyle) -- inferred equivalent call
	}
end

return getBubbleTone
