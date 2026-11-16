local RunService = game:GetService("RunService")
local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius

local ItemCardThumbnailSkeleton = require(script.Parent.ItemCardThumbnailSkeleton)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags.FFlagLuaAppHomePageFirstImageLoadObserver

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXTestSkeletonInCatalog = AvatarExperienceFlags.FFlagAXTestSkeletonInCatalog
local v = game:DefineFastFlag("AXTestDontUseSkeletonOnloadInCatalog", false) and FFlagAXTestSkeletonInCatalog

local function ItemCardThumbnail(props, callback)
	local state, setState = React.useState(false)
	local v2 = useDesignTokens()
	local tag = props.tag

	if FFlagLuaAppHomePageFirstImageLoadObserver then
		tag = not tag and "observed-image" or `{tag} observed-image`
	end

	local ref = React.useCallback(function(current)
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

	if FFlagAXTestSkeletonInCatalog and props.inSkeletonExperiment then
		local createElement = React.createElement
		local fragment = React.Fragment
		local itemCardThumbnailSkeleton

		if not (v or state) then
			itemCardThumbnailSkeleton = React.createElement(ItemCardThumbnailSkeleton, {
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
				testId = `item-card-thumbnail-skeleton-{props.url}`,
				radius = Radius.Medium
			})
		end

		return createElement(fragment, nil, {
			ItemCardThumbnailSkeleton = itemCardThumbnailSkeleton,
			ItemCardThumbnailImage = React.createElement(Image, {
				imageRect = props.imageRect,
				Image = props.url,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ref = ref,
				testId = `item-card-thumbnail-image-{props.url}`,
				tag = props.tag
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v2.Radius.Medium)
				})
			})
		})
	else
		local createElement = React.createElement
		local fragment = React.Fragment
		local itemCardThumbnailSkeleton

		if not state then
			itemCardThumbnailSkeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
				testId = `item-card-thumbnail-skeleton-{props.url}`,
				radius = Radius.Medium
			})
		end

		return createElement(fragment, nil, {
			ItemCardThumbnailSkeleton = itemCardThumbnailSkeleton,
			ItemCardThumbnailImage = React.createElement(Image, {
				imageRect = props.imageRect,
				Image = props.url,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ref = ref,
				testId = `item-card-thumbnail-image-{props.url}`,
				tag = tag
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v2.Radius.Medium)
				})
			})
		})
	end
end

return React.forwardRef(ItemCardThumbnail)
