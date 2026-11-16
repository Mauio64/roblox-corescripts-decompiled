local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

require(script.Parent.ReactElementType)

require(script.Parent["flowtypes.roblox"])

local ReactSymbols = require(script.Parent.ReactSymbols)
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = ReactSymbols.REACT_SUSPENSE_LIST_TYPE
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_BLOCK_TYPE = ReactSymbols.REACT_BLOCK_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE

local ConsolePatchingDevroblox = require(script.Parent["ConsolePatchingDev.roblox"])
local disableLogs = ConsolePatchingDevroblox.disableLogs
local reenableLogs = ConsolePatchingDevroblox.reenableLogs

local ReactSharedInternals = require(script.Parent.ReactSharedInternals)
local ReactCurrentDispatcher = ReactSharedInternals.ReactCurrentDispatcher

local describeComponentFrame

local function describeOwner(value)
	if type(value) == "function" then
		return debug.info(value, "n")
	end

	if type(value) == "table" then
		return (tostring(value))
	end

	return nil
end

local function describeBuiltInComponentFrame(p: string, p2, value)
	local v

	if ReactGlobals.__DEV__ and value then
		if type(value) == "function" then
			v = debug.info(value, "n")
		elseif type(value) == "table" then
			v = tostring(value)
		end
	end

	return describeComponentFrame(p, p2, v)
end

local v = false
local v2

if ReactGlobals.__DEV__ then
	v2 = setmetatable({}, { __mode = "k" })
else
	v2 = nil
end

local function describeNativeComponentFrame(callback, flag: boolean)
	if not callback or v then
		return ""
	end

	if ReactGlobals.__DEV__ then
		local v3 = v2[callback]

		if v3 ~= nil then
			return v3
		end
	end

	local v3 = nil
	v = true
	local current

	if ReactGlobals.__DEV__ then
		current = ReactCurrentDispatcher.current

		ReactCurrentDispatcher.current = nil
		disableLogs()
	end

	local traceback = nil
	local _, result = xpcall(function()
		if flag then
			return
		end

		local _, result = pcall(function()
			traceback = debug.traceback()
			error({ stack = traceback })
		end)
		v3 = result

		callback()
	end, function(message)
		return { message = message, stack = traceback }
	end)

	local v4 = nil

	if result and v3 and type(result.stack) == "string" then
		local v5 = string.split(result.stack, "\n")
		local v6 = string.split(v3.stack, "\n")

		local v7 = #v5 - 1
		local v8 = #v6 - 1

		while v7 >= 2 and v8 >= 0 and v5[v7] ~= v6[v8] do
			v8 -= 1
		end

		while v7 >= 3 and v8 >= 1 do
			v7 -= 1
			v8 -= 1

			if v5[v7] ~= v6[v8] then
				if v7 == 1 and v8 == 1 then
					break
				end

				repeat
					v7 -= 1
					v8 -= 1

					if v8 < 0 or v5[v7] ~= v6[v8] then
						v4 = "\n" .. "    in " .. v5[v7]

						if ReactGlobals.__DEV__ then
							v2[callback] = v4
						end
					end
				until not (v7 >= 3 and v8 >= 1)

				break
			end
		end
	end

	v = false

	if ReactGlobals.__DEV__ then
		ReactCurrentDispatcher.current = current
		reenableLogs()
	end

	if v4 ~= nil then
		return v4
	end

	local v5

	if type(callback) == "function" then
		v5 = debug.info(callback, "n")
	else
		v5 = type(callback) ~= "table" and "" or tostring(callback)
	end

	local v6

	if v5 == nil or v5 == "" then
		v6 = ""
	else
		local ___DEV__ = ReactGlobals.__DEV__

		v6 = describeComponentFrame(v5, nil, nil)
	end

	if ReactGlobals.__DEV__ then
		v2[callback] = v6
	end

	return v6
end

describeComponentFrame = function(value: string?, p, p2: string?)
	local v3 = ""

	if ReactGlobals.__DEV__ and p then
		local fileName = p.fileName
		local v4 = string.gsub(fileName, "^(.*)[\\/]", "")

		if string.match(v4, "^init%.") then
			local v5 = string.match(fileName, "^(.*)[\\/]")

			if v5 and #v5 ~= 0 then
				v4 = string.gsub(v5, "^(.*)[\\/]", "") .. "/" .. v4
			end
		end

		v3 = " (at " .. v4 .. ":" .. p.lineNumber .. ")"
	elseif p2 then
		v3 = " (created by " .. p2 .. ")"
	end

	return "\n    in " .. (value or "Unknown") .. v3
end

local function describeClassComponentFrame(value, p, value2)
	local v3 = tostring(value)
	local v4

	if ReactGlobals.__DEV__ and value2 then
		if type(value2) == "function" then
			v4 = debug.info(value2, "n")
		elseif type(value2) == "table" then
			v4 = tostring(value2)
		end
	end

	return describeComponentFrame(v3, p, v4)
end

local function describeFunctionComponentFrame(callback, p, value)
	if not callback then
		return ""
	end

	local v3

	if type(callback) == "function" then
		v3 = debug.info(callback, "n")
	else
		v3 = tostring(callback)
	end

	local v4

	if ReactGlobals.__DEV__ and value then
		if type(value) == "function" then
			v4 = debug.info(value, "n")
		elseif type(value) == "table" then
			v4 = tostring(value)
		end
	end

	return describeComponentFrame(v3, p, v4)
end

local function describeUnknownElementTypeFrameInDEV(value, p, p2)
	if not (ReactGlobals.__DEV__ and value ~= nil) then
		return ""
	end

	if type(value) == "table" and type(value.__ctor) == "function" then
		return describeClassComponentFrame(value, p, p2)
	end

	if type(value) == "function" then
		return describeFunctionComponentFrame(value, p, p2)
	end

	if type(value) == "string" then
		return describeBuiltInComponentFrame(value, p, p2)
	end

	if value == REACT_SUSPENSE_TYPE then
		return describeBuiltInComponentFrame("Suspense", p, p2)
	end

	if value == REACT_SUSPENSE_LIST_TYPE then
		return describeBuiltInComponentFrame("SuspenseList", p, p2)
	end

	if type(value) ~= "table" then
		return ""
	end

	local Typeof = value["$$typeof"]

	if Typeof == REACT_FORWARD_REF_TYPE then
		return describeFunctionComponentFrame(value.render, p, p2)
	end

	if Typeof == REACT_MEMO_TYPE then
		return describeUnknownElementTypeFrameInDEV(value.type, p, p2)
	end

	if Typeof == REACT_BLOCK_TYPE then
		return describeFunctionComponentFrame(value._render, p, p2)
	end

	if Typeof ~= REACT_LAZY_TYPE then
		return ""
	end

	local payload = value._payload
	local init = value._init

	local success, result = pcall(function()
		describeUnknownElementTypeFrameInDEV(init(payload), p, p2)
	end)
	return if success then result else ""
end

return {
	describeComponentFrame = describeComponentFrame,
	describeBuiltInComponentFrame = describeBuiltInComponentFrame,
	describeNativeComponentFrame = describeNativeComponentFrame,
	describeClassComponentFrame = describeClassComponentFrame,
	describeFunctionComponentFrame = describeFunctionComponentFrame,
	describeUnknownElementTypeFrameInDEV = describeUnknownElementTypeFrameInDEV
}
