local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LoadableImage = require(Modules.LuaApp.Components.LoadableImage)
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local v9 = Roact.PureComponent:extend("GameMediaItem")

function v9.init(p1) -- line: 22
	-- upvalues: LoadableImage (copy)
	local propsImage = p1.props.Image

	p1.state = {
		loaded = LoadableImage.isLoaded(propsImage)
	}
	p1.isMounted = false

	function p1.onImageLoaded() -- line: 31
		-- upvalues: p1 (copy)
		if p1.state.loaded == false and p1.isMounted then
			p1:setState({
				loaded = true
			})

			if p1.props.onImageLoaded then
				p1.props.onImageLoaded()
			end
		end
	end
end
function v9.didMount(p2) -- line: 44
	p2.isMounted = true
end
function v9.willUnmount(p3) -- line: 48
	p3.isMounted = false
end
function v9.render(p4) -- line: 52
	-- upvalues: Roact (copy), LoadableImage (copy), SpringAnimatedItem (copy), ImageSetLabel (copy), GetImageData (copy)
	local propsSize = p4.props.Size
	local propsPosition = p4.props.Position
	local propsLayoutOrder = p4.props.LayoutOrder
	local propsBackgroundColor3 = p4.props.BackgroundColor3
	local propsBackgroundTransparency = p4.props.BackgroundTransparency
	local propsImage = p4.props.Image
	local propsImageTransparency = p4.props.ImageTransparency
	local isVideo = p4.props.isVideo
	local videoIconColor = p4.props.videoIconColor
	local animationSettings = p4.props.animationSettings
	local onActivated = p4.props.onActivated
	local loaded = p4.state.loaded
	local v27 = propsImageTransparency ~= 1
	local v28 = v27 and not loaded
	local v29 = isVideo and v27
	local v30 = isVideo and Enum.ScaleType.Crop or Enum.ScaleType.Stretch

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = propsSize,
		Position = propsPosition,
		LayoutOrder = propsLayoutOrder,
		BackgroundColor3 = propsBackgroundColor3,
		BackgroundTransparency = propsBackgroundTransparency
	}, {
		MediaImage = v28 and Roact.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			useShimmerAnimationWhileLoading = true,
			Size = UDim2.new(1, 0, 1, 0),
			Image = propsImage,
			ImageTransparency = propsImageTransparency,
			ScaleType = v30,
			onLoaded = p4.onImageLoaded
		}) or Roact.createElement(SpringAnimatedItem.AnimatedImageLabel, {
			regularProps = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Image = propsImage,
				ScaleType = v30
			},
			animatedValues = {
				transparency = propsImageTransparency
			},
			mapValuesToProps = function(p5) -- line: 103
				return {
					ImageTransparency = p5.transparency
				}
			end,
			springOptions = animationSettings
		}),
		VideoIconBackground = v29 and Roact.createElement("ImageLabel", {
			Image = "rbxasset://textures/ui/LuaApp/graphic/playBtnBackground.png",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			VideoIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ImageTransparency = 0.5,
				AnchorPoint = Vector2.new(1, 1),
				Size = UDim2.new(0, 60, 0, 45),
				Position = UDim2.new(1, -10, 1, -10),
				Image = GetImageData("LuaApp/buttons/buttonPill") or "LuaApp/buttons/buttonPill",
				ImageColor3 = videoIconColor
			}, {
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, 26, 0, 26),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Image = GetImageData("LuaApp/icons/GameDetails/play") or "LuaApp/icons/GameDetails/play",
					ImageColor3 = videoIconColor,
					ScaleType = Enum.ScaleType.Fit
				})
			})
		}),
		ItemActivationButton = onActivated ~= nil and Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			ZIndex = 3,
			[Roact.Event.Activated] = onActivated
		})
	})
end

return v9
