local ContentProvider = game:GetService("ContentProvider")

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)

local FFlagMomentsImageWithSkeletonRetry = require(Moments.Flags.FFlagMomentsImageWithSkeletonRetry)

local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local View = Foundation.View

local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local v = { frequency = 3, dampingRatio = 1 }

local function getCornerRadius(radius, p) -- 1 equivalent call inferred from this helper
	if radius == Radius.Circle then
		return UDim.new(1, 0)
	end

	return UDim.new(0, p.Radius[radius])
end

local function ImageWithSkeleton(props)
	local v2 = useTokens()
	local radius = props.radius or Radius.Medium
	local image = props.Image
	local v3

	if image == nil then
		v3 = false
	else
		v3 = image ~= ""
	end

	local state, setState = React.useState(v3)

	local groupTransparency, v4 = ReactOtter.useAnimatedBinding(0, function()
		if image ~= nil and ContentProvider:GetAssetFetchStatus(image) == Enum.AssetFetchStatus.Success then
			setState(false)
		end
	end)

	React.useEffect(function()
		setState(v3)

		if not v3 or image == nil or image == "" then
			v4((ReactOtter.instant(0)))
			return
		end

		local flag = true
		local function fadeInImage() -- 3 equivalent calls inferred from this helper
			if flag then
				v4((ReactOtter.spring(1, v)))
			end
		end

		if ContentProvider:GetAssetFetchStatus(image) == Enum.AssetFetchStatus.Success then
			fadeInImage() -- inferred equivalent call
			return function()
				flag = false
			end
		else
			v4((ReactOtter.instant(0)))

			if not FFlagMomentsImageWithSkeletonRetry then
				task.spawn(function()
					pcall(function()
						ContentProvider:PreloadAsync({ image }, function(p, p2)
							if p == image and p2 == Enum.AssetFetchStatus.Success then
								fadeInImage() -- inferred equivalent call
							end
						end)
					end)

					if ContentProvider:GetAssetFetchStatus(image) == Enum.AssetFetchStatus.Success then
						fadeInImage() -- inferred equivalent call
					end
				end)

				return function()
					flag = false
				end
			end

			local preloadImageWithRetry = require(script.Parent.preloadImageWithRetry)
			task.spawn(preloadImageWithRetry, image, {
				isCurrent = function()
					return flag
				end,
				onSuccess = fadeInImage,
				onGiveUp = function()
					setState(false)
				end
			})

			return function()
				flag = false
			end
		end
	end, { image, v3 })

	local imageStyle = props.imageStyle
	local imageStyle2

	if v3 and imageStyle ~= nil then
		imageStyle2 = React.joinBindings({ imageStyle, groupTransparency }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			return {
				Color3 = item.Color3,
				Transparency = 1 - (1 - item.Transparency) * item2
			}
		end)
	elseif v3 then
		imageStyle2 = groupTransparency:map(function(p: number)
			return {
				Color3 = Color3.new(1, 1, 1),
				Transparency = 1 - p
			}
		end)
	else
		imageStyle2 = imageStyle
	end

	if imageStyle ~= nil then
		groupTransparency = React.joinBindings({ groupTransparency, imageStyle }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			return 1 - (1 - item) * (1 - (item2.Transparency or 0))
		end)
	end

	local createElement = React.createElement
	local v5 = { LayoutOrder = props.LayoutOrder, Size = props.Size }
	local v6 = {
		Image = React.createElement(Image, {
			tag = "size-full",
			Image = image,
			backgroundStyle = props.backgroundStyle,
			imageStyle = imageStyle2,
			cornerRadius = getCornerRadius(radius, v2), -- inferred equivalent call
			ScaleType = props.ScaleType or Enum.ScaleType.Crop
		}),
		SkeletonOverlay = 0
	}
	local skeletonOverlay

	if v3 and state then
		skeletonOverlay = React.createElement(
			View,
			{ tag = "size-full", ZIndex = 2, GroupTransparency = groupTransparency },
			{
				Shimmer = React.createElement(Skeleton, {
					radius = radius,
					Size = UDim2.fromScale(1, 1)
				})
			}
		)
	end

	v6.SkeletonOverlay = skeletonOverlay
	return createElement(View, v5, v6)
end

return React.memo(ImageWithSkeleton)
