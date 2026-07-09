local ParentParent = script.Parent.Parent
local Error = require(ParentParent.LuauPolyfill).Error
local Promise = require(ParentParent.Promise)
local Response = require(script.Parent.Response).Response
local Request = require(script.Parent.Request).Request

local function parseResponse(t1: {[any]: any}) -- line: 34
	-- upvalues: Response (copy)
	local Body = t1.Body

	return Response.new(Body, {
		status = t1.StatusCode,
		statusText = t1.StatusMessage,
		headers = t1.Headers
	})
end
local function buildFetch(p1) -- line: 44
	-- upvalues: Promise (copy), Request (copy), Error (copy), Response (copy)
	local function fetch(p2, p3) -- line: 45
		-- upvalues: Promise (copy), Request (copy), Error (copy), p1 (copy), Response (copy)
		return Promise.new(function(resolve, reject) -- line: 46
			-- upvalues: Request (copy), p2 (copy), p3 (copy), Error (copy), p1 (copy), Response (copy)
			local ok, result = pcall(function() -- line: 47
				-- upvalues: Request (copy), p2 (copy), p3 (copy)
				return Request.new(p2, p3)
			end)

			if not ok then
				reject(Error.new(result))

				return
			end

			p1:RequestInternal({
				Url = result.url,
				Method = result.method,
				Body = result.body,
				Headers = result.headers.headerList,
				CachePolicy = result.cache
			}):Start(function(p4, p5) -- line: 66
				-- upvalues: result (copy), reject (copy), Error (copy), Response (copy), resolve (copy)
				if not p4 then
					result.signal:fire()
					reject(Error.new(p5.ErrorMessage))

					return
				end

				local Body = p5.Body
				local v21 = Response.new(Body, {
					status = p5.StatusCode,
					statusText = p5.StatusMessage,
					headers = p5.Headers
				})

				resolve(v21)
			end)
		end)
	end

	return fetch
end

return buildFetch
