local ancestor = script:FindFirstAncestor("ultimate-list")

require(ancestor.Dimensions)

local DimensionsMethods = require(ancestor.Dimensions.DimensionsMethods)
local React = require(ancestor.Parent.React)
local adjustPositionToScrollAxis = require(ancestor.Dimensions.adjustPositionToScrollAxis)
local createDebugLogger = require(ancestor.Util.createDebugLogger)

require(ancestor.createVirtualizedListController)

local joinAndMapBindings = require(ancestor.Util.joinAndMapBindings)
local createElement = React.createElement
local v8 = createDebugLogger("ReactBindingsRenderer")

local function getKeyDefault(_, n1: number) -- line: 15
	return (tostring(n1))
end
local function ReactBindingsRenderer(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), DimensionsMethods (copy), getKeyDefault (copy), v8 (copy), createElement (copy), joinAndMapBindings (copy), adjustPositionToScrollAxis (copy)
	local v14, v15 = React.useState(function() -- line: 48
		-- upvalues: DimensionsMethods (copy), t1 (copy), React (copy)
		local t2 = {}
		local v23 = DimensionsMethods.elementsDisplayedHint(t1.dimensions, t1.virtualizedListController.getWindowSize(), t1.direction)

		if v23 == nil then
			return t2
		end

		for _ = 1, v23 do
			local v25, v26 = React.createBinding({
				contents = {
					type = "vacant"
				}
			})

			table.insert(t2, {
				binding = v25,
				set = v26
			})
		end

		return t2
	end)
	local v16 = t1.getKey or getKeyDefault

	React.useEffect(function() -- line: 79
		-- upvalues: t1 (copy), v16 (copy), v14 (copy), v8 (copy), React (copy), v15 (copy)
		return t1.virtualizedListController.bindToUpdate(function() -- line: 80
			-- upvalues: t1 (copy), v16 (copy), v14 (copy), v8 (copy), React (copy), v15 (copy)
			local v33 = t1.virtualizedListController.get()
			local v34 = t1.virtualizedListController.getRange()
			local t3 = {}

			for v36, v37 in v33 do
				t3[v16(v37, v36 + (v34.X - 1))] = v36
			end

			local t4 = {}
			local t5 = {}
			local t6 = {}

			for _, v42 in v14 do
				local v43 = v42.binding:getValue()

				if v43.contents.type == "vacant" then
					table.insert(t5, v42.set)
				else
					local key = v43.contents.key
					local v45 = t3[key]

					if v45 == nil then
						v8("%s is now dead", key)
						table.insert(t4, v42.set)
					else
						t3[key] = nil

						local v46 = v33[v45]

						if v46 ~= v43.contents.value then
							v8("%s existed, but changed", key)
							v42.set({
								contents = {
									type = "full",
									index = v45 + (v34.X - 1),
									key = key,
									value = v46
								}
							})
						end
					end
				end
			end

			v8("%d total setters, %d dead setters, %d vacant setters", #v14, #t4, #t5)

			for v47, v48 in t3 do
				assert(v48 ~= nil, "Luau")

				local v49 = v33[v48]
				local t7 = {
					contents = {
						type = "full",
						index = v48 + (v34.X - 1),
						key = v47,
						value = v49
					}
				}
				local v51 = table.remove(t4)

				if v51 ~= nil then
					v8("%s is filling dead spot", v47)
					v51(t7)
				else
					local v52 = table.remove(t5)

					if v52 ~= nil then
						v8("%s is filling vacant spot", v47)
						v52(t7)
					else
						local v53, v54 = React.createBinding(t7)

						table.insert(t6, {
							binding = v53,
							set = v54
						})
					end
				end
			end

			if #t6 > 0 then
				v8("Needed to create %d more bindings to fit, there will be %d setters", #t6, #t6 + #v14)
				v15(function(p2) -- line: 177
					-- upvalues: t6 (copy)
					local v58 = table.clone(p2)

					table.move(t6, 1, #t6, #v58 + 1, v58)

					return v58
				end)
			end

			for _, v56 in t4 do
				v56({
					contents = {
						type = "vacant"
					}
				})
			end
		end)
	end, {
		t1.virtualizedListController,
		v16,
		v14
	})

	local t8 = {}

	for v18, v19 in v14 do
		local binding = v19.binding
		local v21 = binding:map(function(t9: {[any]: any}) -- line: 199
			-- upvalues: DimensionsMethods (copy), t1 (copy)
			if t9.contents.type == "vacant" then
				return {
					size = UDim2.new(),
					position = UDim2.new()
				}
			end

			return DimensionsMethods.getUDimRect(t1.dimensions, t9.contents.value, t9.contents.index, t1.virtualizedListController.getWindowSize(), t1.direction)
		end)

		t8[`Item{ v18 }`] = createElement("Frame", {
			BackgroundTransparency = 1,
			Position = joinAndMapBindings(function(p3, n2: number) -- line: 219
				-- upvalues: adjustPositionToScrollAxis (copy), t1 (copy)
				return adjustPositionToScrollAxis(p3.position, n2, t1.direction)
			end, v21, t1.scrollAxisBinding),
			Size = v21:map(function(p4) -- line: 223
				return p4.size
			end),
			Visible = binding:map(function(t10: {[any]: any}) -- line: 227
				return t10.contents.type == "full"
			end)
		}, {
			Content = t1.callback(binding:map(function(t11: {[any]: any}) -- line: 231
				if t11.contents.type == "full" then
					return t11.contents.value
				end

				return nil
			end))
		})
	end

	return createElement(React.Fragment, {}, t8)
end

return (React.memo(ReactBindingsRenderer))
