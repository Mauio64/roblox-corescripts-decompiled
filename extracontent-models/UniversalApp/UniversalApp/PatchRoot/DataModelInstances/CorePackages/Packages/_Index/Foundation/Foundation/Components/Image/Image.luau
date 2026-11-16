local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local FoundationImages = require(parent.FoundationImages)
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

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

local v = { AutoLocalize = false, AutoButtonColor = false, BorderSizePixel = 0, isDisabled = false }

local function getAspectRatio(size: Vector2) -- 2 equivalent calls inferred from this helper
	return size.X / size.Y
end

local DEV__ = _G.__DEV__ == true

local function getFoundationImageAsset(p: string) -- 5 equivalent calls inferred from this helper
	local v2 = IconImages_DEPRECATED[p]

	if v2 then
		return v2
	end

	if DEV__ then
		return Images[p]
	end

	return (rawget(Images, p))
end

local function shouldUseFoundationSlice(p: string)
	return not not isFoundationImage(p) and (isCloudAsset(p) or getFoundationImageAsset(p) ~= nil) -- inferred equivalent call
end

local function Image(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = v2.onStateChanged ~= nil or v2.onActivated ~= nil or v2.onSecondaryActivated ~= nil

	local aspectRatio = v2.aspectRatio

	local state, setState = React.useState(false)
	React.useEffect(function()
		if not ReactIs.isBinding(v2.Image) then
			return
		end

		local image = v2.Image
		setState(isCloudAsset(image:getValue()))

		local __subscribeToBinding = React.__subscribeToBinding(image, function(p2: string)
			setState(isCloudAsset(p2))
		end)

		return function()
			__subscribeToBinding()
		end
	end, { v2.Image, aspectRatio })

	local image2, imageRectOffset, imageRectSize, aspectRatio2 = React.useMemo(function()
		local image = v2.Image
		local v4

		if v2.imageRect then
			v4 = v2.imageRect.offset
		end

		local v5

		if v2.imageRect then
			v5 = v2.imageRect.size
		end

		local v6 = aspectRatio

		if ReactIs.isBinding(v2.Image) then
			local function getImageBindingValue(p2) -- 4 equivalent calls inferred from this helper
				return v2.Image:map(function(p3: string)
					if isFoundationImage(p3) then
						if isCloudAsset(p3) then
							local asset = Assets[p3]

							if p2 == "Image" then
								return asset.assetId
							end

							if p2 ~= "AspectRatio" then
								return nil
							end

							return getAspectRatio(asset.size) -- inferred equivalent call
						else
							local foundationImageAsset = getFoundationImageAsset(p3) -- inferred equivalent call

							if p2 == "AspectRatio" then
								return aspectRatio
							end

							if foundationImageAsset then
								return foundationImageAsset[p2]
							end

							return if p2 == "Image" then p3 else nil
						end
					else
						if p2 == "Image" then
							return p3
						end

						if p2 == "ImageRectOffset" and v2.imageRect then
							return v2.imageRect.offset
						end

						if p2 == "ImageRectSize" and v2.imageRect then
							return v2.imageRect.size
						end

						return nil
					end
				end)
			end

			local v7

			if state then
				v7 = getImageBindingValue("AspectRatio") -- inferred equivalent call
			else
				v7 = aspectRatio
			end

			return
				getImageBindingValue("Image"), -- inferred equivalent call
				getImageBindingValue("ImageRectOffset"), -- inferred equivalent call
				getImageBindingValue("ImageRectSize"), -- inferred equivalent call
				v7
		end

		if typeof(v2.Image) ~= "string" or not isFoundationImage(v2.Image) then
			return image, v4, v5, v6
		end

		if isCloudAsset(v2.Image) then
			local asset = Assets[v2.Image]
			return asset.assetId, v4, v5, getAspectRatio(asset.size) -- inferred equivalent call
		else
			local foundationImageAsset = getFoundationImageAsset(v2.Image) -- inferred equivalent call

			if foundationImageAsset then
				image = foundationImageAsset.Image
				v4 = foundationImageAsset.ImageRectOffset
				v5 = foundationImageAsset.ImageRectSize
			end

			return image, v4, v5, v6
		end
	end, { v2.Image, v2.imageRect, state, aspectRatio, Images })

	local sliceCenter = nil
	local sliceScale = nil
	local scaleType = v2.ScaleType

	if v2.slice then
		if ReactIs.isBinding(v2.Image) then
			local mapped = v2.Image:map(function(p2: string)
				local v4

				if isFoundationImage(p2) then
					v4 = isCloudAsset(p2) or getFoundationImageAsset(p2) ~= nil -- inferred equivalent call
				else
					v4 = false
				end

				if v4 then
					return getScaledSlice(v2.slice.center, v2.slice.scale)
				end

				return v2.slice
			end)

			sliceCenter = mapped:map(function(p2)
				return p2.center
			end)

			sliceScale = mapped:map(function(p2)
				return p2.scale
			end)
		elseif typeof(v2.Image) == "string" then
			local image = v2.Image
			local v4

			if isFoundationImage(image) then
				v4 = isCloudAsset(image) or getFoundationImageAsset(image) ~= nil -- inferred equivalent call
			else
				v4 = false
			end

			if v4 then
				local scaledSlice = getScaledSlice(v2.slice.center, v2.slice.scale)
				sliceCenter = scaledSlice.center
				sliceScale = scaledSlice.scale
			else
				sliceCenter = v2.slice.center
				sliceScale = v2.slice.scale
			end
		end

		scaleType = Enum.ScaleType.Slice
	end

	v2.aspectRatio = aspectRatio2

	local v4 = v2.backgroundStyle == nil and "gui-object-defaults" or "gui-object-defaults x-default-transparency"

	local v5 = useStyleTags((useDefaultTags(v2.tag, v4)))
	useOnLoaded(image2, v2.onLoaded)

	local imageContent = React.useMemo(function()
		if ReactIs.isBinding(v2.ImageContent) then
			return v2.ImageContent:map(function(value)
				if typeof(value) == "string" then
					return Content.fromUri(value)
				end

				return value
			end)
		end

		if typeof(v2.ImageContent) == "string" then
			return Content.fromUri(v2.ImageContent)
		end

		return v2.ImageContent
	end, { v2.ImageContent })
	local component = v3 and "ImageButton" or "ImageLabel"
	local autoButtonColor

	if component == "ImageButton" then
		autoButtonColor = v2.AutoButtonColor
	end

	local imageColor

	if v2.imageStyle then
		imageColor = indexBindable(v2.imageStyle, "Color3")
	end

	local imageTransparency

	if v2.imageStyle then
		imageTransparency = indexBindable(v2.imageStyle, "Transparency")
	end

	local v6 = withGuiObjectProps(v2, {
		AutoButtonColor = autoButtonColor,
		Image = image2,
		ImageContent = imageContent,
		ImageColor3 = imageColor,
		ImageTransparency = imageTransparency,
		ImageRectOffset = imageRectOffset,
		ImageRectSize = imageRectSize,
		ResampleMode = v2.ResampleMode,
		ScaleType = scaleType,
		SliceCenter = sliceCenter,
		SliceScale = sliceScale,
		TileSize = v2.TileSize,
		ref = ref,
		[React.Tag] = v5
	})
	local v7

	if v3 then
		v7 = Interactable
		v6.component = component
		v6.onActivated = v2.onActivated
		v6.onSecondaryActivated = v2.onSecondaryActivated
		v6.onStateChanged = v2.onStateChanged
		v6.stateLayer = v2.stateLayer
		v6.isDisabled = v2.isDisabled
		v6.cursor = v2.cursor
	else
		v7 = component
	end

	return React.createElement(v7, v6, GuiObjectChildren(v2))
end

return React.memo(React.forwardRef(Image))
