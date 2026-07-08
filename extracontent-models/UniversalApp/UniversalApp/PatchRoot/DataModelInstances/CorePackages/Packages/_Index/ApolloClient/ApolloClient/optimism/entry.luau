local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local Map = LuauPolyfill.Map
local Error = LuauPolyfill.Error
local t1 = {}
local v8 = newproxy(true)

getmetatable(v8).__tostring = function() -- line: 34
	return "Value.None"
end

local rememberParent = nil
local reallyRecompute = nil
local recomputeNewValue = nil
local mightBeDirty = nil
local setClean = nil
local reportDirty = nil
local reportClean = nil
local eachParent = nil
local reportDirtyChild = nil
local reportCleanChild = nil
local removeDirtyChild = nil
local forgetChildren = nil
local forgetChild = nil
local maybeSubscribe = nil
local parentEntrySlot = require(script.Parent.context).parentEntrySlot

require(script.Parent.initTypes)
require(script.Parent.depTypes)

local helpers = require(script.Parent.helpers)
local maybeUnsubscribe = helpers.maybeUnsubscribe
local toArray = helpers.toArray
local t2 = {}

local function assert(p1, s1: string?) -- line: 73
	-- upvalues: Error (copy)
	if not p1 then
		error(Error.new(s1 or "assertion failure"))
	end
end

require(script.Parent.entryTypes)
require(script.Parent.anyEntryTypes)

local function valueIs(p2, p3) -- line: 87
	local v37 = #p2

	return v37 > 0 and (v37 == #p3 and p2[v37] == p3[v37])
end
local function valueGet(p4) -- line: 98
	-- upvalues: v8 (copy), Error (copy)
	if p4[2] ~= nil then
		error(p4[2])

		return
	end

	if p4[1] ~= nil then
		if p4[1] == v8 then
			return nil
		end

		return p4[1]
	end

	error(Error.new("unknown value"))
end
local function valueCopy(p5) -- line: 123
	return (table.clone(p5))
end

local t3 = {}

t3.__index = t3
t3.count = 0

function t3.new(p6: ((...any) -> ...any)) -- line: 138
	-- upvalues: t3 (copy), Set (copy), Map (copy)
	local self = setmetatable({}, t3)

	self.parents = Set.new()
	self.childValues = Map.new(nil)
	self.dirtyChildren = nil
	self.dirty = true
	self.recomputing = false
	self.value = {}
	self.deps = nil
	self.fn = p6

	local v42 = t3

	v42.count = v42.count + 1

	return self
end
function t3.peek(p7) -- line: 159
	-- upvalues: mightBeDirty (ref), rememberParent (ref)
	if #p7.value == 1 and not mightBeDirty(p7) then
		rememberParent(p7)

		return p7.value[1]
	end

	return nil
end
function t3.recompute(p8, p9) -- line: 173
	-- upvalues: Error (copy), rememberParent (ref), mightBeDirty (ref), reallyRecompute (ref), valueGet (copy)
	if p8.recomputing then
		error(Error.new("already recomputing"))
	end

	rememberParent(p8)

	if mightBeDirty(p8) then
		return reallyRecompute(p8, p9)
	end

	return valueGet(p8.value)
end
function t3.setDirty(p10) -- line: 183
	-- upvalues: reportDirty (ref), maybeUnsubscribe (copy)
	if p10.dirty then
		return
	end

	p10.dirty = true
	p10.value = {}
	reportDirty(p10)
	maybeUnsubscribe(p10)
end
function t3.dispose(p11) -- line: 198
	-- upvalues: forgetChildren (ref), eachParent (ref), forgetChild (ref)
	p11:setDirty()
	forgetChildren(p11)
	eachParent(p11, function(p12, _) -- line: 216
		-- upvalues: forgetChild (ref), p11 (copy)
		p12:setDirty()
		forgetChild(p12, p11)

		return nil
	end)
end
function t3.forget(p14) -- line: 223
	p14:dispose()
end
function t3.dependOn(p15, p16) -- line: 230
	-- upvalues: t2 (copy), Set (copy)
	p16:add(p15)

	if not p15.deps then
		p15.deps = table.remove(t2) or Set.new()
	end

	p15.deps:add(p16)
end
function t3.forgetDeps(p17) -- line: 240
	-- upvalues: Array (copy), toArray (copy), t2 (copy)
	if p17.deps then
		Array.forEach(toArray(p17.deps), function(p18) -- line: 244
			-- upvalues: p17 (copy)
			p18:delete(p17)
		end)
		p17.deps:clear()
		table.insert(t2, p17.deps)
		p17.deps = nil
	end
end

t1.Entry = t3

function rememberParent(p19) -- line: 255
	-- upvalues: parentEntrySlot (copy), mightBeDirty (ref), reportDirtyChild (ref), reportCleanChild (ref)
	local v53 = parentEntrySlot:getValue()

	if v53 then
		p19.parents:add(v53)

		if not v53.childValues:has(p19) then
			v53.childValues:set(p19, {})
		end

		if mightBeDirty(p19) then
			reportDirtyChild(v53, p19)

			return v53
		end

		reportCleanChild(v53, p19)

		return v53
	end

	return nil
end
function reallyRecompute(p20, p21) -- line: 281
	-- upvalues: forgetChildren (ref), parentEntrySlot (copy), recomputeNewValue (ref), maybeSubscribe (ref), setClean (ref), valueGet (copy)
	forgetChildren(p20)
	parentEntrySlot:withValue(p20, recomputeNewValue, {
		p20,
		p21
	})

	if maybeSubscribe(p20, p21) then
		setClean(p20)
	end

	return valueGet(p20.value)
end
function recomputeNewValue(_, p23, p24) -- line: 298
	-- upvalues: v8 (copy)
	p23.recomputing = true
	table.clear(p23.value)

	local ok, result = pcall(p23.fn, table.unpack(p24))

	if ok then
		p23.value[1] = result

		if p23.value[1] == nil then
			p23.value[1] = v8
		end
	end

	if not ok then
		p23.value[2] = result
	end

	p23.recomputing = false
end
function mightBeDirty(p25) -- line: 321
	return p25.dirty or p25.dirtyChildren ~= nil and p25.dirtyChildren.size > 0
end
function setClean(p26) -- line: 327
	-- upvalues: mightBeDirty (ref), reportClean (ref)
	p26.dirty = false

	if mightBeDirty(p26) then
		return
	end

	reportClean(p26)
end
function reportDirty(p27) -- line: 339
	-- upvalues: eachParent (ref), reportDirtyChild (ref)
	eachParent(p27, reportDirtyChild)
end
function reportClean(p28) -- line: 343
	-- upvalues: eachParent (ref), reportCleanChild (ref)
	eachParent(p28, reportCleanChild)
end
function eachParent(p29, p30: ((...any) -> ...any)) -- line: 347
	-- upvalues: toArray (copy)
	local size = p29.parents.size

	if size then
		local v68 = toArray(p29.parents)

		for i = 1, size do
			p30(v68[i], p29)
		end
	end
end
function reportDirtyChild(p31, p32) -- line: 360
	-- upvalues: Error (copy), mightBeDirty (ref), t2 (copy), Set (copy), reportDirty (ref)
	if _G.__DEV__ then
		local v72, v73 = p31.childValues:has(p32)

		if not v72 then
			error(Error.new(v73 or "assertion failure"))
		end

		local v74, v75 = mightBeDirty(p32)

		if not v74 then
			error(Error.new(v75 or "assertion failure"))
		end
	end

	local v76 = mightBeDirty(p31)

	if not p31.dirtyChildren then
		p31.dirtyChildren = table.remove(t2) or Set.new()
	elseif p31.dirtyChildren:has(p32) then
		return
	end

	p31.dirtyChildren:add(p32)

	if not v76 then
		reportDirty(p31)
	end
end
function reportCleanChild(p33, p34) -- line: 394
	-- upvalues: Error (copy), mightBeDirty (ref), removeDirtyChild (ref), reportClean (ref)
	if _G.__DEV__ then
		local v79, v80 = p33.childValues:has(p34)

		if not v79 then
			error(Error.new(v80 or "assertion failure"))
		end

		if mightBeDirty(p34) then
			error(Error.new("assertion failure"))
		end
	end

	local v81 = p33.childValues:get(p34)

	if #v81 == 0 then
		local childValues = p33.childValues
		local value = p34.value

		childValues:set(p34, (table.clone(value)))
	else
		local value = p34.value
		local v85 = #v81

		if not (v85 > 0) or (v85 ~= #value or v81[v85] ~= value[v85]) then
			p33:setDirty()
		end
	end

	removeDirtyChild(p33, p34)

	if mightBeDirty(p33) then
		return
	end

	reportClean(p33)
end
function removeDirtyChild(p35, p36) -- line: 421
	-- upvalues: t2 (copy)
	local dirtyChildren = p35.dirtyChildren

	if dirtyChildren ~= nil then
		dirtyChildren:delete(p36)

		if dirtyChildren.size == 0 then
			if #t2 < 100 then
				table.insert(t2, dirtyChildren)
			end

			p35.dirtyChildren = nil
		end
	end
end
function forgetChildren(p37) -- line: 436
	-- upvalues: Array (copy), forgetChild (ref), Error (copy)
	if p37.childValues.size > 0 then
		local v90 = table.clone(p37.childValues:keys())

		Array.forEach(v90, function(p38) -- line: 444
			-- upvalues: forgetChild (ref), p37 (copy)
			forgetChild(p37, p38)
		end)
	end

	p37:forgetDeps()

	if p37.dirtyChildren ~= nil then
		error(Error.new("assertion failure"))
	end
end
function forgetChild(p39, p40) -- line: 458
	-- upvalues: removeDirtyChild (ref)
	p40.parents:delete(p39)
	p39.childValues:delete(p40)
	removeDirtyChild(p39, p40)
end
function maybeSubscribe(p41, p42) -- line: 464
	-- upvalues: maybeUnsubscribe (copy)
	if typeof(p41.subscribe) == "function" and not pcall(function() -- line: 466
		-- upvalues: maybeUnsubscribe (copy), p41 (copy), p42 (copy)
		maybeUnsubscribe(p41)
		p41.unsubscribe = p41.subscribe(table.unpack(p42))

		return nil, false
	end) then
		p41:setDirty()

		return false
	end

	return true
end

return t1
