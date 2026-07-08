local function rine(p1) -- line: 3
	return p1 and (#p1 > 0 and p1)
end
local function rit(p2) -- line: 6
	return type(p2) == "table" and p2
end
local function dont_crash() -- line: 10
	if math.random() <= 0.004 then
		wait()
	end

	return true
end
local function v4() -- line: 18
end

local _tostring = tostring
local char = string.char
local t1 = {}
local v8 = t1.silent and v4 or function(p3, p4, ...) -- line: 26
	-- upvalues: t1 (copy)
	if p3 == "i" then
	end

	local v18 = (" [%s] "):format(p3:upper())

	print("[HTMLParser]" .. v18 .. p4:format(...) .. (t1.nonl or "\n"))
end
local v9 = t1.noerr and v4 or function(p5, ...) -- line: 32
	-- upvalues: v8 (copy)
	v8("e", p5, ...)
end

if not t1.noout or not v4 then
end

local v10 = t1.debug and function(p6, ...) -- line: 41
	-- upvalues: v8 (copy), v4 (copy), _tostring (copy)
	v8("d", p6:gsub("#LINE#", (_tostring(v4(3)))), ...)
end or v4
local ElementNode = require(script.ElementNode)
local voidelements = require(script.voidelements)

return {
	parse = function(p7, p8, p9) -- line: 53
		-- upvalues: t1 (copy), _tostring (copy), char (copy), v10 (copy), v9 (copy), ElementNode (copy), voidelements (copy)
		local v25 = t1
		local v26 = v25 and (#v25 > 0 and v25) or ({} or {})

		v26.looplimit = v26.looplimit or 100000000

		local v27 = _tostring(p7)
		local v28 = p8 or (v26.looplimit or 100000000)
		local u29 = false

		if not v26.keep_comments then
			v27 = v27:gsub("<!%-%-.-%-%->", "")
		end

		local t2 = {}

		if not v26.keep_danger_placeholders then
			local t3 = {}
			local n1 = 0

			repeat
				local v33 = char(n1)

				if not v27:match(v33) then
					if t2["<"] and t2[">"] then
						v10("[FindPH]:#LINE# Done!", n1)

						break
					end

					if not t3[n1] then
						if not t2["<"] then
							t2["<"] = v33
						elseif not t2[">"] then
							t2[">"] = v33
						end

						t3[n1] = true
						v10("c:{%s}||cc:{%d}||tpr[c]:{%s}", _tostring(c), v33:byte(), (_tostring(t2[c])))
						v10("busy[i]:{%s},i:{%d}", _tostring(t3[n1]), n1)
						v10("[FindPH]:#LINE# Success! || i=%d", n1)
					else
						v10("[FindPH]:#LINE# Busy! || i=%d", n1)
					end

					v10("c:{%s}||cc:{%d}||tpr[c]:{%s}", c, v33:byte(), (_tostring(t2[c])))
					v10("%s", (_tostring(t3[n1])))
				else
					v10("[FindPH]:#LINE# Text contains this byte! || i=%d", n1)
				end

				local n2 = 1

				if n1 == 31 then
					n2 = 96
				end

				n1 += n2
			until n1 == 255

			if not t2["<"] or not t2[">"] then
				v9("Impossible to find at least two unused byte codes in this HTML-code. We need it to escape bracket-contained placeholders inside tags.")
				v9("Consider enabling 'keep_danger_placeholders' option (to silence this error, if parser wasn't failed with current HTML-code) or manually replace few random bytes, to free up the codes.")
			else
				v10("[FindPH]:#LINE# Found! || '<'=%d, '>'=%d", t2["<"]:byte(), t2[">"]:byte())
			end

			local function g(p10, ...) -- line: 124
				-- upvalues: t2 (copy), u29 (ref), v10 (copy), _tostring (copy)
				local t4 = { ... }
				local v70 = t4[p10]

				t4[p10] = t4[p10]:gsub("(.)", t2)

				if v70 ~= t4[p10] then
					u29 = true
					v10("[g]:#LINE# orig: %s", (_tostring(v70)))
					v10("[g]:#LINE# replaced: %s", (_tostring(t4[p10])))
				end

				v10("[g]:#LINE# called, id: %s, arg[id]: %s, args { " .. ("{%s}, "):rep(#t4):gsub(", $", "") .. " }", p10, t4[p10], ...)
				v10("[g]:#LINE# concat(arg): %s", table.concat(t4))

				return table.concat(t4)
			end

			v27 = v27:gsub("(=[%s]-)(%b'')", function(...) -- line: 144
				-- upvalues: g (copy)
				return g(2, ...)
			end):gsub("(=[%s]-)(%b\"\")", function(...) -- line: 146
				-- upvalues: g (copy)
				return g(2, ...)
			end):gsub("(<" .. (v26.tpl_skip_pattern or "[^!]") .. ")([^>]+)" .. "(>)", function(...) -- line: 150
				-- upvalues: g (copy)
				return g(2, ...)
			end):gsub("(" .. (t2["<"] or "__FAILED__") .. ")(" .. (v26.tpl_marker_pattern or "[^%w%s]") .. ")([%g%s]-)" .. "(%2)(>)" .. "([^>]*>)", function(...) -- line: 156
				-- upvalues: g (copy)
				return g(5, ...)
			end)
		end

		local n3 = 0
		local v37 = ElementNode:new(n3, (_tostring(v27)))

		v37.page_url = p9

		local v38 = v37
		local v39 = true
		local n4 = 1
		local t5 = {}

		while true do
			if math.random() <= 0.004 then
				wait()
			end

			if not true then
				break
			end

			if n3 == v28 then
				v9("Main loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors", v28)

				break
			end

			local start, v43

			start, n4, v43 = v37._text:find("<([%w-]+)[^>]*>", n4)
			v10("[MainLoop]:#LINE# openstart=%s || tpos=%s || name=%s", _tostring(start), _tostring(n4), (_tostring(v43)))

			if not v43 then
				break
			end

			n3 += 1

			local v44 = ElementNode:new(n3, _tostring(v43), v38 or {}, v39, start, n4)

			v44.page_url = p9
			v38 = v44

			local v45 = nil
			local v46 = v44:gettext()
			local n5 = 1

			while true do
				if math.random() <= 0.004 then
					wait()
				end

				if not true then
					break
				end

				if v45 == v28 then
					v9("Tag parsing loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors", v28)

					break
				end

				local v48 = nil
				local start2, v50, v51, v52, v53, v54

				start2, n5, v50, v51, v52, v53, v54 = v46:find("%s+([^%s=/>]+)([%s]-)(=?)([%s]-)(['\"]?)", n5)
				v10("[TagLoop]:#LINE# start=%s || apos=%s || k=%s || zsp='%s' || eq='%s', quote=[%s]", _tostring(start2), _tostring(n5), _tostring(v50), _tostring(v53), _tostring(v52), (_tostring(v54)))

				if not v50 or v50 == "/>" or v50 == ">" then
					break
				end

				if v52 == "=" then
					local s1 = "=([^%s>]*)"

					if v54 ~= "" then
						s1 = v54 .. "([^" .. v54 .. "]*)" .. v54
					end

					local start3

					start3, n5, v48 = v46:find(s1, n5)
					v10("[TagLoop]:#LINE# start=%s || apos=%s || v=%s || pattern=%s", _tostring(start3), _tostring(n5), _tostring(v48), (_tostring(s1)))
				end

				local v57 = v48 or ""

				if u29 then
					for k, v in pairs(t2) do
						v57 = v57:gsub(v, k)
						v10("[TagLoop]:#LINE# rv=%s || rk=%s", _tostring(v), (_tostring(k)))
					end
				end

				v10("[TagLoop]:#LINE# k=%s || v=%s", _tostring(v50), (_tostring(v57)))
				v44:addattribute(v50, v57)
				v45 = (v45 or 0) + 1
			end

			if voidelements[v44.name:lower()] then
				v39 = false
				v44:close()
			else
				t5[v44.name] = t5[v44.name] or {}
				table.insert(t5[v44.name], v44)
			end

			local v60 = n4
			local v61 = nil

			while true do
				if math.random() <= 0.004 then
					wait()
				end

				if not true then
					break
				end

				if v61 == v28 then
					v9("Tag closing loop reached loop limit (%d). Consider either increasing it or checking HTML-code for syntax errors", v28)

					break
				end

				local start4, v63, v64

				start4, v60, v63, v64 = v37._text:find("[^<]*<(/?)([%w-]+)", v60)
				v10("[TagCloseLoop]:#LINE# closestart=%s || closeend=%s || closing=%s || closename=%s", _tostring(start4), _tostring(v60), _tostring(v63), (_tostring(v64)))

				if not v63 or v63 == "" then
					break
				end

				v44 = table.remove(t5[v64] or {}) or v44

				local v65 = v37._text:find("<", start4)

				v10("[TagCloseLoop]:#LINE# closestart=%s", (_tostring(v65)))
				v44:close(v65, v60 + 1)
				v38 = v44.parent
				v39 = true
				v61 = (v61 or 0) + 1
			end
		end

		if u29 then
			v10("tpl")

			for k, v in pairs(t2) do
				v37._text = v37._text:gsub(v, k)
			end
		end

		return v37
	end
}
