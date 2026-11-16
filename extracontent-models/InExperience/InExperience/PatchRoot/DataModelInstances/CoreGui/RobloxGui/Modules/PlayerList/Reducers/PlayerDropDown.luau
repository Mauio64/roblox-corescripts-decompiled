local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local Actions = script.Parent.Parent.Actions
local OpenPlayerDropDown = require(Actions.OpenPlayerDropDown)
local ClosePlayerDropDown = require(Actions.ClosePlayerDropDown)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerListVisibility = require(Actions.SetPlayerListVisibility)

local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav

return (Rodux.createReducer({ isVisible = false, selectedPlayer = nil }, {
	[SetPlayerListVisibility.name] = function(p, p2)
		if p2.isVisible then
			return p
		end

		local selectedPlayer

		if not FFlagAddNewPlayerListMobileFocusNav then
			selectedPlayer = p.selectedPlayer
		end

		return { isVisible = false, selectedPlayer = selectedPlayer }
	end,
	[OpenPlayerDropDown.name] = function(_, p)
		return { isVisible = true, selectedPlayer = p.selectedPlayer }
	end,
	[ClosePlayerDropDown.name] = function(p, _)
		return { isVisible = false, selectedPlayer = p.selectedPlayer }
	end,
	[RemovePlayer.name] = function(p, p2)
		if p2.player == p.selectedPlayer then
			return { isVisible = false, selectedPlayer = nil }
		end

		return p
	end
}))
