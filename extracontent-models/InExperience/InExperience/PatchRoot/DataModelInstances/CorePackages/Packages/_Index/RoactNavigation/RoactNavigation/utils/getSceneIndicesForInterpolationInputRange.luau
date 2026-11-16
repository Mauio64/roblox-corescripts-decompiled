local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local function getSceneIndicesForInterpolationInputRange(p)
	local scene = p.scene
	local scenes = p.scenes

	local index = scene.index
	local count = #scenes

	if not scenes[count].isActive then
		local index2 = Array.indexOf(scenes, scene)
		local v = nil

		for k, scene2 in scenes do
			if scene2.isActive then
				v = k
				break
			end
		end

		local index3 = scenes[v].index
		local index4 = scenes[count].index

		if index ~= index3 and index2 == count then
			return {
				first = math.min(index3, index - 1),
				last = index + 1
			}
		end

		if index == index3 and index2 == v then
			return {
				first = index - 1,
				last = math.max(index4, index + 1)
			}
		end

		if index == index3 or v < index2 then
			return nil
		end
	end

	return {
		first = index - 1,
		last = index + 1
	}
end

return getSceneIndicesForInterpolationInputRange
