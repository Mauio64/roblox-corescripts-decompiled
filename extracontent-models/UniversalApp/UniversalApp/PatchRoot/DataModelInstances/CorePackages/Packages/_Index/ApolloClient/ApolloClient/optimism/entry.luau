local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local Map = LuauPolyfill.Map
local Error = LuauPolyfill.Error

local v = newproxy(true)
getmetatable(v).__tostring = function(): string
	return "Value.None"
end

local rememberParent
local reallyRecompute
local recomputeNewValue
local mightBeDirty
local setClean
local reportDirty
local reportClean
local eachParent
local reportDirtyChild
local reportCleanChild
local removeDirtyChild
local forgetChildren
local forgetChild
local maybeSubscribe

local context = require(script.Parent.context)
local parentEntrySlot = context.parentEntrySlot
require(script.Parent.initTypes)

require(script.Parent.depTypes)

local helpers = require(script.Parent.helpers)
local maybeUnsubscribe = helpers.maybeUnsubscribe
local toArray = helpers.toArray

local v2 = {}

local function assert(p, value: string?) -- 3 equivalent calls inferred from this helper
	if not p then
		error(Error.new(value or "assertion failure"))
	end
end

require(script.Parent.entryTypes)
require(script.Parent.anyEntryTypes)

local function valueIs(list, value): boolean -- 1 equivalent call inferred from this helper
	local count = #list

	return count > 0 and count == #value and list[count] == value[count]
end

local function valueGet(value)
	if value[2] ~= nil then
		error(value[2])
		return
	end

	if value[1] == nil then
		error(Error.new("unknown value"))

		return
	end

	return if value[1] ~= v then value[1] else nil
end

local function valueCopy(value) -- 1 equivalent call inferred from this helper
	return (table.clone(value))
end

local class = {}
class.__index = class
class.count = 0

function class.new(fn)
	local self = setmetatable({}, class)

	self.parents = Set.new()

	self.childValues = Map.new(nil)

	self.dirtyChildren = nil
	self.dirty = true
	self.recomputing = false
	self.value = {}

	self.deps = nil

	self.fn = fn

	class.count += 1

	return self
end

function class.peek(p)
	if #p.value ~= 1 or mightBeDirty(p) then
		return nil
	end

	rememberParent(p)
	return p.value[1]
end

function class.recompute(p, p2)
	if p.recomputing then
		error(Error.new("already recomputing"))
	end

	rememberParent(p)

	if mightBeDirty(p) then
		return reallyRecompute(p, p2)
	end

	return valueGet(p.value)
end

function class:setDirty()
	if self.dirty then
		return
	end

	self.dirty = true

	self.value = {}

	reportDirty(self)

	maybeUnsubscribe(self)
end

function class:dispose()
	self:setDirty()

	forgetChildren(self)

	eachParent(self, function(object, _): nil
		object:setDirty()
		forgetChild(object, self)
		return nil
	end)
end

function class:forget()
	self:dispose()
end

function class:dependOn(object)
	object:add(self)

	if not self.deps then
		self.deps = table.remove(v2) or Set.new()
	end

	self.deps:add(object)
end

function class:forgetDeps()
	if self.deps then
		Array.forEach(toArray(self.deps), function(object)
			object:delete(self)
		end)
		self.deps:clear()
		table.insert(v2, self.deps)
		self.deps = nil
	end
end

rememberParent = function(p)
	local value = parentEntrySlot:getValue()

	if not value then
		return nil
	end

	p.parents:add(value)

	if not value.childValues:has(p) then
		value.childValues:set(p, {})
	end

	if mightBeDirty(p) then
		reportDirtyChild(value, p)
		return value
	end

	reportCleanChild(value, p)

	return value
end

reallyRecompute = function(p, p2)
	forgetChildren(p)

	parentEntrySlot:withValue(p, recomputeNewValue, { p, p2 })

	if maybeSubscribe(p, p2) then
		setClean(p)
	end

	return valueGet(p.value)
end

recomputeNewValue = function(_, state, list)
	state.recomputing = true

	table.clear(state.value)

	local success, result = pcall(state.fn, table.unpack(list))

	if success then
		state.value[1] = result

		if state.value[1] == nil then
			state.value[1] = v
		end
	end

	if not success then
		state.value[2] = result
	end

	state.recomputing = false
end

mightBeDirty = function(p)
	local dirty = p.dirty

	if not dirty then
		if p.dirtyChildren == nil then
			return false
		end

		return p.dirtyChildren.size > 0
	end

	return dirty
end

setClean = function(p)
	p.dirty = false

	if mightBeDirty(p) then
		return
	end

	reportClean(p)
end

reportDirty = function(p)
	eachParent(p, reportDirtyChild)
end

reportClean = function(p)
	eachParent(p, reportCleanChild)
end

eachParent = function(p, callback)
	local size = p.parents.size

	if size then
		local v3 = toArray(p.parents)

		for i = 1, size do
			callback(v3[i], p)
		end
	end
end

reportDirtyChild = function(value, p)
	if _G.__DEV__ then
		local has, v3 = value.childValues:has(p)
		assert(has, v3) -- inferred equivalent call
		local v4, v5 = mightBeDirty(p)
		assert(v4, v5) -- inferred equivalent call
	end

	local v3 = not mightBeDirty(value)

	if value.dirtyChildren then
		if value.dirtyChildren:has(p) then
			return
		end
	else
		value.dirtyChildren = table.remove(v2) or Set.new()
	end

	value.dirtyChildren:add(p)

	if v3 then
		reportDirty(value)
	end
end

reportCleanChild = function(value, p)
	if _G.__DEV__ then
		local has, v3 = value.childValues:has(p)
		assert(has, v3) -- inferred equivalent call

		if mightBeDirty(p) then
			error(Error.new("assertion failure"))
		end
	end

	local v3 = value.childValues:get(p)

	if #v3 == 0 then
		value.childValues:set(p, valueCopy(p.value)) -- inferred equivalent call
	elseif not valueIs(v3, p.value) then -- inferred equivalent call
		value:setDirty()
	end

	removeDirtyChild(value, p)

	if mightBeDirty(value) then
		return
	end

	reportClean(value)
end

removeDirtyChild = function(p, p2)
	local dirtyChildren = p.dirtyChildren

	if dirtyChildren ~= nil then
		dirtyChildren:delete(p2)

		if dirtyChildren.size == 0 then
			if #v2 < 100 then
				table.insert(v2, dirtyChildren)
			end

			p.dirtyChildren = nil
		end
	end
end

forgetChildren = function(object)
	if object.childValues.size > 0 then
		local clone = table.clone(object.childValues:keys())
		Array.forEach(clone, function(p)
			forgetChild(object, p)
		end)
	end

	object:forgetDeps()

	if object.dirtyChildren ~= nil then
		error(Error.new("assertion failure"))
	end
end

forgetChild = function(object, p)
	p.parents:delete(object)
	object.childValues:delete(p)
	removeDirtyChild(object, p)
end

maybeSubscribe = function(object, list): boolean
	if typeof(object.subscribe) ~= "function" or pcall(function(): (nil, boolean)
		maybeUnsubscribe(object)
		object.unsubscribe = object.subscribe(table.unpack(list))
		return nil, false
	end) then
		return true
	end

	object:setDirty()
	return false
end

return { Entry = class }
