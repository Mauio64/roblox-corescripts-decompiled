local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local ArchiveGameDialog = require(script.Parent.ArchiveGameDialog)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local PrivateShareTooltip = require(BuildExperience.Components.ShareAudience.PrivateShareTooltip)
local VersionHistoryContainer = require(BuildExperience.Components.VersionHistory.VersionHistoryContainer)
local leaveExperience = require(BuildExperience.utils.leaveExperience)
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local useScaledValue = Foundation.Hooks.useScaledValue
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)

local releaseAnyFocus = require(BuildExperience.utils.releaseAnyFocus)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience).sharePublishedExperience
local useArchiveGameFlow = require(BuildExperience.utils.useArchiveGameFlow)
local v20 = game:DefineFastInt("BuildOverflowMenuWidth", 172)

local function BuildOverflowMenuButton(t1: {[any]: any}) -- line: 59
	-- upvalues: useScaledValue (copy), v20 (copy), React (copy), useArchiveGameFlow (copy), releaseAnyFocus (copy), sharePublishedExperience (copy), leaveExperience (copy), ArchiveGameDialog (copy), VersionHistoryContainer (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy), PrivateShareTooltip (copy), FriendsOnlyShareDialog (copy)
	local v23 = useScaledValue(v20)
	local v24, v25 = React.useState(false)
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState(nil)
	local v32 = React.useRef(nil)
	local v33 = useArchiveGameFlow()
	local v34 = t1.isDisabled == true or t1.target.universeId == nil
	local v35 = t1.hasPublishedTurn == true
	local v36 = React.useMemo(function() -- line: 70
		-- upvalues: t1 (copy), v35 (copy)
		if t1.target.universeId == nil then
			return nil
		end

		return {
			universeId = t1.target.universeId,
			placeId = t1.target.placeId,
			sessionId = t1.target.sessionId,
			isNewGameTarget = t1.target.isNewGameTarget,
			hasPublishedTurn = v35,
			hasPublishedVersion = t1.hasPublishedVersion == true
		}
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.sessionId,
		t1.target.isNewGameTarget,
		v35,
		t1.hasPublishedVersion
	})
	local v37 = t1.store.useItems(v36)
	local v38 = React.useMemo(function() -- line: 94
		-- upvalues: v34 (copy), v36 (copy), v37 (copy), v32 (copy)
		if v34 or v36 == nil then
			return {}
		end

		local t2 = {}

		for _, v50 in v37 do
			local t3 = {
				items = {}
			}

			for _, v53 in v50.items do
				local v54 = if v53.isDisabled == nil then nil else v53.isDisabled(v36)
				local t4 = {
					id = v53.id,
					text = if v53.getText == nil then v53.text else v53.getText(v36),
					icon = v53.icon,
					isDisabled = v54,
					ref = if v53.id ~= "share" then nil else v32
				}

				table.insert(t3.items, t4)
			end

			table.insert(t2, t3)
		end

		return t2
	end, {
		v34,
		v37,
		v36
	})
	local v39 = React.useCallback(function() -- line: 119
		-- upvalues: v34 (copy), v29 (copy), v25 (copy), t1 (copy)
		if v34 then
			return
		end

		v29(false)
		v25(function(p1) -- line: 124
			return not p1
		end)

		if t1.onActivated then
			t1.onActivated()
		end
	end, {
		v34,
		t1.onActivated
	})
	local v40 = React.useCallback(function() -- line: 132
		-- upvalues: v25 (copy), v29 (copy)
		v25(false)
		v29(false)
	end, {})
	local v41 = React.useCallback(function(p2) -- line: 138
		-- upvalues: v36 (copy), v37 (copy), v33 (copy), t1 (copy), releaseAnyFocus (copy), v27 (copy), v31 (copy), sharePublishedExperience (copy), v29 (copy), v25 (copy), leaveExperience (copy)
		if v36 == nil then
			return
		end

		for _, v58 in v37 do
			for _, v60 in v58.items do
				if p2 == v60.id then
					local v61 = if not v60.onActivated then nil else v60.onActivated(v36)

					if v61 ~= nil then
						if v61.type == "archive" then
							v33.requestArchive(v36.universeId)
						elseif v61.type == "openPage" then
							if t1.onAction then
								t1.onAction(v61)
							end
						elseif v61.type == "openVersionHistory" then
							releaseAnyFocus()
							v27(true)
						elseif v61.type == "confirmFriendsShare" then
							v31(v61.placeId)
						elseif v61.type == "share" then
							sharePublishedExperience(v61.placeId)
						else
							if v61.type == "showPrivateShareTooltip" then
								v29(function(p3) -- line: 161
									return not p3
								end)

								return
							end

							if v61.type == "leaveExperience" then
								v25(false)
								leaveExperience()

								return
							end
						end
					end

					v29(false)
					v25(false)

					return
				end
			end
		end
	end, {
		v37,
		v36,
		t1.onAction,
		v33.requestArchive
	})
	local v42 = React.useCallback(function() -- line: 186
		-- upvalues: v27 (copy)
		v27(false)
	end, {})
	local v43 = React.useCallback(function() -- line: 190
		-- upvalues: v30 (copy), v31 (copy), sharePublishedExperience (copy)
		local v62 = v30

		v31(nil)

		if v62 ~= nil then
			sharePublishedExperience(v62)
		end
	end, { v30 })
	local v44 = React.useCallback(function() -- line: 198
		-- upvalues: v31 (copy)
		v31(nil)
	end, {})
	local v45 = React.useCallback(function() -- line: 202
		-- upvalues: v33 (copy), t1 (copy)
		v33.confirm()

		if t1.onClose then
			t1.onClose()
		end
	end, {
		v33.confirm,
		t1.onClose
	})
	local v46 = if not v33.isOpen then nil else React.createElement(ArchiveGameDialog, {
		isOpen = true,
		onArchive = v45,
		onCancel = v33.cancel
	})
	local v47 = if not v26 or t1.target.placeId == nil then nil else React.createElement(VersionHistoryContainer, {
		isOpen = true,
		testId = "build-version-history",
		placeId = t1.target.placeId,
		onClose = v42
	})

	return React.createElement(React.Fragment, nil, {
		Menu = React.createElement(Menu, {
			isOpen = v24 and not v34,
			items = v38,
			side = PopoverSide.Bottom,
			align = PopoverAlign.End,
			onPressedOutside = v40,
			onActivated = v41,
			LayoutOrder = t1.layoutOrder,
			width = UDim.new(0, v23)
		}, React.createElement(IconButton, {
			isCircular = true,
			testId = "build-header-overflow-button",
			icon = t1.icon,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			isDisabled = v34,
			onActivated = v39
		})),
		ArchiveDialog = v46,
		PrivateShareTooltip = React.createElement(PrivateShareTooltip, {
			anchorRef = v32,
			isOpen = v24 and v28
		}),
		FriendsOnlyShareDialog = if v30 == nil then nil else React.createElement(FriendsOnlyShareDialog, {
			onCancel = v44,
			onShare = v43
		}),
		VersionHistory = v47
	})
end

return BuildOverflowMenuButton
