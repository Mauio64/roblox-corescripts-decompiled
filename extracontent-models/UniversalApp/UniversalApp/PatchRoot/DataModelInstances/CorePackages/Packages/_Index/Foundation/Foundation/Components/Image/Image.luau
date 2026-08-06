local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local FoundationCloudAssets = require(FoundationParent.FoundationCloudAssets)
local FoundationImages = require(FoundationParent.FoundationImages)
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local useOnLoaded = require(script.Parent.useOnLoaded)
local Assets = FoundationCloudAssets.Assets
local Interactable = require(Foundation.Components.Interactable)
local Images = FoundationImages.Images
local IconImages_DEPRECATED = FoundationImages.IconImages_DEPRECATED
local getScaledSlice = require(script.Parent.ImageSet.getScaledSlice)
local isCloudAsset = require(script.Parent.CloudAsset.isCloudAsset)
local isFoundationImage = require(script.Parent.ImageSet.isFoundationImage)
local Flags = require(Foundation.Utility.Flags)
local GuiObjectChildren = require(Foundation.Utility.GuiObjectChildren)

require(Foundation.Components.Types)

local indexBindable = require(Foundation.Utility.indexBindable)
local useDefaultTags = require(Foundation.Utility.useDefaultTags)
local withDefaults = require(Foundation.Utility.withDefaults)
local withGuiObjectProps = require(Foundation.Utility.withGuiObjectProps)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)
local t1 = {
	AutoLocalize = false,
	AutoButtonColor = false,
	BorderSizePixel = 0,
	isDisabled = false
}

local function getAspectRatio(vector2: Vector2) -- line: 62
	return vector2.X / vector2.Y
end

local v24 = _G.__DEV__ == true

local function getFoundationImageAsset(s1: string) -- line: 68
	-- upvalues: IconImages_DEPRECATED (copy), v24 (copy), Images (copy)
	local v30 = IconImages_DEPRECATED[s1]

	if v30 then
		return v30
	end

	if v24 then
		return Images[s1]
	end

	return (rawget(Images, s1))
end
local function shouldUseFoundationSlice(s2: string) -- line: 84
	-- upvalues: isFoundationImage (copy), isCloudAsset (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy)
	if not isFoundationImage(s2) then
		return false
	end

	local v32 = isCloudAsset(s2)

	if not v32 then
		local v33 = IconImages_DEPRECATED[s2]

		v32 = ((if not v33 then (if not v24 then rawget(Images, s2) else Images[s2]) else v33)) ~= nil
	end

	return v32
end
local function Image(p1, p2) -- line: 95
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), ReactIs (copy), isCloudAsset (copy), isFoundationImage (copy), Assets (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), getScaledSlice (copy), useDefaultTags (copy), useStyleTags (copy), useOnLoaded (copy), Flags (copy), withGuiObjectProps (copy), indexBindable (copy), Interactable (copy), GuiObjectChildren (copy)
	local v36 = withDefaults(p1, t1)
	local v37 = v36.onStateChanged ~= nil or (v36.onActivated ~= nil or v36.onSecondaryActivated ~= nil)
	local aspectRatio = v36.aspectRatio
	local v39, v40 = React.useState(false)

	React.useEffect(function() -- line: 103
		-- upvalues: ReactIs (copy), v36 (copy), v40 (copy), isCloudAsset (copy), React (copy)
		if not ReactIs.isBinding(v36.Image) then
			return
		end

		local Image2 = v36.Image

		v40(isCloudAsset(Image2:getValue()))

		local v61 = React.__subscribeToBinding(Image2, function(s3: string) -- line: 111
			-- upvalues: v40 (copy), isCloudAsset (copy)
			v40(isCloudAsset(s3))
		end)

		return function() -- line: 115
			-- upvalues: v61 (copy)
			v61()
		end
	end, {
		v36.Image,
		aspectRatio
	})

	local v41, v42, v43, v44 = React.useMemo(function() -- line: 121
		-- upvalues: v36 (copy), aspectRatio (copy), ReactIs (copy), isFoundationImage (copy), isCloudAsset (copy), Assets (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), v39 (copy)
		local Image3 = v36.Image
		local v63 = if not v36.imageRect then nil else v36.imageRect.offset
		local v64 = if not v36.imageRect then nil else v36.imageRect.size
		local v65 = aspectRatio

		if ReactIs.isBinding(v36.Image) then
			local function getImageBindingValue(p3) -- line: 132
				-- upvalues: v36 (copy), isFoundationImage (copy), isCloudAsset (copy), Assets (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), aspectRatio (copy)
				return v36.Image:map(function(s4: string) -- line: 133
					-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), p3 (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), aspectRatio (copy), v36 (copy)
					if isFoundationImage(s4) then
						if isCloudAsset(s4) then
							local v107 = Assets[s4]

							if p3 == "Image" then
								return v107.assetId
							end

							if p3 == "AspectRatio" then
								local size = v107.size

								return size.X / size.Y
							end

							return nil
						end

						local v109 = IconImages_DEPRECATED[s4]
						local v110 = if not v109 then if not v24 then rawget(Images, s4) else Images[s4] else v109

						if p3 == "AspectRatio" then
							return aspectRatio
						end

						if v110 then
							return v110[p3]
						end

						if p3 == "Image" then
							return s4
						end

						return nil
					end

					if p3 == "Image" then
						return s4
					end

					if p3 == "ImageRectOffset" and v36.imageRect then
						return v36.imageRect.offset
					end

					if p3 == "ImageRectSize" and v36.imageRect then
						return v36.imageRect.size
					end

					return nil
				end)
			end

			local v68

			if v39 then
				local s5 = "AspectRatio"

				v68 = v36.Image:map(function(s6: string) -- line: 133
					-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s5 (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), aspectRatio (copy), v36 (copy)
					if isFoundationImage(s6) then
						if isCloudAsset(s6) then
							local v86 = Assets[s6]

							if s5 == "Image" then
								return v86.assetId
							end

							if s5 == "AspectRatio" then
								local size = v86.size

								return size.X / size.Y
							end

							return nil
						end

						local v88 = IconImages_DEPRECATED[s6]
						local v89 = if not v88 then if not v24 then rawget(Images, s6) else Images[s6] else v88

						if s5 == "AspectRatio" then
							return aspectRatio
						end

						if v89 then
							return v89[s5]
						end

						if s5 == "Image" then
							return s6
						end

						return nil
					end

					if s5 == "Image" then
						return s6
					end

					if s5 == "ImageRectOffset" and v36.imageRect then
						return v36.imageRect.offset
					end

					if s5 == "ImageRectSize" and v36.imageRect then
						return v36.imageRect.size
					end

					return nil
				end)
			else
				v68 = aspectRatio
			end

			local s7 = "Image"
			local s8 = "ImageRectOffset"
			local s9 = "ImageRectSize"

			return v36.Image:map(function(s10: string) -- line: 133
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s7 (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), aspectRatio (copy), v36 (copy)
				if isFoundationImage(s10) then
					if isCloudAsset(s10) then
						local v91 = Assets[s10]

						if s7 == "Image" then
							return v91.assetId
						end

						if s7 == "AspectRatio" then
							local size = v91.size

							return size.X / size.Y
						end

						return nil
					end

					local v93 = IconImages_DEPRECATED[s10]
					local v94 = if not v93 then if not v24 then rawget(Images, s10) else Images[s10] else v93

					if s7 == "AspectRatio" then
						return aspectRatio
					end

					if v94 then
						return v94[s7]
					end

					if s7 == "Image" then
						return s10
					end

					return nil
				end

				if s7 == "Image" then
					return s10
				end

				if s7 == "ImageRectOffset" and v36.imageRect then
					return v36.imageRect.offset
				end

				if s7 == "ImageRectSize" and v36.imageRect then
					return v36.imageRect.size
				end

				return nil
			end), v36.Image:map(function(s11: string) -- line: 133
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s8 (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), aspectRatio (copy), v36 (copy)
				if isFoundationImage(s11) then
					if isCloudAsset(s11) then
						local v96 = Assets[s11]

						if s8 == "Image" then
							return v96.assetId
						end

						if s8 == "AspectRatio" then
							local size = v96.size

							return size.X / size.Y
						end

						return nil
					end

					local v98 = IconImages_DEPRECATED[s11]
					local v99 = if not v98 then if not v24 then rawget(Images, s11) else Images[s11] else v98

					if s8 == "AspectRatio" then
						return aspectRatio
					end

					if v99 then
						return v99[s8]
					end

					if s8 == "Image" then
						return s11
					end

					return nil
				end

				if s8 == "Image" then
					return s11
				end

				if s8 == "ImageRectOffset" and v36.imageRect then
					return v36.imageRect.offset
				end

				if s8 == "ImageRectSize" and v36.imageRect then
					return v36.imageRect.size
				end

				return nil
			end), v36.Image:map(function(s12: string) -- line: 133
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s9 (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), aspectRatio (copy), v36 (copy)
				if isFoundationImage(s12) then
					if isCloudAsset(s12) then
						local v101 = Assets[s12]

						if s9 == "Image" then
							return v101.assetId
						end

						if s9 == "AspectRatio" then
							local size = v101.size

							return size.X / size.Y
						end

						return nil
					end

					local v103 = IconImages_DEPRECATED[s12]
					local v104 = if not v103 then if not v24 then rawget(Images, s12) else Images[s12] else v103

					if s9 == "AspectRatio" then
						return aspectRatio
					end

					if v104 then
						return v104[s9]
					end

					if s9 == "Image" then
						return s12
					end

					return nil
				end

				if s9 == "Image" then
					return s12
				end

				if s9 == "ImageRectOffset" and v36.imageRect then
					return v36.imageRect.offset
				end

				if s9 == "ImageRectSize" and v36.imageRect then
					return v36.imageRect.size
				end

				return nil
			end), v68
		end

		if typeof(v36.Image) == "string" and isFoundationImage(v36.Image) then
			if isCloudAsset(v36.Image) then
				local v72 = Assets[v36.Image]
				local assetId = v72.assetId
				local size = v72.size

				return assetId, v63, v64, size.X / size.Y
			end

			local Image4 = v36.Image
			local v76 = IconImages_DEPRECATED[Image4]
			local v77 = if not v76 then if not v24 then rawget(Images, Image4) else Images[Image4] else v76

			if v77 then
				Image3 = v77.Image
				v63 = v77.ImageRectOffset
				v64 = v77.ImageRectSize
			end
		end

		return Image3, v63, v64, v65
	end, {
		v36.Image,
		v36.imageRect,
		v39,
		aspectRatio,
		Images
	})
	local v45 = nil
	local v46 = nil
	local ScaleType = v36.ScaleType

	if v36.slice then
		if ReactIs.isBinding(v36.Image) then
			local v48 = v36.Image:map(function(s13: string) -- line: 198
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), IconImages_DEPRECATED (copy), v24 (copy), Images (copy), getScaledSlice (copy), v36 (copy)
				local v79

				if not isFoundationImage(s13) then
					v79 = false
				else
					v79 = isCloudAsset(s13)

					if not v79 then
						local v80 = IconImages_DEPRECATED[s13]

						v79 = ((if not v80 then (if not v24 then rawget(Images, s13) else Images[s13]) else v80)) ~= nil
					end
				end

				if v79 then
					return getScaledSlice(v36.slice.center, v36.slice.scale)
				end

				return v36.slice
			end)

			v45 = v48:map(function(p4) -- line: 205
				return p4.center
			end)
			v46 = v48:map(function(p5) -- line: 208
				return p5.scale
			end)
		elseif typeof(v36.Image) == "string" then
			local Image5 = v36.Image
			local v50

			if not isFoundationImage(Image5) then
				v50 = false
			else
				v50 = isCloudAsset(Image5)

				if not v50 then
					local v51 = IconImages_DEPRECATED[Image5]

					v50 = ((if not v51 then (if not v24 then rawget(Images, Image5) else Images[Image5]) else v51)) ~= nil
				end
			end

			if v50 then
				local v52 = getScaledSlice(v36.slice.center, v36.slice.scale)

				v45 = v52.center
				v46 = v52.scale
			else
				v45 = v36.slice.center
				v46 = v36.slice.scale
			end
		end

		ScaleType = Enum.ScaleType.Slice
	end

	v36.aspectRatio = v44

	local v53 = v36.backgroundStyle == nil and "gui-object-defaults" or "gui-object-defaults x-default-transparency"
	local v54 = useDefaultTags(v36.tag, v53)
	local v55 = useStyleTags(v54)

	useOnLoaded(v41, v36.onLoaded)

	local v56 = if not Flags.FoundationImageContentSupport then nil else React.useMemo(function() -- line: 232
		-- upvalues: ReactIs (copy), v36 (copy)
		if ReactIs.isBinding(v36.ImageContent) then
			return v36.ImageContent:map(function(p6) -- line: 235
				if typeof(p6) == "string" then
					return Content.fromUri(p6)
				end

				return p6
			end)
		end

		if typeof(v36.ImageContent) == "string" then
			return Content.fromUri(v36.ImageContent)
		end

		return v36.ImageContent
	end, { v36.ImageContent })
	local v57 = not v37 and "ImageLabel" or "ImageButton"
	local v58 = withGuiObjectProps(v36, {
		AutoButtonColor = if v57 ~= "ImageButton" then nil else v36.AutoButtonColor,
		Image = v41,
		ImageContent = v56,
		ImageColor3 = if not v36.imageStyle then nil else indexBindable(v36.imageStyle, "Color3"),
		ImageTransparency = if not v36.imageStyle then nil else indexBindable(v36.imageStyle, "Transparency"),
		ImageRectOffset = v42,
		ImageRectSize = v43,
		ResampleMode = v36.ResampleMode,
		ScaleType = ScaleType,
		SliceCenter = v45,
		SliceScale = v46,
		TileSize = v36.TileSize,
		ref = p2,
		[React.Tag] = v55
	})
	local v59 = v57

	if v37 then
		v59 = Interactable
		v58.component = v57
		v58.onActivated = v36.onActivated
		v58.onSecondaryActivated = v36.onSecondaryActivated
		v58.onStateChanged = v36.onStateChanged
		v58.stateLayer = v36.stateLayer
		v58.isDisabled = v36.isDisabled
		v58.cursor = v36.cursor
	end

	return React.createElement(v59, v58, GuiObjectChildren(v36))
end

return React.memo(React.forwardRef(Image))
