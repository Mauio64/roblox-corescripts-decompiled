local createFaeFeatureAccessStore = require(script.createFaeFeatureAccessStore)
local useFaeFeatureAccess = require(script.useFaeFeatureAccess)
local v3 = createFaeFeatureAccessStore()

return {
	getFaeFeatureAccessStore = function() -- line: 7
		-- upvalues: v3 (copy)
		return v3
	end,
	useFaeFeatureAccess = function() -- line: 10
		-- upvalues: useFaeFeatureAccess (copy), v3 (copy)
		return useFaeFeatureAccess(v3)
	end
}
