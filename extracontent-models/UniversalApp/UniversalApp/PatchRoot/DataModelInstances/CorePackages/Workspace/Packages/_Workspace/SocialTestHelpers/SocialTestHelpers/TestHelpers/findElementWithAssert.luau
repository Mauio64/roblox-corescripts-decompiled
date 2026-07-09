local Parent = script:FindFirstAncestor("SocialTestHelpers").Parent
local expect = require(Parent.JestGlobals).expect
local RhodiumHelpers = require(Parent.RhodiumHelpers)

return function(t1: {[any]: any}) -- line: 9
	-- upvalues: RhodiumHelpers (copy), expect (copy)
	return function(p1, t2: {[any]: any}) -- line: 10
		-- upvalues: RhodiumHelpers (copy), t1 (copy), expect (copy)
		local v7 = RhodiumHelpers.findFirstElement(p1, t1)

		if t2.assertElementExists then
			expect(v7).never.toBeNil()

			return v7
		end

		expect(v7).toBeNil()

		return nil
	end
end
