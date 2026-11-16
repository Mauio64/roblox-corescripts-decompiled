local dependencies = require(script.Parent.dependencies)
local t = dependencies.t
local linkedList = dependencies.LinkedList
local promise = dependencies.Promise

local Paginator = { llRoot = nil, llIndex = nil, _isFetching = false }

Paginator.__index = Paginator

local strictInterface = t.strictInterface({
	pageSize = t.number,
	fetchWithCursor = t.callback,
	fetchInit = t.callback
})

function Paginator.new(items)
	assert(strictInterface(items))
	local class = {}

	for k, item in pairs(items) do
		class[k] = item
	end

	setmetatable(class, Paginator)

	class:_init()
	return class
end

function Paginator:_init()
	self._isFetching = true
	return self.fetchInit():andThen(function(p, p2)
		self.llRoot = linkedList.createNode()
		self.llIndex = self.llRoot
		self.llIndex:CreatePrevious(p)
		self.llIndex:CreateNext(p2)
		self._isFetching = false
	end)
end

function Paginator.getCurrent(p)
	return p.llIndex.value or {}
end

function Paginator:getNext()
	if self._isFetching then
		return promise.reject("Paginator is currently busy. Please wait.")
	end

	local value = self.llIndex.next.value or ""

	if value == "" then
		return promise.reject("Next cursor is invalid")
	end

	self.llIndex = self.llIndex.next
	self._isFetching = true

	return self.fetchWithCursor(value):andThen(function(p, p2)
		self.llIndex.previous.value = p

		if self.llIndex.next then
			self.llIndex.next.value = p2
		else
			self.llIndex:CreateNext(p2)
		end

		self._isFetching = false
	end)
end

function Paginator:getPrevious()
	if self._isFetching then
		return promise.reject("Paginator is currently busy. Please wait.")
	end

	local value = self.llIndex.previous.value or ""

	if value == "" then
		return promise.reject("Previous cursor is invalid")
	end

	self.llIndex = self.llIndex.previous
	self._isFetching = true

	return self.fetchWithCursor(value, true):andThen(function(p, p2)
		self.llIndex.next.value = p2

		if self.llIndex.previous then
			self.llIndex.previous.value = p
		else
			self.llIndex:CreatePrevious(p)
		end

		self._isFetching = false
	end)
end

function Paginator:isFetching()
	return self._isFetching
end

return Paginator
