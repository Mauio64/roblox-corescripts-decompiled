local parent = script.Parent
local makeActionCreator = require(parent.makeActionCreator)
local RequestBuilder = require(parent.RequestBuilder)
local NetworkStatus = require(parent.NetworkStatus)
local Promise = require(parent.Promise)
require(parent.Types)

return function(data, p)
	local networkStatus = NetworkStatus({
		keyPath = data.keyPath,
		killRequestWithFilteredIds = data.killRequestWithFilteredIds
	})

	return function(p2, callback)
		local actionCreator = makeActionCreator(p2)
		local fn = nil

		local function fn2(callback2, data2)
			if data2.mockNetworkImpl then
				error("Request already mocked - you may need to call `Mock.clear` between tests/uses")
			end

			if type(callback2) ~= "function" and type(callback2) ~= data2.defaultType then
				error(data2.argumentName .. " must be a " .. data2.defaultType .. " or function")
			end

			fn = function(...)
				local v = type(callback2) == "function" and callback2(...) or callback2

				return Promise[data2.defaultResolveMethod](v)
			end
		end

		return {
			Mock = {
				reply = function(p3)
					return fn2(p3, {
						defaultResolveMethod = "resolve",
						argumentName = "mockResponse",
						defaultType = "table",
						mockNetworkImpl = fn
					})
				end,
				replyWithError = function(p3)
					return fn2(p3, {
						defaultResolveMethod = "reject",
						argumentName = "mockError",
						defaultType = "string",
						mockNetworkImpl = fn
					})
				end,
				clear = function()
					fn = nil
				end
			},
			getStatus = function(p3, p4)
				local v = callback(function(p5: string, p6)
					return RequestBuilder.new(p5, p6)
				end, p4):makeKeyMapper()(p4)

				return networkStatus.getStatus(p3, v)
			end,
			API = function(p3, ...)
				local v = callback(function(p4: string, p5)
					return RequestBuilder.new(p4, p5)
				end, p3, ...)

				return function(p4)
					return networkStatus.setStatus(p4, v:getIds(), v:makeKeyMapper(), function(object, p5)
						local v2 = fn or data.networkImpl
						local options = v:makeOptions()
						local namedIds = v:getNamedIds()

						return v2(v:makeUrl(p5), p, options):andThen(function(p6)
							object:dispatch(actionCreator.Succeeded(
								p5,
								p6.responseBody,
								namedIds,
								options,
								v:getAdditionalData()
							))
							return p6
						end, function(p6)
							object:dispatch(actionCreator.Failed(p5, p6, namedIds, options, v:getAdditionalData()))

							return Promise.reject(p6)
						end)
					end)
				end
			end,
			Succeeded = actionCreator.Succeeded,
			Failed = actionCreator.Failed
		}
	end
end
