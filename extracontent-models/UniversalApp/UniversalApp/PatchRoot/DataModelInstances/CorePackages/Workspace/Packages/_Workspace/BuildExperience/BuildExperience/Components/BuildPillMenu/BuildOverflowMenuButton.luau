local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local ArchiveGameDialog = require(script.Parent.ArchiveGameDialog)
local VersionHistoryContainer = require(BuildExperience.Components.VersionHistory.VersionHistoryContainer)
local leaveExperience = require(BuildExperience.utils.leaveExperience)
local useSessionSummary = require(BuildExperience.Chat.useSessionSummary)
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

local function BuildOverflowMenuButton(t1: {[any]: any}) -- line: 56
	-- upvalues: useScaledValue (copy), v20 (copy), React (copy), useArchiveGameFlow (copy), CreatorAgentChat (copy), useSessionSummary (copy), releaseAnyFocus (copy), sharePublishedExperience (copy), leaveExperience (copy), ArchiveGameDialog (copy), VersionHistoryContainer (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy)
	local v23 = useScaledValue(v20)
	local v24, v25 = React.useState(false)
	local v26, v27 = React.useState(false)
	local v28 = useArchiveGameFlow()
	local v29 = React.useMemo(function() -- line: 61
		-- upvalues: CreatorAgentChat (copy), t1 (copy)
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(t1.target.universeId, t1.target.placeId, t1.target.sessionId)
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.sessionId
	})
	local hasPublishedTurn = useSessionSummary(v29).hasPublishedTurn
	local v31 = React.useMemo(function() -- line: 67
		-- upvalues: t1 (copy), hasPublishedTurn (copy)
		return {
			universeId = t1.target.universeId,
			placeId = t1.target.placeId,
			isNewGameTarget = t1.target.isNewGameTarget,
			hasPublishedTurn = hasPublishedTurn
		}
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.isNewGameTarget,
		hasPublishedTurn
	})
	local v32 = t1.store.useItems(v31)
	local t2 = {}

	for _, v35 in v32 do
		local t3 = {
			items = {}
		}

		for _, v38 in v35.items do
			local v39 = if v38.isDisabled == nil then nil else v38.isDisabled(v31)
			local t4 = {
				id = v38.id,
				text = v38.text,
				icon = v38.icon,
				isDisabled = v39
			}

			table.insert(t3.items, t4)
		end

		table.insert(t2, t3)
	end

	local v41 = React.useCallback(function() -- line: 102
		-- upvalues: v25 (copy), t1 (copy)
		v25(function(p1) -- line: 103
			return not p1
		end)

		if t1.onActivated then
			t1.onActivated()
		end
	end, { t1.onActivated })
	local v42 = React.useCallback(function() -- line: 111
		-- upvalues: v25 (copy)
		v25(false)
	end, {})
	local v43 = React.useCallback(function(p2) -- line: 115
		-- upvalues: v32 (copy), v31 (copy), v28 (copy), t1 (copy), releaseAnyFocus (copy), v27 (copy), sharePublishedExperience (copy), v25 (copy), leaveExperience (copy)
		for _, v50 in v32 do
			for _, v52 in v50.items do
				if p2 == v52.id then
					local v53 = if not v52.onActivated then nil else v52.onActivated(v31)

					if v53 ~= nil then
						if v53.type == "archive" then
							v28.requestArchive(t1.target.universeId)
						elseif v53.type == "openPage" then
							if t1.onAction then
								t1.onAction(v53)
							end
						elseif v53.type == "openVersionHistory" then
							releaseAnyFocus()
							v27(true)
						elseif v53.type == "share" then
							sharePublishedExperience(v53.placeId)
						elseif v53.type == "leaveExperience" then
							v25(false)
							leaveExperience()

							return
						end
					end

					v25(false)

					return
				end
			end
		end
	end, {
		v32,
		v31,
		t1.onAction,
		v28.requestArchive,
		t1.target.universeId
	})
	local v44 = React.useCallback(function() -- line: 145
		-- upvalues: v27 (copy)
		v27(false)
	end, {})
	local v45 = React.useCallback(function() -- line: 149
		-- upvalues: v28 (copy), t1 (copy)
		v28.confirm()

		if t1.onClose then
			t1.onClose()
		end
	end, {
		v28.confirm,
		t1.onClose
	})
	local v46 = if not v28.isOpen then nil else React.createElement(ArchiveGameDialog, {
		isOpen = true,
		onArchive = v45,
		onCancel = v28.cancel
	})
	local v47 = if not v26 or t1.target.placeId == nil then nil else React.createElement(VersionHistoryContainer, {
		isOpen = true,
		testId = "build-version-history",
		placeId = t1.target.placeId,
		onClose = v44
	})

	return React.createElement(React.Fragment, nil, {
		Menu = React.createElement(Menu, {
			isOpen = v24,
			items = t2,
			side = PopoverSide.Bottom,
			align = PopoverAlign.End,
			onPressedOutside = v42,
			onActivated = v43,
			LayoutOrder = t1.layoutOrder,
			width = UDim.new(0, v23)
		}, React.createElement(IconButton, {
			isCircular = true,
			testId = "build-header-overflow-button",
			icon = t1.icon,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			onActivated = v41
		})),
		ArchiveDialog = v46,
		VersionHistory = v47
	})
end

return BuildOverflowMenuButton
