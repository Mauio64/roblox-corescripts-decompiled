local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local ArchiveGameDialog = require(script.Parent.ArchiveGameDialog)
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
local v18 = game:DefineFastInt("BuildOverflowMenuWidth", 172)

local function BuildOverflowMenuButton(t1: {[any]: any}) -- line: 56
	-- upvalues: useScaledValue (copy), v18 (copy), React (copy), useArchiveGameFlow (copy), releaseAnyFocus (copy), sharePublishedExperience (copy), leaveExperience (copy), ArchiveGameDialog (copy), VersionHistoryContainer (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy), IconButton (copy), ButtonVariant (copy), InputSize (copy)
	local v21 = useScaledValue(v18)
	local v22, v23 = React.useState(false)
	local v24, v25 = React.useState(false)
	local v26 = useArchiveGameFlow()
	local v27 = t1.isDisabled == true or t1.target.universeId == nil
	local v28 = t1.hasPublishedTurn == true
	local v29 = React.useMemo(function() -- line: 64
		-- upvalues: t1 (copy), v28 (copy)
		if t1.target.universeId == nil then
			return nil
		end

		return {
			universeId = t1.target.universeId,
			placeId = t1.target.placeId,
			isNewGameTarget = t1.target.isNewGameTarget,
			hasPublishedTurn = v28
		}
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.isNewGameTarget,
		v28
	})
	local v30 = t1.store.useItems(v29)
	local v31 = React.useMemo(function() -- line: 84
		-- upvalues: v27 (copy), v29 (copy), v30 (copy)
		if v27 or v29 == nil then
			return {}
		end

		local t2 = {}

		for _, v41 in v30 do
			local t3 = {
				items = {}
			}

			for _, v44 in v41.items do
				local v45 = if v44.isDisabled == nil then nil else v44.isDisabled(v29)
				local t4 = {
					id = v44.id,
					text = v44.text,
					icon = v44.icon,
					isDisabled = v45
				}

				table.insert(t3.items, t4)
			end

			table.insert(t2, t3)
		end

		return t2
	end, {
		v27,
		v30,
		v29
	})
	local v32 = React.useCallback(function() -- line: 108
		-- upvalues: v27 (copy), v23 (copy), t1 (copy)
		if v27 then
			return
		end

		v23(function(p1) -- line: 112
			return not p1
		end)

		if t1.onActivated then
			t1.onActivated()
		end
	end, {
		v27,
		t1.onActivated
	})
	local v33 = React.useCallback(function() -- line: 120
		-- upvalues: v23 (copy)
		v23(false)
	end, {})
	local v34 = React.useCallback(function(p2) -- line: 124
		-- upvalues: v29 (copy), v30 (copy), v26 (copy), t1 (copy), releaseAnyFocus (copy), v25 (copy), sharePublishedExperience (copy), v23 (copy), leaveExperience (copy)
		if v29 == nil then
			return
		end

		for _, v49 in v30 do
			for _, v51 in v49.items do
				if p2 == v51.id then
					local v52 = if not v51.onActivated then nil else v51.onActivated(v29)

					if v52 ~= nil then
						if v52.type == "archive" then
							v26.requestArchive(v29.universeId)
						elseif v52.type == "openPage" then
							if t1.onAction then
								t1.onAction(v52)
							end
						elseif v52.type == "openVersionHistory" then
							releaseAnyFocus()
							v25(true)
						elseif v52.type == "share" then
							sharePublishedExperience(v52.placeId)
						elseif v52.type == "leaveExperience" then
							v23(false)
							leaveExperience()

							return
						end
					end

					v23(false)

					return
				end
			end
		end
	end, {
		v30,
		v29,
		t1.onAction,
		v26.requestArchive,
		t1.target.universeId
	})
	local v35 = React.useCallback(function() -- line: 157
		-- upvalues: v25 (copy)
		v25(false)
	end, {})
	local v36 = React.useCallback(function() -- line: 161
		-- upvalues: v26 (copy), t1 (copy)
		v26.confirm()

		if t1.onClose then
			t1.onClose()
		end
	end, {
		v26.confirm,
		t1.onClose
	})
	local v37 = if not v26.isOpen then nil else React.createElement(ArchiveGameDialog, {
		isOpen = true,
		onArchive = v36,
		onCancel = v26.cancel
	})
	local v38 = if not v24 or t1.target.placeId == nil then nil else React.createElement(VersionHistoryContainer, {
		isOpen = true,
		testId = "build-version-history",
		placeId = t1.target.placeId,
		onClose = v35
	})

	return React.createElement(React.Fragment, nil, {
		Menu = React.createElement(Menu, {
			isOpen = v22 and not v27,
			items = v31,
			side = PopoverSide.Bottom,
			align = PopoverAlign.End,
			onPressedOutside = v33,
			onActivated = v34,
			LayoutOrder = t1.layoutOrder,
			width = UDim.new(0, v21)
		}, React.createElement(IconButton, {
			isCircular = true,
			testId = "build-header-overflow-button",
			icon = t1.icon,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			isDisabled = v27,
			onActivated = v32
		})),
		ArchiveDialog = v37,
		VersionHistory = v38
	})
end

return BuildOverflowMenuButton
