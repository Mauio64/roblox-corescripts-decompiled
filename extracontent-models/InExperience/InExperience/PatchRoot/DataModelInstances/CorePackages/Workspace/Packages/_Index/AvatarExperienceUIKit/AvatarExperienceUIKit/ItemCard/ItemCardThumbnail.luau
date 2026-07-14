local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local ItemCardThumbnailSkeleton = require(script.Parent.ItemCardThumbnailSkeleton)
local useDesignTokens = require(Parent.Style).useDesignTokens
local FFlagAXMigrateAXToGlobalAutofocus = require(Parent.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagLuaAppHomePageFirstImageLoadObserver = require(Parent.SharedFlags).FFlagLuaAppHomePageFirstImageLoadObserver
local FFlagAXTestSkeletonInCatalog = require(Parent.AvatarExperienceFlags).FFlagAXTestSkeletonInCatalog
local v14 = game:DefineFastFlag("AXTestDontUseSkeletonOnloadInCatalog", false) and FFlagAXTestSkeletonInCatalog

local function ItemCardThumbnail(t1: {[any]: any}, p1) -- line: 37
	-- upvalues: React (copy), useDesignTokens (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), RunService (copy), FFlagAXTestSkeletonInCatalog (copy), v14 (copy), ItemCardThumbnailSkeleton (copy), EnumsRadius (copy), FoundationImage (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Skeleton (copy)
	local v18, v19 = React.useState(false)
	local v20 = useDesignTokens()
	local v21 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t1.tag
	local v22 = if not FFlagLuaAppHomePageFirstImageLoadObserver then v21 else not v21 and "observed-image" or `{ v21 } observed-image`
	local v23 = React.useCallback(function(p2) -- line: 46
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p1 (copy), v19 (copy), t1 (copy), RunService (copy)
		if FFlagAXMigrateAXToGlobalAutofocus then
			if typeof(p1) == "function" then
				p1(p2)
			elseif typeof(p1) == "table" then
				p1.current = p2
			end
		end

		v19(false)

		if p2 and t1.url then
			local connection = nil
			local timestamp = tick()

			connection = RunService.Heartbeat:Connect(function(dt) -- line: 58
				-- upvalues: timestamp (ref), p2 (copy), v19 (copy), t1 (copy), connection (ref)
				timestamp += dt

				if p2.IsLoaded then
					v19(true)

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
			ItemCardThumbnailSkeleton = if v14 or v18 then nil else React.createElement(ItemCardThumbnailSkeleton, {
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
				ref = v23,
				testId = `item-card-thumbnail-image-{ t1.url }`,
				tag = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t1.tag
			}, {
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v20.Semantic.Radius.Medium else v20.Radius.Medium)
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, {
		ItemCardThumbnailSkeleton = if v18 then nil else React.createElement(Skeleton, {
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
			ref = v23,
			testId = `item-card-thumbnail-image-{ t1.url }`,
			tag = v22
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v20.Semantic.Radius.Medium else v20.Radius.Medium)
			})
		})
	})
end

if FFlagAXMigrateAXToGlobalAutofocus then
	return (React.forwardRef(ItemCardThumbnail))
end

return ItemCardThumbnail
