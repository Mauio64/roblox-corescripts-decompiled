local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Virtualizer.ItemSequence)
require(ViewRecycler.Core.Types)

local function createStickyIndexResolver(p, callback)
	local v = p
	local v2 = callback
	local v3 = nil
	local flag = true

	local function applyShift(state, p2: number) -- 6 equivalent calls inferred from this helper
		if state ~= nil then
			state.index += p2
			state.lazy += p2
		end
	end

	local function push(state) -- 12 equivalent calls inferred from this helper
		local lazy = state.lazy

		if lazy ~= 0 then
			applyShift(state.left, lazy) -- inferred equivalent call
			applyShift(state.right, lazy) -- inferred equivalent call
			state.lazy = 0
		end
	end

	local function height(p2) -- 10 equivalent calls inferred from this helper
		return if p2 == nil then 0 else p2.height
	end

	local function updateHeight(state) -- 9 equivalent calls inferred from this helper
		state.height = math.max(height(state.left), height(state.right)) + 1 -- inferred equivalent call
	end

	local function rotateLeft(left) -- 2 equivalent calls inferred from this helper
		local right = left.right
		push(left) -- inferred equivalent call
		push(right) -- inferred equivalent call
		left.right = right.left
		right.left = left
		updateHeight(left) -- inferred equivalent call
		updateHeight(right) -- inferred equivalent call
		return right
	end

	local function rotateRight(right) -- 2 equivalent calls inferred from this helper
		local left = right.left
		push(right) -- inferred equivalent call
		push(left) -- inferred equivalent call
		right.left = left.right
		left.right = right
		updateHeight(right) -- inferred equivalent call
		updateHeight(left) -- inferred equivalent call
		return left
	end

	local function balance(state)
		updateHeight(state) -- inferred equivalent call
		local v4 = height(state.left) - height(state.right) -- inferred equivalent call

		if v4 > 1 then
			local left = state.left
			push(left) -- inferred equivalent call

			if height(left.left) < height(left.right) then -- inferred equivalent call
				state.left = rotateLeft(left) -- inferred equivalent call
			end

			return rotateRight(state) -- inferred equivalent call
		else
			if not (v4 < -1) then
				return state
			end

			local right = state.right
			push(right) -- inferred equivalent call

			if height(right.right) < height(right.left) then -- inferred equivalent call
				state.right = rotateRight(right) -- inferred equivalent call
			end

			return rotateLeft(state) -- inferred equivalent call
		end
	end

	local function fn(left, state, right)
		local v4 = height(left) -- inferred equivalent call
		local v5 = height(right) -- inferred equivalent call

		if v5 + 1 < v4 then
			push(left) -- inferred equivalent call
			left.right = fn(left.right, state, right)
			return (balance(left))
		elseif v4 + 1 < v5 then
			push(right) -- inferred equivalent call
			right.left = fn(left, state, right.left)
			return (balance(right))
		else
			state.left = left
			state.right = right
			state.lazy = 0
			updateHeight(state) -- inferred equivalent call
			return state
		end
	end

	local function split(state, p2: number)
		if state == nil then
			return nil, nil
		end

		push(state) -- inferred equivalent call

		if state.index < p2 then
			local v4, v5 = split(state.right, p2)
			local left = state.left
			state.left = nil
			state.right = nil
			return fn(left, state, v4), v5
		else
			local v4, v5 = split(state.left, p2)
			local right = state.right
			state.left = nil
			state.right = nil
			return v4, fn(v5, state, right)
		end
	end

	local function removeFirst(left)
		push(left) -- inferred equivalent call

		if left.left == nil then
			local right = left.right
			left.right = nil
			updateHeight(left) -- inferred equivalent call
			return right, left
		else
			local left2, v4 = removeFirst(left.left)
			left.left = left2
			return balance(left), v4
		end
	end

	local function join(p2, state) -- 9 equivalent calls inferred from this helper
		if p2 == nil then
			return state
		end

		if state == nil then
			return p2
		end

		push(state) -- inferred equivalent call
		local v4, v5

		if state.left == nil then
			v4 = state.right
			state.right = nil
			updateHeight(state) -- inferred equivalent call
			v5 = state
		else
			local left
			left, v5 = removeFirst(state.left)
			state.left = left
			v4 = balance(state)
		end

		return fn(p2, v5, v4)
	end

	local function newNode(p2: number)
		return {
			index = p2,
			height = 1,
			lazy = 0,
			left = nil,
			right = nil
		}
	end

	local function buildBalanced(p2, p3: number, p4: number)
		if p4 < p3 then
			return nil
		end

		local v4 = math.floor((p3 + p4) / 2)
		local v5 = {
			index = p2[v4],
			height = 1,
			lazy = 0,
			left = buildBalanced(p2, p3, v4 - 1),
			right = buildBalanced(p2, v4 + 1, p4)
		}
		updateHeight(v5) -- inferred equivalent call
		return v5
	end

	local function rebuild()
		local v4 = {}

		if v2 ~= nil then
			for i = 1, v.getItemCount() do
				local itemKey = v.getItemKey(i)

				if v2(itemKey) then
					table.insert(v4, i)
				end
			end
		end

		v3 = buildBalanced(v4, 1, #v4)
		flag = false
	end

	return {
		setPredicate = function(p2): boolean
			if v2 == p2 then
				return false
			end

			v2 = p2
			flag = true
			return true
		end,
		setItemSequence = function(p2)
			if v ~= p2 then
				v = p2
				flag = true
			end
		end,
		applyDataSourceChange = function(p2)
			if flag or v2 == nil then
				return
			end

			for _, change in p2.changes do
				if change.type == DataSourceChangeType.Reset or change.type == DataSourceChangeType.Reorder then
					flag = true
					break
				end

				if change.type == DataSourceChangeType.Insert then
					local index = change.index
					local v4 = #change.keys
					local v5, v6 = split(v3, index)
					applyShift(v6, v4) -- inferred equivalent call
					local v7 = {}

					for k, key in change.keys do
						if v2(key) then
							table.insert(v7, index + k - 1)
						end
					end

					v5 = join(v5, buildBalanced(v7, 1, #v7)) -- inferred equivalent call
					v5 = join(v5, v6) -- inferred equivalent call
					v3 = v5
				elseif change.type == DataSourceChangeType.Remove then
					local index = change.index
					local v4 = index + #change.keys - 1
					local v5, v6 = split(v3, index)
					local _, v7 = split(v6, v4 + 1)
					applyShift(v7, -#change.keys) -- inferred equivalent call
					v5 = join(v5, v7) -- inferred equivalent call
					v3 = v5
				elseif change.type == DataSourceChangeType.Move then
					local fromIndex = change.fromIndex
					local toIndex = change.toIndex

					if fromIndex < toIndex then
						local v4, v5 = split(v3, fromIndex)
						local v6, v7 = split(v5, fromIndex + 1)
						local v8, v9 = split(v7, toIndex + 1)
						applyShift(v8, -1) -- inferred equivalent call

						if v6 ~= nil then
							v6.index = toIndex
						end

						v4 = join(v4, v8) -- inferred equivalent call
						v4 = join(v4, v6) -- inferred equivalent call
						v4 = join(v4, v9) -- inferred equivalent call
						v3 = v4
					else
						local v4, v5 = split(v3, toIndex)
						local v6, v7 = split(v5, fromIndex)
						local v8, v9 = split(v7, fromIndex + 1)
						applyShift(v6, 1) -- inferred equivalent call

						if v8 ~= nil then
							v8.index = toIndex
						end

						v4 = join(v4, v8) -- inferred equivalent call
						v4 = join(v4, v6) -- inferred equivalent call
						v4 = join(v4, v9) -- inferred equivalent call
						v3 = v4
					end
				end
			end
		end,
		resolveActive = function(callback2)
			if flag then
				rebuild()
			end

			local v4 = v3
			local index = nil
			local index2 = nil

			while v4 ~= nil do
				push(v4) -- inferred equivalent call

				if callback2(v4.index) then
					index = v4.index
					v4 = v4.right
				else
					index2 = v4.index
					v4 = v4.left
				end
			end

			return index, index2
		end
	}
end

return createStickyIndexResolver
