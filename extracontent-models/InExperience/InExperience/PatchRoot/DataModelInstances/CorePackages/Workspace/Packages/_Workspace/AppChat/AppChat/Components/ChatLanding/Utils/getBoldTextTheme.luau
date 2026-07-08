local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)

return function(p1) -- line: 6
	-- upvalues: Cryo (copy)
	local t1 = {
		TextDefault = {
			Color = p1.Theme.TextEmphasis.Color,
			Transparency = p1.Theme.TextEmphasis.Transparency
		}
	}
	local t2 = {
		Body = {
			Font = p1.Font.Header1.Font,
			RelativeSize = p1.Font.Body.RelativeSize,
			RelativeMinSize = p1.Font.Body.RelativeMinSize
		},
		CaptionBody = {
			Font = p1.Font.Header1.Font,
			RelativeSize = p1.Font.CaptionBody.RelativeSize,
			RelativeMinSize = p1.Font.CaptionBody.RelativeMinSize
		}
	}

	return {
		Settings = nil,
		Theme = Cryo.Dictionary.join(p1.Theme, t1),
		Font = Cryo.Dictionary.join(p1.Font, t2),
		Tokens = p1.Tokens
	}
end
