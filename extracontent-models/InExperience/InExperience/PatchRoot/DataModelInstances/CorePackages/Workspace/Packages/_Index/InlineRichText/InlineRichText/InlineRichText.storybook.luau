local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local UIBlox = require(InlineRichTextParent.UIBlox)
local RobloxAppUIBloxConfig = require(InlineRichTextParent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local Roact = require(InlineRichTextParent.Dev.Roact)
local Cryo = require(InlineRichTextParent.Cryo)
local MockProviders = require(InlineRichText.MockProviders)
local t1 = {
	Default = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}

return {
	roact = Roact,
	mapStory = function(p1) -- line: 35
		-- upvalues: t1 (copy), Roact (copy), MockProviders (copy), Cryo (copy)
		return function(p2) -- line: 36
			-- upvalues: t1 (copy), Roact (copy), MockProviders (copy), p1 (copy), Cryo (copy)
			local v11 = p2 and (not not p2.definition and p2.definition.props) or {}
			local v12 = p2 and t1[p2.theme] or t1.Default

			return Roact.createElement(MockProviders, {
				themeName = v12.themeName
			}, {
				story = Roact.createElement(p1, Cryo.Dictionary.union(v11, p2))
			})
		end
	end
}
