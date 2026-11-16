local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)

local MomentItem = require(Moments.Components.Feed.Items.Moment.MomentItem)
require(Moments.Components.Feed.Items.Moment.MomentContext)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
require(parent.MomentsTypes)

local function AvatarMomentView(p)
	local element = React.createElement(MomentsCommon.Media.MomentMediaView, {
		momentId = p.moment.momentId,
		suppressTapToToggle = true,
		getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
	})

	return React.createElement(Foundation.View, {
		backgroundStyle = { Transparency = 1 },
		tag = "size-full"
	}, {
		Moment = React.createElement(MomentItem, {
			data = p.data,
			moment = p.moment,
			mediaSurface = element,
			isStaticMedia = true,
			isWorkspaceRendered = true
		})
	})
end

return AvatarMomentView
