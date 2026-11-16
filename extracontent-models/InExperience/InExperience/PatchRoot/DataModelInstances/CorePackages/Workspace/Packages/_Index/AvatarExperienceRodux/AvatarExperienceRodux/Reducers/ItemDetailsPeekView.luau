local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local parent = AvatarExperienceRodux.Parent

local Cryo = require(parent.Cryo)
local PeekView = require(parent.PeekView)
local PeekViewState = PeekView.PeekViewState
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local Rodux = require(parent.Rodux)

local SetItemDetailsPeekViewState = require(AvatarExperienceRodux.Actions.SetItemDetailsPeekViewState)
local SetItemTryOnPeekViewState = require(AvatarExperienceRodux.Actions.SetItemTryOnPeekViewState)
local SetTryOnManagerPeekViewState = require(AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState)
local SetLookDetailsPeekViewSelectedTab = require(AvatarExperienceRodux.Actions.SetLookDetailsPeekViewSelectedTab)

local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated

local v = {
	viewState = PeekViewState.Closed,
	tryOnViewState = PeekViewState.Closed,
	tryOnManagerViewState = PeekViewState.Closed,
	lookDetailsSelectedTab = 2
}

return Rodux.createReducer(v, {
	[SetItemDetailsPeekViewState.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { viewState = p2.viewState })
	end,
	[SetItemTryOnPeekViewState.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { tryOnViewState = p2.viewState })
	end,
	[SetTryOnManagerPeekViewState.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { tryOnManagerViewState = p2.viewState })
	end,
	[SetLookDetailsPeekViewSelectedTab.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { lookDetailsSelectedTab = p2.selectedTab })
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p, p2)
		if not (p2.tryOn and p2.tryOn.OutfitTryOn) then
			return p
		end

		local lookId = p2.tryOn.OutfitTryOn.LookId
		local v2

		if lookId == nil then
			v2 = false
		else
			v2 = lookId ~= Cryo.None
		end

		local v3 = v2 and p.tryOnManagerViewState == PeekViewState.Closed
		local v4 = not v2 and p.tryOnManagerViewState ~= PeekViewState.Closed
		local join = Cryo.Dictionary.join
		local tryOnManagerViewState

		if v3 then
			tryOnManagerViewState = PeekViewState.SuperBrief
		elseif v4 then
			tryOnManagerViewState = PeekViewState.Closed
		else
			tryOnManagerViewState = p.tryOnManagerViewState
		end

		return join(p, { tryOnManagerViewState = tryOnManagerViewState })
	end
})
