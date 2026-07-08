local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local ReactOtter = require(MomentsParent.ReactOtter)
local Analytics = require(MomentsParent.MomentsCommon).Analytics
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local EventNames = Analytics.EventNames
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
local v26 = utf8.char(57344)

local function CreatorAttribution(t2: {[any]: any}) -- line: 57
	-- upvalues: useTokens (copy), MomentContext (copy), React (copy), ReactOtter (copy), useUsername (copy), useMomentsHost (copy), fireAnalyticsEvent (copy), EventNames (copy), v26 (copy), View (copy), StateLayerAffordance (copy), ControlState (copy), ImageWithSkeleton (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), EnumsRadius (copy), getColorStyleWithTransparency (copy), t1 (copy), FoundationText (copy), Skeleton (copy), vector2 (copy)
	local v29 = useTokens()
	local v30 = MomentContext.useMoment()
	local v31 = v30.store.getData(false)
	local v32, v33 = React.useState(false)
	local v34, v35 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 66
		-- upvalues: v35 (copy), ReactOtter (copy), v32 (copy)
		v35(ReactOtter.ease(not v32 and 0 or 0.6, {
			duration = not v32 and 0.03 or 0.05,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, { v32 })

	local animationRatio = v30.animationRatio
	local v37 = React.joinBindings({
		animationRatio,
		v34
	}):map(function(t3: {[any]: any}) -- line: 74
		return 1 - (1 - t3[1]) * (1 - t3[2])
	end)
	local v38 = useUsername(v31.creatorId)
	local openProfile = useMomentsHost().openProfile
	local v40 = React.useCallback(function() -- line: 84
		-- upvalues: openProfile (copy), fireAnalyticsEvent (copy), EventNames (copy), v31 (copy)
		if openProfile ~= nil then
			fireAnalyticsEvent(EventNames.ProfileCreatorInfoTapped, {
				userId = tostring(v31.creatorId)
			})
			openProfile(v31.creatorId)
		end
	end, {
		openProfile,
		v31.creatorId
	})
	local Size_800 = v29.Size.Size_800
	local v42 = if not v38 or not v31.creatorIsVerified then v38 else `{ v38 } { v26 }`

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-small auto-xy",
		LayoutOrder = t2.LayoutOrder,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onActivated = if openProfile == nil then nil else v40,
		onStateChanged = function(p1) -- line: 104
			-- upvalues: v33 (copy), ControlState (copy)
			v33(p1 == ControlState.Pressed or p1 == ControlState.SelectedPressed)
		end
	}, {
		Avatar = React.createElement(ImageWithSkeleton, {
			LayoutOrder = 1,
			Image = getRbxThumb(ThumbnailType.AvatarHeadShot, v31.creatorId, ThumbnailSize.Medium),
			Size = UDim2.fromOffset(Size_800, Size_800),
			radius = EnumsRadius.Circle,
			backgroundStyle = v37:map(function(n1: number) -- line: 115
				-- upvalues: getColorStyleWithTransparency (copy), v29 (copy)
				return getColorStyleWithTransparency(v29.Color.Shift.Shift_300, n1)
			end),
			imageStyle = v37:map(function(n2: number) -- line: 118
				-- upvalues: getColorStyleWithTransparency (copy), t1 (copy)
				return getColorStyleWithTransparency(t1, n2)
			end)
		}),
		Username = if not v42 then React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = EnumsRadius.Medium,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		}) else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-title-large text-align-x-left text-align-y-center text-truncate-end content-emphasis",
			Text = v42,
			textStyle = v37:map(function(n3: number) -- line: 128
				-- upvalues: getColorStyleWithTransparency (copy), v29 (copy)
				return getColorStyleWithTransparency(v29.Color.Content.Emphasis, n3)
			end)
		})
	})
end

return React.memo(CreatorAttribution)
