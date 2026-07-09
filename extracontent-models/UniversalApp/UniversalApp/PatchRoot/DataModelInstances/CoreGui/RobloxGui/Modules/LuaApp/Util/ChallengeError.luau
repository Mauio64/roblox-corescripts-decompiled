local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local Modules = CoreGui.RobloxGui.Modules
local ErrorKind = require(Modules.LuaApp.Enum.Challenge.ErrorKind)
local t1 = {}

t1.__index = t1

function t1.new(_, p2, p3) -- line: 12
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.kind = p2
	t2.data = p3

	return t2
end
function t1.match(p4) -- line: 20
	-- upvalues: LuauPolyfill (copy), t1 (copy)
	return LuauPolyfill.instanceof(p4, t1)
end
function t1.matchAbandoned(p5) -- line: 24
	-- upvalues: t1 (copy), ErrorKind (copy)
	return t1.match(p5) and p5.kind == ErrorKind.Abandoned
end
function t1.matchRateLimited(p6) -- line: 28
	-- upvalues: t1 (copy), ErrorKind (copy)
	if not t1.match(p6) or (p6.kind ~= ErrorKind.RateLimited or not p6.data or not p6.data.retryTime or not DateTime.fromIsoDate(p6.data.retryTime)) then
		return nil
	end

	return p6.data.retryTime
end

return t1
