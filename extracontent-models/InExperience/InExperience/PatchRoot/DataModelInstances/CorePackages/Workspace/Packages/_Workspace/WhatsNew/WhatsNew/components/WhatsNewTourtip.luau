local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local Enums = require(WhatsNew.Enums)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local useWhatsNewRuntimeState = require(WhatsNew.hooks.useWhatsNewRuntimeState)
local WhatsNewTelemetry = require(WhatsNew.telemetry.WhatsNewTelemetry)

local EducationalTooltip = Foundation.EducationalTooltip
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local useLocalization = Localization.Hooks.useLocalization

local function isRectReady(absoluteSize: Vector2): boolean -- 1 equivalent call inferred from this helper
	return absoluteSize.X > 0 and absoluteSize.Y > 0
end

local function WhatsNewTourtip()
	local whatsNewStore = GetWhatsNewStore()
	local v = useWhatsNewRuntimeState()
	local currentEntry = v.currentEntry
	local globalStepIndex = v.globalStepIndex
	local v2

	if v.surface == Enums.WhatsNewSurface.TourTip and currentEntry ~= nil then
		v2 = globalStepIndex ~= nil
	else
		v2 = false
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v3 = useLocalization({
		back = "CommonUI.Controls.Action.Back",
		next = "CommonUI.Controls.Action.Next",
		done = "CommonUI.Controls.Action.Done"
	})

	local current = globalStepIndex == nil and 0 or globalStepIndex + 1
	local globalTotalSteps = v.globalTotalSteps
	local isDisabled = v2 and globalStepIndex == 0
	local v4 = v2 and globalTotalSteps <= current
	local current2

	if v2 and currentEntry ~= nil then
		current2 = whatsNewStore.getAnchorRef(currentEntry.anchorId)
	end

	ref2.current = current2
	local v5

	if current2 == nil then
		v5 = false
	else
		v5 = isRectReady(current2.AbsoluteSize) -- inferred equivalent call
	end

	React.useEffect(function()
		if not v2 or currentEntry == nil then
			ref.current = nil
			return
		end

		if ref.current == currentEntry.id then
			return
		end

		ref.current = currentEntry.id
		WhatsNewTelemetry.logTourtipInteraction(
			WhatsNewTelemetry.InteractionType.IMPRESSION,
			currentEntry.id,
			nil,
			whatsNewStore.getRuntimeState()
		)
	end, { v2, currentEntry, whatsNewStore })

	local onActivated = React.useCallback(function()
		if currentEntry == nil then
			return
		end

		whatsNewStore.next()
	end, { whatsNewStore, currentEntry })

	local onActivated2 = React.useCallback(function()
		if currentEntry == nil then
			return
		end

		whatsNewStore.back()
	end, { whatsNewStore, currentEntry })

	local onClose = React.useCallback(function()
		if currentEntry == nil then
			return
		end

		whatsNewStore.completeTour({ earlyDismiss = true })
	end, { whatsNewStore, currentEntry })

	if not v2 or currentEntry == nil or globalStepIndex == nil then
		return nil
	end

	if current2 == nil or not v5 then
		return nil
	end

	local v6 = globalTotalSteps > 1
	local actions = {}
	local steps

	if v6 then
		table.insert(actions, {
			isDisabled = isDisabled,
			text = v3.back,
			variant = ButtonVariant.Standard,
			onActivated = onActivated2,
			testId = "whats-new-tourtip--action-1"
		})

		local text = if v4 then v3.done else v3.next
		local v7 = {
			text = text,
			variant = ButtonVariant.Emphasis,
			onActivated = onActivated,
			testId = "whats-new-tourtip--action-2"
		}
		table.insert(actions, v7)

		steps = { current = current, total = globalTotalSteps }
	end

	local formatted = `{currentEntry.id}-{current2:GetFullName()}`

	return React.createElement(View, {
		tag = "size-full",
		BackgroundTransparency = 1,
		Active = false
	}, {
		[formatted] = React.createElement(EducationalTooltip, {
			anchorRef = ref2,
			title = currentEntry.title,
			text = currentEntry.text,
			side = currentEntry.side or PopoverSide.Bottom,
			align = currentEntry.align or PopoverAlign.Center,
			isOpen = true,
			hasActions = v6,
			showSteps = v6,
			steps = steps,
			onClose = onClose,
			actions = actions,
			testId = "whats-new-tourtip"
		})
	})
end

return React.memo(WhatsNewTourtip)
