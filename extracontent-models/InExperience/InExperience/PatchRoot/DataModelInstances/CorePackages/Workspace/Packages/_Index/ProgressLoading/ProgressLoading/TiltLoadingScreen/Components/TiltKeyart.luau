local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local ParentParent = TiltLoadingScreen.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local TILT_DEGREES = require(TiltLoadingScreen.Constants).KEYART.TILT_DEGREES

require(TiltLoadingScreen.Types)

local t1 = {
	rotation = React.createBinding(TILT_DEGREES),
	sizeScale = React.createBinding(1),
	coverTransparency = React.createBinding(1)
}
local t2 = {
	rotation = React.createBinding(-TILT_DEGREES),
	sizeScale = React.createBinding(1),
	groupTransparency = React.createBinding(0)
}

local function TiltKeyart(p1) -- line: 29
	-- upvalues: useTokens (copy), React (copy), t1 (copy), t2 (copy), TILT_DEGREES (copy), View (copy), Skeleton (copy), FoundationImage (copy)
	local v14 = useTokens()
	local v15, v16 = React.useState(false)
	local v17 = p1.keyart or t1
	local v18 = p1.frame or t2
	local v19 = v14.Size.Size_2400 * 2
	local v20 = v19 / (math.cos((math.rad(TILT_DEGREES))) + math.sin((math.rad(TILT_DEGREES))))
	local v21 = React.useCallback(function(p2) -- line: 38
		-- upvalues: v16 (copy)
		if p2 == Enum.AssetFetchStatus.Success then
			v16(true)
		end
	end, {})

	return React.createElement(View, {
		testId = "tilt-keyart",
		Size = UDim2.fromOffset(v19, v19)
	}, {
		Square = React.createElement(View, {
			tag = "position-center-center anchor-center-center stroke-standard stroke-system-neutral",
			testId = "tilt-keyart-frame",
			ZIndex = 1,
			Size = v18.sizeScale:map(function(p3) -- line: 51
				-- upvalues: v20 (copy)
				return UDim2.fromOffset(v20 * p3, v20 * p3)
			end),
			Rotation = v18.rotation,
			GroupTransparency = v18.groupTransparency,
			Visible = v18.groupTransparency:map(function(p4) -- line: 56
				return p4 < 1
			end)
		}),
		Keyart = React.createElement(View, {
			tag = "position-center-center anchor-center-center",
			testId = "tilt-keyart-card",
			ZIndex = 2,
			Size = v17.sizeScale:map(function(p5) -- line: 64
				-- upvalues: v20 (copy)
				return UDim2.fromOffset(v20 * p5, v20 * p5)
			end),
			Rotation = v17.rotation
		}, {
			ThumbnailSkeleton = if v15 then nil else React.createElement(Skeleton, {
				tag = "size-full",
				ZIndex = 1,
				testId = "tilt-keyart-skeleton"
			}),
			Thumbnail = if p1.thumbnailUrl == "" then nil else React.createElement(FoundationImage, {
				tag = "size-full radius-small",
				ZIndex = 2,
				testId = "tilt-keyart-thumbnail",
				Image = p1.thumbnailUrl,
				ScaleType = Enum.ScaleType.Crop,
				ImageTransparency = not v15 and 1 or 0,
				onLoaded = v21
			}),
			RevealCover = React.createElement(View, {
				tag = "size-full",
				ZIndex = 3,
				backgroundStyle = v17.coverTransparency:map(function(p6) -- line: 90
					-- upvalues: v14 (copy)
					return {
						Color3 = v14.Color.Extended.Black.Black_100.Color3,
						Transparency = p6
					}
				end)
			})
		})
	})
end

return React.memo(TiltKeyart)
