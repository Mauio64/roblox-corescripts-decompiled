local class = {}
class.__index = class

function class.get()
	if not class.default then
		local v5 = {}
		setmetatable(v5, class)
		class.default = v5
	end

	return class.default
end

function class:initialize(omniFeedItemMap)
	if not self._omniFeedItemMap then
		self._omniFeedItemMap = omniFeedItemMap
	elseif not (_G.__TEST_SUITE_PACKAGE__ or _G.__TESTEZ_RUNNING_TEST__) then
		warn("OmniFeedService already initialized with an item map.  Ignoring.")
	end
end

function class:getOmniFeedItemMap()
	if not self._omniFeedItemMap then
		error("OmniFeedService was never initialized with a proper item map. Make sure that OmniFeedService:initialize is called before being accessed.")
	end

	return self._omniFeedItemMap
end

return class
