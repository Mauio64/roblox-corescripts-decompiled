local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)

return function(data)
	local v = {
		TextDefault = {
			Color = data.Theme.TextEmphasis.Color,
			Transparency = data.Theme.TextEmphasis.Transparency
		}
	}

	local v2 = {
		Body = {
			Font = data.Font.Header1.Font,
			RelativeSize = data.Font.Body.RelativeSize,
			RelativeMinSize = data.Font.Body.RelativeMinSize
		},
		CaptionBody = {
			Font = data.Font.Header1.Font,
			RelativeSize = data.Font.CaptionBody.RelativeSize,
			RelativeMinSize = data.Font.CaptionBody.RelativeMinSize
		}
	}

	return {
		Theme = Cryo.Dictionary.join(data.Theme, v),
		Font = Cryo.Dictionary.join(data.Font, v2),
		Settings = nil,
		Tokens = data.Tokens
	}
end
