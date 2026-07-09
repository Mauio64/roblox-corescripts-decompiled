local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ExpandableTextArea = UIBlox.App.Text.ExpandableTextArea
local GetCanExpand = UIBlox.Core.Text.ExpandableText.GetCanExpand
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local GetTextSize = require(CorePackages.Workspace.Packages.Style).GetTextSize
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ExperienceDetailsPanel = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceDetailsPanel)
local sendExpandableTextImpressionEvent = require(Modules.LuaApp.Components.ExperienceDetails.sendExpandableTextImpressionEvent)
local ContentThresholdImpressionsDetector = require(CorePackages.Workspace.Packages.Impressions).ContentThresholdImpressionsDetector
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local FFlagExperienceDetailsTextUseTokens = require(script.Parent.Flags.FFlagExperienceDetailsTextUseTokens)
local FFlagLuaAppExpandableTextImpressionsEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExpandableTextImpressionsEnabled
local v21 = game:DefineFastFlag("LuaAppFixDescriptionImpressionExpanded", false)
local useCursor = require(CorePackages.Packages.Foundation).Hooks.useCursor
local t1 = {
	0.01,
	0.5,
	1
}

local function NOOP_NEEDED_FOR_SELECTION() -- line: 57
end

return function(t2: {[any]: any}) -- line: 61
	-- upvalues: useCursor (copy), useStyle (copy), useLocalization (copy), useAppPolicy (copy), useDesignTokens (copy), RetrievalStatus (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagExperienceDetailsTextUseTokens (copy), React (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), GetTextSize (copy), v21 (copy), GetCanExpand (copy), sendExpandableTextImpressionEvent (copy), HttpService (copy), ExpandableTextArea (copy), StyledTextLabel (copy), NOOP_NEEDED_FOR_SELECTION (copy), ContentThresholdImpressionsDetector (copy), t1 (copy), ExperienceDetailsPanel (copy)
	local v26 = useCursor("RoundedRect")
	local v27 = useStyle()
	local v28 = useLocalization({
		DescriptionTitle = "Feature.ExperienceDetails.Body.DescriptionTitle"
	})
	local v29 = useAppPolicy(function(p1) -- line: 67
		return p1.enableExperienceDetailsPanel()
	end)
	local v30 = useDesignTokens(function(p2) -- line: 70
		if p2 then
			return p2.LuaApps.ExperienceDetails.PanelWidthScale
		end

		return 1
	end)
	local v31 = useDesignTokens(function(p3) -- line: 73
		if p3 then
			return p3.LuaApps.ExperienceDetails.PanelInnerPadding
		end

		return 0
	end)
	local v32 = t2.dataStatus == RetrievalStatus.Done
	local v33 = t2.descriptionText and #t2.descriptionText > 0
	local v34 = useDesignTokens(function(p4) -- line: 80
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		if FFlagRenameDeprecatedUIBloxTokens then
			return p4.Typography.BodyLarge
		end

		return p4.Semantic.Typography.Body
	end)
	local v35 = useDesignTokens(function(p5) -- line: 85
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		if FFlagRenameDeprecatedUIBloxTokens then
			return p5.Typography.HeadingSmall
		end

		return p5.Semantic.Typography.Header
	end)
	local LineHeight = v34.LineHeight
	local FontSize, Font

	if FFlagExperienceDetailsTextUseTokens then
		FontSize = v34.FontSize
		Font = v34.Font
	else
		FontSize = v27.Font.BaseSize * v27.Font.Body.RelativeSize
		Font = v27.Font.Body.Font
	end

	local v39, v40 = React.useState(0)
	local v41 = v39 * v30
	local v42 = React.useMemo(function() -- line: 108
		-- upvalues: v33 (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), v29 (copy), GetTextSize (copy), t2 (copy), FontSize (ref), Font (ref), v41 (copy), LineHeight (copy)
		if v33 and (FFlagLuaAppExpandableTextImpressionsEnabled or v29) then
			local v56 = GetTextSize(t2.descriptionText, FontSize, Font, Vector2.new(v41, 1e999))

			if FFlagLuaAppExpandableTextImpressionsEnabled and t2.expandable then
				return v56.Y
			end

			return v56.Y * LineHeight
		end

		return 0
	end, {
		t2.descriptionText,
		FontSize,
		Font,
		v41,
		if not FFlagLuaAppExpandableTextImpressionsEnabled then v29 else nil,
		LineHeight,
		if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else t2.expandable,
		if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else v33
	})
	local u43 = nil
	local v44 = nil

	if FFlagLuaAppExpandableTextImpressionsEnabled then
		u43 = React.useRef(false)
		v44 = React.useCallback(function() -- line: 144
			-- upvalues: u43 (ref)
			u43.current = not u43.current
		end)
	end

	local u45 = nil

	if v21 then
		u45 = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else React.useRef(nil)
	end

	local v46 = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else React.useCallback(function(t3: {[any]: any}) -- line: 158
		-- upvalues: v21 (copy), t2 (copy), u45 (ref), GetCanExpand (copy), v27 (copy), sendExpandableTextImpressionEvent (copy), u43 (ref), HttpService (copy)
		local v58 = nil

		if v21 and t2.expandable then
			local v59 = u45.current and u45.current.AbsoluteSize.X or 0

			if v59 > 0 then
				v58 = GetCanExpand(v27.Font, v59, t2.descriptionText, 3)
			end
		end

		for _, v61 in t3 do
			sendExpandableTextImpressionEvent({
				contentType = "description",
				impressionThreshold = v61 * 100,
				isButtonExpanded = if not v21 then if not t2.expandable then nil else u43.current else if not v58 then nil else u43.current,
				interactionUuid = HttpService:GenerateGUID(false),
				pageContext = t2.pageContext,
				itemId = tonumber(t2.universeId),
				componentType = t2.componentType or "unknown"
			})
		end
	end, {
		if not v21 then nil else t2.descriptionText,
		u43,
		t2.expandable,
		t2.componentType,
		t2.pageContext,
		t2.universeId,
		if not v21 then nil else v27.Font
	})
	local v47 = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else `ExperienceDescription_{ t2.universeId }_{ t2.componentType }_{ t2.pageContext }`

	if not v21 then
		u45 = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else React.useRef(nil)
	end

	local v48 = React.useRef(nil)

	React.useEffect(function() -- line: 211
		-- upvalues: v48 (copy), v40 (copy)
		if v48.current then
			v40(v48.current.AbsoluteSize.X)
		end
	end)

	if v32 and v33 then
		local v49 = if not t2.expandable then React.createElement(StyledTextLabel, {
			richText = false,
			fluidSizing = false,
			text = t2.descriptionText,
			size = UDim2.new(v30, 0, 0, v42),
			textYAlignment = Enum.TextYAlignment.Top,
			fontStyle = if not FFlagExperienceDetailsTextUseTokens then v27.Font.Body else v34,
			colorStyle = v27.Theme.TextDefault,
			automaticSize = if not v29 then Enum.AutomaticSize.Y else nil,
			lineHeight = LineHeight
		}) else React.createElement(ExpandableTextArea, {
			Text = t2.descriptionText,
			compactNumberOfLines = not v21 and 3 or 3,
			padding = Vector2.new(0, 0),
			gradientColor = v27.Theme.BackgroundContrast.Color,
			onClick = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else v44
		})
		local v50 = React.createElement("Frame", {
			ref = v48,
			[React.Change.AbsoluteSize] = function(p6) -- line: 242
				-- upvalues: v40 (copy)
				v40(p6.AbsoluteSize.X)
			end,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = t2.LayoutOrder,
			Selectable = true,
			[React.Event.SelectionGained] = NOOP_NEEDED_FOR_SELECTION,
			SelectionImageObject = v26
		}, {
			Padding = if not v29 then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v31),
				PaddingTop = UDim.new(0, v31),
				PaddingRight = UDim.new(0, v31),
				PaddingBottom = UDim.new(0, v31)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, t2.listPadding or 24)
			}),
			Title = if not v29 then React.createElement(StyledTextLabel, {
				richText = false,
				fluidSizing = false,
				text = t2.headerText or v28.DescriptionTitle,
				size = UDim2.fromScale(1, 0),
				fontStyle = if not FFlagExperienceDetailsTextUseTokens then v27.Font.Header1 else v35,
				colorStyle = v27.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.Y
			}) else nil,
			Description = if not FFlagLuaAppExpandableTextImpressionsEnabled then v49 else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				ref = u45,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Body = v49
			}),
			ContentThresholdImpressionsDetector = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else React.createElement(ContentThresholdImpressionsDetector, {
				containerRef = u45,
				fullContentHeight = v42,
				thresholds = t1,
				impressionsTag = v47,
				sendImpressions = v46,
				viewportBoundsOffset = t2.viewportBoundsOffset
			})
		})

		if v29 then
			return React.createElement(ExperienceDetailsPanel, {
				title = t2.headerText or v28.DescriptionTitle,
				onFocusChanged = t2.onFocusChanged
			}, v50)
		end

		return v50
	end

	return nil
end
