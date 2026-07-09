local ContentProvider = game:GetService("ContentProvider")
local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local Foundation = require(Parent.Foundation)
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	frequency = 3,
	dampingRatio = 1
}

local function getCornerRadius(p1, p2) -- line: 55
	-- upvalues: EnumsRadius (copy)
	if p1 == EnumsRadius.Circle then
		return UDim.new(1, 0)
	end

	return UDim.new(0, p2.Radius[p1])
end
local function ImageWithSkeleton(t2: {[any]: any}) -- line: 62
	-- upvalues: useTokens (copy), EnumsRadius (copy), React (copy), ReactOtter (copy), ContentProvider (copy), t1 (copy), View (copy), FoundationImage (copy), Skeleton (copy)
	local v17 = useTokens()
	local v18 = t2.radius or EnumsRadius.Medium
	local t2Image = t2.Image
	local v20 = t2Image ~= nil and t2Image ~= ""
	local v21, v22 = React.useState(v20)
	local v23, v24 = ReactOtter.useAnimatedBinding(0, function() -- line: 71
		-- upvalues: t2Image (copy), ContentProvider (copy), v22 (copy)
		if t2Image ~= nil and ContentProvider:GetAssetFetchStatus(t2Image) == Enum.AssetFetchStatus.Success then
			v22(false)
		end
	end)

	React.useEffect(function() -- line: 78
		-- upvalues: v22 (copy), v20 (copy), t2Image (copy), v24 (copy), ReactOtter (copy), t1 (copy), ContentProvider (copy)
		v22(v20)

		if not v20 or (t2Image == nil or t2Image == "") then
			v24((ReactOtter.instant(0)))

			return
		end

		local u27 = true

		local function fadeInImage() -- line: 87
			-- upvalues: u27 (ref), v24 (copy), ReactOtter (copy), t1 (copy)
			if u27 then
				v24((ReactOtter.spring(1, t1)))
			end
		end

		if ContentProvider:GetAssetFetchStatus(t2Image) == Enum.AssetFetchStatus.Success then
			if u27 then
				v24((ReactOtter.spring(1, t1)))
			end

			return function() -- line: 95
				-- upvalues: u27 (ref)
				u27 = false
			end
		end

		v24((ReactOtter.instant(0)))
		task.spawn(function() -- line: 101
			-- upvalues: ContentProvider (copy), t2Image (copy), u27 (ref), v24 (copy), ReactOtter (copy), t1 (copy)
			pcall(function() -- line: 102
				-- upvalues: ContentProvider (copy), t2Image (copy), u27 (ref), v24 (copy), ReactOtter (copy), t1 (copy)
				ContentProvider:PreloadAsync({ t2Image }, function(p3, p4) -- line: 103
					-- upvalues: t2Image (copy), u27 (ref), v24 (copy), ReactOtter (copy), t1 (copy)
					if p3 == t2Image and (p4 == Enum.AssetFetchStatus.Success and u27) then
						v24((ReactOtter.spring(1, t1)))
					end
				end)
			end)

			if ContentProvider:GetAssetFetchStatus(t2Image) == Enum.AssetFetchStatus.Success and u27 then
				v24((ReactOtter.spring(1, t1)))
			end
		end)

		return function() -- line: 115
			-- upvalues: u27 (ref)
			u27 = false
		end
	end, {
		t2Image,
		v20
	})

	local imageStyle = t2.imageStyle
	local v26 = if not v20 or imageStyle == nil then if not v20 then imageStyle else v23:map(function(n1: number) -- line: 136
		return {
			Color3 = Color3.new(1, 1, 1),
			Transparency = 1 - n1
		}
	end) else React.joinBindings({
		imageStyle,
		v23
	}):map(function(t3: {[any]: any}) -- line: 127
		local v30 = t3[1]
		local v31 = t3[2]

		return {
			Color3 = v30.Color3,
			Transparency = 1 - (1 - v30.Transparency) * v31
		}
	end)

	if imageStyle ~= nil then
		v23 = React.joinBindings({
			v23,
			imageStyle
		}):map(function(t4: {[any]: any}) -- line: 154
			local v34 = t4[1]
			local v35 = t4[2]

			return 1 - (1 - v34) * (1 - (v35.Transparency or 0))
		end)
	end

	return React.createElement(View, {
		LayoutOrder = t2.LayoutOrder,
		Size = t2.Size
	}, {
		Image = React.createElement(FoundationImage, {
			tag = "size-full",
			Image = t2Image,
			backgroundStyle = t2.backgroundStyle,
			imageStyle = v26,
			cornerRadius = if v18 ~= EnumsRadius.Circle then UDim.new(0, v17.Radius[v18]) else UDim.new(1, 0),
			ScaleType = t2.ScaleType or Enum.ScaleType.Crop
		}),
		SkeletonOverlay = if not v20 or not v21 then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = 2,
			GroupTransparency = v23
		}, {
			Shimmer = React.createElement(Skeleton, {
				radius = v18,
				Size = UDim2.fromScale(1, 1)
			})
		})
	})
end

return React.memo(ImageWithSkeleton)
