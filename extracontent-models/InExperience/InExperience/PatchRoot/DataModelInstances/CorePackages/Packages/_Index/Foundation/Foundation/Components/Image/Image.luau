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

local function getAspectRatio(vector2: Vector2) -- line: 60
	return vector2.X / vector2.Y
end

local v23 = _G.__DEV__ == true

local function getFoundationImageAsset(s1: string) -- line: 66
	-- upvalues: IconImages_DEPRECATED (copy), v23 (copy), Images (copy)
	local v29 = IconImages_DEPRECATED[s1]

	if v29 then
		return v29
	end

	if v23 then
		return Images[s1]
	end

	return (rawget(Images, s1))
end
local function shouldUseFoundationSlice(s2: string) -- line: 82
	-- upvalues: isFoundationImage (copy), isCloudAsset (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy)
	if not isFoundationImage(s2) then
		return false
	end

	local v31 = isCloudAsset(s2)

	if not v31 then
		local v32 = IconImages_DEPRECATED[s2]

		v31 = ((if not v32 then (if not v23 then rawget(Images, s2) else Images[s2]) else v32)) ~= nil
	end

	return v31
end
local function Image(p1, p2) -- line: 93
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), ReactIs (copy), isCloudAsset (copy), isFoundationImage (copy), Assets (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), getScaledSlice (copy), useDefaultTags (copy), useStyleTags (copy), useOnLoaded (copy), withGuiObjectProps (copy), indexBindable (copy), Interactable (copy), GuiObjectChildren (copy)
	local v35 = withDefaults(p1, t1)
	local v36 = v35.onStateChanged ~= nil or (v35.onActivated ~= nil or v35.onSecondaryActivated ~= nil)
	local aspectRatio = v35.aspectRatio
	local v38, v39 = React.useState(false)

	React.useEffect(function() -- line: 101
		-- upvalues: ReactIs (copy), v35 (copy), v39 (copy), isCloudAsset (copy), React (copy)
		if not ReactIs.isBinding(v35.Image) then
			return
		end

		local Image2 = v35.Image

		v39(isCloudAsset(Image2:getValue()))

		local v59 = React.__subscribeToBinding(Image2, function(s3: string) -- line: 109
			-- upvalues: v39 (copy), isCloudAsset (copy)
			v39(isCloudAsset(s3))
		end)

		return function() -- line: 113
			-- upvalues: v59 (copy)
			v59()
		end
	end, {
		v35.Image,
		aspectRatio
	})

	local v40, v41, v42, v43 = React.useMemo(function() -- line: 119
		-- upvalues: v35 (copy), aspectRatio (copy), ReactIs (copy), isFoundationImage (copy), isCloudAsset (copy), Assets (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), v38 (copy)
		local Image3 = v35.Image
		local v61 = if not v35.imageRect then nil else v35.imageRect.offset
		local v62 = if not v35.imageRect then nil else v35.imageRect.size
		local v63 = aspectRatio

		if ReactIs.isBinding(v35.Image) then
			local function getImageBindingValue(p3) -- line: 130
				-- upvalues: v35 (copy), isFoundationImage (copy), isCloudAsset (copy), Assets (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), aspectRatio (copy)
				return v35.Image:map(function(s4: string) -- line: 131
					-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), p3 (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), aspectRatio (copy), v35 (copy)
					if isFoundationImage(s4) then
						if isCloudAsset(s4) then
							local v104 = Assets[s4]

							if p3 == "Image" then
								return v104.assetId
							end

							if p3 == "AspectRatio" then
								local size = v104.size

								return size.X / size.Y
							end

							return nil
						end

						local v106 = IconImages_DEPRECATED[s4]
						local v107 = if not v106 then if not v23 then rawget(Images, s4) else Images[s4] else v106

						if p3 == "AspectRatio" then
							return aspectRatio
						end

						if v107 then
							return v107[p3]
						end

						if p3 == "Image" then
							return s4
						end

						return nil
					end

					if p3 == "Image" then
						return s4
					end

					if p3 == "ImageRectOffset" and v35.imageRect then
						return v35.imageRect.offset
					end

					if p3 == "ImageRectSize" and v35.imageRect then
						return v35.imageRect.size
					end

					return nil
				end)
			end

			local v66

			if v38 then
				local s5 = "AspectRatio"

				v66 = v35.Image:map(function(s6: string) -- line: 131
					-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s5 (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), aspectRatio (copy), v35 (copy)
					if isFoundationImage(s6) then
						if isCloudAsset(s6) then
							local v84 = Assets[s6]

							if s5 == "Image" then
								return v84.assetId
							end

							if s5 == "AspectRatio" then
								local size = v84.size

								return size.X / size.Y
							end

							return nil
						end

						local v86 = IconImages_DEPRECATED[s6]
						local v87 = if not v86 then if not v23 then rawget(Images, s6) else Images[s6] else v86

						if s5 == "AspectRatio" then
							return aspectRatio
						end

						if v87 then
							return v87[s5]
						end

						if s5 == "Image" then
							return s6
						end

						return nil
					end

					if s5 == "Image" then
						return s6
					end

					if s5 == "ImageRectOffset" and v35.imageRect then
						return v35.imageRect.offset
					end

					if s5 == "ImageRectSize" and v35.imageRect then
						return v35.imageRect.size
					end

					return nil
				end)
			else
				v66 = aspectRatio
			end

			local s7 = "Image"
			local s8 = "ImageRectOffset"
			local s9 = "ImageRectSize"

			return v35.Image:map(function(s10: string) -- line: 131
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s7 (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), aspectRatio (copy), v35 (copy)
				if isFoundationImage(s10) then
					if isCloudAsset(s10) then
						local v89 = Assets[s10]

						if s7 == "Image" then
							return v89.assetId
						end

						if s7 == "AspectRatio" then
							local size = v89.size

							return size.X / size.Y
						end

						return nil
					end

					local v91 = IconImages_DEPRECATED[s10]
					local v92 = if not v91 then if not v23 then rawget(Images, s10) else Images[s10] else v91

					if s7 == "AspectRatio" then
						return aspectRatio
					end

					if v92 then
						return v92[s7]
					end

					if s7 == "Image" then
						return s10
					end

					return nil
				end

				if s7 == "Image" then
					return s10
				end

				if s7 == "ImageRectOffset" and v35.imageRect then
					return v35.imageRect.offset
				end

				if s7 == "ImageRectSize" and v35.imageRect then
					return v35.imageRect.size
				end

				return nil
			end), v35.Image:map(function(s11: string) -- line: 131
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s8 (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), aspectRatio (copy), v35 (copy)
				if isFoundationImage(s11) then
					if isCloudAsset(s11) then
						local v94 = Assets[s11]

						if s8 == "Image" then
							return v94.assetId
						end

						if s8 == "AspectRatio" then
							local size = v94.size

							return size.X / size.Y
						end

						return nil
					end

					local v96 = IconImages_DEPRECATED[s11]
					local v97 = if not v96 then if not v23 then rawget(Images, s11) else Images[s11] else v96

					if s8 == "AspectRatio" then
						return aspectRatio
					end

					if v97 then
						return v97[s8]
					end

					if s8 == "Image" then
						return s11
					end

					return nil
				end

				if s8 == "Image" then
					return s11
				end

				if s8 == "ImageRectOffset" and v35.imageRect then
					return v35.imageRect.offset
				end

				if s8 == "ImageRectSize" and v35.imageRect then
					return v35.imageRect.size
				end

				return nil
			end), v35.Image:map(function(s12: string) -- line: 131
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), Assets (copy), s9 (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), aspectRatio (copy), v35 (copy)
				if isFoundationImage(s12) then
					if isCloudAsset(s12) then
						local v99 = Assets[s12]

						if s9 == "Image" then
							return v99.assetId
						end

						if s9 == "AspectRatio" then
							local size = v99.size

							return size.X / size.Y
						end

						return nil
					end

					local v101 = IconImages_DEPRECATED[s12]
					local v102 = if not v101 then if not v23 then rawget(Images, s12) else Images[s12] else v101

					if s9 == "AspectRatio" then
						return aspectRatio
					end

					if v102 then
						return v102[s9]
					end

					if s9 == "Image" then
						return s12
					end

					return nil
				end

				if s9 == "Image" then
					return s12
				end

				if s9 == "ImageRectOffset" and v35.imageRect then
					return v35.imageRect.offset
				end

				if s9 == "ImageRectSize" and v35.imageRect then
					return v35.imageRect.size
				end

				return nil
			end), v66
		end

		if typeof(v35.Image) == "string" and isFoundationImage(v35.Image) then
			if isCloudAsset(v35.Image) then
				local v70 = Assets[v35.Image]
				local assetId = v70.assetId
				local size = v70.size

				return assetId, v61, v62, size.X / size.Y
			end

			local Image4 = v35.Image
			local v74 = IconImages_DEPRECATED[Image4]
			local v75 = if not v74 then if not v23 then rawget(Images, Image4) else Images[Image4] else v74

			if v75 then
				Image3 = v75.Image
				v61 = v75.ImageRectOffset
				v62 = v75.ImageRectSize
			end
		end

		return Image3, v61, v62, v63
	end, {
		v35.Image,
		v35.imageRect,
		v38,
		aspectRatio,
		Images
	})
	local v44 = nil
	local v45 = nil
	local ScaleType = v35.ScaleType

	if v35.slice then
		if ReactIs.isBinding(v35.Image) then
			local v47 = v35.Image:map(function(s13: string) -- line: 196
				-- upvalues: isFoundationImage (copy), isCloudAsset (copy), IconImages_DEPRECATED (copy), v23 (copy), Images (copy), getScaledSlice (copy), v35 (copy)
				local v77

				if not isFoundationImage(s13) then
					v77 = false
				else
					v77 = isCloudAsset(s13)

					if not v77 then
						local v78 = IconImages_DEPRECATED[s13]

						v77 = ((if not v78 then (if not v23 then rawget(Images, s13) else Images[s13]) else v78)) ~= nil
					end
				end

				if v77 then
					return getScaledSlice(v35.slice.center, v35.slice.scale)
				end

				return v35.slice
			end)

			v44 = v47:map(function(p4) -- line: 203
				return p4.center
			end)
			v45 = v47:map(function(p5) -- line: 206
				return p5.scale
			end)
		elseif typeof(v35.Image) == "string" then
			local Image5 = v35.Image
			local v49

			if not isFoundationImage(Image5) then
				v49 = false
			else
				v49 = isCloudAsset(Image5)

				if not v49 then
					local v50 = IconImages_DEPRECATED[Image5]

					v49 = ((if not v50 then (if not v23 then rawget(Images, Image5) else Images[Image5]) else v50)) ~= nil
				end
			end

			if v49 then
				local v51 = getScaledSlice(v35.slice.center, v35.slice.scale)

				v44 = v51.center
				v45 = v51.scale
			else
				v44 = v35.slice.center
				v45 = v35.slice.scale
			end
		end

		ScaleType = Enum.ScaleType.Slice
	end

	v35.aspectRatio = v43

	local v52 = v35.backgroundStyle == nil and "gui-object-defaults" or "gui-object-defaults x-default-transparency"
	local v53 = useDefaultTags(v35.tag, v52)
	local v54 = useStyleTags(v53)

	useOnLoaded(v40, v35.onLoaded)

	local v55 = not v36 and "ImageLabel" or "ImageButton"
	local v56 = withGuiObjectProps(v35, {
		AutoButtonColor = if v55 ~= "ImageButton" then nil else v35.AutoButtonColor,
		Image = v40,
		ImageColor3 = if not v35.imageStyle then nil else indexBindable(v35.imageStyle, "Color3"),
		ImageTransparency = if not v35.imageStyle then nil else indexBindable(v35.imageStyle, "Transparency"),
		ImageRectOffset = v41,
		ImageRectSize = v42,
		ResampleMode = v35.ResampleMode,
		ScaleType = ScaleType,
		SliceCenter = v44,
		SliceScale = v45,
		TileSize = v35.TileSize,
		ref = p2,
		[React.Tag] = v54
	})
	local v57 = v55

	if v36 then
		v57 = Interactable
		v56.component = v55
		v56.onActivated = v35.onActivated
		v56.onSecondaryActivated = v35.onSecondaryActivated
		v56.onStateChanged = v35.onStateChanged
		v56.stateLayer = v35.stateLayer
		v56.isDisabled = v35.isDisabled
		v56.cursor = v35.cursor
	end

	return React.createElement(v57, v56, GuiObjectChildren(v35))
end

return React.memo(React.forwardRef(Image))
