local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local view = Foundation.View

local musicThumbnailIcon = MomentsCommon.Components.MusicThumbnailIcon
local musicThumbnailIconSize = MomentsCommon.Enums.MusicThumbnailIconSize

local useMusicInfo = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useMusicInfo")
local MusicModal = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MusicModal")
local FFlagMomentsActionRailSpacing = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsActionRailSpacing")

local function MusicButton(props)
	local moment = props.moment
	local state, setState = React.useState(false)

	local v6 = useMusicInfo((React.useMemo(function()
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
	end, { moment })))

	local v7 = React.useCallback(function()
		setState(true)
	end, {})

	local v8 = React.useCallback(function()
		setState(false)
	end, {})

	if v6 == nil then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v10 = {
		Button = React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			GroupTransparency = props.animationRatio,
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Inner = React.createElement(view, {
				isDisabled = props.isDisabled,
				onActivated = v7,
				tag = FFlagMomentsActionRailSpacing and "align-x-center align-y-center size-1000-1000 radius-medium" or "align-x-center align-y-center size-1200-1200 radius-medium"
			}, {
				MusicThumbnail = React.createElement(musicThumbnailIcon, {
					assetId = v6.AssetId,
					size = musicThumbnailIconSize.Small
				})
			})
		}),
		Modal = 0
	}

	local v11 = if state then React.createElement(MusicModal, {
		musicInfo = v6,
		onClose = v8
	}) else nil
	v10.Modal = v11
	return createElement(fragment, nil, v10)
end

return React.memo(MusicButton)
