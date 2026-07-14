local Parent = script:FindFirstAncestor("DataHydration").Parent
local createEffect = require(Parent.Signals).createEffect

require(script.Parent.types)

local t1 = {}

local function onTerminal(p1, p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)?) -- line: 26
	-- upvalues: t1 (copy), createEffect (copy)
	local t2 = {}
	local u9 = false
	local u10 = false

	local function cleanupEffect() -- line: 35
		-- upvalues: u10 (ref), t1 (copy), t2 (copy)
		if u10 then
			return
		end

		u10 = true

		local v16 = t1[t2]

		t1[t2] = nil

		if v16 ~= nil then
			v16()
		end
	end
	local function settle(p4) -- line: 47
		-- upvalues: u9 (ref), u10 (ref), t1 (copy), t2 (copy), p2 (copy), p3 (copy)
		if u9 then
			return
		end

		u9 = true

		if not u10 then
			u10 = true

			local v18 = t1[t2]

			t1[t2] = nil

			if v18 ~= nil then
				v18()
			end
		end

		if p4.status == "succeeded" and p2 then
			p2(p4.result)

			return
		end

		if p4.status == "failed" and p3 then
			p3(p4.error or "request failed", p4.errorCode)
		end
	end

	local v13 = p1(false)

	if v13.status ~= "pending" then
		if not u9 then
			u9 = true

			if not u10 then
				u10 = true

				local v14 = t1[t2]

				t1[t2] = nil

				if v14 ~= nil then
					v14()
				end
			end

			if v13.status == "succeeded" and p2 then
				p2(v13.result)
			elseif v13.status == "failed" and p3 then
				p3(v13.error or "request failed", v13.errorCode)
			end
		end

		return
	end

	local v15 = createEffect(function(p5) -- line: 68
		-- upvalues: p1 (copy), u9 (ref), u10 (ref), t1 (copy), t2 (copy), p2 (copy), p3 (copy)
		local v20 = p1(p5)

		if v20.status == "pending" then
			return
		end

		if u9 then
			return
		end

		u9 = true

		if not u10 then
			u10 = true

			local v21 = t1[t2]

			t1[t2] = nil

			if v21 ~= nil then
				v21()
			end
		end

		if v20.status == "succeeded" and p2 then
			p2(v20.result)

			return
		end

		if v20.status == "failed" and p3 then
			p3(v20.error or "request failed", v20.errorCode)
		end
	end)

	if u10 then
		v15()
	else
		t1[t2] = v15
	end
end

return onTerminal
