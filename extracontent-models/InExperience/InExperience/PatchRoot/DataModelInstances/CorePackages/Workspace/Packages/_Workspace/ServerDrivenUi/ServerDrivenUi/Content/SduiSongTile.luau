local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Cryo = require(parent.Cryo)
local Songbird = require(parent.Songbird)
local useSongAlbumArt = Songbird.useSongAlbumArt
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local executeAction = SduiCoreSystem.executeAction

local SduiTile = require(ServerDrivenUi.Content.SduiTile)
local SduiTileFooter = require(ServerDrivenUi.Content.SduiTileFooter)

local function SduiSongTile(props)
	local v = useTokens()
	local songId = props.songId

	local v2 = useSongAlbumArt(songId)
	local image

	if props.image and props.image ~= "" then
		image = props.image
	else
		image = v2.value
	end

	local onActivated = React.useCallback(function()
		if props.onActivated then
			props.onActivated()
		else
			executeAction({
				actionType = SduiActionType.OpenSongDetail,
				actionParams = { songId = songId }
			}, props.analyticsContext, props.sduiContext)
		end
	end, { props.onActivated, props.sduiContext, props.analyticsContext, songId })

	local footerComponent = React.useMemo(function()
		if props.footerComponent then
			return props.footerComponent
		end

		return React.createElement(SduiTileFooter, {
			leftText = props.artistText,
			testId = "--sdui-song-tile-footer-artist"
		})
	end, { props.footerComponent, props.artistText, v })

	return React.createElement(
		SduiTile,
		Cryo.Dictionary.join(props, {
			image = image,
			onActivated = onActivated,
			footerComponent = footerComponent,
			testId = "--sdui-song-tile"
		})
	)
end

return React.memo(SduiSongTile)
