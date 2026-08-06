local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local VersionHistoryContainer = require(BuildExperience.Components.VersionHistory.VersionHistoryContainer)
local PrivateShareTooltip = require(BuildExperience.Components.ShareAudience.PrivateShareTooltip)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local ExperienceShareOverlays = require(BuildExperience.Components.ShareAudience.ExperienceShareOverlays)
local leaveExperience = require(BuildExperience.utils.leaveExperience)
local useExperienceShareFlow = require(BuildExperience.utils.useExperienceShareFlow)
local useSharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience).useSharePublishedExperience
local useCreatorCreditMenuItem = require(script.Parent.useCreatorCreditMenuItem).useCreatorCreditMenuItem
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local FFlagEnableBuildOverflowMenuForNewGames = require(BuildExperience.Flags.FFlagEnableBuildOverflowMenuForNewGames)
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local useScaledValue = Foundation.Hooks.useScaledValue
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local releaseAnyFocus = require(BuildExperience.utils.releaseAnyFocus)
local v23 = game:DefineFastInt("BuildOverflowMenuWidth", 172)

local function BuildOverflowMenuButton(t1: {[any]: any}) -- line: 66
	-- upvalues: useScaledValue (copy), v23 (copy), React (copy), FFlagBuildExperiencePrivateInvites (copy), useExperienceShareFlow (copy), useSharePublishedExperience (copy), FFlagEnableBuildOverflowMenuForNewGames (copy), useCreatorCreditMenuItem (copy), releaseAnyFocus (copy), leaveExperience (copy), VersionHistoryContainer (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy), ExperienceShareOverlays (copy), FriendsOnlyShareDialog (copy), PrivateShareTooltip (copy)
	local v26 = useScaledValue(v23)
	local v27, v28 = React.useState(false)
	local v29, v30 = React.useState(false)
	local v31, v32 = React.useState(false)
	local v33 = React.useRef(nil)
	local v34 = if not FFlagBuildExperiencePrivateInvites then nil else useExperienceShareFlow(t1.target.universeId, t1.target.placeId)
	local v35 = if v34 == nil then nil else v34.onShare
	local v36 = useSharePublishedExperience(t1.target.universeId)
	local v37, v38 = React.useState(nil)
	local v39 = t1.onOpenCreatorCreditPage ~= nil
	local v40 = FFlagEnableBuildOverflowMenuForNewGames and (t1.target.universeId == nil and v39)
	local v41 = t1.isDisabled == true or t1.target.universeId == nil and not v40
	local v42 = t1.hasPublishedTurn == true
	local v43 = React.useMemo(function() -- line: 94
		-- upvalues: t1 (copy), v42 (copy)
		if t1.target.universeId == nil then
			return nil
		end

		return {
			universeId = t1.target.universeId,
			placeId = t1.target.placeId,
			sessionId = t1.target.sessionId,
			isNewGameTarget = t1.target.isNewGameTarget,
			hasPublishedTurn = v42,
			hasPublishedVersion = t1.hasPublishedVersion == true
		}
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.sessionId,
		t1.target.isNewGameTarget,
		v42,
		t1.hasPublishedVersion
	})
	local v44 = t1.store.useItems(v43)
	local v45 = useCreatorCreditMenuItem({
		onOpenCreatorCreditPage = t1.onOpenCreatorCreditPage
	})
	local v46 = React.useMemo(function() -- line: 122
		-- upvalues: v41 (copy), v43 (copy), v44 (copy), v33 (copy), v39 (copy), v45 (copy)
		if v41 then
			return {}
		end

		local t2 = {}

		if v43 ~= nil then
			for _, v56 in v44 do
				local t3 = {
					items = {}
				}

				for _, v59 in v56.items do
					local v60 = if v59.isDisabled == nil then nil else v59.isDisabled(v43)
					local t4 = {
						id = v59.id,
						text = if v59.getText == nil then v59.text else v59.getText(v43),
						icon = v59.icon,
						isDisabled = v60,
						ref = if v59.id ~= "share" then nil else v33
					}

					table.insert(t3.items, t4)
				end

				table.insert(t2, t3)
			end
		end

		if v39 then
			table.insert(t2, {
				items = { v45.item }
			})
		end

		return t2
	end, {
		v41,
		v44,
		v43,
		v39,
		v45
	})
	local v47 = React.useCallback(function() -- line: 154
		-- upvalues: v41 (copy), v32 (copy), v28 (copy), t1 (copy)
		if v41 then
			return
		end

		v32(false)
		v28(function(p1) -- line: 159
			return not p1
		end)

		if t1.onActivated then
			t1.onActivated()
		end
	end, {
		v41,
		t1.onActivated
	})
	local v48 = React.useCallback(function() -- line: 167
		-- upvalues: v28 (copy), v32 (copy)
		v28(false)
		v32(false)
	end, {})
	local v49 = React.useCallback(function(p2) -- line: 173
		-- upvalues: v39 (copy), v45 (copy), v28 (copy), v43 (copy), v44 (copy), t1 (copy), releaseAnyFocus (copy), v30 (copy), FFlagBuildExperiencePrivateInvites (copy), v35 (copy), v36 (copy), v38 (copy), v32 (copy), leaveExperience (copy)
		if v39 and (v45 ~= nil and p2 == v45.item.id) then
			v45.activate()
			v28(false)

			return
		end

		if v43 == nil then
			return
		end

		for _, v64 in v44 do
			for _, v66 in v64.items do
				if p2 == v66.id then
					local v67 = if not v66.onActivated then nil else v66.onActivated(v43)

					if v67 ~= nil then
						if v67.type == "openPage" then
							if t1.onAction then
								t1.onAction(v67)
							end
						elseif v67.type == "openInvitePicker" then
							if t1.onAction then
								t1.onAction(v67)
							end
						elseif v67.type == "openVersionHistory" then
							releaseAnyFocus()
							v30(true)
						elseif v67.type == "share" then
							if FFlagBuildExperiencePrivateInvites and v35 ~= nil then
								v35()
							elseif v67.placeId ~= nil then
								v36(v67.placeId)
							end
						elseif v67.type == "confirmFriendsShare" then
							v38(v67.placeId)
						else
							if v67.type == "showPrivateShareTooltip" then
								v32(function(p3) -- line: 212
									return not p3
								end)

								return
							end

							if v67.type == "leaveExperience" then
								v28(false)
								leaveExperience()

								return
							end
						end
					end

					v28(false)

					return
				end
			end
		end
	end, {
		v44,
		v43,
		t1.onAction,
		v35,
		v36,
		v39,
		v45
	})
	local v50 = React.useCallback(function() -- line: 239
		-- upvalues: v30 (copy)
		v30(false)
	end, {})
	local v51 = React.useCallback(function() -- line: 244
		-- upvalues: v37 (copy), v38 (copy), v36 (copy)
		local v68 = v37

		v38(nil)

		if v68 ~= nil then
			v36(v68)
		end
	end, {
		v37,
		v36
	})
	local v52 = React.useCallback(function() -- line: 252
		-- upvalues: v38 (copy)
		v38(nil)
	end, {})
	local v53 = if not v29 or t1.target.placeId == nil then nil else React.createElement(VersionHistoryContainer, {
		isOpen = true,
		testId = "build-version-history",
		placeId = t1.target.placeId,
		onClose = v50
	})

	return React.createElement(React.Fragment, nil, {
		Menu = React.createElement(Menu, {
			isOpen = v27 and not v41,
			items = v46,
			side = PopoverSide.Bottom,
			align = PopoverAlign.End,
			onPressedOutside = v48,
			onActivated = v49,
			LayoutOrder = t1.layoutOrder,
			width = UDim.new(0, v26)
		}, React.createElement(IconButton, {
			isCircular = true,
			testId = "build-header-overflow-button",
			icon = t1.icon,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			isDisabled = v41,
			onActivated = v47
		})),
		ShareOverlays = if not FFlagBuildExperiencePrivateInvites or v34 == nil then nil else React.createElement(ExperienceShareOverlays, {
			activeDialog = v34.activeDialog,
			hasShareError = v34.hasShareError,
			onCancel = v34.onCancelDialog,
			onConfirmFriends = v34.onConfirmFriends,
			onConfirmPlaytesters = v34.onConfirmPlaytesters
		}),
		FriendsOnlyShareDialog = if FFlagBuildExperiencePrivateInvites or v37 == nil then nil else React.createElement(FriendsOnlyShareDialog, {
			onCancel = v52,
			onShare = v51
		}),
		PrivateShareTooltip = React.createElement(PrivateShareTooltip, {
			anchorRef = v33,
			isOpen = v27 and v31
		}),
		VersionHistory = v53
	})
end

return BuildOverflowMenuButton
