local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local MomentsCommon = require(ProfilePlatformParent.MomentsCommon)

require(ProfilePlatformParent.DataHydration.MomentsStoreTypes)

local ToMediaItem = require(ProfilePlatformParent.Moments.ToMediaItem)
local useExperienceName = require(ProfilePlatform.Hooks.useExperienceName)
local View = Foundation.View
local FoundationText = Foundation.Text
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local MomentMediaTile = MomentsCommon.Media.MomentMediaTile

local function MomentTile(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), useExperienceName (copy), React (copy), ToMediaItem (copy), View (copy), StateLayerAffordance (copy), MomentMediaTile (copy), FoundationText (copy)
	local moment = t1.moment
	local v16 = useTokens()
	local v17 = useExperienceName(moment.metadata.universeId)
	local v18 = React.useMemo(function() -- line: 44
		-- upvalues: ToMediaItem (copy), moment (copy), v16 (copy)
		local v19 = ToMediaItem({
			kind = "moment",
			moment = moment
		})

		v19.cornerRadius = v16.Radius.Large

		return v19
	end, { moment.momentId })

	return React.createElement(View, {
		tag = "col gap-xsmall",
		LayoutOrder = t1.layoutOrder,
		Size = t1.itemSize,
		onActivated = t1.onActivated,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		MediaContainer = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, -48 - v16.Gap.XSmall)
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v16.Radius.Large)
			}),
			Media = React.createElement(MomentMediaTile, {
				mediaItem = v18,
				isActive = t1.isActive
			})
		}),
		Footer = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-left align-y-top gap-xxsmall",
			Size = UDim2.new(1, 0, 0, 48)
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-align-x-left text-truncate-end",
				fontStyle = v16.Typography.TitleMedium,
				textStyle = v16.Color.Content.Emphasis,
				Text = moment.metadata.experienceName or (v17 or "")
			})
		})
	})
end

return MomentTile
