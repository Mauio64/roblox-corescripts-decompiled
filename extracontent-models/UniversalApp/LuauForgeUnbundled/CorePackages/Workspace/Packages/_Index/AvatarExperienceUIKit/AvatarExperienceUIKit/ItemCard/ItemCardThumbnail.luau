local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")

local image = Foundation.Image
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardThumbnailSkeleton")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Style").useDesignTokens

local fFlagLuaAppHomePageFirstImageLoadObserver = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/SharedFlags").FFlagLuaAppHomePageFirstImageLoadObserver

local fFlagAXTestSkeletonInCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXTestSkeletonInCatalog
local v5 = game:DefineFastFlag("AXTestDontUseSkeletonOnloadInCatalog", false)
	and fFlagAXTestSkeletonInCatalog

local function ItemCardThumbnail(props, callback)
	local state, setState = React.useState(false)
	local v6 = useDesignTokens()
	local v7 = props.tag

	if fFlagLuaAppHomePageFirstImageLoadObserver then
		v7 = not v7 and "observed-image" or `{v7} observed-image`
	end

	local v8 = React.useCallback(function(current)
		if typeof(callback) == "function" then
			callback(current)
		elseif typeof(callback) == "table" then
			callback.current = current
		end

		setState(false)

		if current and props.url then
			local heartbeatConnection = nil
			local now = tick()
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
				now += dt

				if current.IsLoaded then
					setState(true)

					if props.onLoaded then
						props.onLoaded(now)
					end

					heartbeatConnection:Disconnect()
				elseif not current.Parent then
					heartbeatConnection:Disconnect()
				end
			end)
		end
	end, { props.onLoaded, props.url })

	if fFlagAXTestSkeletonInCatalog and props.inSkeletonExperiment then
		local createElement = React.createElement
		local fragment = React.Fragment

		local v11 = if not (v5 or state) then React.createElement(module3, {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			testId = `item-card-thumbnail-skeleton-{props.url}`,
			radius = radius.Medium
		}) else nil
		return createElement(fragment, nil, {
			ItemCardThumbnailSkeleton = v11,
			ItemCardThumbnailImage = React.createElement(image, {
				imageRect = props.imageRect,
				Image = props.url,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ref = v8,
				testId = `item-card-thumbnail-image-{props.url}`,
				tag = props.tag
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v6.Radius.Medium)
				})
			})
		})
	else
		local createElement = React.createElement
		local fragment = React.Fragment

		local v11 = if not state then React.createElement(skeleton, {
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			testId = `item-card-thumbnail-skeleton-{props.url}`,
			radius = radius.Medium
		}) else nil
		return createElement(fragment, nil, {
			ItemCardThumbnailSkeleton = v11,
			ItemCardThumbnailImage = React.createElement(image, {
				imageRect = props.imageRect,
				Image = props.url,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ref = v8,
				testId = `item-card-thumbnail-image-{props.url}`,
				tag = v7
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v6.Radius.Medium)
				})
			})
		})
	end
end

return React.forwardRef(ItemCardThumbnail)
