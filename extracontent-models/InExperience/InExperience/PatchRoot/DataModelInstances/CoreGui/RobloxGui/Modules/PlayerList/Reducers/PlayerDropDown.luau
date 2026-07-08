local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Actions = script.Parent.Parent.Actions
local OpenPlayerDropDown = require(Actions.OpenPlayerDropDown)
local ClosePlayerDropDown = require(Actions.ClosePlayerDropDown)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerListVisibility = require(Actions.SetPlayerListVisibility)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local t1 = {
	isVisible = false,
	selectedPlayer = nil
}

return (Rodux.createReducer(t1, {
	[SetPlayerListVisibility.name] = function(p1, p2) -- line: 21
		-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy)
		if not p2.isVisible then
			return {
				isVisible = false,
				selectedPlayer = if not FFlagAddNewPlayerListMobileFocusNav then p1.selectedPlayer else nil
			}
		end

		return p1
	end,
	[OpenPlayerDropDown.name] = function(_, p4) -- line: 31
		return {
			isVisible = true,
			selectedPlayer = p4.selectedPlayer
		}
	end,
	[ClosePlayerDropDown.name] = function(p5, _) -- line: 38
		return {
			isVisible = false,
			selectedPlayer = p5.selectedPlayer
		}
	end,
	[RemovePlayer.name] = function(p7, p8) -- line: 45
		if p8.player == p7.selectedPlayer then
			return {
				isVisible = false,
				selectedPlayer = nil
			}
		end

		return p7
	end
}))
