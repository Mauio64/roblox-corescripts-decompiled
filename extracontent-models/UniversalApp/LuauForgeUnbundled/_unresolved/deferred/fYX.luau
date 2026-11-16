local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local expandableTextArea = UIBlox.App.Text.ExpandableTextArea
local getCanExpand = UIBlox.Core.Text.ExpandableText.GetCanExpand
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize

local module = require("@luauforge/deferred/fYY")

local module2 = require("@luauforge/deferred/fZb")
local contentThresholdImpressionsDetector = require("@luauforge/bundled/edd").ContentThresholdImpressionsDetector
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module4 = require("@luauforge/deferred/fZa")

local fFlagLuaAppExpandableTextImpressionsEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExpandableTextImpressionsEnabled
local defineFastFlag = game:DefineFastFlag("LuaAppFixDescriptionImpressionExpanded", false)

local Foundation = require(CorePackages.Packages.Foundation)
local useCursor = Foundation.Hooks.useCursor

local v5 = { 0.01, 0.5, 1 }

local function NOOP_NEEDED_FOR_SELECTION() end

return function(props)
	local v6 = useCursor("RoundedRect")
	local v7 = useStyle()
	local v8 = useLocalization({
		DescriptionTitle = "Feature.ExperienceDetails.Body.DescriptionTitle"
	})

	local v9 = useAppPolicy(function(p2)
		return p2.enableExperienceDetailsPanel()
	end)

	local v10 = useDesignTokens(function(p2)
		if p2 then
			return p2.LuaApps.ExperienceDetails.PanelWidthScale
		end

		return 1
	end)

	local v11 = useDesignTokens(function(p2)
		if p2 then
			return p2.LuaApps.ExperienceDetails.PanelInnerPadding
		end

		return 0
	end)

	local v12 = props.dataStatus == retrievalStatus.Done
	local v13 = props.descriptionText and #props.descriptionText > 0

	local v14 = useDesignTokens(function(p2)
		return p2.Typography.BodyLarge
	end)

	local v15 = useDesignTokens(function(p2)
		return p2.Typography.HeadingSmall
	end)

	local lineHeight = v14.LineHeight
	local v16, font

	if module4 then
		v16 = v14.FontSize
		font = v14.Font
	else
		v16 = v7.Font.BaseSize * v7.Font.Body.RelativeSize
		font = v7.Font.Body.Font
	end

	local state, setState = React.useState(0)
	local v17 = state * v10
	local useMemo = React.useMemo
	local function fn()
		if not (v13 and (fFlagLuaAppExpandableTextImpressionsEnabled or v9)) then
			return 0
		end

		local textSize = getTextSize(props.descriptionText, v16, font, Vector2.new(v17, 1e999))

		if fFlagLuaAppExpandableTextImpressionsEnabled and props.expandable then
			return textSize.Y
		end

		return textSize.Y * lineHeight
	end

	local descriptionText = props.descriptionText
	local v19 = if not fFlagLuaAppExpandableTextImpressionsEnabled then v9 else nil
	local expandable = if fFlagLuaAppExpandableTextImpressionsEnabled then props.expandable else nil
	local v21 = useMemo(fn, {
		descriptionText,
		v16,
		font,
		v17,
		v19,
		lineHeight,
		expandable,
		if fFlagLuaAppExpandableTextImpressionsEnabled then v13 else nil
	})
	local ref, v22

	if fFlagLuaAppExpandableTextImpressionsEnabled then
		ref = React.useRef(false)
		v22 = React.useCallback(function()
			ref.current = not ref.current
		end)
	else
		ref = nil
	end

	local v23

	if defineFastFlag and fFlagLuaAppExpandableTextImpressionsEnabled then
		v23 = React.useRef(nil)
	else
		v23 = nil
	end

	local v24

	if fFlagLuaAppExpandableTextImpressionsEnabled then
		local useCallback = React.useCallback
		local function fn2(items)
			local v25 = nil

			if defineFastFlag and props.expandable then
				local x = v23.current and v23.current.AbsoluteSize.X or 0

				if x > 0 then
					v25 = getCanExpand(v7.Font, x, props.descriptionText, 3)
				end
			end

			for k, item in items do
				local v27 = {
					impressionThreshold = item * 100,
					isButtonExpanded = 0,
					interactionUuid = 0,
					contentType = "description",
					pageContext = 0,
					itemId = 0,
					componentType = 0
				}
				local current

				if defineFastFlag then
					if v25 then
						current = ref.current
					end
				elseif props.expandable then
					current = ref.current
				end

				v27.isButtonExpanded = current

				v27.interactionUuid = HttpService:GenerateGUID(false)

				v27.pageContext = props.pageContext
				v27.itemId = tonumber(props.universeId)
				v27.componentType = props.componentType or "unknown"
				module2(v27)
			end
		end

		local descriptionText2 = if defineFastFlag then props.descriptionText else nil

		local expandable2 = props.expandable
		local componentType = props.componentType
		local pageContext = props.pageContext
		local universeId = props.universeId
		local v26 = if defineFastFlag then v7.Font else nil
		v24 = useCallback(fn2, {
			descriptionText2,
			ref,
			expandable2,
			componentType,
			pageContext,
			universeId,
			v26
		})
	end

	local v25

	if fFlagLuaAppExpandableTextImpressionsEnabled then
		v25 = `ExperienceDescription_{props.universeId}_{props.componentType}_{props.pageContext}`
	end

	if not defineFastFlag then
		v23 = if fFlagLuaAppExpandableTextImpressionsEnabled then React.useRef(nil) else nil
	end

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if ref2.current then
			setState(ref2.current.AbsoluteSize.X)
		end
	end)

	if not (v12 and v13) then
		return nil
	end

	local v26

	if props.expandable then
		local createElement = React.createElement
		local v28 = {
			Text = props.descriptionText,
			compactNumberOfLines = 3,
			padding = Vector2.new(0, 0),
			gradientColor = v7.Theme.BackgroundContrast.Color,
			onClick = 0
		}

		if not fFlagLuaAppExpandableTextImpressionsEnabled then
			v22 = nil
		end

		v28.onClick = v22
		v26 = createElement(expandableTextArea, v28)
	else
		local createElement = React.createElement
		local v28 = {
			text = props.descriptionText,
			size = UDim2.new(v10, 0, 0, v21),
			textYAlignment = Enum.TextYAlignment.Top,
			fontStyle = 0,
			colorStyle = 0,
			automaticSize = 0,
			lineHeight = 0,
			richText = false,
			fluidSizing = false
		}

		if not module4 then
			v14 = v7.Font.Body
		end

		v28.fontStyle = v14
		v28.colorStyle = v7.Theme.TextDefault
		local v29 = if not v9 then Enum.AutomaticSize.Y else nil
		v28.automaticSize = v29
		v28.lineHeight = lineHeight
		v26 = createElement(styledTextLabel, v28)
	end

	local createElement = React.createElement
	local v28 = {
		ref = ref2,
		[React.Change.AbsoluteSize] = function(p2)
			setState(p2.AbsoluteSize.X)
		end,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Selectable = true,
		[React.Event.SelectionGained] = NOOP_NEEDED_FOR_SELECTION,
		SelectionImageObject = v6
	}

	local v30 = if v9 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v11),
		PaddingTop = UDim.new(0, v11),
		PaddingRight = UDim.new(0, v11),
		PaddingBottom = UDim.new(0, v11)
	}) else nil
	local v29 = {
		Padding = v30,
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, props.listPadding or 24)
		}),
		Title = 0,
		Description = 0,
		ContentThresholdImpressionsDetector = 0
	}
	local v31

	if not v9 then
		local createElement2 = React.createElement
		local v33 = {
			text = props.headerText or v8.DescriptionTitle,
			size = UDim2.fromScale(1, 0),
			fontStyle = 0,
			colorStyle = 0,
			automaticSize = 0,
			richText = false,
			fluidSizing = false
		}

		if not module4 then
			v15 = v7.Font.Header1
		end

		v33.fontStyle = v15
		v33.colorStyle = v7.Theme.TextEmphasis
		v33.automaticSize = Enum.AutomaticSize.Y
		v31 = createElement2(styledTextLabel, v33)
	end

	v29.Title = v31

	if fFlagLuaAppExpandableTextImpressionsEnabled then
		v26 = React.createElement("Frame", {
			ref = v23,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}, { Body = v26 })
	end

	v29.Description = v26

	local v32 = if fFlagLuaAppExpandableTextImpressionsEnabled then React.createElement(contentThresholdImpressionsDetector, {
		containerRef = v23,
		fullContentHeight = v21,
		thresholds = v5,
		impressionsTag = v25,
		sendImpressions = v24,
		viewportBoundsOffset = props.viewportBoundsOffset
	}) else nil
	v29.ContentThresholdImpressionsDetector = v32
	local element = createElement("Frame", v28, v29)

	if v9 then
		return React.createElement(module, {
			title = props.headerText or v8.DescriptionTitle,
			onFocusChanged = props.onFocusChanged
		}, element)
	end

	return element
end
