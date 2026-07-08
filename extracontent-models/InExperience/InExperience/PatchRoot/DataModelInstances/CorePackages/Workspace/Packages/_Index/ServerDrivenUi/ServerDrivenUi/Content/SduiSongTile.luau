local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local Cryo = require(ServerDrivenUiParent.Cryo)
local useSongAlbumArt = require(ServerDrivenUiParent.Songbird).useSongAlbumArt
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local executeAction = SduiCoreSystem.executeAction
local SduiTile = require(ServerDrivenUi.Content.SduiTile)
local SduiTileFooter = require(ServerDrivenUi.Content.SduiTileFooter)

local function SduiSongTile(p1) -- line: 28
	-- upvalues: useTokens (copy), useSongAlbumArt (copy), React (copy), SduiActionType (copy), executeAction (copy), SduiTileFooter (copy), SduiTile (copy), Cryo (copy)
	local v14 = useTokens()
	local songId = p1.songId
	local v16 = useSongAlbumArt(songId)
	local v17 = if not p1.image or p1.image == "" then v16.value else p1.image
	local v18 = React.useCallback(function() -- line: 35
		-- upvalues: p1 (copy), SduiActionType (copy), songId (copy), executeAction (copy)
		if p1.onActivated then
			p1.onActivated()

			return
		end

		local t1 = {
			actionType = SduiActionType.OpenSongDetail,
			actionParams = {
				songId = songId
			}
		}

		executeAction(t1, p1.analyticsContext, p1.sduiContext)
	end, {
		p1.onActivated,
		p1.sduiContext,
		p1.analyticsContext,
		songId
	})
	local v19 = React.useMemo(function() -- line: 49
		-- upvalues: p1 (copy), React (copy), SduiTileFooter (copy)
		if p1.footerComponent then
			return p1.footerComponent
		end

		return React.createElement(SduiTileFooter, {
			testId = "--sdui-song-tile-footer-artist",
			leftText = p1.artistText
		})
	end, {
		p1.footerComponent,
		p1.artistText,
		v14
	})

	return React.createElement(SduiTile, Cryo.Dictionary.join(p1, {
		testId = "--sdui-song-tile",
		image = v17,
		onActivated = v18,
		footerComponent = v19
	}))
end

return React.memo(SduiSongTile)
