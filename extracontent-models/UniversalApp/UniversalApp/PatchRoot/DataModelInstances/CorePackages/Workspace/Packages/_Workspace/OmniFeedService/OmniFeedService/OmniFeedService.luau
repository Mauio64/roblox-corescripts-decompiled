local t1 = {}

t1.__index = t1

function t1.get() -- line: 18
	-- upvalues: t1 (copy)
	if not t1.default then
		local t2 = {}

		setmetatable(t2, t1)
		t1.default = t2
	end

	return t1.default
end
function t1.initialize(t3: {[any]: any}, t4: {[any]: any}) -- line: 28
	if not t3._omniFeedItemMap then
		t3._omniFeedItemMap = t4

		return
	end

	if not _G.__TEST_SUITE_PACKAGE__ and not _G.__TESTEZ_RUNNING_TEST__ then
		warn("OmniFeedService already initialized with an item map.  Ignoring.")
	end
end
function t1.getOmniFeedItemMap(p1) -- line: 38
	if not p1._omniFeedItemMap then
		error("OmniFeedService was never initialized with a proper item map. Make sure that OmniFeedService:initialize is called before being accessed.")
	end

	return p1._omniFeedItemMap
end

return t1
