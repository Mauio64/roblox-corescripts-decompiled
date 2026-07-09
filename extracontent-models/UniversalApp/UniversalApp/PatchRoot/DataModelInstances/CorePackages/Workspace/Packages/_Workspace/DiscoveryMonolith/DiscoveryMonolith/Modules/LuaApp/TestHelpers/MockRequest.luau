local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local t = require(DiscoveryMonolithParent.t)
local ArgCheck = require(DiscoveryMonolithParent.ArgCheck)
local Promise = require(DiscoveryMonolithParent.Promise)
local StatusCodes = require(DiscoveryMonolithParent.Http).StatusCodes
local Modules = DiscoveryMonolith.Modules
local HttpError = require(Modules.LuaApp.Http.HttpError)
local HttpResponse = require(Modules.LuaApp.Http.HttpResponse)
local t1 = {
	simpleSuccessRequest = function(p1) -- line: 19
		-- upvalues: Promise (copy), HttpResponse (copy), StatusCodes (copy)
		assert(p1 ~= nil, "Expected responseBody not to be nil")

		return function(p2, _, _) -- line: 23
			-- upvalues: Promise (copy), HttpResponse (copy), p1 (copy), StatusCodes (copy)
			return Promise.resolve(HttpResponse.new(p2, p1, 0, StatusCodes.OK))
		end
	end,
	simpleOngoingRequest = function() -- line: 28
		-- upvalues: Promise (copy)
		return function(_, _, _) -- line: 30
			-- upvalues: Promise (copy)
			return Promise.new(function(_, _) -- line: 31
			end)
		end
	end,
	simpleFailRequest = function(s1: string, s2: string?, n1: number?) -- line: 37
		-- upvalues: Promise (copy), HttpError (copy)
		assert(s1 ~= nil, "Expected errKind not to be nil")

		if s2 == nil then
			s2 = "Fake request failed"
		end

		assert(s2, "Cannot be nil")

		return function(p10, _, _) -- line: 44
			-- upvalues: Promise (copy), HttpError (copy), s1 (copy), s2 (ref), n1 (copy)
			return Promise.reject(HttpError.new(p10, s1, s2, n1))
		end
	end
}

function t1.failThenSuccessRequests(p13, s3: string, n2: number?, s4: string?, n3: number?) -- line: 49
	-- upvalues: t1 (copy)
	local u25 = n2 or 1
	local n4 = 0

	return function(p14, p15, p16) -- line: 61
		-- upvalues: n4 (ref), u25 (ref), t1 (copy), s3 (copy), s4 (copy), n3 (copy), p13 (copy)
		if n4 < u25 then
			n4 += 1

			return t1.simpleFailRequest(s3, s4, n3)(p14, p15, p16)
		end

		return t1.simpleSuccessRequest(p13)(p14, p15, p16)
	end
end

local v11 = t.interface({
	url = t.string,
	usePatterns = t.optional(t.boolean),
	request = t.callback
})
local v12 = t.tuple(t.array(v11), t.string)

local function _getRequestCallbackForUrl(p17, p18) -- line: 89
	-- upvalues: ArgCheck (copy), v12 (copy)
	ArgCheck.assert(v12(p17, p18))

	for _, v in ipairs(p17) do
		if if not v.usePatterns then p18:find(v.url, nil, true) else p18:match(v.url) then
			return v.request
		end
	end

	return nil
end

local v14 = t.array(v11)

function t1.mockEndpoints(p19) -- line: 132
	-- upvalues: ArgCheck (copy), v14 (copy), _getRequestCallbackForUrl (copy)
	ArgCheck.assert(v14(p19))

	return function(p20, p21, p22) -- line: 135
		-- upvalues: _getRequestCallbackForUrl (copy), p19 (copy)
		local v47 = _getRequestCallbackForUrl(p19, p20)

		assert(v47, ("Url %q needs a request associated with it. (mockEndpoints requires all APIs to be mocked)"):format(p20))

		return v47(p20, p21, p22)
	end
end

return t1
