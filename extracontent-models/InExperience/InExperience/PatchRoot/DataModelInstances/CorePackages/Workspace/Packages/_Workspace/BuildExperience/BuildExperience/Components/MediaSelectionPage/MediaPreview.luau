local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Progress = Foundation.Progress
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize
local useTokens = Foundation.Hooks.useTokens

require(script.Parent.types)

local function MediaPreview(t1: {[any]: any}) -- line: 36
	-- upvalues: useTokens (copy), React (copy), RunService (copy), View (copy), Skeleton (copy), Foundation (copy), Icon (copy), IconName (copy), IconSize (copy), IconButton (copy), InputSize (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy), FoundationImage (copy)
	local v19 = useTokens()
	local v20, v21 = React.useState(true)
	local v22 = React.useRef(nil)
	local v23, v24 = React.useBinding(0)
	local v25 = not t1.isIcon and 1.7777777777777777 or 1
	local v26 = React.useCallback(function() -- line: 44
		-- upvalues: v21 (copy), v20 (copy)
		v21(not v20)
	end, { v20 })

	React.useEffect(function() -- line: 48
		-- upvalues: t1 (copy), v22 (copy), RunService (copy), v24 (copy)
		if t1.mediaType ~= "video" then
			return nil
		end

		if not v22.current then
			return nil
		end

		local connection = RunService.RenderStepped:Connect(function() -- line: 58
			-- upvalues: v22 (copy), v24 (copy)
			local current = v22.current

			if current and current.TimeLength > 0 then
				v24(100 * current.TimePosition / current.TimeLength)
			end
		end)

		return function() -- line: 65
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { t1.mediaType })

	if t1.isLoading then
		return React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = t1.LayoutOrder,
			aspectRatio = {
				AspectRatio = v25,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			LoadingSkeleton = React.createElement(Skeleton, {
				radius = Foundation.Enums.Radius.Medium,
				Size = UDim2.fromScale(1, 1)
			})
		})
	end

	if not t1.assetSource and not t1.imageContent then
		return React.createElement(View, {
			tag = "align-x-center align-y-center radius-large clip bg-surface-200",
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = t1.LayoutOrder,
			aspectRatio = {
				AspectRatio = v25,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			PlaceholderIcon = React.createElement(Icon, {
				tag = "auto-xy content-default",
				name = IconName.Image,
				size = IconSize.XLarge
			})
		})
	end

	if t1.mediaType == "video" then
		return React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			aspectRatio = {
				AspectRatio = v25,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			},
			LayoutOrder = t1.LayoutOrder
		}, {
			Video = React.createElement("VideoFrame", {
				Looped = true,
				Volume = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				Video = t1.assetSource,
				VideoContent = t1.imageContent,
				Playing = v20,
				ref = v22
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 12)
				}),
				PlayPauseButton = React.createElement(IconButton, {
					Position = UDim2.new(0, 0, 1, -v19.Gap.XSmall),
					AnchorPoint = Vector2.new(0, 1),
					icon = if not v20 then IconName.PlaySmall else IconName.PauseSmall,
					size = InputSize.Small,
					onActivated = v26
				})
			}),
			ProgressBar = React.createElement(Progress, {
				Position = UDim2.new(0, 0, 1, v19.Gap.Medium),
				value = v23,
				shape = ProgressShape.Bar,
				size = ProgressSize.Medium
			})
		})
	end

	return React.createElement(View, {
		tag = "align-x-center align-y-center radius-large clip bg-surface-200",
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = t1.LayoutOrder,
		aspectRatio = {
			AspectRatio = v25,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}
	}, {
		PreviewImage = if not t1.imageContent then React.createElement(FoundationImage, {
			tag = "size-full radius-large",
			Image = t1.assetSource,
			ScaleType = Enum.ScaleType.Crop
		}) else React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ImageContent = t1.imageContent,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			})
		})
	})
end

return MediaPreview
