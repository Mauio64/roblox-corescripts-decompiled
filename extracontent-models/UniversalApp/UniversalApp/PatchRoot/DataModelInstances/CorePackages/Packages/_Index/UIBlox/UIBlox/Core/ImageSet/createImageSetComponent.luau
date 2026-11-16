local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local Roact = require(parent3.Roact)
local BuilderIcons = require(parent3.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local Foundation = require(parent3.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local scaleSliceToResolution = require(parent2.App.ImageSet.scaleSliceToResolution)
local ImagesInverse = require(parent2.App.ImageSet.ImagesInverse)
local getBuilderIconElement = require(parent.getBuilderIconElement)

return function(p, p2)
	assert(p2 > 0, "resolutionScale for ImageSet must be greater than 0! got " .. tostring(p2))

	return Roact.forwardRef(function(props, p3)
		local v = { [Roact.Ref] = p3, [Roact.Children] = props[Roact.Children] }
		local flag = false
		local v2 = false
		local v3 = nil
		local v4 = nil

		for k, v5 in pairs(props) do
			if k == "Image" and typeof(v5) == "table" then
				if uiblox[v5.Image] then
					v3 = v5.Image
					v2 = true
				else
					v4 = v5
					flag = true
				end
			else
				v[k] = v5
			end
		end

		local v5 = useTokens()
		local v6 = useTextSizeOffset()

		if flag or v2 then
			if not v2 then
				v3 = ImagesInverse[v4]
			end

			if v3 and uiblox[v3] then
				if not v5.Stroke then
					error(`No StyleProvider in tree for migrated icon ImageSetComponent.\n UIBlox Icon: {v3}, BuilderIcon: {uiblox[v3]}`)
				end

				local standard = v5.Stroke.Standard
				return getBuilderIconElement(v, p, uiblox[v3], v3, v5, v6, standard)
			end
		end

		if flag then
			for k, v7 in pairs(v4) do
				if v[k] then
					if k == "ImageRectOffset" then
						v.ImageRectOffset = v7 + v.ImageRectOffset * p2
					elseif k == "ImageRectSize" then
						v.ImageRectSize *= p2
					end
				else
					v[k] = v7
				end
			end
		end

		if flag then
			v = scaleSliceToResolution(v, p2)
		end

		return Roact.createElement(p, v)
	end)
end
