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
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local useScaledValue = Foundation.Hooks.useScaledValue
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local releaseAnyFocus = require(BuildExperience.utils.releaseAnyFocus)
local v22 = game:DefineFastInt("BuildOverflowMenuWidth", 172)

local function BuildOverflowMenuButton(t1: {[any]: any}) -- line: 65
	-- upvalues: useScaledValue (copy), v22 (copy), React (copy), FFlagBuildExperiencePrivateInvites (copy), useExperienceShareFlow (copy), useSharePublishedExperience (copy), useCreatorCreditMenuItem (copy), releaseAnyFocus (copy), leaveExperience (copy), VersionHistoryContainer (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy), ExperienceShareOverlays (copy), FriendsOnlyShareDialog (copy), PrivateShareTooltip (copy)
	local v25 = useScaledValue(v22)
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState(false)
	local v32 = React.useRef(nil)
	local v33 = if not FFlagBuildExperiencePrivateInvites then nil else useExperienceShareFlow(t1.target.universeId, t1.target.placeId)
	local v34 = if v33 == nil then nil else v33.onShare
	local v35 = useSharePublishedExperience(t1.target.universeId)
	local v36, v37 = React.useState(nil)
	local v38 = t1.isDisabled == true or t1.target.universeId == nil
	local v39 = t1.hasPublishedTurn == true
	local v40 = t1.onOpenCreatorCreditPage ~= nil
	local v41 = React.useMemo(function() -- line: 90
		-- upvalues: t1 (copy), v39 (copy)
		if t1.target.universeId == nil then
			return nil
		end

		return {
			universeId = t1.target.universeId,
			placeId = t1.target.placeId,
			sessionId = t1.target.sessionId,
			isNewGameTarget = t1.target.isNewGameTarget,
			hasPublishedTurn = v39,
			hasPublishedVersion = t1.hasPublishedVersion == true
		}
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.sessionId,
		t1.target.isNewGameTarget,
		v39,
		t1.hasPublishedVersion
	})
	local v42 = t1.store.useItems(v41)
	local v43 = useCreatorCreditMenuItem({
		onOpenCreatorCreditPage = t1.onOpenCreatorCreditPage
	})
	local v44 = React.useMemo(function() -- line: 118
		-- upvalues: v38 (copy), v41 (copy), v42 (copy), v32 (copy), v40 (copy), v43 (copy)
		if v38 or v41 == nil then
			return {}
		end

		local t2 = {}

		for _, v54 in v42 do
			local t3 = {
				items = {}
			}

			for _, v57 in v54.items do
				local v58 = if v57.isDisabled == nil then nil else v57.isDisabled(v41)
				local t4 = {
					id = v57.id,
					text = if v57.getText == nil then v57.text else v57.getText(v41),
					icon = v57.icon,
					isDisabled = v58,
					ref = if v57.id ~= "share" then nil else v32
				}

				table.insert(t3.items, t4)
			end

			table.insert(t2, t3)
		end

		if v40 then
			table.insert(t2, {
				items = { v43.item }
			})
		end

		return t2
	end, {
		v38,
		v42,
		v41,
		v40,
		v43
	})
	local v45 = React.useCallback(function() -- line: 148
		-- upvalues: v38 (copy), v31 (copy), v27 (copy), t1 (copy)
		if v38 then
			return
		end

		v31(false)
		v27(function(p1) -- line: 153
			return not p1
		end)

		if t1.onActivated then
			t1.onActivated()
		end
	end, {
		v38,
		t1.onActivated
	})
	local v46 = React.useCallback(function() -- line: 161
		-- upvalues: v27 (copy), v31 (copy)
		v27(false)
		v31(false)
	end, {})
	local v47 = React.useCallback(function(p2) -- line: 167
		-- upvalues: v40 (copy), v43 (copy), v27 (copy), v41 (copy), v42 (copy), t1 (copy), releaseAnyFocus (copy), v29 (copy), FFlagBuildExperiencePrivateInvites (copy), v34 (copy), v35 (copy), v37 (copy), v31 (copy), leaveExperience (copy)
		if v40 and (v43 ~= nil and p2 == v43.item.id) then
			v43.activate()
			v27(false)

			return
		end

		if v41 == nil then
			return
		end

		for _, v62 in v42 do
			for _, v64 in v62.items do
				if p2 == v64.id then
					local v65 = if not v64.onActivated then nil else v64.onActivated(v41)

					if v65 ~= nil then
						if v65.type == "openPage" then
							if t1.onAction then
								t1.onAction(v65)
							end
						elseif v65.type == "openInvitePicker" then
							if t1.onAction then
								t1.onAction(v65)
							end
						elseif v65.type == "openVersionHistory" then
							releaseAnyFocus()
							v29(true)
						elseif v65.type == "share" then
							if FFlagBuildExperiencePrivateInvites and v34 ~= nil then
								v34()
							elseif v65.placeId ~= nil then
								v35(v65.placeId)
							end
						elseif v65.type == "confirmFriendsShare" then
							v37(v65.placeId)
						else
							if v65.type == "showPrivateShareTooltip" then
								v31(function(p3) -- line: 206
									return not p3
								end)

								return
							end

							if v65.type == "leaveExperience" then
								v27(false)
								leaveExperience()

								return
							end
						end
					end

					v27(false)

					return
				end
			end
		end
	end, {
		v42,
		v41,
		t1.onAction,
		v34,
		v35,
		v40,
		v43
	})
	local v48 = React.useCallback(function() -- line: 233
		-- upvalues: v29 (copy)
		v29(false)
	end, {})
	local v49 = React.useCallback(function() -- line: 238
		-- upvalues: v36 (copy), v37 (copy), v35 (copy)
		local v66 = v36

		v37(nil)

		if v66 ~= nil then
			v35(v66)
		end
	end, {
		v36,
		v35
	})
	local v50 = React.useCallback(function() -- line: 246
		-- upvalues: v37 (copy)
		v37(nil)
	end, {})
	local v51 = if not v28 or t1.target.placeId == nil then nil else React.createElement(VersionHistoryContainer, {
		isOpen = true,
		testId = "build-version-history",
		placeId = t1.target.placeId,
		onClose = v48
	})

	return React.createElement(React.Fragment, nil, {
		Menu = React.createElement(Menu, {
			isOpen = v26 and not v38,
			items = v44,
			side = PopoverSide.Bottom,
			align = PopoverAlign.End,
			onPressedOutside = v46,
			onActivated = v47,
			LayoutOrder = t1.layoutOrder,
			width = UDim.new(0, v25)
		}, React.createElement(IconButton, {
			isCircular = true,
			testId = "build-header-overflow-button",
			icon = t1.icon,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			isDisabled = v38,
			onActivated = v45
		})),
		ShareOverlays = if not FFlagBuildExperiencePrivateInvites or v33 == nil then nil else React.createElement(ExperienceShareOverlays, {
			activeDialog = v33.activeDialog,
			hasShareError = v33.hasShareError,
			onCancel = v33.onCancelDialog,
			onConfirmFriends = v33.onConfirmFriends,
			onConfirmPlaytesters = v33.onConfirmPlaytesters
		}),
		FriendsOnlyShareDialog = if FFlagBuildExperiencePrivateInvites or v36 == nil then nil else React.createElement(FriendsOnlyShareDialog, {
			onCancel = v50,
			onShare = v49
		}),
		PrivateShareTooltip = React.createElement(PrivateShareTooltip, {
			anchorRef = v32,
			isOpen = v26 and v30
		}),
		VersionHistory = v51
	})
end

return BuildOverflowMenuButton
