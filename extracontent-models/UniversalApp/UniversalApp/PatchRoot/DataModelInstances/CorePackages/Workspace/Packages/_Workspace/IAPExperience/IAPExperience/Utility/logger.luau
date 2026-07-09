local ParentParent = script.Parent.Parent.Parent
local Logger = require(ParentParent.Loggers).Logger
local HttpService = game:GetService("HttpService")

local function attachPackageName(t1: {[any]: any}) -- line: 9
	if not t1 then
		t1 = {}
	end

	t1.packageName = "IAPExperience"

	return t1
end

return {
	debug = function(t2: {[any]: any}) -- line: 17
		-- upvalues: Logger (copy), HttpService (copy)
		local v7 = Logger
		local v8 = HttpService
		local v9 = t2 or {}

		v9.packageName = "IAPExperience"
		v7:debug(v8:JSONEncode(v9))
	end,
	info = function(t3: {[any]: any}) -- line: 20
		-- upvalues: Logger (copy), HttpService (copy)
		local v11 = Logger
		local v12 = HttpService
		local v13 = t3 or {}

		v13.packageName = "IAPExperience"
		v11:info(v12:JSONEncode(v13))
	end,
	warn = function(t4: {[any]: any}) -- line: 23
		-- upvalues: Logger (copy), HttpService (copy)
		local v15 = Logger
		local v16 = HttpService
		local v17 = t4 or {}

		v17.packageName = "IAPExperience"
		v15:warn(v16:JSONEncode(v17))
	end,
	error = function(t5: {[any]: any}) -- line: 26
		-- upvalues: Logger (copy), HttpService (copy)
		local v19 = Logger
		local v20 = HttpService
		local v21 = t5 or {}

		v21.packageName = "IAPExperience"
		v19:error(v20:JSONEncode(v21))
	end
}
