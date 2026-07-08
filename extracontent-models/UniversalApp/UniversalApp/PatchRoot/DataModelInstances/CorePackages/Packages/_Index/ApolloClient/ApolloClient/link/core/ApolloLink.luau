local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local invariant = require(ParentParent.jsutils.invariant)
local InvariantError = invariant.InvariantError
local invariant2 = invariant.invariant
local Observable = require(ParentParent.utilities).Observable

require(script.Parent.types)

local utils = require(script.Parent.Parent.utils)
local validateOperation = utils.validateOperation
local createOperation = utils.createOperation
local transformOperation = utils.transformOperation
local t2 = {}

t2.__index = t2

local function passthrough(_: {[any]: any}, p1, p2) -- line: 53
	-- upvalues: Boolean (copy), Observable (copy)
	if Boolean.toJSBoolean(p2) then
		return (p2(p1))
	end

	return Observable.of()
end
local function toLink(p3) -- line: 61
	-- upvalues: t2 (copy)
	if typeof(p3) == "function" then
		return t2.new(p3)
	end

	return p3
end
local function isTerminating(t4: {[any]: any}) -- line: 69
	local v26, _ = debug.info(t4.request, "a")

	return v26 <= 2
end

local self = setmetatable({}, {
	__index = Error
})

self.__index = self

function self.new(s1: string?, t5: {[any]: any}?) -- line: 79
	-- upvalues: Error (copy), self (copy)
	local v30 = Error.new(s1)

	v30.link = t5

	return (setmetatable(v30, self))
end
function t2.empty() -- line: 86
	-- upvalues: t2 (copy), Observable (copy)
	return t2.new(function(_) -- line: 87
		-- upvalues: Observable (copy)
		return Observable.of()
	end)
end
function t2.from(p5) -- line: 92
	-- upvalues: t2 (copy), Array (copy), toLink (copy)
	if #p5 == 0 then
		return t2.empty()
	end

	return (Array.reduce(Array.map(p5, toLink, nil), function(p6, p7) -- line: 96
		return p6:concat(p7)
	end))
end
function t2.split_(p8: ((...any) -> ...any), p9, p10) -- line: 101
	-- upvalues: t2 (copy), Boolean (copy), passthrough (copy), Observable (copy)
	local v35 = if typeof(p9) ~= "function" then p9 else t2.new(p9)
	local u36

	if Boolean.toJSBoolean(p10) and p10 ~= nil then
		u36 = if typeof(p10) ~= "function" then p10 else t2.new(p10)
	else
		local v37 = t2.new(passthrough)

		u36 = if typeof(v37) ~= "function" then v37 else t2.new(v37)
	end

	local v38, _ = debug.info(v35.request, "a")

	if v38 <= 2 then
		local v40 = u36
		local v41, _ = debug.info(v40.request, "a")

		if v41 <= 2 then
			return t2.new(function(_, p12) -- line: 115
				-- upvalues: p8 (copy), v35 (copy), Boolean (copy), Observable (copy), u36 (ref)
				if p8(p12) then
					local v75 = v35:request(p12)

					return Boolean.toJSBoolean(v75) and v75 or Observable.of()
				end

				local v76 = u36:request(p12)

				return Boolean.toJSBoolean(v76) and v76 or Observable.of()
			end)
		end
	end

	return t2.new(function(_, p14, p15) -- line: 125
		-- upvalues: p8 (copy), v35 (copy), Boolean (copy), Observable (copy), u36 (ref)
		if p8(p14) then
			local v80 = v35:request(p14, p15)

			return Boolean.toJSBoolean(v80) and v80 or Observable.of()
		end

		local v81 = u36:request(p14, p15)

		return Boolean.toJSBoolean(v81) and v81 or Observable.of()
	end)
end
function t2.execute(t6: {[any]: any}, p16) -- line: 137
	-- upvalues: createOperation (copy), transformOperation (copy), validateOperation (copy), Boolean (copy), Observable (copy)
	local v45 = t6:request(createOperation(p16.context, transformOperation(validateOperation(p16))))

	return Boolean.toJSBoolean(v45) and v45 or Observable.of()
end
function t2.concat_(p17, p18) -- line: 142
	-- upvalues: t2 (copy), invariant2 (copy), self (copy), Boolean (copy), Observable (copy)
	local v48 = if typeof(p17) ~= "function" then p17 else t2.new(p17)
	local v49, _ = debug.info(v48.request, "a")

	if v49 <= 2 then
		invariant2.warn(self.new("You are calling concat on a terminating link, which will have no effect", v48))

		return v48
	end

	local v51 = if typeof(p18) ~= "function" then p18 else t2.new(p18)
	local v52, _ = debug.info(v51.request, "a")

	if v52 <= 2 then
		return t2.new(function(_, p20) -- line: 153
			-- upvalues: v48 (copy), v51 (copy), Boolean (copy), Observable (copy)
			local v84 = v48:request(p20, function(p21) -- line: 154
				-- upvalues: v51 (copy), Boolean (copy), Observable (copy)
				local v90 = v51:request(p21)

				return Boolean.toJSBoolean(v90) and v90 or Observable.of()
			end)

			return Boolean.toJSBoolean(v84) and v84 or Observable.of()
		end)
	end

	return t2.new(function(_, p23, p24) -- line: 161
		-- upvalues: v48 (copy), v51 (copy), Boolean (copy), Observable (copy)
		local v88 = v48:request(p23, function(p25) -- line: 162
			-- upvalues: v51 (copy), p24 (copy), Boolean (copy), Observable (copy)
			local v92 = v51:request(p25, p24)

			return Boolean.toJSBoolean(v92) and v92 or Observable.of()
		end)

		return Boolean.toJSBoolean(v88) and v88 or Observable.of()
	end)
end
function t2.new(p26) -- line: 171
	-- upvalues: Boolean (copy), t2 (copy)
	local t7 = {}

	if Boolean.toJSBoolean(p26) then
		t7.request = p26
	end

	return (setmetatable(t7, t2))
end
function t2.split(t8: {[any]: any}, p27: ((...any) -> ...any), p28, p29) -- line: 179
	-- upvalues: t2 (copy), Boolean (copy), passthrough (copy)
	return t8:concat(t2.split_(p27, p28, Boolean.toJSBoolean(p29) and p29 or t2.new(passthrough)))
end
function t2.concat(p30, p31) -- line: 189
	-- upvalues: t2 (copy)
	return t2.concat_(p30, p31)
end
function t2.request(_, _, _) -- line: 193
	-- upvalues: InvariantError (copy)
	error(InvariantError.new("request is not implemented"))
end
function t2.onError(_, p36, p37) -- line: 197
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p37) and (p37 ~= nil and Boolean.toJSBoolean(p37.error)) then
		p37:error(p36)

		return false
	end

	error(p36)
end
function t2.setOnError(p38, p39) -- line: 213
	p38.onError = p39

	return p38
end

t1.ApolloLink = t2

return t1
