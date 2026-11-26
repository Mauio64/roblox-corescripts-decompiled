local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Cryo")
local peekViewState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/PeekView").PeekViewState
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

local SetItemDetailsPeekViewState = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetItemDetailsPeekViewState")
local SetItemTryOnPeekViewState = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetItemTryOnPeekViewState")
local SetTryOnManagerPeekViewState = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetTryOnManagerPeekViewState")
local SetLookDetailsPeekViewSelectedTab = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetLookDetailsPeekViewSelectedTab")

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated

local v5 = {
	viewState = peekViewState.Closed,
	tryOnViewState = peekViewState.Closed,
	tryOnManagerViewState = peekViewState.Closed,
	lookDetailsSelectedTab = 2
}

return Rodux.createReducer(v5, {
	[SetItemDetailsPeekViewState.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { viewState = p3.viewState })
	end,
	[SetItemTryOnPeekViewState.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { tryOnViewState = p3.viewState })
	end,
	[SetTryOnManagerPeekViewState.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { tryOnManagerViewState = p3.viewState })
	end,
	[SetLookDetailsPeekViewSelectedTab.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { lookDetailsSelectedTab = p3.selectedTab })
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if not (p3.tryOn and p3.tryOn.OutfitTryOn) then
			return p2
		end

		local lookId = p3.tryOn.OutfitTryOn.LookId
		local v7 = not (lookId == nil) and lookId ~= Cryo.None
		local v8 = v7 and p2.tryOnManagerViewState == peekViewState.Closed
		local v9 = not v7 and p2.tryOnManagerViewState ~= peekViewState.Closed
		local join = Cryo.Dictionary.join
		local v11

		if v8 then
			v11 = peekViewState.SuperBrief
		else
			v11 = if v9 then peekViewState.Closed else p2.tryOnManagerViewState
		end

		return join(p2, { tryOnManagerViewState = v11 })
	end
})
