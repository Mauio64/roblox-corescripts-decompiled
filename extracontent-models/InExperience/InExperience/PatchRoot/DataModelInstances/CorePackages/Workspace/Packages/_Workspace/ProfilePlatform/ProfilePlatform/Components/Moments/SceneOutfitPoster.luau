local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local function SceneOutfitPoster(props)
	local v = useTokens()
	local uri = props.content.Uri
	local state, setState = React.useState(nil)
	local v2

	if uri == nil then
		v2 = false
	else
		v2 = state == uri
	end

	local onLoaded = React.useCallback(function(p)
		if p == Enum.AssetFetchStatus.Success then
			setState(uri)
		end
	end, { uri })

	local createElement = React.createElement
	local v3 = {
		Image = uri,
		ScaleType = Enum.ScaleType.Crop,
		ZIndex = props.zIndex,
		cornerRadius = 0,
		tag = "size-full",
		backgroundStyle = 0,
		onLoaded = 0
	}
	local cornerRadius

	if props.cornerRadius ~= nil then
		cornerRadius = UDim.new(0, props.cornerRadius)
	end

	v3.cornerRadius = cornerRadius

	v3.backgroundStyle = {
		Color3 = v.Color.Surface.Surface_100.Color3,
		Transparency = v2 and 0 or 1
	}

	v3.onLoaded = onLoaded
	return createElement(Image, v3)
end

return SceneOutfitPoster
