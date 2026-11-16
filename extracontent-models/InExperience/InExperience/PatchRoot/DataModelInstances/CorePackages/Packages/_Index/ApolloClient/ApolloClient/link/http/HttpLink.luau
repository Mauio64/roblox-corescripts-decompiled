local core = require(script.Parent.Parent.core)
local apolloLink = core.ApolloLink

require(script.Parent.selectHttpOptionsAndBody)

local createHttpLink = require(script.Parent.createHttpLink)
local createHttpLink2 = createHttpLink.createHttpLink

local object = setmetatable({}, { __index = apolloLink })
object.__index = object

function object.new(p)
	local options = p == nil and {} or p

	local self = setmetatable(apolloLink.new(createHttpLink2(options).request), object)
	self.options = options
	return self
end

return { HttpLink = object }
