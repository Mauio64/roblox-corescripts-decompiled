local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local RoactRodux = require(Parent.RoactRodux)
local RoactServices = require(Parent.Dev.RoactServices).RoactServices
local AppStyleProvider = require(Parent.Style).AppStyleProvider
local Constants = require(Parent.Style).Constants
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

local function v10(p1, p2) -- line: 34
	-- upvalues: Rodux (copy)
	local v13 = p2 or function(p3) -- line: 35
		return p3
	end

	return Rodux.Store.new(v13, p1 or {}, { Rodux.thunkMiddleware })
end

return {
	mockServices = function(p4, p5) -- line: 42
		-- upvalues: v10 (copy), t2 (copy), React (copy), RoactRodux (copy), AppStyleProvider (copy), t1 (copy), RoactServices (copy)
		local t3 = {
			store = p5 or v10(t2)
		}
		local t4 = {
			storeProvider = React.createElement(RoactRodux.StoreProvider, t3, {
				styleProvider = React.createElement(AppStyleProvider, {
					style = t1
				}, p4)
			})
		}

		return (React.createElement(RoactServices.ServiceProvider, {}, t4))
	end,
	mockStore = v10
}
