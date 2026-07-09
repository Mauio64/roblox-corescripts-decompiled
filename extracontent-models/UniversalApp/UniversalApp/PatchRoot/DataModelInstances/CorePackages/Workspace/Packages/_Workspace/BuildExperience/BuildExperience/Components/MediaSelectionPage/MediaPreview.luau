local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationImage = Foundation.Image
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

local function MediaPreview(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), React (copy), RunService (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), IconButton (copy), InputSize (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy), FoundationImage (copy)
	local v18 = useTokens()
	local v19, v20 = React.useState(true)
	local v21 = React.useRef(nil)
	local v22, v23 = React.useBinding(0)
	local v24 = not t1.isIcon and 1.7777777777777777 or 1
	local v25 = React.useCallback(function() -- line: 42
		-- upvalues: v20 (copy), v19 (copy)
		v20(not v19)
	end, { v19 })

	React.useEffect(function() -- line: 46
		-- upvalues: t1 (copy), v21 (copy), RunService (copy), v23 (copy)
		if t1.mediaType ~= "video" then
			return nil
		end

		if not v21.current then
			return nil
		end

		local connection = RunService.RenderStepped:Connect(function() -- line: 56
			-- upvalues: v21 (copy), v23 (copy)
			local current = v21.current

			if current and current.TimeLength > 0 then
				v23(100 * current.TimePosition / current.TimeLength)
			end
		end)

		return function() -- line: 63
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { t1.mediaType })

	if not t1.assetSource then
		return React.createElement(View, {
			tag = "align-x-center align-y-center radius-large clip bg-surface-200",
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = t1.LayoutOrder,
			aspectRatio = {
				AspectRatio = v24,
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
				AspectRatio = v24,
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
				Playing = v19,
				ref = v21
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 12)
				}),
				PlayPauseButton = React.createElement(IconButton, {
					Position = UDim2.new(0, 0, 1, -v18.Gap.XSmall),
					AnchorPoint = Vector2.new(0, 1),
					icon = if not v19 then IconName.PlaySmall else IconName.PauseSmall,
					size = InputSize.Small,
					onActivated = v25
				})
			}),
			ProgressBar = React.createElement(Progress, {
				Position = UDim2.new(0, 0, 1, v18.Gap.Medium),
				value = v22,
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
			AspectRatio = v24,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}
	}, {
		PreviewImage = React.createElement(FoundationImage, {
			tag = "size-full radius-large",
			Image = t1.assetSource,
			ScaleType = Enum.ScaleType.Fit
		})
	})
end

return MediaPreview
