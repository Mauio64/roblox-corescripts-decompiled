local Parent = script:FindFirstAncestor("AppChat").Parent
local Rodux = require(Parent.Rodux)
local Cryo = require(Parent.Cryo)
local t1 = {
	ChatAppReducer = {
		Presence = {
			byUserId = {}
		}
	},
	Users = {}
}

local function createStoryStore(p1) -- line: 15
	-- upvalues: Cryo (copy), t1 (copy), Rodux (copy)
	local v7 = if not p1 then t1 else Cryo.Dictionary.join(t1, p1)

	return Rodux.Store.new(function() -- line: 17
		-- upvalues: v7 (copy)
		return v7
	end, v7, { Rodux.thunkMiddleware })
end

return createStoryStore
