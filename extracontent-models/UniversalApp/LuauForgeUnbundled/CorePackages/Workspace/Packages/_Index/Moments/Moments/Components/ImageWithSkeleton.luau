local ContentProvider = game:GetService("ContentProvider")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")

local FFlagMomentsImageWithSkeletonRetry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsImageWithSkeletonRetry")

local image = Foundation.Image
local skeleton = Foundation.Skeleton
local view = Foundation.View

local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local v5 = { frequency = 3, dampingRatio = 1 }

local function getCornerRadius(p2, p3)
	if p2 == radius.Circle then
		return UDim.new(1, 0)
	end

	return UDim.new(0, p3.Radius[p2])
end

local function ImageWithSkeleton(props)
	local v6 = useTokens()
	local radius2 = props.radius or radius.Medium
	local image2 = props.Image
	local v7 = not (image2 == nil) and image2 ~= ""

	local state, setState = React.useState(v7)

	local v8, v9 = ReactOtter.useAnimatedBinding(0, function()
		if
			image2 ~= nil
			and ContentProvider:GetAssetFetchStatus(image2) == Enum.AssetFetchStatus.Success
		then
			setState(false)
		end
	end)

	React.useEffect(function()
		setState(v7)

		if not v7 or image2 == nil or image2 == "" then
			v9(ReactOtter.instant(0))
			return
		end

		local flag = true
		local function fadeInImage()
			if flag then
				v9(ReactOtter.spring(1, v5))
			end
		end

		if ContentProvider:GetAssetFetchStatus(image2) == Enum.AssetFetchStatus.Success then
			if flag then
				v9(ReactOtter.spring(1, v5))
			end

			return function()
				flag = false
			end
		else
			v9(ReactOtter.instant(0))

			if not FFlagMomentsImageWithSkeletonRetry then
				task.spawn(function()
					pcall(function()
						ContentProvider:PreloadAsync({ image2 }, function(p2, p3)
							if p2 == image2 and p3 == Enum.AssetFetchStatus.Success and flag then
								v9(ReactOtter.spring(1, v5))
							end
						end)
					end)

					if
						ContentProvider:GetAssetFetchStatus(image2) == Enum.AssetFetchStatus.Success
						and flag
					then
						v9(ReactOtter.spring(1, v5))
					end
				end)

				return function()
					flag = false
				end
			end

			local preloadImageWithRetry = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/preloadImageWithRetry")
			task.spawn(preloadImageWithRetry, image2, {
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
	end, { image2, v7 })

	local imageStyle = props.imageStyle
	local v10

	if v7 and imageStyle ~= nil then
		v10 = React.joinBindings({ imageStyle, v8 }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			return {
				Color3 = item.Color3,
				Transparency = 1 - (1 - item.Transparency) * item2
			}
		end)
	elseif v7 then
		v10 = v8:map(function(p2)
			return {
				Color3 = Color3.new(1, 1, 1),
				Transparency = 1 - p2
			}
		end)
	else
		v10 = imageStyle
	end

	if imageStyle ~= nil then
		v8 = React.joinBindings({ v8, imageStyle }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			return 1 - (1 - item) * (1 - (item2.Transparency or 0))
		end)
	end

	local createElement = React.createElement
	local v12 = { LayoutOrder = props.LayoutOrder, Size = props.Size }

	local createElement2 = React.createElement
	local v15 = {
		tag = "size-full",
		Image = image2,
		backgroundStyle = props.backgroundStyle,
		imageStyle = v10,
		cornerRadius = 0,
		ScaleType = 0
	}
	local v16 = if radius2 == radius.Circle then UDim.new(1, 0) else UDim.new(0, v6.Radius[radius2])

	v15.cornerRadius = v16
	v15.ScaleType = props.ScaleType or Enum.ScaleType.Crop
	local v13 = { Image = createElement2(image, v15), SkeletonOverlay = 0 }

	local v17 = if v7 and state then React.createElement(
		view,
		{ tag = "size-full", ZIndex = 2, GroupTransparency = v8 },
		{
			Shimmer = React.createElement(skeleton, {
				radius = radius2,
				Size = UDim2.fromScale(1, 1)
			})
		}
	) else nil
	v13.SkeletonOverlay = v17
	return createElement(view, v12, v13)
end

return React.memo(ImageWithSkeleton)
