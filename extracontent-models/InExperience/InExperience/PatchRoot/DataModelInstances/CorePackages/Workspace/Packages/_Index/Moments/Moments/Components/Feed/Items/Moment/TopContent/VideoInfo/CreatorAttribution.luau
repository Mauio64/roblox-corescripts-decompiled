local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local ReactOtter = require(MomentsParent.ReactOtter)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local Analytics = MomentsCommon.Analytics
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local Foundation = require(MomentsParent.Foundation)
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local useUsername = require(Moments.Hooks.useUsername)
local ImageWithSkeleton = require(Moments.Components.ImageWithSkeleton)
local useMomentsHost = require(Moments.MomentsHostContext).useMomentsHost
local MomentContext = require(script.Parent.Parent.Parent.MomentContext)

require(script.Parent.Parent.Parent.createMomentStore)

local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local vector2 = Vector2.new(120, 16)
local t1 = {
	Transparency = 0,
	Color3 = Color3.new(1, 1, 1)
}
local v29 = utf8.char(57344)

local function CreatorAttribution(t2: {[any]: any}) -- line: 60
	-- upvalues: useTokens (copy), MomentContext (copy), React (copy), ReactOtter (copy), useUsername (copy), useMomentsHost (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeFeedActionFields (copy), fireAnalyticsEvent (copy), EventNames (copy), v29 (copy), View (copy), StateLayerAffordance (copy), ControlState (copy), ImageWithSkeleton (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), EnumsRadius (copy), getColorStyleWithTransparency (copy), t1 (copy), FoundationText (copy), Skeleton (copy), vector2 (copy)
	local v32 = useTokens()
	local v33 = MomentContext.useMoment()
	local v34 = v33.store.getData(false)
	local v35, v36 = React.useState(false)
	local v37, v38 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 69
		-- upvalues: v38 (copy), ReactOtter (copy), v35 (copy)
		v38(ReactOtter.ease(not v35 and 0 or 0.6, {
			duration = not v35 and 0.03 or 0.05,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, { v35 })

	local animationRatio = v33.animationRatio
	local v40 = React.joinBindings({
		animationRatio,
		v37
	}):map(function(t3: {[any]: any}) -- line: 77
		return 1 - (1 - t3[1]) * (1 - t3[2])
	end)
	local v41 = useUsername(v34.creatorId)
	local openProfile = useMomentsHost().openProfile
	local v43 = React.useCallback(function() -- line: 92
		-- upvalues: openProfile (copy), GetFFlagMomentsAnalyticsSchemaIdentity (copy), makeFeedActionFields (copy), v34 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if openProfile ~= nil then
			if GetFFlagMomentsAnalyticsSchemaIdentity() then
				local v47 = makeFeedActionFields(v34.momentId, v34.feedItemId, v34.feedSessionId)

				if v47 ~= nil then
					fireAnalyticsEvent(EventNames.ProfileCreatorInfoTapped, v47)
				end
			else
				fireAnalyticsEvent(EventNames.ProfileCreatorInfoTapped, {
					userId = tostring(v34.creatorId)
				})
			end

			openProfile(v34.creatorId)
		end
	end, if not GetFFlagMomentsAnalyticsSchemaIdentity() then {
		openProfile,
		v34.creatorId
	} else {
		openProfile,
		v34.creatorId,
		v34.momentId,
		v34.feedItemId,
		v34.feedSessionId
	})
	local Size_800 = v32.Size.Size_800
	local v45 = if not v41 or not v34.creatorIsVerified then v41 else `{ v41 } { v29 }`

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-small auto-xy",
		LayoutOrder = t2.LayoutOrder,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onActivated = if openProfile == nil then nil else v43,
		onStateChanged = function(p1) -- line: 131
			-- upvalues: v36 (copy), ControlState (copy)
			v36(p1 == ControlState.Pressed or p1 == ControlState.SelectedPressed)
		end
	}, {
		Avatar = React.createElement(ImageWithSkeleton, {
			LayoutOrder = 1,
			Image = getRbxThumb(ThumbnailType.AvatarHeadShot, v34.creatorId, ThumbnailSize.Medium),
			Size = UDim2.fromOffset(Size_800, Size_800),
			radius = EnumsRadius.Circle,
			backgroundStyle = v40:map(function(n1: number) -- line: 142
				-- upvalues: getColorStyleWithTransparency (copy), v32 (copy)
				return getColorStyleWithTransparency(v32.Color.Shift.Shift_300, n1)
			end),
			imageStyle = v40:map(function(n2: number) -- line: 145
				-- upvalues: getColorStyleWithTransparency (copy), t1 (copy)
				return getColorStyleWithTransparency(t1, n2)
			end)
		}),
		Username = if not v45 then React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = EnumsRadius.Medium,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		}) else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-title-large text-align-x-left text-align-y-center text-truncate-end content-emphasis",
			Text = v45,
			textStyle = v40:map(function(n3: number) -- line: 155
				-- upvalues: getColorStyleWithTransparency (copy), v32 (copy)
				return getColorStyleWithTransparency(v32.Color.Content.Emphasis, n3)
			end)
		})
	})
end

return React.memo(CreatorAttribution)
