local Parent = script:FindFirstAncestor("HttpClient").Parent
local Promise = require(Parent.Promise)
local Signals = require(Parent.Signals)

require(script.Parent.types)

local t1 = {}

local function asPromise(p1) -- line: 15
	-- upvalues: Promise (copy), t1 (copy), Signals (copy)
	local t2 = {}

	return Promise.new(function(resolve, reject, onCancel) -- line: 17
		-- upvalues: t1 (copy), t2 (copy), p1 (copy), Signals (copy)
		local u11 = false
		local u12 = false

		local function cleanupEffect() -- line: 21
			-- upvalues: u12 (ref), t1 (copy), t2 (copy)
			if u12 then
				return
			end

			u12 = true

			local v17 = t1[t2]

			t1[t2] = nil

			if v17 ~= nil then
				v17()
			end
		end
		local function settle(p2) -- line: 33
			-- upvalues: u11 (ref), u12 (ref), t1 (copy), t2 (copy), resolve (copy), reject (copy)
			if u11 then
				return
			end

			u11 = true

			if not u12 then
				u12 = true

				local v19 = t1[t2]

				t1[t2] = nil

				if v19 ~= nil then
					v19()
				end
			end

			if p2.status == "succeeded" then
				resolve(p2.result)

				return
			end

			reject({
				responseCode = p2.errorCode,
				errorMessage = p2.error
			})
		end

		local v15 = p1.state(false)

		if v15.status ~= "pending" then
			settle(v15)

			return
		end

		local v16 = Signals.createEffect(function(p3) -- line: 54
			-- upvalues: p1 (copy), settle (copy)
			local v21 = p1.state(p3)

			if v21.status == "pending" then
				return
			end

			settle(v21)
		end)

		if u12 then
			v16()
		else
			t1[t2] = v16
		end

		onCancel(function() -- line: 67
			-- upvalues: u11 (ref), u12 (ref), t1 (copy), t2 (copy)
			if u11 then
				return
			end

			u11 = true

			if u12 then
				return
			end

			u12 = true

			local v22 = t1[t2]

			t1[t2] = nil

			if v22 ~= nil then
				v22()
			end
		end)
	end)
end

return asPromise
