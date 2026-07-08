local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)

require(script.Parent.ReactElementType)
require(script.Parent["flowtypes.roblox"])

local ReactSymbols = require(script.Parent.ReactSymbols)
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = ReactSymbols.REACT_SUSPENSE_LIST_TYPE
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_BLOCK_TYPE = ReactSymbols.REACT_BLOCK_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local lib = require(script.Parent["ConsolePatchingDev.roblox"])
local disableLogs = lib.disableLogs
local reenableLogs = lib.reenableLogs
local ReactCurrentDispatcher = require(script.Parent.ReactSharedInternals).ReactCurrentDispatcher
local describeComponentFrame = nil

local function describeOwner(p1) -- line: 60
	if type(p1) == "function" then
		return debug.info(p1, "n")
	end

	if type(p1) == "table" then
		return (tostring(p1))
	end

	return nil
end
local function describeBuiltInComponentFrame(s1: string, p2, p3) -- line: 69
	-- upvalues: ReactGlobals (copy), describeComponentFrame (ref)
	local v26 = nil

	if ReactGlobals.__DEV__ and p3 then
		v26 = if type(p3) ~= "function" then if type(p3) ~= "table" then nil else tostring(p3) else debug.info(p3, "n")
	end

	return describeComponentFrame(s1, p2, v26)
end

local u17 = false
local self = nil

if ReactGlobals.__DEV__ then
	self = setmetatable({}, {
		__mode = "k"
	})
end

function describeComponentFrame(s2: string?, p4, s3: string?) -- line: 286
	-- upvalues: ReactGlobals (copy)
	local s4 = ""

	if ReactGlobals.__DEV__ and p4 then
		local fileName = p4.fileName
		local v49 = string.gsub(fileName, "^(.*)[\\/]", "")

		if string.match(v49, "^init%.") then
			local match = string.match(fileName, "^(.*)[\\/]")

			if match and #match ~= 0 then
				v49 = string.gsub(match, "^(.*)[\\/]", "") .. "/" .. v49
			end
		end

		s4 = " (at " .. v49 .. ":" .. p4.lineNumber .. ")"
	elseif s3 then
		s4 = " (created by " .. s3 .. ")"
	end

	return "\n    in " .. (s2 or "Unknown") .. s4
end

local function describeClassComponentFrame(p5, p6, p7) -- line: 319
	-- upvalues: ReactGlobals (copy), describeComponentFrame (ref)
	local str = tostring(p5)
	local v55 = nil

	if ReactGlobals.__DEV__ and p7 then
		v55 = if type(p7) ~= "function" then if type(p7) ~= "table" then nil else tostring(p7) else debug.info(p7, "n")
	end

	return describeComponentFrame(str, p6, v55)
end
local function describeFunctionComponentFrame(p8: ((...any) -> ...any)?, p9, p10) -- line: 343
	-- upvalues: ReactGlobals (copy), describeComponentFrame (ref)
	if not p8 then
		return ""
	end

	local v59 = if type(p8) ~= "function" then tostring(p8) else debug.info(p8, "n")
	local v60 = nil

	if ReactGlobals.__DEV__ and p10 then
		v60 = if type(p10) ~= "function" then if type(p10) ~= "table" then nil else tostring(p10) else debug.info(p10, "n")
	end

	return describeComponentFrame(v59, p9, v60)
end
local function describeUnknownElementTypeFrameInDEV(p11, p12, p13) -- line: 390
	-- upvalues: ReactGlobals (copy), describeClassComponentFrame (copy), describeFunctionComponentFrame (ref), describeBuiltInComponentFrame (copy), REACT_SUSPENSE_TYPE (copy), REACT_SUSPENSE_LIST_TYPE (copy), REACT_FORWARD_REF_TYPE (copy), REACT_MEMO_TYPE (copy), describeUnknownElementTypeFrameInDEV (copy), REACT_BLOCK_TYPE (copy), REACT_LAZY_TYPE (copy)
	if not ReactGlobals.__DEV__ then
		return ""
	end

	if p11 == nil then
		return ""
	end

	if type(p11) == "table" and type(p11.__ctor) == "function" then
		return describeClassComponentFrame(p11, p12, p13)
	end

	if type(p11) == "function" then
		return describeFunctionComponentFrame(p11, p12, p13)
	end

	if type(p11) == "string" then
		return describeBuiltInComponentFrame(p11, p12, p13)
	end

	if p11 == REACT_SUSPENSE_TYPE then
		return describeBuiltInComponentFrame("Suspense", p12, p13)
	end

	if p11 == REACT_SUSPENSE_LIST_TYPE then
		return describeBuiltInComponentFrame("SuspenseList", p12, p13)
	end

	if type(p11) == "table" then
		local v64 = p11["$$typeof"]

		if v64 == REACT_FORWARD_REF_TYPE then
			return describeFunctionComponentFrame(p11.render, p12, p13)
		end

		if v64 == REACT_MEMO_TYPE then
			return describeUnknownElementTypeFrameInDEV(p11.type, p12, p13)
		end

		if v64 == REACT_BLOCK_TYPE then
			return describeFunctionComponentFrame(p11._render, p12, p13)
		end

		if v64 == REACT_LAZY_TYPE then
			local _payload = p11._payload
			local _init = p11._init
			local ok, result = pcall(function() -- line: 449
				-- upvalues: describeUnknownElementTypeFrameInDEV (copy), _init (copy), _payload (copy), p12 (copy), p13 (copy)
				describeUnknownElementTypeFrameInDEV(_init(_payload), p12, p13)
			end)

			if ok then
				return result
			end
		end
	end

	return ""
end

return {
	describeComponentFrame = describeComponentFrame,
	describeBuiltInComponentFrame = describeBuiltInComponentFrame,
	describeNativeComponentFrame = function(p14, b1: boolean) -- line: 116
		-- upvalues: u17 (ref), ReactGlobals (copy), self (ref), ReactCurrentDispatcher (copy), disableLogs (copy), reenableLogs (copy), describeComponentFrame (ref)
		if not p14 or u17 then
			return ""
		end

		local g40 = nil

		if ReactGlobals.__DEV__ then
			local v29 = self[p14]

			if v29 ~= nil then
				return v29
			end
		end

		local u30 = nil

		u17 = true

		local current = nil

		if ReactGlobals.__DEV__ then
			current = ReactCurrentDispatcher.current
			ReactCurrentDispatcher.current = nil
			disableLogs()
		end

		local trace = nil
		local _, result = xpcall(function() -- line: 156
			-- upvalues: b1 (copy), trace (ref), u30 (ref), p14 (copy)
			if b1 then
				return
			end

			local _, result = pcall(function() -- line: 162
				-- upvalues: trace (ref)
				trace = debug.traceback()
				error({
					stack = trace
				})
			end)

			u30 = result
			p14()
		end, function(err) -- line: 172
			-- upvalues: trace (ref)
			return {
				message = err,
				stack = trace
			}
		end)
		local v35 = nil

		if result and u30 and type(result.stack) == "string" then
			local parts = string.split(result.stack, "\n")
			local parts2 = string.split(u30.stack, "\n")
			local v38 = #parts - 1
			local v39 = #parts2 - 1

			while v38 >= 2 and v39 >= 0 and parts[v38] ~= parts2[v39] do
				v39 -= 1
			end

			repeat
				if not (v38 >= 3) or not (v39 >= 1) then
					g40 = true
				end

				if g40 then
					break
				end

				v38 -= 1
				v39 -= 1
			until parts[v38] ~= parts2[v39]

			if not g40 then
				if v38 ~= 1 or v39 ~= 1 then
					repeat
						v38 -= 1
						v39 -= 1

						if v39 < 0 or parts[v38] ~= parts2[v39] then
							v35 = "\n" .. "    in " .. parts[v38]

							if ReactGlobals.__DEV__ then
								self[p14] = v35
							end
						end
					until not (v38 >= 3) or not (v39 >= 1)
				end
			end
		end

		g40 = false
		u17 = false

		if ReactGlobals.__DEV__ then
			ReactCurrentDispatcher.current = current
			reenableLogs()
		end

		if v35 ~= nil then
			return v35
		end

		local v41 = if type(p14) ~= "function" then type(p14) ~= "table" and "" or tostring(p14) else debug.info(p14, "n")
		local s5 = ""

		if v41 ~= nil and v41 ~= "" then
			local _ = ReactGlobals.__DEV__

			s5 = describeComponentFrame(v41, nil, nil)
		end

		if ReactGlobals.__DEV__ then
			self[p14] = s5
		end

		return s5
	end,
	describeClassComponentFrame = describeClassComponentFrame,
	describeFunctionComponentFrame = describeFunctionComponentFrame,
	describeUnknownElementTypeFrameInDEV = describeUnknownElementTypeFrameInDEV
}
