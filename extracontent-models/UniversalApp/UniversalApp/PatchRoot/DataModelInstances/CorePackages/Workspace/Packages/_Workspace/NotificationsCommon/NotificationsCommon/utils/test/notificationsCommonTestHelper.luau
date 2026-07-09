local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Rodux = require(ParentParent.Rodux)
local RoactRodux = require(ParentParent.RoactRodux)
local RoactServices = require(ParentParent.RoactServices).RoactServices
local createStyleProvider = require(ParentParent.Dev.UnitTestHelpers).createStyleProvider
local t1 = {
	ScreenSize = Vector2.new(500, 500),
	SetAlias = {
		Aliases = {
			byUserId = {
				["1"] = "foo"
			}
		}
	}
}

local function v8(p1, p2) -- line: 24
	-- upvalues: Rodux (copy)
	local v11 = p2 or function(p3) -- line: 25
		return p3
	end

	return Rodux.Store.new(v11, p1 or {}, { Rodux.thunkMiddleware })
end

return {
	mockServices = function(p4) -- line: 32
		-- upvalues: React (copy), RoactRodux (copy), v8 (copy), t1 (copy), createStyleProvider (copy), RoactServices (copy)
		local t2 = {
			storeProvider = React.createElement(RoactRodux.StoreProvider, {
				store = v8(t1)
			}, {
				styleProvider = createStyleProvider(p4)
			})
		}

		return (React.createElement(RoactServices.ServiceProvider, {}, t2))
	end
}
