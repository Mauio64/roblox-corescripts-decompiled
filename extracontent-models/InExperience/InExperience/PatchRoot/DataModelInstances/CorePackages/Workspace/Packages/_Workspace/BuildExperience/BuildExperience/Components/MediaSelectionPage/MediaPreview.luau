local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Image = Foundation.Image
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

local function MediaPreview(props)
	local v = useTokens()
	local state, setState = React.useState(true)
	local ref = React.useRef(nil)
	local v2, v3 = React.useBinding(0)

	local aspectRatio = props.isIcon and 1 or 16 / 9

	local onActivated = React.useCallback(function()
		setState(not state)
	end, { state })

	React.useEffect(function()
		if not (props.mediaType == "video" and ref.current) then
			return nil
		end

		local renderSteppedConnection = RunService.RenderStepped:Connect(function()
			local current = ref.current

			if current and current.TimeLength > 0 then
				v3(100 * current.TimePosition / current.TimeLength)
			end
		end)

		return function()
			renderSteppedConnection:Disconnect()
		end
	end, { props.mediaType })

	if props.isLoading then
		return React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = props.LayoutOrder,
			aspectRatio = {
				AspectRatio = aspectRatio,
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

	if not (props.assetSource or props.imageContent) then
		return React.createElement(View, {
			tag = "align-x-center align-y-center radius-large clip bg-surface-200",
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = props.LayoutOrder,
			aspectRatio = {
				AspectRatio = aspectRatio,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}, {
			PlaceholderIcon = React.createElement(Icon, {
				name = IconName.Image,
				size = IconSize.XLarge,
				tag = "auto-xy content-default"
			})
		})
	end

	if props.mediaType == "video" then
		local createElement = React.createElement
		local v4 = {
			Size = UDim2.fromScale(1, 1),
			aspectRatio = {
				AspectRatio = aspectRatio,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			},
			LayoutOrder = props.LayoutOrder
		}

		local createElement2 = React.createElement
		local v5 = {
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

		local v6 = {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 12) }),
			PlayPauseButton = 0
		}

		local createElement3 = React.createElement
		local v7 = {
			Position = UDim2.new(0, 0, 1, -v.Gap.XSmall),
			AnchorPoint = Vector2.new(0, 1),
			icon = 0,
			size = 0,
			onActivated = 0
		}
		local icon

		if state then
			icon = IconName.PauseSmall
		else
			icon = IconName.PlaySmall
		end

		v7.icon = icon
		v7.size = InputSize.Small
		v7.onActivated = onActivated
		v6.PlayPauseButton = createElement3(IconButton, v7)
		return createElement(View, v4, {
			Video = createElement2("VideoFrame", v5, v6),
			ProgressBar = React.createElement(Progress, {
				Position = UDim2.new(0, 0, 1, v.Gap.Medium),
				value = v2,
				shape = ProgressShape.Bar,
				size = ProgressSize.Medium
			})
		})
	else
		local createElement = React.createElement
		local v4 = {
			tag = "align-x-center align-y-center radius-large clip bg-surface-200",
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = props.LayoutOrder,
			aspectRatio = {
				AspectRatio = aspectRatio,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}
		}
		local previewImage

		if props.imageContent then
			previewImage = React.createElement(
				"ImageLabel",
				{
					BackgroundTransparency = 1,
					ImageContent = props.imageContent,
					ScaleType = Enum.ScaleType.Crop,
					Size = UDim2.fromScale(1, 1)
				},
				{
					UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 12) })
				}
			)
		else
			previewImage = React.createElement(Image, {
				Image = props.assetSource,
				tag = "size-full radius-large",
				ScaleType = Enum.ScaleType.Crop
			})
		end

		return createElement(View, v4, { PreviewImage = previewImage })
	end
end

return MediaPreview
