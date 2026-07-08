local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Error = LuauPolyfill.Error
local inspect = LuauPolyfill.util.inspect
local filterInternalStackFrames = require(script.Parent.ReactFeatureFlags).filterInternalStackFrames
local t1 = {
	"React",
	"ReactDevtoolsShared",
	"ReactNoopRenderer",
	"ReactReconciler",
	"ReactRefresh",
	"ReactRoblox",
	"RoactCompat",
	"Scheduler",
	"Shared"
}
local u7 = nil

local function getReactPackagePrefixes() -- line: 52
	-- upvalues: u7 (ref), t1 (copy), ParentParent (copy)
	if u7 then
		return u7
	end

	local t2 = {}

	for _, v13 in t1 do
		local v14 = ParentParent.Parent:FindFirstChild(v13)

		if v14 then
			table.insert(t2, (v14:GetFullName():gsub("^game%.", "")))
		end
	end

	u7 = t2

	return t2
end
local function isInternalFrame(s1: string) -- line: 79
	-- upvalues: getReactPackagePrefixes (copy)
	for _, v17 in (getReactPackagePrefixes()) do
		if v17 == string.sub(s1, 1, #v17) then
			return true
		end
	end

	return false
end
local function buildStackString(n1: number) -- line: 98
	-- upvalues: getReactPackagePrefixes (copy)
	local s2 = ""
	local v20 = false
	local v21 = false
	local g29 = nil
	local v28 = nil
	local g33 = nil
	local v32 = nil

	for i = n1 + 1, 1e999 do
		local v23, v24, v25 = debug.info(i, "sln")

		if not v23 then
			return (string.gsub(s2, "\n$", ""))
		end

		if v23 == "[C]" then
			continue
		end

		if not v20 then
			for _, v27 in (getReactPackagePrefixes()) do
				if v27 == string.sub(v23, 1, #v27) then
					v28 = true
					g29 = true
				end

				if g29 then
					break
				end
			end

			if not g29 then
				v28 = false
			end

			g29 = false
			v21 = not v28
			v20 = true
		end

		if v21 then
			for _, v31 in (getReactPackagePrefixes()) do
				if v31 == string.sub(v23, 1, #v31) then
					v32 = true
					g33 = true
				end

				if g33 then
					break
				end
			end

			if not g33 then
				v32 = false
			end

			g33 = false

			if v32 then
				continue
			end
		end

		s2 ..= ("%*:%* function %*\n"):format(v23, v24, v25 or "?")
	end

	return (string.gsub(s2, "\n$", ""))
end

return {
	__ERROR_DIVIDER = "\n------ Error caught by React ------\n",
	describeError = function(p1) -- line: 141
		-- upvalues: LuauPolyfill (copy), filterInternalStackFrames (copy), buildStackString (copy)
		if typeof(p1) == "string" then
			local _, stop = string.find(p1, ":[%d]+: ")
			local v37 = if not stop then p1 else string.sub(p1, stop + 1)
			local v38 = LuauPolyfill.Error.new(v37)

			if filterInternalStackFrames then
				v38.stack = buildStackString(2)

				return v38
			end

			v38.stack = debug.traceback(nil, 2)

			return v38
		end

		return p1
	end,
	errorToString = function(p2) -- line: 165
		-- upvalues: inspect (copy)
		if typeof(p2) == "table" then
			if p2.message and p2.stack then
				return "\n------ Error caught by React ------\n" .. p2.message .. "\n------ Error caught by React ------\n" .. tostring(p2.stack)
			end

			return (inspect(p2))
		end

		return (inspect(p2))
	end,
	parseReactError = function(s3: string) -- line: 191
		-- upvalues: Error (copy)
		local parts = string.split(s3, "\n------ Error caught by React ------\n")

		if #parts == 3 then
			local v42, v43, v44 = table.unpack(parts)
			local v45 = Error.new(v43)

			v45.stack = v44

			return v45, v42
		end

		local v46 = Error.new(s3)

		v46.stack = nil

		return v46, ""
	end
}
