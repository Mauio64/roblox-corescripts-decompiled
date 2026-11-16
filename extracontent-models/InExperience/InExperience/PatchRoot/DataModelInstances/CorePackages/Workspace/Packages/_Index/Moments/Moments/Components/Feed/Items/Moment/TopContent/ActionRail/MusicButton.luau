local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)

local View = Foundation.View

local MusicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local MusicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize

local useMusicInfo = require(Moments.Hooks.useMusicInfo)
local MusicModal = require(Moments.Components.MusicModal)
local FFlagMomentsActionRailSpacing = require(Moments.Flags.FFlagMomentsActionRailSpacing)

local function MusicButton(props)
	local moment = props.moment
	local state, setState = React.useState(false)

	local musicInfo = useMusicInfo((React.useMemo(function()
		if moment == nil then
			return nil
		end

		local edits = moment.metadata.edits

		if edits == nil then
			return nil
		end

		local music = edits.music

		return if music ~= nil then music.assetId else nil
	end, { moment })))

	local onActivated = React.useCallback(function()
		setState(true)
	end, {})

	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	if musicInfo == nil then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v = {
		Button = React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			GroupTransparency = props.animationRatio,
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Inner = React.createElement(View, {
				isDisabled = props.isDisabled,
				onActivated = onActivated,
				tag = FFlagMomentsActionRailSpacing and "align-x-center align-y-center size-1000-1000 radius-medium" or "align-x-center align-y-center size-1200-1200 radius-medium"
			}, {
				MusicThumbnail = React.createElement(MusicThumbnailIcon, {
					assetId = musicInfo.AssetId,
					size = MusicThumbnailIconSize.Small
				})
			})
		}),
		Modal = 0
	}
	local modal

	if state then
		modal = React.createElement(MusicModal, { musicInfo = musicInfo, onClose = onClose })
	end

	v.Modal = modal
	return createElement(fragment, nil, v)
end

return React.memo(MusicButton)
