local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Rodux = require(ParentParent.Rodux)
local RoactRodux = require(ParentParent.RoactRodux)
local RoactServices = require(ParentParent.RoactServices).RoactServices
local Foundation = require(ParentParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local AppStyleProvider = require(ParentParent.Style).AppStyleProvider
local Constants = require(ParentParent.Style).Constants
local t1 = {
	themeName = Constants.ThemeName.Dark,
	fontName = Constants.FontName.Gotham
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

local function v12(p1, p2) -- line: 31
	-- upvalues: Rodux (copy)
	local v15 = p2 or function(p3) -- line: 32
		return p3
	end

	return Rodux.Store.new(v15, p1 or {}, { Rodux.thunkMiddleware })
end

return {
	mockServices = function(p4) -- line: 39
		-- upvalues: React (copy), RoactRodux (copy), v12 (copy), t2 (copy), FoundationProvider (copy), Foundation (copy), AppStyleProvider (copy), t1 (copy), RoactServices (copy)
		local t3 = {
			storeProvider = React.createElement(RoactRodux.StoreProvider, {
				store = v12(t2)
			}, {
				foundationProvider = React.createElement(FoundationProvider, {
					theme = Foundation.Enums.Theme.Dark
				}, {
					styleProvider = React.createElement(AppStyleProvider, {
						style = t1
					}, p4)
				})
			})
		}

		return (React.createElement(RoactServices.ServiceProvider, {}, t3))
	end
}
