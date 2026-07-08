local Parent = script:FindFirstAncestor("HttpClient").Parent
local Resources = require(Parent.Resources)
local Signals = require(Parent.Signals)

require(script.Parent.types)

local encoders = require(script.Parent.encoders)
local analytics = require(script.Parent.analytics)
local createSignal = Signals.createSignal
local createResource = Resources.createResource

local function safeDecode(p1, p2) -- line: 18
	local ok, result, v14, v15 = pcall(p1, p2)

	if not ok then
		return nil, `decode error: { tostring(result) }`, nil
	end

	return result, v14, v15
end
local function createRequest(p3) -- line: 26
	-- upvalues: analytics (copy), encoders (copy), createSignal (copy), createResource (copy)
	local v17 = p3.analytics or analytics.defaultAnalytics
	local v18 = p3.encode or encoders.encodeJson
	local v19, v20 = createSignal({
		status = "pending"
	})
	local t1 = {
		Accept = "application/json"
	}

	if p3.headers then
		for v22, v23 in p3.headers do
			t1[v22] = v23
		end
	end

	local u24 = nil

	if p3.body ~= nil then
		local v25, v26 = v18(p3.body)

		u24 = v25
		t1["Content-Type"] = t1["Content-Type"] or v26
	end

	local v27 = createResource(function(p4) -- line: 47
		-- upvalues: v20 (copy), v17 (copy), p3 (copy), t1 (copy), u24 (ref)
		local u29 = false
		local elapsed = os.clock()

		local function settleFailed(s1: string) -- line: 51
			-- upvalues: u29 (ref), elapsed (copy), v20 (copy), v17 (copy), p3 (copy)
			if u29 then
				return
			end

			u29 = true

			local v36 = (os.clock() - elapsed) * 1000

			v20({
				status = "failed",
				error = `transport error: { s1 }`
			})
			v17(p3.analyticsKey, p3.method, p3.url, nil, v36, "failed")
		end
		local function settleResponse(p5) -- line: 61
			-- upvalues: u29 (ref), elapsed (copy), p3 (copy), v20 (copy), v17 (copy)
			if u29 then
				return
			end

			u29 = true

			local v38 = (os.clock() - elapsed) * 1000

			if p3.statusCodeActions ~= nil then
				local v39 = p3.statusCodeActions[p5.statusCode]

				if v39 ~= nil then
					for _, v41 in v39 do
						local ok, result = pcall(v41, p5)

						if not ok then
							warn(`[HttpClient] { p3.analyticsKey } status code action threw: { tostring(result) }`)
						end
					end
				end
			end

			local decode = p3.decode
			local ok, result, v47, v48 = pcall(decode, p5)
			local v49

			if not ok then
				v49 = nil
				v47 = `decode error: { tostring(result) }`
				v48 = nil
			else
				v49 = result
			end

			local v50 = v47 == nil and "succeeded" or "failed"

			if v47 ~= nil then
				v20({
					status = "failed",
					error = v47,
					errorCode = v48
				})
			else
				v20({
					status = "succeeded",
					result = v49
				})
			end

			v17(p3.analyticsKey, p3.method, p3.url, p5, v38, v50)
		end

		local ok, result = pcall(function() -- line: 92
			-- upvalues: p3 (copy), t1 (copy), u24 (ref), settleResponse (copy), settleFailed (copy), p4 (copy), u29 (ref)
			local v51 = p3.networkImpl.request({
				url = p3.url,
				method = p3.method,
				headers = t1,
				body = u24
			}, function(p6, p7) -- line: 98
				-- upvalues: settleResponse (copy), settleFailed (copy)
				if p6 then
					settleResponse(p7)

					return
				end

				settleFailed((tostring(p7)))
			end)

			p4(function() -- line: 105
				-- upvalues: u29 (ref), v51 (copy)
				if u29 then
					return
				end

				u29 = true
				v51()
			end)
		end)

		if not ok then
			settleFailed((tostring(result)))
		end
	end)

	return {
		state = v19,
		dispose = v27
	}
end

return createRequest
