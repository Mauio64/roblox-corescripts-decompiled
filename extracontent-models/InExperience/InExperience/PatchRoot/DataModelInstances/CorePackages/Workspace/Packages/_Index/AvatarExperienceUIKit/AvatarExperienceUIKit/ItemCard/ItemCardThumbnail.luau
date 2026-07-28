local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local ItemCardThumbnailSkeleton = require(script.Parent.ItemCardThumbnailSkeleton)
local useDesignTokens = require(Parent.Style).useDesignTokens
local FFlagAXMigrateAXToGlobalAutofocus = require(Parent.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagLuaAppHomePageFirstImageLoadObserver = require(Parent.SharedFlags).FFlagLuaAppHomePageFirstImageLoadObserver
local FFlagAXTestSkeletonInCatalog = require(Parent.AvatarExperienceFlags).FFlagAXTestSkeletonInCatalog
local v13 = game:DefineFastFlag("AXTestDontUseSkeletonOnloadInCatalog", false) and FFlagAXTestSkeletonInCatalog

local function ItemCardThumbnail(t1: {[any]: any}, p1) -- line: 35
	-- upvalues: React (copy), useDesignTokens (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), RunService (copy), FFlagAXTestSkeletonInCatalog (copy), v13 (copy), ItemCardThumbnailSkeleton (copy), EnumsRadius (copy), FoundationImage (copy), Skeleton (copy)
	local v17, v18 = React.useState(false)
	local v19 = useDesignTokens()
	local v20 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t1.tag
	local v21 = if not FFlagLuaAppHomePageFirstImageLoadObserver then v20 else not v20 and "observed-image" or `{ v20 } observed-image`
	local v22 = React.useCallback(function(p2) -- line: 44
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p1 (copy), v18 (copy), t1 (copy), RunService (copy)
		if FFlagAXMigrateAXToGlobalAutofocus then
			if typeof(p1) == "function" then
				p1(p2)
			elseif typeof(p1) == "table" then
				p1.current = p2
			end
		end

		v18(false)

		if p2 and t1.url then
			local connection = nil
			local timestamp = tick()

			connection = RunService.Heartbeat:Connect(function(dt) -- line: 56
				-- upvalues: timestamp (ref), p2 (copy), v18 (copy), t1 (copy), connection (ref)
				timestamp += dt

				if p2.IsLoaded then
					v18(true)

					if t1.onLoaded then
						t1.onLoaded(timestamp)
					end

					connection:Disconnect()

					return
				end

				if not p2.Parent then
					connection:Disconnect()
				end
			end)
		end
	end, {
		t1.onLoaded,
		t1.url
	})

	if FFlagAXTestSkeletonInCatalog and t1.inSkeletonExperiment then
		return React.createElement(React.Fragment, nil, {
			ItemCardThumbnailSkeleton = if v13 or v17 then nil else React.createElement(ItemCardThumbnailSkeleton, {
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				testId = `item-card-thumbnail-skeleton-{ t1.url }`,
				radius = EnumsRadius.Medium
			}),
			ItemCardThumbnailImage = React.createElement(FoundationImage, {
				imageRect = t1.imageRect,
				Image = t1.url,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				ref = v22,
				testId = `item-card-thumbnail-image-{ t1.url }`,
				tag = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t1.tag
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v19.Radius.Medium)
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, {
		ItemCardThumbnailSkeleton = if v17 then nil else React.createElement(Skeleton, {
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			testId = `item-card-thumbnail-skeleton-{ t1.url }`,
			radius = EnumsRadius.Medium
		}),
		ItemCardThumbnailImage = React.createElement(FoundationImage, {
			imageRect = t1.imageRect,
			Image = t1.url,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			ref = v22,
			testId = `item-card-thumbnail-image-{ t1.url }`,
			tag = v21
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v19.Radius.Medium)
			})
		})
	})
end

if FFlagAXMigrateAXToGlobalAutofocus then
	return (React.forwardRef(ItemCardThumbnail))
end

return ItemCardThumbnail
