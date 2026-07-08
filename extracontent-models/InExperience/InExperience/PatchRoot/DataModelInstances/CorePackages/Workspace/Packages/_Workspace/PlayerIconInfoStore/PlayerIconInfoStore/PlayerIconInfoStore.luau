local ParentParent = script.Parent.Parent
local createSignal = require(ParentParent.Signals).createSignal
local t1 = {}

local function createDefaultPlayerIconInfo(n1: number) -- line: 25
	return {
		avatarIcon = nil,
		specialGroupIcon = nil,
		isPlaceOwner = game.CreatorType == Enum.CreatorType.User and n1 == game.CreatorId
	}
end
local function getOrCreatePlayerSignal(n2: number) -- line: 33
	-- upvalues: t1 (ref), createSignal (copy)
	if not t1[n2] then
		local v8, v9 = createSignal({
			avatarIcon = nil,
			specialGroupIcon = nil,
			isPlaceOwner = game.CreatorType == Enum.CreatorType.User and n2 == game.CreatorId
		})

		t1[n2] = {
			getter = v8,
			setter = v9
		}
	end

	return t1[n2]
end

return {
	getPlayerIconInfoReactive = function(n3: number) -- line: 41
		-- upvalues: t1 (ref), createSignal (copy)
		if not t1[n3] then
			local v11, v12 = createSignal({
				avatarIcon = nil,
				specialGroupIcon = nil,
				isPlaceOwner = game.CreatorType == Enum.CreatorType.User and n3 == game.CreatorId
			})

			t1[n3] = {
				getter = v11,
				setter = v12
			}
		end

		return t1[n3].getter
	end,
	setPlayerIconInfo = function(n4: number, t2: {[any]: any}) -- line: 46
		-- upvalues: t1 (ref), createSignal (copy)
		if not t1[n4] then
			local v15, v16 = createSignal({
				avatarIcon = nil,
				specialGroupIcon = nil,
				isPlaceOwner = game.CreatorType == Enum.CreatorType.User and n4 == game.CreatorId
			})

			t1[n4] = {
				getter = v15,
				setter = v16
			}
		end

		t1[n4].setter(t2)
	end,
	addPlayer = function(n5: number) -- line: 51
		-- upvalues: t1 (ref), createSignal (copy)
		if not t1[n5] then
			local v18, v19 = createSignal({
				avatarIcon = nil,
				specialGroupIcon = nil,
				isPlaceOwner = game.CreatorType == Enum.CreatorType.User and n5 == game.CreatorId
			})

			t1[n5] = {
				getter = v18,
				setter = v19
			}
		end

		local _ = t1[n5]
	end,
	removePlayer = function(n6: number) -- line: 56
		-- upvalues: t1 (ref)
		t1[n6] = nil
	end,
	cleanUp = function() -- line: 60
		-- upvalues: t1 (ref)
		t1 = {}
	end
}
