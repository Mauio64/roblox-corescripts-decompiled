local Parent = script:FindFirstAncestor("DataHydration").Parent

require(Parent.HttpClient)

local function getCsrfToken(p1) -- line: 14
	local headers = p1.headers

	if headers == nil then
		return nil
	end

	for v7, v8 in headers do
		if string.lower((tostring(v7))) == "x-csrf-token" then
			return v8
		end
	end

	return nil
end
local function mergeHeaders(t1: {[any]: any}?, t2: {[any]: any}) -- line: 27
	local t3 = {}

	if t1 then
		for v12, v13 in t1 do
			t3[v12] = v13
		end
	end

	for v14, v15 in t2 do
		t3[v14] = v15
	end

	return t3
end
local function withCsrfRetry(p2) -- line: 40
	-- upvalues: getCsrfToken (copy)
	return {
		request = function(p3, p4: ((...any) -> ...any)) -- line: 41
			-- upvalues: p2 (copy), getCsrfToken (copy)
			local u19 = false
			local u20 = nil

			u20 = p2.request(p3, function(p5, p6) -- line: 48
				-- upvalues: u19 (ref), p4 (copy), getCsrfToken (copy), p3 (copy), u20 (ref), p2 (copy)
				if u19 then
					return
				end

				if not p5 or typeof(p6) ~= "table" then
					p4(p5, p6)

					return
				end

				if p6.statusCode ~= 403 then
					p4(true, p6)

					return
				end

				local v23 = getCsrfToken(p6)

				if v23 == nil then
					p4(true, p6)

					return
				end

				local t4 = {
					url = p3.url,
					method = p3.method,
					body = p3.body
				}
				local headers = p3.headers
				local t5 = {
					["x-csrf-token"] = v23
				}
				local t6 = {}

				if headers then
					for v28, v29 in headers do
						t6[v28] = v29
					end
				end

				for v30, v31 in t5 do
					t6[v30] = v31
				end

				t4.headers = t6
				u20 = p2.request(t4, function(p7, p8) -- line: 73
					-- upvalues: u19 (ref), p4 (copy)
					if u19 then
						return
					end

					p4(p7, p8)
				end)
			end)

			return function() -- line: 81
				-- upvalues: u19 (ref), u20 (ref)
				if u19 then
					return
				end

				u19 = true

				if u20 then
					u20()
				end
			end
		end
	}
end

return withCsrfRetry
