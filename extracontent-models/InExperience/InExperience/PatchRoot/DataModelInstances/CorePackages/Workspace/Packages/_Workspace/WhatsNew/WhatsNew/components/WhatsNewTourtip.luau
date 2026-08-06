local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Enums = require(WhatsNew.Enums)
local Foundation = require(WhatsNewParent.Foundation)
local Localization = require(WhatsNewParent.Localization)
local React = require(WhatsNewParent.React)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local useWhatsNewRuntimeState = require(WhatsNew.hooks.useWhatsNewRuntimeState)
local WhatsNewTelemetry = require(WhatsNew.telemetry.WhatsNewTelemetry)
local EducationalTooltip = Foundation.EducationalTooltip
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local useLocalization = Localization.Hooks.useLocalization

local function isRectReady(vector2: Vector2) -- line: 26
	return vector2.X > 0 and vector2.Y > 0
end
local function WhatsNewTourtip() -- line: 30
	-- upvalues: GetWhatsNewStore (copy), useWhatsNewRuntimeState (copy), Enums (copy), React (copy), useLocalization (copy), WhatsNewTelemetry (copy), ButtonVariant (copy), View (copy), EducationalTooltip (copy), PopoverSide (copy), PopoverAlign (copy)
	local v19 = GetWhatsNewStore()
	local v20 = useWhatsNewRuntimeState()
	local currentEntry = v20.currentEntry
	local globalStepIndex = v20.globalStepIndex
	local v23 = v20.surface == Enums.WhatsNewSurface.TourTip and (currentEntry ~= nil and globalStepIndex ~= nil)
	local v24 = React.useRef(nil)
	local v25 = React.useRef(nil)
	local v26 = useLocalization({
		back = "CommonUI.Controls.Action.Back",
		next = "CommonUI.Controls.Action.Next",
		done = "CommonUI.Controls.Action.Done"
	})
	local v27 = globalStepIndex == nil and 0 or globalStepIndex + 1
	local globalTotalSteps = v20.globalTotalSteps
	local v29 = v23 and globalStepIndex == 0
	local v30 = v23 and globalTotalSteps <= v27
	local v31 = if not v23 or currentEntry == nil then nil else v19.getAnchorRef(currentEntry.anchorId)

	v25.current = v31

	local v32 = false

	if v31 ~= nil then
		local AbsoluteSize = v31.AbsoluteSize

		v32 = AbsoluteSize.X > 0 and AbsoluteSize.Y > 0
	end

	React.useEffect(function() -- line: 60
		-- upvalues: v23 (copy), currentEntry (copy), v24 (copy), WhatsNewTelemetry (copy), v19 (copy)
		if not v23 or currentEntry == nil then
			v24.current = nil

			return
		end

		if v24.current == currentEntry.id then
			return
		end

		v24.current = currentEntry.id
		WhatsNewTelemetry.logTourtipInteraction(WhatsNewTelemetry.InteractionType.IMPRESSION, currentEntry.id, nil, v19.getRuntimeState())
	end, {
		v23,
		currentEntry,
		v19
	})

	local v34 = React.useCallback(function() -- line: 77
		-- upvalues: currentEntry (copy), v19 (copy)
		if currentEntry == nil then
			return
		end

		v19.next()
	end, {
		v19,
		currentEntry
	})
	local v35 = React.useCallback(function() -- line: 84
		-- upvalues: currentEntry (copy), v19 (copy)
		if currentEntry == nil then
			return
		end

		v19.back()
	end, {
		v19,
		currentEntry
	})
	local v36 = React.useCallback(function() -- line: 91
		-- upvalues: currentEntry (copy), v19 (copy)
		if currentEntry == nil then
			return
		end

		v19.completeTour({
			earlyDismiss = true
		})
	end, {
		v19,
		currentEntry
	})

	if not v23 or currentEntry == nil or globalStepIndex == nil then
		return nil
	end

	if v31 == nil or not v32 then
		return nil
	end

	local v37 = globalTotalSteps > 1
	local t1 = {}
	local t2 = nil

	if v37 then
		table.insert(t1, {
			isDisabled = v29,
			text = v26.back,
			variant = ButtonVariant.Standard,
			onActivated = v35
		})
		table.insert(t1, {
			text = if not v30 then v26.next else v26.done,
			variant = ButtonVariant.Emphasis,
			onActivated = v34
		})
		t2 = {
			current = v27,
			total = globalTotalSteps
		}
	end

	local v40 = `{ currentEntry.id }-{ v31:GetFullName() }`

	return React.createElement(View, {
		tag = "size-full",
		BackgroundTransparency = 1,
		Active = false
	}, {
		[v40] = React.createElement(EducationalTooltip, {
			isOpen = true,
			testId = "whats-new-tourtip",
			anchorRef = v25,
			title = currentEntry.title,
			text = currentEntry.text,
			side = currentEntry.side or PopoverSide.Bottom,
			align = currentEntry.align or PopoverAlign.Center,
			hasActions = v37,
			showSteps = v37,
			steps = t2,
			onClose = v36,
			actions = t1
		})
	})
end

return React.memo(WhatsNewTourtip)
