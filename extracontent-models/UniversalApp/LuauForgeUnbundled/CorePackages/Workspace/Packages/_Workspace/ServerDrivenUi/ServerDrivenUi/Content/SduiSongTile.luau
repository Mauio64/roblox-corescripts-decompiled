local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local useSongAlbumArt = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Songbird").useSongAlbumArt
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local executeAction = SduiCoreSystem.executeAction

local SduiTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTile")
local SduiTileFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTileFooter")

local function SduiSongTile(props)
	local v5 = useTokens()
	local songId = props.songId

	local v6 = useSongAlbumArt(songId)
	local v7 = if props.image and props.image ~= "" then props.image else v6.value

	local v8 = React.useCallback(function()
		if props.onActivated then
			props.onActivated()
			return
		end

		executeAction({
			actionType = sduiActionType.OpenSongDetail,
			actionParams = { songId = songId }
		}, props.analyticsContext, props.sduiContext)
	end, { props.onActivated, props.sduiContext, props.analyticsContext, songId })

	local v9 = React.useMemo(function()
		if props.footerComponent then
			return props.footerComponent
		end

		return React.createElement(SduiTileFooter, {
			leftText = props.artistText,
			testId = "--sdui-song-tile-footer-artist"
		})
	end, { props.footerComponent, props.artistText, v5 })

	return React.createElement(
		SduiTile,
		Cryo.Dictionary.join(props, {
			image = v7,
			onActivated = v8,
			footerComponent = v9,
			testId = "--sdui-song-tile"
		})
	)
end

return React.memo(SduiSongTile)
