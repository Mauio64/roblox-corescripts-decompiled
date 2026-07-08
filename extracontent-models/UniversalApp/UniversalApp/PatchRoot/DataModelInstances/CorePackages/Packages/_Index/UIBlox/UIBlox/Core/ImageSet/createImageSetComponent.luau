local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local uiblox = require(ParentParentParent.BuilderIcons).Migration.uiblox
local Foundation = require(ParentParentParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local scaleSliceToResolution = require(ParentParent.App.ImageSet.scaleSliceToResolution)
local ImagesInverse = require(ParentParent.App.ImageSet.ImagesInverse)
local getBuilderIconElement = require(scriptParent.getBuilderIconElement)

return function(p1, p2) -- line: 16
	-- upvalues: Roact (copy), uiblox (copy), useTokens (copy), useTextSizeOffset (copy), ImagesInverse (copy), getBuilderIconElement (copy), scaleSliceToResolution (copy)
	assert(p2 > 0, "resolutionScale for ImageSet must be greater than 0! got " .. tostring(p2))

	return Roact.forwardRef(function(p3, p4) -- line: 22
		-- upvalues: Roact (copy), uiblox (copy), useTokens (copy), useTextSizeOffset (copy), ImagesInverse (copy), getBuilderIconElement (copy), p1 (copy), p2 (copy), scaleSliceToResolution (copy)
		local t1 = {
			[Roact.Ref] = p4,
			[Roact.Children] = p3[Roact.Children]
		}
		local v17 = nil
		local vImage = nil
		local v19 = false
		local v20 = false

		for k, v in pairs(p3) do
			if k == "Image" and typeof(v) == "table" then
				if uiblox[v.Image] then
					v20 = true
					vImage = v.Image
				else
					v19 = true
					v17 = v
				end
			else
				t1[k] = v
			end
		end

		local v23 = useTokens()
		local v24 = useTextSizeOffset()

		if v19 or v20 then
			local v25 = if not v20 then ImagesInverse[v17] else vImage

			if v25 and uiblox[v25] then
				if not v23.Stroke then
					error(`No StyleProvider in tree for migrated icon ImageSetComponent.\n UIBlox Icon: { v25 }, BuilderIcon: { uiblox[v25] }`)
				end

				local Standard = v23.Stroke.Standard

				return getBuilderIconElement(t1, p1, uiblox[v25], v25, v23, v24, Standard)
			end
		end

		if v19 then
			for k, v in pairs(v17) do
				if not t1[k] then
					t1[k] = v
				elseif k == "ImageRectOffset" then
					t1[k] = v + t1[k] * p2
				elseif k == "ImageRectSize" then
					t1[k] = t1[k] * p2
				end
			end
		end

		if v19 then
			t1 = scaleSliceToResolution(t1, p2)
		end

		return Roact.createElement(p1, t1)
	end)
end
