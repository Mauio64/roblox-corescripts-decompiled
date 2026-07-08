local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local Promise = require(Parent.Promise)

return {
	networkError = function(s1: string, p1) -- line: 21
		return {
			kind = "Network",
			message = s1,
			cause = p1
		}
	end,
	parseError = function(s2: string, p2) -- line: 30
		return {
			kind = "Parse",
			message = s2,
			cause = p2
		}
	end,
	schemaError = function(s3: string, p3) -- line: 38
		return {
			kind = "Schema",
			message = s3,
			cause = p3
		}
	end,
	engineError = function(s4: string, p4) -- line: 42
		return {
			kind = "Engine",
			message = s4,
			cause = p4
		}
	end,
	rejectNetwork = function(s5: string, p5) -- line: 49
		-- upvalues: Promise (copy)
		return Promise.reject({
			kind = "Network",
			message = s5,
			cause = p5
		})
	end,
	rejectParse = function(s6: string, p6) -- line: 53
		-- upvalues: Promise (copy)
		return Promise.reject({
			kind = "Parse",
			message = s6,
			cause = p6
		})
	end,
	rejectSchema = function(s7: string, p7) -- line: 57
		-- upvalues: Promise (copy)
		return Promise.reject({
			kind = "Schema",
			message = s7,
			cause = p7
		})
	end,
	rejectEngine = function(s8: string, p8) -- line: 61
		-- upvalues: Promise (copy)
		return Promise.reject({
			kind = "Engine",
			message = s8,
			cause = p8
		})
	end
}
