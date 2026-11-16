local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local Error = LuauPolyfill.Error
local inspect = LuauPolyfill.util.inspect

local ReactFeatureFlags = require(script.Parent.ReactFeatureFlags)
local filterInternalStackFrames = ReactFeatureFlags.filterInternalStackFrames

local v = {
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

local v2 = nil

local function getReactPackagePrefixes()
	if _G.ENVIRONMENT == "PRODUCTION" then
		return {}
	end

	if v2 then
		return v2
	end

	local result = {}

	for _, childName in v do
		local child = parent.Parent:FindFirstChild(childName)

		if child then
			table.insert(result, (child:GetFullName():gsub("^game%.", "")))
		end
	end

	v2 = result
	return result
end

local function isInternalFrame(value: string): boolean
	local reactPackagePrefixes = getReactPackagePrefixes()

	for _, reactPackagePrefix in reactPackagePrefixes do
		if string.sub(value, 1, #reactPackagePrefix) == reactPackagePrefix then
			return true
		end
	end

	return false
end

local function buildStackString(p: number)
	local v3 = false
	local v4 = false
	local v5 = ""

	for i = p + 1, 1e999 do
		local v6, v7, v8 = debug.info(i, "sln")

		if not v6 then
			break
		end

		if v6 == "[C]" then
			continue
		end

		if not v3 then
			local reactPackagePrefixes = getReactPackagePrefixes()
			local flag = true
			local v9

			for _, reactPackagePrefix in reactPackagePrefixes do
				if string.sub(v6, 1, #reactPackagePrefix) == reactPackagePrefix then
					v9 = true
					flag = false
					break
				end
			end

			if flag then
				v9 = false
			end

			v4 = not v9
			v3 = true
		end

		if v4 then
			local reactPackagePrefixes = getReactPackagePrefixes()
			local flag = true
			local flag2

			for _, reactPackagePrefix in reactPackagePrefixes do
				if string.sub(v6, 1, #reactPackagePrefix) == reactPackagePrefix then
					flag2 = true
					flag = false
					break
				end
			end

			if flag then
				flag2 = false
			end

			if flag2 then
				continue
			end
		end

		v5 ..= `{v6}:{v7} function {v8 or "?"}\n`
	end

	return (string.gsub(v5, "\n$", ""))
end

local Roblox = {}

function Roblox.describeError(value)
	if typeof(value) ~= "string" then
		return value
	end

	local _, v3 = string.find(value, ":[%d]+: ")

	if v3 then
		value = string.sub(value, v3 + 1)
	end

	local err = LuauPolyfill.Error.new(value)

	if filterInternalStackFrames then
		err.stack = buildStackString(2)
		return err
	end

	err.stack = debug.traceback(nil, 2)

	return err
end

function Roblox.errorToString(p)
	if typeof(p) ~= "table" then
		return (inspect(p))
	end

	if p.message and p.stack then
		return "\n------ Error caught by React ------\n" .. p.message .. "\n------ Error caught by React ------\n" .. tostring(p.stack)
	end

	return (inspect(p))
end

function Roblox.parseReactError(value: string)
	local v3 = string.split(value, "\n------ Error caught by React ------\n")

	if #v3 == 3 then
		local v4, v5, stack = table.unpack(v3)

		local v6 = Error.new(v5)
		v6.stack = stack

		return v6, v4
	else
		local v4 = Error.new(value)
		v4.stack = nil

		return v4, ""
	end
end

Roblox.__ERROR_DIVIDER = "\n------ Error caught by React ------\n"
return Roblox
