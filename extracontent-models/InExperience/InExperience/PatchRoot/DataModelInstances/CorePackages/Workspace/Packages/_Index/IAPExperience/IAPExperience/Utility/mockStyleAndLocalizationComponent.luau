local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local UIBlox = require(ParentParentParent.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local Dark = Constants.ThemeName.Dark
local Gotham = Constants.FontName.Gotham
local LocaleProvider = require(ParentParent.Locale.LocaleProvider)

return function(p1) -- line: 15
	-- upvalues: Roact (copy), LocaleProvider (copy), AppStyleProvider (copy), Dark (copy), Gotham (copy)
	return Roact.createElement(LocaleProvider, {
		locale = "en-us",
		render = function() -- line: 18
			-- upvalues: Roact (copy), AppStyleProvider (copy), Dark (copy), Gotham (copy), p1 (copy)
			return Roact.createElement(AppStyleProvider, {
				style = {
					themeName = Dark,
					fontName = Gotham
				}
			}, { Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0)
			}, p1) })
		end
	})
end
