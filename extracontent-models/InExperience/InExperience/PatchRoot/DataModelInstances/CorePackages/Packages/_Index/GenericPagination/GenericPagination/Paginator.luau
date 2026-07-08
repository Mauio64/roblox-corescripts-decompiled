local dependencies = require(script.Parent.dependencies)
local t = dependencies.t
local LinkedList = dependencies.LinkedList
local Promise = dependencies.Promise
local t1 = {
	llRoot = nil,
	llIndex = nil,
	_isFetching = false
}

t1.__index = t1

local v6 = t.strictInterface({
	pageSize = t.number,
	fetchWithCursor = t.callback,
	fetchInit = t.callback
})

function t1.new(p1) -- line: 23
	-- upvalues: v6 (copy), t1 (copy)
	assert(v6(p1))

	local t2 = {}

	for k, v in pairs(p1) do
		t2[k] = v
	end

	setmetatable(t2, t1)
	t2:_init()

	return t2
end
function t1._init(p2) -- line: 35
	-- upvalues: LinkedList (copy)
	p2._isFetching = true

	return p2.fetchInit():andThen(function(p3, p4) -- line: 38
		-- upvalues: p2 (copy), LinkedList (copy)
		p2.llRoot = LinkedList.createNode()
		p2.llIndex = p2.llRoot
		p2.llIndex:CreatePrevious(p3)
		p2.llIndex:CreateNext(p4)
		p2._isFetching = false
	end)
end
function t1.getCurrent(p5) -- line: 47
	return p5.llIndex.value or {}
end
function t1.getNext(p6) -- line: 51
	-- upvalues: Promise (copy)
	if p6._isFetching then
		return Promise.reject("Paginator is currently busy. Please wait.")
	end

	local v14 = p6.llIndex.next.value or ""

	if v14 == "" then
		return Promise.reject("Next cursor is invalid")
	end

	p6.llIndex = p6.llIndex.next
	p6._isFetching = true

	return p6.fetchWithCursor(v14):andThen(function(p7, p8) -- line: 65
		-- upvalues: p6 (copy)
		p6.llIndex.previous.value = p7

		if p6.llIndex.next then
			p6.llIndex.next.value = p8
		else
			p6.llIndex:CreateNext(p8)
		end

		p6._isFetching = false
	end)
end
function t1.getPrevious(p9) -- line: 76
	-- upvalues: Promise (copy)
	if p9._isFetching then
		return Promise.reject("Paginator is currently busy. Please wait.")
	end

	local v16 = p9.llIndex.previous.value or ""

	if v16 == "" then
		return Promise.reject("Previous cursor is invalid")
	end

	p9.llIndex = p9.llIndex.previous
	p9._isFetching = true

	return p9.fetchWithCursor(v16, true):andThen(function(p10, p11) -- line: 90
		-- upvalues: p9 (copy)
		p9.llIndex.next.value = p11

		if p9.llIndex.previous then
			p9.llIndex.previous.value = p10
		else
			p9.llIndex:CreatePrevious(p10)
		end

		p9._isFetching = false
	end)
end
function t1.isFetching(p12) -- line: 101
	return p12._isFetching
end

return t1
