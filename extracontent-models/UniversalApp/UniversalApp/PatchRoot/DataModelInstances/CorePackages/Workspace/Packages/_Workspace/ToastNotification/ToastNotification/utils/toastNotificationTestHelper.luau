local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Rodux = require(ParentParent.Rodux)
local RoactRodux = require(ParentParent.RoactRodux)
local RoactServices = require(ParentParent.RoactServices).RoactServices
local LocalizationProvider = require(ParentParent.Localization).LocalizationProvider
local Localization = require(ParentParent.RobloxAppLocales).Localization
local Foundation = require(ParentParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local AppStyleProvider = require(ParentParent.Style).AppStyleProvider
local Constants = require(ParentParent.Style).Constants
local t1 = {
	themeName = Constants.ThemeName.Dark,
	fontName = Constants.FontName.Gotham,
	Tokens = {
		Global = {
			Size_350 = 28,
			Size_500 = 40
		}
	}
}
local t2 = {
	ScreenSize = Vector2.new(500, 500),
	SetAlias = {
		Aliases = {
			byUserId = {
				["1"] = "foo"
			}
		}
	}
}

local function v14(p1, p2) -- line: 42
	-- upvalues: Rodux (copy)
	local v18 = p2 or function(p3) -- line: 43
		return p3
	end

	return Rodux.Store.new(v18, p1 or {}, { Rodux.thunkMiddleware })
end

local v15 = Localization.new("en-us")

return {
	mockServices = function(p4) -- line: 52
		-- upvalues: React (copy), RoactRodux (copy), v14 (copy), t2 (copy), FoundationProvider (copy), Foundation (copy), AppStyleProvider (copy), t1 (copy), LocalizationProvider (copy), v15 (copy), RoactServices (copy)
		local t3 = {
			storeProvider = React.createElement(RoactRodux.StoreProvider, {
				store = v14(t2)
			}, {
				foundationProvider = React.createElement(FoundationProvider, {
					theme = Foundation.Enums.Theme.Dark
				}, {
					styleProvider = React.createElement(AppStyleProvider, {
						style = t1
					}, {
						localizationProvider = React.createElement(LocalizationProvider, {
							localization = v15
						}, p4)
					})
				})
			})
		}

		return (React.createElement(RoactServices.ServiceProvider, {}, t3))
	end
}
