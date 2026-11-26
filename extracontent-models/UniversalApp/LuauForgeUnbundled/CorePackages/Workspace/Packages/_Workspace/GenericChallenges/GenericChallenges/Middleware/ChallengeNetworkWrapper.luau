local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/HttpClient")
local IsChallengeHttpResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/IsChallengeHttpResponse")
local InterceptChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/InterceptChallenge")

return function(p2, p3)
	local v5 = p3 or InterceptChallenge
	return {
		request = function(p4, callback)
			local flag = false
			local flag2 = false
			local v6 = nil

			local function settle(p5, p6)
				if flag or flag2 then
					return
				end

				flag2 = true
				callback(p5, p6)
			end

			local function retryWithChallengeHeaders(items)
				if flag then
					return Promise.reject()
				end

				return Promise.new(function(callback2)
					local v7 = not p4.headers and {} or table.clone(p4.headers)

					for k, item in items do
						v7[k] = item
					end

					local clone = table.clone(p4)
					clone.headers = v7
					v6 = p2.request(clone, function(p5, p6)
						callback2({ success = p5, response = p6 })
					end)
				end)
			end

			v6 = p2.request(p4, function(p5, p6)
				v6 = nil

				if flag then
					return
				end

				if p5 then
					local headers = p6.headers

					if headers and IsChallengeHttpResponse(p6.statusCode, headers) then
						local success, result = pcall(v5, {
							rawResponseHeaders = headers,
							retryRequestCallback = retryWithChallengeHeaders
						})

						if success then
							result:andThen(function(p7)
								local success2 = p7.success
								local response = p7.response

								if not flag then
									if flag2 then
										return
									end

									flag2 = true
									callback(success2, response)
								end
							end):catch(function()
								local v7 = p5
								local v8 = p6

								if not flag then
									if flag2 then
										return
									end

									flag2 = true
									callback(v7, v8)
								end
							end)
							return
						end

						if flag or flag2 then
							return
						end

						flag2 = true
						callback(p5, p6)

						return
					end
				end

				if not flag then
					if flag2 then
						return
					end

					flag2 = true
					callback(p5, p6)
				end
			end)

			return function()
				flag = true

				if v6 ~= nil then
					v6()
					v6 = nil
				end
			end
		end
	}
end
