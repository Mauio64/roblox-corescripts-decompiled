local t1 = {}
local Language = require(script.Language)
local keyword = Language.keyword
local builtin = Language.builtin
local libraries = Language.libraries

t1.language = Language

local t2 = {}
local t3 = {}

for v8, v9 in {
	{
		"^[%c%s]*[%a_][%w_]*[%c%s]*",
		"var"
	},
	{
		"^[%c%s]*0[xX][%da-fA-F_]+[%c%s]*",
		"number"
	},
	{
		"^[%c%s]*0[bB][01_]+[%c%s]*",
		"number"
	},
	{
		"^[%c%s]*%d+%.?%d*[eE][%+%-]?%d+[%c%s]*",
		"number"
	},
	{
		"^[%c%s]*%d+[%._]?[%d_eE]*[%c%s]*",
		"number"
	},
	{
		"^[%c%s]*(['\"])%1[%c%s]*",
		"string"
	},
	{
		"^[%c%s]*(['\"])[^\n]-([^\\]%1)[%c%s]*",
		"string"
	},
	{
		"^[%c%s]*(['\"]).-\n[%c%s]*",
		"string"
	},
	{
		"^[%c%s]*(['\"])[^\n]*[%c%s]*",
		"string"
	},
	{
		"^[%c%s]*%[(=*)%[.-%]%1%][%c%s]*",
		"string"
	},
	{
		"^[%c%s]*%[=*%[.-.*[%c%s]*",
		"string"
	},
	{
		"^[%c%s]*`[^\n]-`[%c%s]*",
		"string_inter"
	},
	{
		"^[%c%s]*%-%-%[(=*)%[.-%]%1%][%c%s]*",
		"comment"
	},
	{
		"^[%c%s]*%-%-%[=*%[.-.*[%c%s]*",
		"comment"
	},
	{
		"^[%c%s]*%-%-.-\n[%c%s]*",
		"comment"
	},
	{
		"^[%c%s]*%-%-.*[%c%s]*",
		"comment"
	},
	{
		"^[%c%s]*[:;<>/~%*%(%)%-={},%.#%^%+%%]+[%c%s]*",
		"operator"
	},
	{
		"^[%c%s]*[%[%]]+[%c%s]*",
		"operator"
	},
	{
		"^[%c%s]*[%z\001-\127\194-\244][\128-\191]+[%c%s]*",
		"iden"
	},
	{
		"^.",
		"iden"
	}
} do
	t2[v8] = v9[1]
	t3[v8] = v9[2]
end

function t1.scan(s1: string) -- line: 105
	-- upvalues: t2 (copy), t3 (copy), keyword (copy), builtin (copy), libraries (copy), t1 (copy)
	local n1 = 1
	local v12 = #s1
	local s2 = ""
	local s3 = ""
	local s4 = ""
	local s5 = ""
	local co = coroutine.create(function() -- line: 110
		-- upvalues: n1 (ref), v12 (copy), t2 (copy), s1 (copy), t3 (copy), keyword (copy), builtin (copy), s2 (ref), s5 (ref), s3 (ref), libraries (copy), s4 (ref), t1 (copy)
		local g29 = nil

		repeat
			if not (n1 <= v12) then
				return
			end

			local v19 = false

			for i, v in ipairs(t2) do
				local start, stop = string.find(s1, v, n1)

				if start ~= nil then
					n1 = stop + 1
					v19 = true

					local v24 = string.sub(s1, start, stop)
					local v25 = t3[i]
					local v26 = v25

					if v25 == "var" then
						local v27 = string.gsub(v24, "[%c%s]+", "")

						if keyword[v27] then
							v26 = "keyword"
						elseif builtin[v27] then
							v26 = "builtin"
						elseif string.find(s2, "%.[%s%c]*$") and s5 ~= "comment" then
							local v28 = libraries[string.gsub(s3, "[%c%s]+", "")]

							v26 = (not v28 or (not v28[v27] or string.find(s4, "%.[%s%c]*$"))) and "iden" or "builtin"
						else
							v26 = "iden"
						end

						g29 = true
					end

					if not g29 then
						if v25 == "string_inter" then
							if not string.find(v24, "[^\\]{") then
								v26 = "string"
								g29 = true
							end

							if not g29 then
								v26 = nil

								local v30 = true
								local n2 = 1
								local v32 = #v24

								while true do
									if not (n2 <= v32) then
										g29 = true
									end

									if g29 then
										break
									end

									local start2, stop2 = string.find(v24, "^.-[^\\][{}]", n2)

									if start2 == nil then
										break
									end

									if v30 then
										n2 = stop2 + 1
										coroutine.yield("string", (string.sub(v24, start2, stop2)))
										v30 = false
									else
										n2 = stop2

										local v35 = string.sub(v24, start2, stop2 - 1)

										for v36, v37 in t1.scan(v35) do
											coroutine.yield(v36, v37)
										end

										v30 = true
									end
								end

								if not g29 then
									coroutine.yield("string", (string.sub(v24, n2)))
								end
							end
						end
					end

					g29 = false
					s4 = s3
					s3 = s2
					s2 = v24
					s5 = v26 or v25

					if not v26 then
						break
					end

					coroutine.yield(v26, v24)

					break
				end
			end
		until not v19
	end)

	return function() -- line: 218
		-- upvalues: co (copy)
		if coroutine.status(co) == "dead" then
			return
		end

		local ok, result, v40 = coroutine.resume(co)

		if ok and result then
			return result, v40
		end
	end
end
function t1.navigator() -- line: 232
	-- upvalues: t1 (copy)
	local t4 = {
		Source = "",
		_RealIndex = 0,
		_UserIndex = 0,
		_ScanThread = nil,
		TokenCache = table.create(50),
		Destroy = function(p1) -- line: 242
			p1.Source = nil
			p1._RealIndex = nil
			p1._UserIndex = nil
			p1.TokenCache = nil
			p1._ScanThread = nil
		end,
		SetSource = function(p2, p3) -- line: 250
			-- upvalues: t1 (copy)
			p2.Source = p3
			p2._RealIndex = 0
			p2._UserIndex = 0
			table.clear(p2.TokenCache)
			p2._ScanThread = coroutine.create(function() -- line: 257
				-- upvalues: t1 (copy), p2 (copy)
				for v54, v55 in t1.scan(p2.Source) do
					local v56 = p2

					v56._RealIndex = v56._RealIndex + 1
					p2.TokenCache[p2._RealIndex] = {
						v54,
						v55
					}
					coroutine.yield(v54, v55)
				end
			end)
		end
	}

	function t4.Next() -- line: 266
		-- upvalues: t4 (copy)
		local v44 = t4

		v44._UserIndex = v44._UserIndex + 1

		if t4._RealIndex >= t4._UserIndex then
			return table.unpack(t4.TokenCache[t4._UserIndex])
		end

		if coroutine.status(t4._ScanThread) == "dead" then
			return
		end

		local ok, result, v47 = coroutine.resume(t4._ScanThread)

		if ok and result then
			return result, v47
		end
	end
	function t4.Peek(p4) -- line: 289
		-- upvalues: t4 (copy)
		local v49 = t4._UserIndex + p4

		if v49 <= t4._RealIndex then
			if v49 > 0 then
				return table.unpack(t4.TokenCache[v49])
			end

			return
		end

		if coroutine.status(t4._ScanThread) == "dead" then
			return
		end

		local result = nil
		local v51 = nil

		for _ = 1, v49 - t4._RealIndex do
			local ok

			ok, result, v51 = coroutine.resume(t4._ScanThread)

			if not ok and not result then
				return result, v51
			end
		end

		return result, v51
	end

	return t4
end

return t1
