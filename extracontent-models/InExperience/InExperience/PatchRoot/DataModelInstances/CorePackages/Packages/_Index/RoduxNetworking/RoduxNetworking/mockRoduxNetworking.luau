local makeActionCreator = require(script.Parent.makeActionCreator)

local function makeMockRequestObject(p1) -- line: 3
	-- upvalues: makeActionCreator (copy)
	local v4 = makeActionCreator(p1)

	local function v5() -- line: 5
	end

	function v4.API() -- line: 6
		-- upvalues: v4 (copy)
		return v4.Succeeded()
	end

	v4.Mock = {
		reply = v5,
		clear = v5,
		replyWithError = v5
	}

	return v4
end

return function() -- line: 19
	-- upvalues: makeMockRequestObject (copy)
	return {
		GET = makeMockRequestObject,
		POST = makeMockRequestObject,
		PATCH = makeMockRequestObject,
		DELETE = makeMockRequestObject
	}
end
