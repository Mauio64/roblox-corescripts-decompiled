local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local useSelector = require(ExpChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local Foundation = require(ExpChatParent.Foundation)
local Coachmark = Foundation.Coachmark
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local FFlagExpChatUseUnifiedTooltipStore = require(ExpChatParent.ExpChatShared).Flags.FFlagExpChatUseUnifiedTooltipStore
local Localization = require(ExpChat.Localization)
local Config = require(ExpChat.Config)
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetGlobalChatTooltipStore = require(ExpChat.Stores.GetGlobalChatTooltipStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local useChatTooltipLifecycle = require(script.Parent.Parent.useChatTooltipLifecycle)
local MinTabWidth = Config.ChannelTabsSettings.MinTabWidth
local DropdownIconContainerWidth = Config.ChannelTabsSettings.DropdownIconContainerWidth

local function GlobalChatTooltipNew(t1: {[any]: any}) -- line: 41
	-- upvalues: GetChatTooltipStore (copy), SignalsReact (copy), useSelector (copy), React (copy), MinTabWidth (copy), DropdownIconContainerWidth (copy), useChatTooltipLifecycle (copy), Localization (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy), Config (copy)
	local v24 = GetChatTooltipStore(false)
	local v25 = SignalsReact.useSignalState(v24.getShouldShow("GlobalChatTooltip"))
	local v26 = useSelector(function(p1) -- line: 45
		local v67 = p1.ChannelTabs and p1.ChannelTabs.allChannelTabs

		if v67 == nil then
			return 0
		end

		local n1 = 0

		for _ in v67 do
			n1 += 1
		end

		return n1
	end)
	local v27, v28 = React.useState(0)
	local v29 = v27 > 0 and v27 < v26 * MinTabWidth
	local n2

	if v26 < 2 then
		n2 = 1
	elseif not v29 then
		n2 = 2 / v26
	else
		local v31 = v27 - DropdownIconContainerWidth
		local v32 = math.floor(v31 / MinTabWidth)

		n2 = not (v32 >= 2) and 1 or 2 * v31 / (v32 * v27)
	end

	local v33 = useSelector(function(p2) -- line: 93
		local v71 = p2.ChatLayout and p2.ChatLayout.Alignment

		return v71 ~= nil and (v71.AnchorPoint.X == 0 and v71.AnchorPoint.Y == 0)
	end)
	local v34 = useChatTooltipLifecycle({
		tooltipKey = "GlobalChatTooltip",
		targetTextChannel = t1.targetTextChannel
	})
	local v35 = Localization.useLocalization({
		headerText = "CoreScripts.TextChat.Tooltip.Global.Header",
		bodyText = "CoreScripts.TextChat.Tooltip.Global.Body"
	})

	if not t1.visible or not v25 or not v33 then
		return nil
	end

	local function onAnchorChanged(p3) -- line: 112
		-- upvalues: v28 (copy)
		local p3Parent = p3.Parent

		if p3Parent and p3Parent:IsA("GuiObject") then
			v28(p3Parent.AbsoluteSize.X)
		end
	end

	return React.createElement(Coachmark, {
		title = v35.headerText,
		text = v35.bodyText,
		isOpen = v34.isActive,
		onClose = v34.onDismiss,
		side = PopoverSide.Right,
		align = PopoverAlign.Start,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(n2, -13, 0, -48),
		onAbsoluteSizeChanged = onAnchorChanged,
		onAbsolutePositionChanged = onAnchorChanged
	}, {
		AnchorSizer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 1, 0, Config.ChannelTabsSettings.HorizontalBarHeight)
		})
	})
end
local function GlobalChatTooltipLegacy(t2: {[any]: any}) -- line: 150
	-- upvalues: GetGlobalChatTooltipStore (copy), GetTransparencyStore (copy), SignalsReact (copy), useSelector (copy), React (copy), MinTabWidth (copy), DropdownIconContainerWidth (copy), isUserChatEnabled (copy), Config (copy), Localization (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy)
	local v38 = GetGlobalChatTooltipStore(false)
	local v39 = GetTransparencyStore(false)
	local v40 = SignalsReact.useSignalState(v38.getShouldShowGlobalChatTooltip)
	local v41 = SignalsReact.useSignalState(v38.getIsScreenWideEnough)
	local v42 = v39.getIsFocused or v39.getIsTextBoxFocused
	local v43 = SignalsReact.useSignalState(v39.getLastActivity)
	local v44 = SignalsReact.useSignalState(v42)
	local v45 = useSelector(function(p4) -- line: 160
		local v75 = p4.ChannelTabs and p4.ChannelTabs.allChannelTabs

		if v75 == nil then
			return 0
		end

		local n3 = 0

		for _ in v75 do
			n3 += 1
		end

		return n3
	end)
	local v46, v47 = React.useState(0)
	local v48 = v46 > 0 and v46 < v45 * MinTabWidth
	local n4

	if v45 < 2 then
		n4 = 1
	elseif not v48 then
		n4 = 2 / v45
	else
		local v50 = v46 - DropdownIconContainerWidth
		local v51 = math.floor(v50 / MinTabWidth)

		n4 = not (v51 >= 2) and 1 or 2 * v50 / (v51 * v46)
	end

	local v52 = useSelector(function(p5) -- line: 208
		local v79 = p5.ChatLayout and p5.ChatLayout.Alignment

		return v79 ~= nil and (v79.AnchorPoint.X == 0 and v79.AnchorPoint.Y == 0)
	end)
	local v53 = t2.chatStatus == nil or isUserChatEnabled(t2.chatStatus)
	local v54, v55 = React.useState(true)
	local v56, v57 = React.useState(false)
	local v58 = React.useRef(false)
	local v59 = React.useRef(0)
	local v60 = React.useRef(t2.targetTextChannel)
	local v61 = React.useCallback(function() -- line: 222
		-- upvalues: v58 (copy), v38 (copy)
		if not v58.current then
			v58.current = true
			v38.reportImpression()
		end

		v38.setIsGlobalChatTooltipDismissed(true)
	end, {
		v38.setIsGlobalChatTooltipDismissed,
		v38.reportImpression
	})

	React.useEffect(function() -- line: 230
		-- upvalues: v38 (copy), t2 (copy)
		v38.setIsChatWindowOpen(t2.visible)

		return function() -- line: 232
			-- upvalues: v38 (copy)
			v38.setIsChatWindowOpen(false)
		end
	end, { t2.visible })
	React.useEffect(function() -- line: 237
		-- upvalues: v44 (copy), v55 (copy), Config (copy), v43 (copy)
		if v44 then
			v55(true)

			return nil
		end

		local v80 = Config.ChatWindowBackgroundFadeOutTime - (os.clock() - v43)

		if v80 <= 0 then
			v55(false)

			return nil
		end

		v55(true)

		local thread = task.delay(v80, function() -- line: 251
			-- upvalues: v55 (copy)
			v55(false)
		end)

		return function() -- line: 254
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v43,
		v44
	})
	React.useEffect(function() -- line: 260
		-- upvalues: v54 (copy), v41 (copy), v56 (copy), v40 (copy), v53 (copy), v59 (copy), v57 (copy)
		if not v54 or not v41 or (v56 or not v40 or not v53) then
			return nil
		end

		local elapsed = os.clock()
		local v83 = math.max(0, 10 - v59.current)
		local thread = task.delay(v83, function() -- line: 267
			-- upvalues: v57 (copy)
			v57(true)
		end)

		return function() -- line: 270
			-- upvalues: v59 (copy), elapsed (copy), thread (copy)
			local v89 = v59

			v89.current = v89.current + (os.clock() - elapsed)
			task.cancel(thread)
		end
	end, {
		v54,
		v41,
		v56,
		v40,
		v53
	})
	React.useEffect(function() -- line: 277
		-- upvalues: v56 (copy), v61 (copy)
		if not v56 then
			return nil
		end

		local thread = task.delay(1, function() -- line: 281
			-- upvalues: v61 (copy)
			v61()
		end)

		return function() -- line: 284
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v56,
		v61
	})
	React.useEffect(function() -- line: 290
		-- upvalues: v60 (copy), t2 (copy), v40 (copy), v53 (copy), v56 (copy), v57 (copy)
		local current = v60.current

		v60.current = t2.targetTextChannel

		if current and (current ~= t2.targetTextChannel and v40 and v53 and not v56) then
			v57(true)
		end
	end, {
		t2.targetTextChannel,
		v40,
		v53,
		v56
	})

	local v62 = Localization.useLocalization({
		headerText = "CoreScripts.TextChat.Tooltip.Global.Header",
		bodyText = "CoreScripts.TextChat.Tooltip.Global.Body"
	})

	if not t2.visible or not v40 or not v52 then
		return nil
	end

	local v63 = v54 and (v41 and not v56)

	local function onAnchorChanged(p6) -- line: 311
		-- upvalues: v47 (copy)
		local p6Parent = p6.Parent

		if p6Parent and p6Parent:IsA("GuiObject") then
			v47(p6Parent.AbsoluteSize.X)
		end
	end

	return React.createElement(Coachmark, {
		title = v62.headerText,
		text = v62.bodyText,
		isOpen = v63,
		onClose = v61,
		side = PopoverSide.Right,
		align = PopoverAlign.Start,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(n4, -13, 0, -48),
		onAbsoluteSizeChanged = onAnchorChanged,
		onAbsolutePositionChanged = onAnchorChanged
	}, {
		AnchorSizer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 1, 0, Config.ChannelTabsSettings.HorizontalBarHeight)
		})
	})
end
local function GlobalChatTooltip(t3: {[any]: any}) -- line: 347
	-- upvalues: FFlagExpChatUseUnifiedTooltipStore (copy), GlobalChatTooltipNew (copy), GlobalChatTooltipLegacy (copy)
	if FFlagExpChatUseUnifiedTooltipStore then
		return GlobalChatTooltipNew(t3)
	end

	return GlobalChatTooltipLegacy(t3)
end

return GlobalChatTooltip
