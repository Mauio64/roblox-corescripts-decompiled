local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList.createNode(p)
	local v = { previous = nil, next = nil, value = p }

	setmetatable(v, LinkedList)

	return v
end

function LinkedList:CreateNext(options)
	local nextNode = {
		previous = self,
		next = self.next,
		value = options or {}
	}

	if self.next then
		self.next.previous = nextNode
	end

	setmetatable(nextNode, LinkedList)
	self.next = nextNode
	return nextNode
end

function LinkedList:CreatePrevious(options)
	local previous = {
		previous = self.previous,
		next = self,
		value = options or {}
	}

	if self.previous then
		self.previous.next = previous
	end

	setmetatable(previous, LinkedList)
	self.previous = previous
	return previous
end

return LinkedList
