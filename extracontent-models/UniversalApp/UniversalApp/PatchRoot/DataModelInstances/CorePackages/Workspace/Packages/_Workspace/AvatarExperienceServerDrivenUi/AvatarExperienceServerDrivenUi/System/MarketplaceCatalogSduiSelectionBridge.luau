local Parent = script:FindFirstAncestor("AvatarExperienceServerDrivenUi").Parent
local Signals = require(Parent.Signals)
local v3, v4 = Signals.createSignal(nil)
local v5, v6 = Signals.createSignal(nil)
local t2 = nil
local t3 = nil

return {
	register = function(s1: string, t1: {[any]: any}) -- line: 45
		-- upvalues: t2 (ref)
		t2 = {
			ownerId = s1,
			handlers = t1
		}
	end,
	unregister = function(s2: string) -- line: 52
		-- upvalues: t2 (ref)
		if t2 and s2 == t2.ownerId then
			t2 = nil
		end
	end,
	registerFocusedSortHandler = function(s3: string, p1: ((...any) -> ...any)) -- line: 62
		-- upvalues: t3 (ref)
		t3 = {
			ownerId = s3,
			handler = p1
		}
	end,
	unregisterFocusedSortHandler = function(s4: string) -- line: 69
		-- upvalues: t3 (ref)
		if t3 and s4 == t3.ownerId then
			t3 = nil
		end
	end,
	selectCategory = function(s5: string) -- line: 75
		-- upvalues: v4 (copy), v6 (copy), t2 (ref)
		v4(s5)
		v6(nil)

		if t2 and t2.handlers then
			t2.handlers.selectCategory(s5)
		end
	end,
	selectSubcategory = function(s6: string) -- line: 85
		-- upvalues: v6 (copy), t2 (ref)
		v6(s6)

		if t2 and t2.handlers then
			t2.handlers.selectSubcategory(s6)
		end
	end,
	requestFocusedSort = function(t4: {[any]: any}) -- line: 92
		-- upvalues: t3 (ref)
		if t3 and t3.handler then
			t3.handler(t4)
		end
	end,
	activeCategoryId = v3,
	activeSubcategoryId = v5
}
