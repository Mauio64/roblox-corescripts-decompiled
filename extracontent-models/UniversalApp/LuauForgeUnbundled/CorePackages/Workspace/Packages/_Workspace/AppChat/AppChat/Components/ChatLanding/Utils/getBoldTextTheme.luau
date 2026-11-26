local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

return function(data)
	local v5 = {
		TextDefault = {
			Color = data.Theme.TextEmphasis.Color,
			Transparency = data.Theme.TextEmphasis.Transparency
		}
	}

	local v6 = {
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
		Theme = Cryo.Dictionary.join(data.Theme, v5),
		Font = Cryo.Dictionary.join(data.Font, v6),
		Settings = nil,
		Tokens = data.Tokens
	}
end
