local parent = script:FindFirstAncestor("GenericChallenges").Parent

local Promise = require(parent.Promise)
require(parent.HttpClient)
local IsChallengeHttpResponse = require(script.Parent.IsChallengeHttpResponse)
local InterceptChallenge = require(script.Parent.InterceptChallenge)

return function(p, p2)
	local v = p2 or InterceptChallenge
	return {
		request = function(p3, callback)
			local flag = false
			local flag2 = false
			local v2 = nil

			local function settle(flag3: boolean, p4)
				if flag or flag2 then
					return
				end

				flag2 = true
				callback(flag3, p4)
			end

			local function retryWithChallengeHeaders(items)
				if flag then
					return Promise.reject()
				end

				return Promise.new(function(callback2)
					local headers = not p3.headers and {} or table.clone(p3.headers)

					for k, item in items do
						headers[k] = item
					end

					local clone = table.clone(p3)
					clone.headers = headers
					v2 = p.request(clone, function(success, response)
						callback2({ success = success, response = response })
					end)
				end)
			end

			v2 = p.request(p3, function(p4, p5)
				v2 = nil

				if flag then
					return
				end

				if p4 then
					local headers = p5.headers

					if headers and IsChallengeHttpResponse(p5.statusCode, headers) then
						local success, result = pcall(v, {
							rawResponseHeaders = headers,
							retryRequestCallback = retryWithChallengeHeaders
						})

						if success then
							result:andThen(function(p6)
								local success2 = p6.success
								local response = p6.response

								if not flag then
									if flag2 then
										return
									end

									flag2 = true
									callback(success2, response)
								end
							end):catch(function()
								if not flag then
									if flag2 then
										return
									end

									flag2 = true
									callback(p4, p5)
								end
							end)
							return
						end

						if flag or flag2 then
							return
						end

						flag2 = true
						callback(p4, p5)

						return
					end
				end

				if not flag then
					if flag2 then
						return
					end

					flag2 = true
					callback(p4, p5)
				end
			end)

			return function()
				flag = true

				if v2 ~= nil then
					v2()
					v2 = nil
				end
			end
		end
	}
end
