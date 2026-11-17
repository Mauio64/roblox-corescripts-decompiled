local function rine(list) -- 1 equivalent call inferred from this helper
	if list and not (#list > 0) then
		list = false
	end

	return list
end

local function rit(p)
	if type(p) ~= "table" then
		p = false
	end

	return p
end

local function dont_crash(): boolean -- 3 equivalent calls inferred from this helper
	if math.random() <= 0.004 then
		wait()
	end

	return true
end

local function fn() end

local tostring = tostring
local char = string.char
local v = {}

local v2 = v.silent and fn or function(value, value2, ...)
	local formatted = (" [%s] "):format(value:upper())
	print("[HTMLParser]" .. formatted .. value2:format(...) .. (v.nonl or "\n"))
end

local v3 = v.noerr and fn or function(p, ...)
	v2("e", p, ...)
end

local _ = v.noout and fn

local fn2 = v.debug and (function(value, ...)
	v2("d", value:gsub("#LINE#", (tostring(fn(3)))), ...)
end or fn) or fn

local ElementNode = require(script.ElementNode)
local voidelements = require(script.voidelements)

return {
	parse = function(p, p2, page_url)
		local v4 = rine(v) or {} -- inferred equivalent call

		v4.looplimit = v4.looplimit or 100000000

		local v5 = tostring(p)
		local v6 = p2 or v4.looplimit or 100000000
		local flag = false

		if not v4.keep_comments then
			v5 = v5:gsub("<!%-%-.-%-%->", "")
		end

		local v7 = {}

		if not v4.keep_danger_placeholders then
			local total = 0
			local set = {}

			repeat
				local v8 = char(total)

				if v5:match(v8) then
					fn2("[FindPH]:#LINE# Text contains this byte! || i=%d", total)
				else
					if v7["<"] and v7[">"] then
						fn2("[FindPH]:#LINE# Done!", total)
						break
					end

					if set[total] then
						fn2("[FindPH]:#LINE# Busy! || i=%d", total)
					else
						if v7["<"] then
							if not v7[">"] then
								v7[">"] = v8
							end
						else
							v7["<"] = v8
						end

						set[total] = true
						local c2 = c
						fn2("c:{%s}||cc:{%d}||tpr[c]:{%s}", tostring(c2), v8:byte(), (tostring(v7[c])))
						fn2("busy[i]:{%s},i:{%d}", tostring(set[total]), total)
						fn2("[FindPH]:#LINE# Success! || i=%d", total)
					end

					local c2 = c
					fn2("c:{%s}||cc:{%d}||tpr[c]:{%s}", c2, v8:byte(), (tostring(v7[c])))
					fn2("%s", (tostring(set[total])))
				end

				total += total == 31 and 96 or 1
			until total == 255

			if v7["<"] and v7[">"] then
				fn2("[FindPH]:#LINE# Found! || '<'=%d, '>'=%d", v7["<"]:byte(), v7[">"]:byte())
			else
				v3("Impossible to find at least two unused byte codes in this HTML-code. We need it to escape bracket-contained placeholders inside tags.")

				v3("Consider enabling 'keep_danger_placeholders' option (to silence this error, if parser wasn't failed with current HTML-code) or manually replace few random bytes, to free up the codes.")
			end

			local function g(p3, ...)
				local v8 = { ... }
				local v9 = v8[p3]
				v8[p3] = v8[p3]:gsub("(.)", v7)

				if v8[p3] ~= v9 then
					flag = true
					fn2("[g]:#LINE# orig: %s", (tostring(v9)))
					fn2("[g]:#LINE# replaced: %s", (tostring(v8[p3])))
				end

				fn2(
					"[g]:#LINE# called, id: %s, arg[id]: %s, args { " .. ("{%s}, "):rep(#v8):gsub(", $", "") .. " }",
					p3,
					v8[p3],
					...
				)

				fn2("[g]:#LINE# concat(arg): %s", table.concat(v8))
				return table.concat(v8)
			end

			v5 = v5:gsub("(=[%s]-)(%b'')", function(...)
				return g(2, ...)
			end):gsub("(=[%s]-)(%b\"\")", function(...)
				return g(2, ...)
			end):gsub("(<" .. (v4.tpl_skip_pattern or "[^!]") .. ")([^>]+)(>)", function(...)
				return g(2, ...)
			end):gsub("(" .. (v7["<"] or "__FAILED__") .. ")(" .. (v4.tpl_marker_pattern or "[^%w%s]") .. ")([%g%s]-)(%2)(>)([^>]*>)", function(...)
				return g(5, ...)
			end)
		end

		local count = 0
		local result = ElementNode:new(count, (tostring(v5)))
		result.page_url = page_url
		local v8 = result
		local v9 = 1
		local v10 = true
		local v11 = {}

		while dont_crash() do -- inferred equivalent call
			if count == v6 then
				v3(
					"Main loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors",
					v6
				)
				break
			end

			local v12, v13
			v12, v9, v13 = result._text:find("<([%w-]+)[^>]*>", v9)

			fn2("[MainLoop]:#LINE# openstart=%s || tpos=%s || name=%s", tostring(v12), tostring(v9), (tostring(v13)))

			if not v13 then
				break
			end

			count += 1
			local v14 = ElementNode:new(count, tostring(v13), v8 or {}, v10, v12, v9)

			v14.page_url = page_url

			local gettext = v14:gettext()
			v8 = v14
			local v15 = nil
			local v16 = 1

			while dont_crash() do -- inferred equivalent call
				if v15 == v6 then
					v3(
						"Tag parsing loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors",
						v6
					)
					break
				end

				local v17 = nil
				local v18, v19, v20, v21, v22, v23
				v18, v16, v19, v20, v21, v22, v23 = gettext:find("%s+([^%s=/>]+)([%s]-)(=?)([%s]-)(['\"]?)", v16)

				fn2(
					"[TagLoop]:#LINE# start=%s || apos=%s || k=%s || zsp='%s' || eq='%s', quote=[%s]",
					tostring(v18),
					tostring(v16),
					tostring(v19),
					tostring(v22),
					tostring(v21),
					(tostring(v23))
				)

				if not v19 or v19 == "/>" or v19 == ">" then
					break
				end

				if v21 == "=" then
					local v24 = v23 == "" and "=([^%s>]*)" or v23 .. "([^" .. v23 .. "]*)" .. v23
					local v25
					v25, v16, v17 = gettext:find(v24, v16)
					fn2(
						"[TagLoop]:#LINE# start=%s || apos=%s || v=%s || pattern=%s",
						tostring(v25),
						tostring(v16),
						tostring(v17),
						(tostring(v24))
					)
				end

				local v24 = v17 or ""

				if flag then
					for k, v25 in pairs(v7) do
						v24 = v24:gsub(v25, k)
						fn2("[TagLoop]:#LINE# rv=%s || rk=%s", tostring(v25), (tostring(k)))
					end
				end

				fn2("[TagLoop]:#LINE# k=%s || v=%s", tostring(v19), (tostring(v24)))
				v14:addattribute(v19, v24)
				v15 = (v15 or 0) + 1
			end

			if voidelements[v14.name:lower()] then
				v14:close()
				v10 = false
			else
				v11[v14.name] = v11[v14.name] or {}
				table.insert(v11[v14.name], v14)
			end

			local v17 = v9
			local v18 = nil

			while dont_crash() do -- inferred equivalent call
				if v18 == v6 then
					v3(
						"Tag closing loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors",
						v6
					)
					break
				end

				local v19, v20, v21
				v19, v17, v20, v21 = result._text:find("[^<]*<(/?)([%w-]+)", v17)
				fn2(
					"[TagCloseLoop]:#LINE# closestart=%s || closeend=%s || closing=%s || closename=%s",
					tostring(v19),
					tostring(v17),
					tostring(v20),
					(tostring(v21))
				)

				if not v20 or v20 == "" then
					break
				end

				v14 = table.remove(v11[v21] or {}) or v14
				local v22 = result._text:find("<", v19)
				fn2("[TagCloseLoop]:#LINE# closestart=%s", (tostring(v22)))
				v14:close(v22, v17 + 1)
				v8 = v14.parent

				v18 = (v18 or 0) + 1
				v10 = true
			end
		end

		if flag then
			fn2("tpl")

			for k, v12 in pairs(v7) do
				result._text = result._text:gsub(v12, k)
			end
		end

		return result
	end
}
