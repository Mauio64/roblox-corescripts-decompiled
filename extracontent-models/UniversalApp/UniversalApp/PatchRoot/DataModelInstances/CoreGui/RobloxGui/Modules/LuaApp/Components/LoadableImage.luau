local ContentProvider = game:GetService("ContentProvider")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local ShimmerAnimation = require(Modules.LuaApp.Components.ShimmerAnimation)
local ThemeContext_DEPRECATED = require(Modules.LuaApp.ThemeContext_DEPRECATED)
local Decal = Instance.new("Decal")
local t1 = {}
local v8 = Roact.PureComponent:extend("LoadableImage")

v8.defaultProps = {
	useShimmerAnimationWhileLoading = false,
	ScaleType = Enum.ScaleType.Stretch
}

function v8.init(p1) -- line: 27
	-- upvalues: t1 (copy)
	p1.state = {
		loaded = t1[p1.props.Image]
	}
	p1._isMounted = false
end
function v8.render(p2) -- line: 35
	-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy), ShimmerAnimation (copy)
	local propsSize = p2.props.Size
	local propsPosition = p2.props.Position
	local BorderSizePixel = p2.props.BorderSizePixel
	local propsBackgroundColor3 = p2.props.BackgroundColor3
	local propsBackgroundTransparency = p2.props.BackgroundTransparency
	local propsImageTransparency = p2.props.ImageTransparency
	local propsScaleType = p2.props.ScaleType
	local propsZIndex = p2.props.ZIndex
	local propsImage = p2.props.Image
	local loadingImage = p2.props.loadingImage
	local useShimmerAnimationWhileLoading = p2.props.useShimmerAnimationWhileLoading
	local loaded = p2.state.loaded

	if not loaded and useShimmerAnimationWhileLoading then
		return Roact.createElement(ThemeContext_DEPRECATED.Consumer, {
			render = function(p3) -- line: 51
				-- upvalues: Roact (copy), propsPosition (copy), BorderSizePixel (copy), propsZIndex (copy), propsSize (copy), ShimmerAnimation (copy)
				local ShimmerPanel = p3.ShimmerPanel

				return Roact.createElement("Frame", {
					Position = propsPosition,
					BorderSizePixel = BorderSizePixel,
					BackgroundColor3 = ShimmerPanel.Color,
					BackgroundTransparency = ShimmerPanel.Transparency,
					ZIndex = propsZIndex,
					Size = propsSize
				}, {
					Shimmer = Roact.createElement(ShimmerAnimation, {
						Size = UDim2.new(1, 0, 1, 0)
					})
				})
			end
		})
	end

	return Roact.createElement("ImageLabel", {
		Position = propsPosition,
		BorderSizePixel = BorderSizePixel,
		BackgroundColor3 = propsBackgroundColor3,
		BackgroundTransparency = propsBackgroundTransparency,
		ImageTransparency = propsImageTransparency,
		ScaleType = propsScaleType,
		ZIndex = propsZIndex,
		Size = propsSize,
		Image = loaded and propsImage or loadingImage
	})
end
function v8.shouldLoadImage(_, p5) -- line: 83
	-- upvalues: t1 (copy)
	return p5 ~= nil and (p5 ~= "" and not t1[p5])
end
function v8.didUpdate(p6, p7) -- line: 87
	if p7.Image ~= p6.props.Image then
		p6:_loadImage()
	end
end
function v8.didMount(p8) -- line: 94
	p8._isMounted = true
	p8:_loadImage()
end
function v8.willUnmount(p9) -- line: 100
	p9._isMounted = false
end
function v8._loadImage(p10) -- line: 104
	-- upvalues: t1 (copy), Decal (copy), ContentProvider (copy)
	local propsImage = p10.props.Image

	if p10:shouldLoadImage(propsImage) then
		if p10.state.loaded then
			p10:setState({
				loaded = false
			})
		end

		spawn(function() -- line: 124
			-- upvalues: Decal (copy), propsImage (copy), ContentProvider (copy), t1 (copy), p10 (copy)
			Decal.Texture = propsImage
			ContentProvider:PreloadAsync({ Decal })
			t1[propsImage] = true

			if p10._isMounted then
				p10:setState({
					loaded = true
				})

				if p10.props.onLoaded then
					p10.props.onLoaded()
				end
			end
		end)

		return
	end

	if t1[propsImage] and not p10.state.loaded then
		p10:setState({
			loaded = true
		})
	end
end
function v8._mockPreloadDone(p11) -- line: 142
	-- upvalues: t1 (copy)
	t1[p11] = true
end
function v8.isLoaded(p12) -- line: 146
	-- upvalues: Roact (copy), t1 (copy)
	if p12 == Roact.None or (p12 == nil or p12 == "") then
		return false
	end

	return t1[p12] ~= nil
end

return v8
