local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Enums = require(WhatsNew.Enums)
local Foundation = require(WhatsNewParent.Foundation)
local React = require(WhatsNewParent.React)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local useWhatsNewRuntimeState = require(WhatsNew.hooks.useWhatsNewRuntimeState)
local WhatsNewTelemetry = require(WhatsNew.telemetry.WhatsNewTelemetry)
local EducationalTooltip = Foundation.EducationalTooltip
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function isRectReady(vector2: Vector2) -- line: 21
	return vector2.X > 0 and vector2.Y > 0
end
local function WhatsNewTourtip() -- line: 25
	-- upvalues: GetWhatsNewStore (copy), useWhatsNewRuntimeState (copy), Enums (copy), React (copy), WhatsNewTelemetry (copy), ButtonVariant (copy), View (copy), EducationalTooltip (copy), PopoverSide (copy), PopoverAlign (copy)
	local v17 = GetWhatsNewStore()
	local v18 = useWhatsNewRuntimeState()
	local currentEntry = v18.currentEntry
	local globalStepIndex = v18.globalStepIndex
	local v21 = v18.surface == Enums.WhatsNewSurface.TourTip and (currentEntry ~= nil and globalStepIndex ~= nil)
	local v22 = React.useRef(nil)
	local v23 = React.useRef(nil)
	local v24 = globalStepIndex == nil and 0 or globalStepIndex + 1
	local globalTotalSteps = v18.globalTotalSteps
	local v26 = v21 and globalStepIndex == 0
	local v27 = v21 and globalTotalSteps <= v24
	local v28 = if not v21 or currentEntry == nil then nil else v17.getAnchorRef(currentEntry.anchorId)

	v23.current = v28

	local v29 = false

	if v28 ~= nil then
		local AbsoluteSize = v28.AbsoluteSize

		v29 = AbsoluteSize.X > 0 and AbsoluteSize.Y > 0
	end

	React.useEffect(function() -- line: 49
		-- upvalues: v21 (copy), currentEntry (copy), v22 (copy), WhatsNewTelemetry (copy), v17 (copy)
		if not v21 or currentEntry == nil then
			v22.current = nil

			return
		end

		if v22.current == currentEntry.id then
			return
		end

		v22.current = currentEntry.id
		WhatsNewTelemetry.logTourtipInteraction("impression", currentEntry.id, nil, v17.getRuntimeState())
	end, {
		v21,
		currentEntry,
		v17
	})

	local v31 = React.useCallback(function() -- line: 61
		-- upvalues: currentEntry (copy), v17 (copy)
		if currentEntry == nil then
			return
		end

		v17.next()
	end, {
		v17,
		currentEntry
	})
	local v32 = React.useCallback(function() -- line: 68
		-- upvalues: currentEntry (copy), v17 (copy)
		if currentEntry == nil then
			return
		end

		v17.back()
	end, {
		v17,
		currentEntry
	})
	local v33 = React.useCallback(function() -- line: 75
		-- upvalues: currentEntry (copy), v17 (copy)
		if currentEntry == nil then
			return
		end

		v17.completeTour({
			earlyDismiss = true
		})
	end, {
		v17,
		currentEntry
	})

	if not v21 or currentEntry == nil or globalStepIndex == nil then
		return nil
	end

	if v28 == nil or not v29 then
		return nil
	end

	local t1 = {}

	table.insert(t1, {
		text = "Back",
		isDisabled = v26,
		variant = ButtonVariant.Standard,
		onActivated = v32
	})
	table.insert(t1, {
		text = not v27 and "Next" or "Done",
		variant = ButtonVariant.Emphasis,
		onActivated = v31
	})

	local v35 = `{ currentEntry.id }-{ v28:GetFullName() }`

	return React.createElement(View, {
		tag = "size-full",
		BackgroundTransparency = 1,
		Active = false
	}, {
		[v35] = React.createElement(EducationalTooltip, {
			isOpen = true,
			testId = "whats-new-tourtip",
			anchorRef = v23,
			title = currentEntry.title,
			text = currentEntry.text,
			side = currentEntry.side or PopoverSide.Bottom,
			align = currentEntry.align or PopoverAlign.Center,
			steps = {
				current = v24,
				total = globalTotalSteps
			},
			onClose = v33,
			actions = t1
		})
	})
end

return React.memo(WhatsNewTourtip)
