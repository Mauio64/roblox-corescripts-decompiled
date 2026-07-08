local ParentParent = script.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array

local function getSceneIndicesForInterpolationInputRange(p1) -- line: 5
	-- upvalues: Array (copy)
	local scene = p1.scene
	local scenes = p1.scenes
	local index = scene.index
	local v8 = #scenes

	if not scenes[v8].isActive then
		local v9 = Array.indexOf(scenes, scene)
		local v10 = nil

		for v11, v12 in scenes do
			if v12.isActive then
				v10 = v11

				break
			end
		end

		local index2 = scenes[v10].index
		local index3 = scenes[v8].index

		if index ~= index2 and v9 == v8 then
			return {
				first = math.min(index2, index - 1),
				last = index + 1
			}
		end

		if index == index2 and v9 == v10 then
			return {
				first = index - 1,
				last = math.max(index3, index + 1)
			}
		end

		if index == index2 or v10 < v9 then
			return nil
		end
	end

	return {
		first = index - 1,
		last = index + 1
	}
end

return getSceneIndicesForInterpolationInputRange
