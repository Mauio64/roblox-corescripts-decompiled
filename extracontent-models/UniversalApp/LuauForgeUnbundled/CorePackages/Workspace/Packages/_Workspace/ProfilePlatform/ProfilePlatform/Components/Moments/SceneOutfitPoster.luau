local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local function SceneOutfitPoster(props)
	local v5 = useTokens()
	local uri = props.content.Uri
	local state, setState = React.useState(nil)
	local v6 = not (uri == nil) and state == uri

	local v7 = React.useCallback(function(p2)
		if p2 == Enum.AssetFetchStatus.Success then
			setState(uri)
		end
	end, { uri })

	local createElement = React.createElement
	local v9 = {
		Image = uri,
		ScaleType = Enum.ScaleType.Crop,
		ZIndex = props.zIndex,
		cornerRadius = 0,
		tag = "size-full",
		backgroundStyle = 0,
		onLoaded = 0
	}
	local v10 = if props.cornerRadius ~= nil then UDim.new(0, props.cornerRadius) else nil
	v9.cornerRadius = v10

	v9.backgroundStyle = {
		Color3 = v5.Color.Surface.Surface_100.Color3,
		Transparency = v6 and 0 or 1
	}

	v9.onLoaded = v7
	return createElement(image, v9)
end

return SceneOutfitPoster
