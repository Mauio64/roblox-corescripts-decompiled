local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local RoactAppExperiment = require(ParentParentParent.RoactAppExperiment)
local InspectCTA = require(ParentParent.Components.FeedOverlay.InspectCTA)
local ShareCTA = require(ParentParent.Components.FeedOverlay.ShareCTA)
local View = Foundation.View
local getAvatarItemIds = require(ParentParent.Utils.getAvatarItemIds)
local useAppPolicy = require(ParentParentParent.UniversalAppPolicy).useAppPolicy
local useUserExperiment = RoactAppExperiment.useUserExperiment
local FFlagContentFeedInspectEnabledForAll = require(ParentParent.Flags.FFlagContentFeedInspectEnabledForAll)
local FFlagContentFeedInspectExperimentEnabled = require(ParentParent.Flags.FFlagContentFeedInspectExperimentEnabled)
local FStringContentFeedIXPLayer = require(ParentParent.Flags.FStringContentFeedIXPLayer)

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: useAppPolicy (copy), React (copy), getAvatarItemIds (copy), FFlagContentFeedInspectEnabledForAll (copy), FFlagContentFeedInspectExperimentEnabled (copy), useUserExperiment (copy), FStringContentFeedIXPLayer (copy), View (copy), InspectCTA (copy), ShareCTA (copy)
	local v16 = useAppPolicy(function(p1) -- line: 29
		return p1.getEligibleForExternalContentSharing()
	end)
	local v17 = React.useMemo(function() -- line: 33
		-- upvalues: getAvatarItemIds (copy), t1 (copy)
		return getAvatarItemIds(t1.additionalInfo)
	end, { t1.additionalInfo })
	local v18 = false

	if FFlagContentFeedInspectEnabledForAll then
		v18 = true
	elseif FFlagContentFeedInspectExperimentEnabled then
		v18 = useUserExperiment({ FStringContentFeedIXPLayer }, function(p2) -- line: 41
			-- upvalues: FStringContentFeedIXPLayer (copy)
			return (p2[FStringContentFeedIXPLayer] or {}).ContentFeedInspectEnabled
		end)
	end

	return React.createElement(View, {
		tag = "align-x-center align-y-center col auto-xy bg-action-subtle items-center gap-medium",
		LayoutOrder = t1.layoutOrder
	}, {
		InspectCTA = if not v18 or not v17 then nil else React.createElement(InspectCTA, {
			layoutOrder = 1,
			avatarItemIds = v17,
			postId = t1.postId
		}),
		ShareCTA = if not v16 then nil else React.createElement(ShareCTA, {
			layoutOrder = 2,
			creatorUserId = t1.creatorUserId,
			postId = t1.postId
		})
	})
end
