local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
local UIBlox = require(parent.UIBlox)
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local Roact = require(parent.Dev.Roact)
local Cryo = require(parent.Cryo)

local MockProviders = require(InlineRichText.MockProviders)

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

return {
	roact = Roact,
	mapStory = function(p)
		return function(p2)
			local props = p2 and p2.definition and p2.definition.props or {}
			local v2 = p2 and v[p2.theme] or v.Default

			return Roact.createElement(MockProviders, { themeName = v2.themeName }, {
				story = Roact.createElement(p, Cryo.Dictionary.union(props, p2))
			})
		end
	end
}
