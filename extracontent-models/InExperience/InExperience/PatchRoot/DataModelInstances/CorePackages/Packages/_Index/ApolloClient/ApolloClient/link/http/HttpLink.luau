local t1 = {}
local ApolloLink = require(script.Parent.Parent.core).ApolloLink

require(script.Parent.selectHttpOptionsAndBody)

local createHttpLink = require(script.Parent.createHttpLink).createHttpLink
local self = setmetatable({}, {
	__index = ApolloLink
})

self.__index = self

function self.new(p1) -- line: 23
	-- upvalues: ApolloLink (copy), createHttpLink (copy), self (copy)
	if p1 == nil then
		p1 = {}
	end

	local v6 = setmetatable(ApolloLink.new(createHttpLink(p1).request), self)

	v6.options = p1

	return v6
end

t1.HttpLink = self

return t1
