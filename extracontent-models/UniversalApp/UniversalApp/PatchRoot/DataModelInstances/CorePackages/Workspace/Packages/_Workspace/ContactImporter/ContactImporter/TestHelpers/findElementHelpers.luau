local ContactImporter = script:FindFirstAncestor("ContactImporter")
local devDependencies = require(ContactImporter.devDependencies)
local jestExpect = devDependencies.jestExpect
local v4 = devDependencies.RhodiumHelpers()
local TextKeys = require(ContactImporter.Common.TextKeys)
local t1 = {
	Name = "emptyList"
}
local t2 = {
	Name = "glimmer1"
}
local t3 = {
	Name = "errorModal"
}
local t4 = {
	Text = TextKeys.INVITE_BUTTON_TEXT
}
local t5 = {
	Text = TextKeys.CLOSE_MODAL
}
local t6 = {
	Text = TextKeys.GO_TO_ADD_FRIENDS
}

return {
	findElement = function(t7: {[any]: any}) -- line: 9
		-- upvalues: v4 (copy), jestExpect (copy)
		return function(p1, t8: {[any]: any}) -- line: 10
			-- upvalues: v4 (copy), t7 (copy), jestExpect (copy)
			local v33 = v4.findFirstElement(p1, t7)

			if t8.assertElementExists then
				jestExpect(v33).never.toBeNil()

				return v33
			end

			jestExpect(v33).toBeNil()

			return nil
		end
	end,
	checkEmptyList = function(p2, t9: {[any]: any}) -- line: 10
		-- upvalues: v4 (copy), t1 (copy), jestExpect (copy)
		local v15 = v4.findFirstElement(p2, t1)

		if t9.assertElementExists then
			jestExpect(v15).never.toBeNil()

			return v15
		end

		jestExpect(v15).toBeNil()

		return nil
	end,
	checkLoadingList = function(p3, t10: {[any]: any}) -- line: 10
		-- upvalues: v4 (copy), t2 (copy), jestExpect (copy)
		local v18 = v4.findFirstElement(p3, t2)

		if t10.assertElementExists then
			jestExpect(v18).never.toBeNil()

			return v18
		end

		jestExpect(v18).toBeNil()

		return nil
	end,
	checkFailedList = function(p4, t11: {[any]: any}) -- line: 10
		-- upvalues: v4 (copy), t3 (copy), jestExpect (copy)
		local v21 = v4.findFirstElement(p4, t3)

		if t11.assertElementExists then
			jestExpect(v21).never.toBeNil()

			return v21
		end

		jestExpect(v21).toBeNil()

		return nil
	end,
	checkCloseButton = function(p5, t12: {[any]: any}) -- line: 10
		-- upvalues: v4 (copy), t5 (copy), jestExpect (copy)
		local v27 = v4.findFirstElement(p5, t5)

		if t12.assertElementExists then
			jestExpect(v27).never.toBeNil()

			return v27
		end

		jestExpect(v27).toBeNil()

		return nil
	end,
	checkGoToAddFriends = function(p6, t13: {[any]: any}) -- line: 10
		-- upvalues: v4 (copy), t6 (copy), jestExpect (copy)
		local v30 = v4.findFirstElement(p6, t6)

		if t13.assertElementExists then
			jestExpect(v30).never.toBeNil()

			return v30
		end

		jestExpect(v30).toBeNil()

		return nil
	end,
	checkInviteButton = function(p7, t14: {[any]: any}) -- line: 10
		-- upvalues: v4 (copy), t4 (copy), jestExpect (copy)
		local v24 = v4.findFirstElement(p7, t4)

		if t14.assertElementExists then
			jestExpect(v24).never.toBeNil()

			return v24
		end

		jestExpect(v24).toBeNil()

		return nil
	end
}
