local ParentParent = script.Parent.Parent.Parent
local createSignal = require(ParentParent.Signals).createSignal
local t1 = {}

local function defaultRelationship() -- line: 18
	return {
		isBlocked = false,
		friendStatus = nil,
		isFollowing = false
	}
end
local function getOrCreate(n1: number) -- line: 26
	-- upvalues: t1 (ref), createSignal (copy)
	if not t1[n1] then
		local v7, v8 = createSignal({
			isBlocked = false,
			friendStatus = nil,
			isFollowing = false
		})

		t1[n1] = {
			getter = v7,
			setter = v8
		}
	end

	return t1[n1]
end

return {
	getPlayerRelationshipReactive = function(n2: number) -- line: 34
		-- upvalues: t1 (ref), createSignal (copy)
		if not t1[n2] then
			local v10, v11 = createSignal({
				isBlocked = false,
				friendStatus = nil,
				isFollowing = false
			})

			t1[n2] = {
				getter = v10,
				setter = v11
			}
		end

		return t1[n2].getter
	end,
	patchPlayerRelationship = function(n3: number, t2: {[any]: any}) -- line: 44
		-- upvalues: t1 (ref), createSignal (copy)
		if not t1[n3] then
			local v14, v15 = createSignal({
				isBlocked = false,
				friendStatus = nil,
				isFollowing = false
			})

			t1[n3] = {
				getter = v14,
				setter = v15
			}
		end

		local v16 = t1[n3]
		local v17 = v16.getter(false)
		local t3 = {
			isBlocked = if t2.isBlocked == nil then v17.isBlocked else t2.isBlocked,
			friendStatus = if t2.friendStatus == nil then v17.friendStatus else t2.friendStatus,
			isFollowing = if t2.isFollowing == nil then v17.isFollowing else t2.isFollowing
		}

		v16.setter(t3)
	end,
	removePlayer = function(n4: number) -- line: 55
		-- upvalues: t1 (ref)
		t1[n4] = nil
	end,
	cleanUp = function() -- line: 59
		-- upvalues: t1 (ref)
		t1 = {}
	end
}
