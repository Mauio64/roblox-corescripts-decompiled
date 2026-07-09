local Parent = script:FindFirstAncestor("ExpChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Dictionary = require(Parent.llama).Dictionary
local RobloxAppUIBloxConfig = require(Parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local Light = Constants.ThemeName.Light
local Dark = Constants.ThemeName.Dark
local Gotham = Constants.FontName.Gotham
local t1 = {
	Light = {
		themeName = Light,
		fontName = Gotham
	},
	Dark = {
		themeName = Dark,
		fontName = Gotham
	}
}
local t2 = {}

return function(p1) -- line: 32
	-- upvalues: t2 (copy), Roact (copy), AppStyleProvider (copy), t1 (copy), Dictionary (copy)
	if not t2[p1] then
		t2[p1] = function(p2) -- line: 35
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), p1 (copy), Dictionary (copy)
			return Roact.createElement(AppStyleProvider, {
				style = t1[p2.theme or "Dark"]
			}, {
				Child = Roact.createElement(p1, Dictionary.join(p2, p2.definition and p2.definition.props))
			})
		end
	end

	return t2[p1]
end
