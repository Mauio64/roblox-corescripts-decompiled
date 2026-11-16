local Lexer = {}

local Language = require(script.Language)
local keyword = Language.keyword
local builtin = Language.builtin
local libraries = Language.libraries

Lexer.language = Language

local v = {}
local v2 = {}

for k, v3 in {
	{ "^[%c%s]*[%a_][%w_]*[%c%s]*", "var" },
	{ "^[%c%s]*0[xX][%da-fA-F_]+[%c%s]*", "number" },
	{ "^[%c%s]*0[bB][01_]+[%c%s]*", "number" },
	{ "^[%c%s]*%d+%.?%d*[eE][%+%-]?%d+[%c%s]*", "number" },
	{ "^[%c%s]*%d+[%._]?[%d_eE]*[%c%s]*", "number" },
	{ "^[%c%s]*(['\"])%1[%c%s]*", "string" },
	{ "^[%c%s]*(['\"])[^\n]-([^\\]%1)[%c%s]*", "string" },
	{ "^[%c%s]*(['\"]).-\n[%c%s]*", "string" },
	{ "^[%c%s]*(['\"])[^\n]*[%c%s]*", "string" },
	{ "^[%c%s]*%[(=*)%[.-%]%1%][%c%s]*", "string" },
	{ "^[%c%s]*%[=*%[.-.*[%c%s]*", "string" },
	{ "^[%c%s]*`[^\n]-`[%c%s]*", "string_inter" },
	{ "^[%c%s]*%-%-%[(=*)%[.-%]%1%][%c%s]*", "comment" },
	{ "^[%c%s]*%-%-%[=*%[.-.*[%c%s]*", "comment" },
	{ "^[%c%s]*%-%-.-\n[%c%s]*", "comment" },
	{ "^[%c%s]*%-%-.*[%c%s]*", "comment" },
	{ "^[%c%s]*[:;<>/~%*%(%)%-={},%.#%^%+%%]+[%c%s]*", "operator" },
	{ "^[%c%s]*[%[%]]+[%c%s]*", "operator" },
	{ "^[%c%s]*[%z\1-\127\194-\244][\128-\191]+[%c%s]*", "iden" },
	{ "^.", "iden" }
} do
	v[k] = v3[1]
	v2[k] = v3[2]
end

function Lexer.scan(value: string)
	local v3 = 1
	local count = #value
	local v4 = ""
	local v5 = ""
	local v6 = ""
	local v7 = ""

	local thread = coroutine.create(function()
		while v3 <= count do
			local v8 = false

			for i, v9 in ipairs(v) do
				local v10, v11 = string.find(value, v9, v3)

				if v10 ~= nil then
					v3 = v11 + 1
					v8 = true

					local v12 = string.sub(value, v10, v11)
					local v13 = v2[i]
					local v14

					if v13 == "var" then
						local v15 = string.gsub(v12, "[%c%s]+", "")

						if keyword[v15] then
							v14 = "keyword"
						elseif builtin[v15] then
							v14 = "builtin"
						elseif string.find(v4, "%.[%s%c]*$") and v7 ~= "comment" then
							local library = libraries[string.gsub(v5, "[%c%s]+", "")]

							if library and library[v15] and not string.find(v6, "%.[%s%c]*$") then
								v14 = "builtin"
							else
								v14 = "iden"
							end
						else
							v14 = "iden"
						end
					elseif v13 == "string_inter" then
						if string.find(v12, "[^\\]{") then
							local v15 = #v12
							local v16 = 1
							local flag = true

							while v16 <= v15 do
								local v17, v18 = string.find(v12, "^.-[^\\][{}]", v16)

								if v17 == nil then
									coroutine.yield("string", (string.sub(v12, v16)))
									break
								end

								if flag then
									v16 = v18 + 1
									coroutine.yield("string", (string.sub(v12, v17, v18)))
									flag = false
								else
									local v19 = string.sub(v12, v17, v18 - 1)
									v16 = v18

									for k, v20 in Lexer.scan(v19) do
										coroutine.yield(k, v20)
									end

									flag = true
								end
							end
						else
							v14 = "string"
						end
					else
						v14 = v13
					end

					v6 = v5
					v5 = v4
					v4 = v12
					v7 = v14 or v13

					if v14 then
						coroutine.yield(v14, v12)
					end

					break
				end
			end

			if not v8 then
				break
			end
		end
	end)

	return function()
		if coroutine.status(thread) == "dead" then
			return
		end

		local v8, v9, v10 = coroutine.resume(thread)

		if v8 and v9 then
			return v9, v10
		end
	end
end

function Lexer.navigator()
	local v3 = {
		Source = "",
		TokenCache = table.create(50),
		_RealIndex = 0,
		_UserIndex = 0,
		_ScanThread = nil
	}

	function v3:Destroy()
		self.Source = nil
		self._RealIndex = nil
		self._UserIndex = nil
		self.TokenCache = nil
		self._ScanThread = nil
	end

	function v3:SetSource(source)
		self.Source = source

		self._RealIndex = 0
		self._UserIndex = 0
		table.clear(self.TokenCache)

		self._ScanThread = coroutine.create(function()
			for k, v4 in Lexer.scan(self.Source) do
				self._RealIndex += 1
				self.TokenCache[self._RealIndex] = { k, v4 }
				coroutine.yield(k, v4)
			end
		end)
	end

	function v3.Next()
		v3._UserIndex += 1

		if v3._RealIndex >= v3._UserIndex then
			return table.unpack(v3.TokenCache[v3._UserIndex])
		end

		if coroutine.status(v3._ScanThread) == "dead" then
			return
		end

		local v4, v5, v6 = coroutine.resume(v3._ScanThread)

		if v4 and v5 then
			return v5, v6
		end
	end

	function v3.Peek(p)
		local v4 = v3._UserIndex + p

		if v4 <= v3._RealIndex then
			if v4 > 0 then
				return table.unpack(v3.TokenCache[v4])
			end
		else
			if coroutine.status(v3._ScanThread) == "dead" then
				return
			end

			local v5 = nil
			local v6 = nil

			for _ = 1, v4 - v3._RealIndex do
				local v7
				v7, v5, v6 = coroutine.resume(v3._ScanThread)

				if not (v7 or v5) then
					break
				end
			end

			return v5, v6
		end
	end

	return v3
end

return Lexer
