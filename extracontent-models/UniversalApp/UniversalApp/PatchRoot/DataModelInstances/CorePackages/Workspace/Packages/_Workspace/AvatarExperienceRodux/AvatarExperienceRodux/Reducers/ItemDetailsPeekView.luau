local AvatarExperienceRodux = script:FindFirstAncestor("AvatarExperienceRodux")
local AvatarExperienceRoduxParent = AvatarExperienceRodux.Parent
local Cryo = require(AvatarExperienceRoduxParent.Cryo)
local PeekViewState = require(AvatarExperienceRoduxParent.PeekView).PeekViewState
local AvatarExperienceCommon = require(AvatarExperienceRoduxParent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(AvatarExperienceRoduxParent.AvatarExperienceFlags)
local Rodux = require(AvatarExperienceRoduxParent.Rodux)
local SetItemDetailsPeekViewState = require(AvatarExperienceRodux.Actions.SetItemDetailsPeekViewState)
local SetItemTryOnPeekViewState = require(AvatarExperienceRodux.Actions.SetItemTryOnPeekViewState)
local SetTryOnManagerPeekViewState = require(AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState)
local SetLookDetailsPeekViewSelectedTab = require(AvatarExperienceRodux.Actions.SetLookDetailsPeekViewSelectedTab)
local CharacterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated

if AvatarExperienceFlags.FFlagAXRootSlotBasedEditorFlag then
	local t1 = {
		lookDetailsSelectedTab = 2,
		viewState = PeekViewState.Closed,
		tryOnViewState = PeekViewState.Closed,
		tryOnManagerViewState = PeekViewState.Closed
	}

	return Rodux.createReducer(t1, {
		[SetItemDetailsPeekViewState.name] = function(t2: {[any]: any}, t3: {[any]: any}) -- line: 44
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(t2, {
				viewState = t3.viewState
			})
		end,
		[SetItemTryOnPeekViewState.name] = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 49
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(t4, {
				tryOnViewState = t5.viewState
			})
		end,
		[SetTryOnManagerPeekViewState.name] = function(t6: {[any]: any}, t7: {[any]: any}) -- line: 54
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(t6, {
				tryOnManagerViewState = t7.viewState
			})
		end,
		[SetLookDetailsPeekViewSelectedTab.name] = function(t8: {[any]: any}, t9: {[any]: any}) -- line: 59
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(t8, {
				lookDetailsSelectedTab = t9.selectedTab
			})
		end,
		[CharacterHistoryStateChangeButtonActivated.name] = function(t10: {[any]: any}, p1) -- line: 64
			-- upvalues: Cryo (copy), PeekViewState (copy)
			if p1.tryOn and p1.tryOn.OutfitTryOn then
				local LookId = p1.tryOn.OutfitTryOn.LookId
				local v25 = LookId ~= nil and LookId ~= Cryo.None
				local v26 = v25 and t10.tryOnManagerViewState == PeekViewState.Closed
				local v27 = not v25 and t10.tryOnManagerViewState ~= PeekViewState.Closed

				return Cryo.Dictionary.join(t10, {
					tryOnManagerViewState = if not v26 then if not v27 then t10.tryOnManagerViewState else PeekViewState.Closed else PeekViewState.SuperBrief
				})
			end

			return t10
		end
	})
end

return function(t11: {[any]: any}?, t12: {[any]: any}) -- line: 86
	-- upvalues: PeekViewState (copy), SetItemDetailsPeekViewState (copy), Cryo (copy), SetItemTryOnPeekViewState (copy), SetTryOnManagerPeekViewState (copy), SetLookDetailsPeekViewSelectedTab (copy)
	local v30 = t11 or {
		lookDetailsSelectedTab = 2,
		viewState = PeekViewState.Closed,
		tryOnViewState = PeekViewState.Closed,
		tryOnManagerViewState = PeekViewState.Closed
	}

	if t12.type == SetItemDetailsPeekViewState.name then
		return (Cryo.Dictionary.join(v30, {
			viewState = t12.viewState
		}))
	end

	if t12.type == SetItemTryOnPeekViewState.name then
		return (Cryo.Dictionary.join(v30, {
			tryOnViewState = t12.viewState
		}))
	end

	if t12.type == SetTryOnManagerPeekViewState.name then
		return (Cryo.Dictionary.join(v30, {
			tryOnManagerViewState = t12.viewState
		}))
	end

	if t12.type == SetLookDetailsPeekViewSelectedTab.name then
		v30 = Cryo.Dictionary.join(v30, {
			lookDetailsSelectedTab = t12.selectedTab
		})
	end

	return v30
end
