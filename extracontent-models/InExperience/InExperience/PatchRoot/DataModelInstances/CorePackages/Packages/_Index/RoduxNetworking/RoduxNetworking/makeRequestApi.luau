local scriptParent = script.Parent
local makeActionCreator = require(scriptParent.makeActionCreator)
local RequestBuilder = require(scriptParent.RequestBuilder)
local NetworkStatus = require(scriptParent.NetworkStatus)
local Promise = require(scriptParent.Promise)

require(scriptParent.Types)

return function(p1, p2) -- line: 12
	-- upvalues: NetworkStatus (copy), makeActionCreator (copy), Promise (copy), RequestBuilder (copy)
	local keyPath = p1.keyPath
	local killRequestWithFilteredIds = p1.killRequestWithFilteredIds
	local v10 = NetworkStatus({
		keyPath = keyPath,
		killRequestWithFilteredIds = killRequestWithFilteredIds
	})

	return function(p3, p4: ((...any) -> ...any)) -- line: 21
		-- upvalues: makeActionCreator (copy), Promise (copy), RequestBuilder (copy), v10 (copy), p1 (copy), p2 (copy)
		local v13 = makeActionCreator(p3)
		local u14 = nil

		local function v15(p5, t1: {[any]: any}) -- line: 25
			-- upvalues: u14 (ref), Promise (copy)
			if t1.mockNetworkImpl then
				error("Request already mocked - you may need to call `Mock.clear` between tests/uses")
			end

			if type(p5) ~= "function" and type(p5) ~= t1.defaultType then
				error(t1.argumentName .. " must be a " .. t1.defaultType .. " or function")
			end

			function u14(...) -- line: 39
				-- upvalues: p5 (copy), Promise (copy), t1 (copy)
				local v25 = type(p5) == "function" and p5(...) or p5

				return Promise[t1.defaultResolveMethod](v25)
			end
		end

		return {
			Mock = {
				reply = function(p6) -- line: 84
					-- upvalues: v15 (copy), u14 (ref)
					return v15(p6, {
						defaultResolveMethod = "resolve",
						argumentName = "mockResponse",
						defaultType = "table",
						mockNetworkImpl = u14
					})
				end,
				replyWithError = function(p7) -- line: 93
					-- upvalues: v15 (copy), u14 (ref)
					return v15(p7, {
						defaultResolveMethod = "reject",
						argumentName = "mockError",
						defaultType = "string",
						mockNetworkImpl = u14
					})
				end,
				clear = function() -- line: 102
					-- upvalues: u14 (ref)
					u14 = nil
				end
			},
			getStatus = function(p8, p9) -- line: 72
				-- upvalues: p4 (copy), RequestBuilder (copy), v10 (copy)
				local v22 = p4(function(s1: string, p10) -- line: 73
					-- upvalues: RequestBuilder (copy)
					return RequestBuilder.new(s1, p10)
				end, p9):makeKeyMapper()(p9)

				return v10.getStatus(p8, v22)
			end,
			API = function(p11, ...) -- line: 46
				-- upvalues: p4 (copy), RequestBuilder (copy), v10 (copy), u14 (ref), p1 (copy), p2 (copy), v13 (copy), Promise (copy)
				local v19 = p4(function(s2: string, p12) -- line: 47
					-- upvalues: RequestBuilder (copy)
					return RequestBuilder.new(s2, p12)
				end, p11, ...)

				return function(t2: {[any]: any}) -- line: 51
					-- upvalues: v10 (copy), v19 (copy), u14 (ref), p1 (copy), p2 (copy), v13 (copy), Promise (copy)
					return v10.setStatus(t2, v19:getIds(), v19:makeKeyMapper(), function(p13, p14) -- line: 52
						-- upvalues: u14 (ref), p1 (copy), v19 (copy), p2 (copy), v13 (copy), Promise (copy)
						local v33 = u14 or p1.networkImpl
						local v34 = v19:makeOptions()
						local v35 = v19:getNamedIds()

						return v33(v19:makeUrl(p14), p2, v34):andThen(function(p15) -- line: 58
							-- upvalues: p13 (copy), v13 (copy), p14 (copy), v35 (copy), v34 (copy), v19 (copy)
							p13:dispatch(v13.Succeeded(p14, p15.responseBody, v35, v34, v19:getAdditionalData()))

							return p15
						end, function(p16) -- line: 62
							-- upvalues: p13 (copy), v13 (copy), p14 (copy), v35 (copy), v34 (copy), v19 (copy), Promise (copy)
							p13:dispatch(v13.Failed(p14, p16, v35, v34, v19:getAdditionalData()))

							return Promise.reject(p16)
						end)
					end)
				end
			end,
			Succeeded = v13.Succeeded,
			Failed = v13.Failed
		}
	end
end
