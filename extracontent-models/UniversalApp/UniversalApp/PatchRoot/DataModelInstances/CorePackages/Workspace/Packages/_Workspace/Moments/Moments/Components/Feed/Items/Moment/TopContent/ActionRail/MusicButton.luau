local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
local View = Foundation.View
local MusicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local MusicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize
local useMusicInfo = require(Moments.Hooks.useMusicInfo)
local MusicModal = require(Moments.Components.MusicModal)

local function MusicButton(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), useMusicInfo (copy), View (copy), MusicThumbnailIcon (copy), MusicThumbnailIconSize (copy), MusicModal (copy)
	local moment = t1.moment
	local v14, v15 = React.useState(false)
	local v16 = React.useMemo(function() -- line: 30
		-- upvalues: moment (copy)
		if moment == nil then
			return nil
		end

		local edits = moment.metadata.edits

		if edits == nil then
			return nil
		end

		local music = edits.music

		if music == nil then
			return nil
		end

		return music.assetId
	end, { moment })
	local v17 = useMusicInfo(v16)
	local v18 = React.useCallback(function() -- line: 47
		-- upvalues: v15 (copy)
		v15(true)
	end, {})
	local v19 = React.useCallback(function() -- line: 51
		-- upvalues: v15 (copy)
		v15(false)
	end, {})

	if v17 == nil then
		return nil
	end

	return React.createElement(React.Fragment, nil, {
		Button = React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			GroupTransparency = t1.animationRatio,
			LayoutOrder = t1.LayoutOrder,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Inner = React.createElement(View, {
				tag = "align-x-center align-y-center size-1200-1200 radius-medium",
				isDisabled = t1.isDisabled,
				onActivated = v18
			}, {
				MusicThumbnail = React.createElement(MusicThumbnailIcon, {
					assetId = v17.AssetId,
					size = MusicThumbnailIconSize.Small
				})
			})
		}),
		Modal = if not v14 then nil else React.createElement(MusicModal, {
			musicInfo = v17,
			onClose = v19
		})
	})
end

return React.memo(MusicButton)
