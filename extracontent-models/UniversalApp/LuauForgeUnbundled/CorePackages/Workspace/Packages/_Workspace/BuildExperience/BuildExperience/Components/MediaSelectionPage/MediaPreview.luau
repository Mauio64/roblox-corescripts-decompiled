local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local image = Foundation.Image
local skeleton = Foundation.Skeleton
local view = Foundation.View
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local progress = Foundation.Progress

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local progressShape = Foundation.Enums.ProgressShape
local progressSize = Foundation.Enums.ProgressSize

local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/types")

local function MediaPreview(props)
	local v5 = useTokens()
	local state, setState = React.useState(true)
	local ref = React.useRef(nil)
	local v6, v7 = React.useBinding(0)

	local v8 = props.isIcon and 1 or 16 / 9

	local v9 = React.useCallback(function()
		setState(not state)
	end, { state })

	React.useEffect(function()
		if not (props.mediaType == "video" and ref.current) then
			return nil
		end

		local renderSteppedConnection = RunService.RenderStepped:Connect(function()
			local current = ref.current

			if current and current.TimeLength > 0 then
				v7(100 * current.TimePosition / current.TimeLength)
			end
		end)

		return function()
			renderSteppedConnection:Disconnect()
		end
	end, { props.mediaType })

	if props.isLoading then
		return React.createElement(view, {
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = props.LayoutOrder,
			aspectRatio = {
				AspectRatio = v8,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			LoadingSkeleton = React.createElement(skeleton, {
				radius = Foundation.Enums.Radius.Medium,
				Size = UDim2.fromScale(1, 1)
			})
		})
	end

	if not (props.assetSource or props.imageContent) then
		return React.createElement(view, {
			tag = "align-x-center align-y-center radius-large clip bg-surface-200",
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = props.LayoutOrder,
			aspectRatio = {
				AspectRatio = v8,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			PlaceholderIcon = React.createElement(icon, {
				name = iconName.Image,
				size = iconSize.XLarge,
				tag = "auto-xy content-default"
			})
		})
	end

	if props.mediaType == "video" then
		local createElement = React.createElement
		local v11 = {
			Size = UDim2.fromScale(1, 1),
			aspectRatio = {
				AspectRatio = v8,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			},
			LayoutOrder = props.LayoutOrder
		}

		local createElement2 = React.createElement
		local v13 = {
			Size = UDim2.fromScale(1, 1),
			Video = props.assetSource,
			VideoContent = props.imageContent,
			Playing = state,
			Looped = true,
			Volume = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ref = ref
		}

		local v14 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			}),
			PlayPauseButton = 0
		}

		local createElement3 = React.createElement
		local v16 = {
			Position = UDim2.new(0, 0, 1, -v5.Gap.XSmall),
			AnchorPoint = Vector2.new(0, 1),
			icon = 0,
			size = 0,
			onActivated = 0
		}
		local v17 = if state then iconName.PauseSmall else iconName.PlaySmall
		v16.icon = v17
		v16.size = inputSize.Small
		v16.onActivated = v9
		v14.PlayPauseButton = createElement3(iconButton, v16)
		return createElement(view, v11, {
			Video = createElement2("VideoFrame", v13, v14),
			ProgressBar = React.createElement(progress, {
				Position = UDim2.new(0, 0, 1, v5.Gap.Medium),
				value = v6,
				shape = progressShape.Bar,
				size = progressSize.Medium
			})
		})
	else
		local createElement = React.createElement
		local v11 = {
			tag = "align-x-center align-y-center radius-large clip bg-surface-200",
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = props.LayoutOrder,
			aspectRatio = {
				AspectRatio = v8,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}

		local v13 = if props.imageContent then React.createElement(
			"ImageLabel",
			{
				BackgroundTransparency = 1,
				ImageContent = props.imageContent,
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(1, 1)
			},
			{
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 12)
				})
			}
		) else React.createElement(image, {
			Image = props.assetSource,
			tag = "size-full radius-large",
			ScaleType = Enum.ScaleType.Crop
		})
		return createElement(view, v11, { PreviewImage = v13 })
	end
end

return MediaPreview
