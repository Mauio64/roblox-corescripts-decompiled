local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local Rodux = require(ParentParentParent.Rodux)
local Constants = require(ParentParent.Constants)
local installReducer = require(ParentParent.installReducer)
local Networking = require(ParentParent.App.Networking)
local ScreenSize = require(ParentParent.installReducer.ScreenSize)
local ServerType = require(ParentParent.installReducer.ServerType)
local t1 = {}

local function createStore(p1) -- line: 15
	-- upvalues: Dash (copy), t1 (copy), Rodux (copy), Constants (copy), installReducer (copy), Networking (copy), ScreenSize (copy), ServerType (copy)
	local v13 = Dash.joinDeep(t1, p1 or {})
	local v14 = Rodux.combineReducers({
		[Constants.RoduxKey] = installReducer(),
		NetworkStatus = Networking.RoduxNetworking.installReducer(),
		ScreenSize = ScreenSize,
		ServerType = ServerType
	})

	return Rodux.Store.new(v14, v13, { Rodux.thunkMiddleware })
end

return createStore
