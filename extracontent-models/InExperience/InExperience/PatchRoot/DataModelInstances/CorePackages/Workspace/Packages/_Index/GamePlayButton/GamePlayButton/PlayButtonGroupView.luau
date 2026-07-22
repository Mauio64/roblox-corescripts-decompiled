local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppUseTokenHeightForPlayButton = SharedFlags.FFlagLuaAppUseTokenHeightForPlayButton
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local ButtonHeightSizeKeyByInputSize = require(script.Parent.ButtonHeightSizeKeyByInputSize)
local PlayButtonView = require(script.Parent.PlayButtonView)

local function v11() -- line: 20
end
local function makePlayButtonProps(p1, s1: string, p2: ((...any) -> ...any), p3, p4, p5, n1: number, s2: string?) -- line: 28
	return {
		playButtonState = s1,
		gameProductInfo = p1.gameProductInfo,
		localized = p1.localized,
		tokens = p1.tokens,
		hasJoinTextPlayableButtonIxp = p1.hasJoinTextPlayableButtonIxp,
		hasIconPlayButtonIxp = p1.hasIconPlayButtonIxp,
		hasPlayButtonLoadingSkeletonIxp = p1.hasPlayButtonLoadingSkeletonIxp,
		onPlayButtonActivated = p2,
		onPlaySquadButtonActivated = p1.onPlaySquadButtonActivated,
		playButtonCaptureRef = p3,
		loadingCaptureRef = p4,
		shouldLaunchWhenLoading = p1.shouldLaunchWhenLoading,
		shouldLaunchOnReleaseAfterUnmount = p1.shouldLaunchOnReleaseAfterUnmount,
		squadButtonMenuDirection = p1.squadButtonMenuDirection,
		playableText = p1.playableText,
		fiatText = p1.fiatText,
		hidePlayableIcon = p1.hidePlayableIcon,
		hideOptionalText = p1.hideOptionalText,
		buttonSize = p1.buttonSize,
		fillBehavior = p5,
		useUIBloxButton = p1.useUIBloxButton,
		hideIfUnplayable = p1.hideIfUnplayable,
		hideIfLoading = p1.hideIfLoading,
		LayoutOrder = n1,
		testId = s2
	}
end
local function PlayButtonGroupView(p6) -- line: 67
	-- upvalues: InputSize (copy), FFlagLuaAppUseTokenHeightForPlayButton (copy), ButtonHeightSizeKeyByInputSize (copy), FillBehavior (copy), React (copy), FFlagSduiExperienceDetailsSupport (copy), PlayButtonView (copy), makePlayButtonProps (copy), v11 (copy)
	local tokens = p6.tokens
	local v24 = p6.buttonSize or InputSize.Medium
	local n2 = 0

	if FFlagLuaAppUseTokenHeightForPlayButton then
		local v26 = ButtonHeightSizeKeyByInputSize[v24] or "Size_1000"

		n2 = (not tokens or not tokens.Size[v26]) and 40 or tokens.Size[v26]
	end

	local v27 = not tokens and 8 or tokens.Gap.Small
	local width = p6.width

	if p6.expandWidthForSecondaryPlayButton and p6.secondaryPlayButtonState ~= nil and width ~= nil then
		width = UDim.new(width.Scale * 2, width.Offset * 2 + v27)
	end

	local v29 = if not width then p6.fillBehavior else FillBehavior.Fill
	local v30 = if p6.secondaryPlayButtonState == nil and width == nil then v29 else if v29 ~= "Fill" then FillBehavior.Fit else FillBehavior.Fill
	local v31 = if not p6.testId then nil else `{ p6.testId }--secondary`

	return React.createElement("Frame", {
		LayoutOrder = p6.LayoutOrder,
		Position = p6.Position,
		Size = if not FFlagLuaAppUseTokenHeightForPlayButton then if not width then if v29 ~= "Fill" then nil else UDim2.new(1, 0, 1, 0) else UDim2.new(width, UDim.new(0, 0)) else UDim2.new(if not width then if v29 ~= "Fill" then UDim.new(0, 0) else UDim.new(1, 0) else width, UDim.new(0, n2)),
		AutomaticSize = if not FFlagLuaAppUseTokenHeightForPlayButton then if v29 ~= "Fill" then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y else if v29 ~= "Fill" then Enum.AutomaticSize.X else nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Tag] = if not FFlagSduiExperienceDetailsSupport then nil else p6.tag
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = if v29 ~= "Fill" then Enum.UIFlexAlignment.None else Enum.UIFlexAlignment.Fill,
			Padding = UDim.new(0, v27),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PlayButton = React.createElement(PlayButtonView, (makePlayButtonProps(p6, p6.playButtonState, p6.onPlayButtonActivated, p6.playButtonCaptureRef, p6.loadingCaptureRef, v30, 1, p6.testId))),
		SecondaryPlayButton = if not p6.secondaryPlayButtonState then nil else React.createElement(PlayButtonView, (makePlayButtonProps(p6, p6.secondaryPlayButtonState, p6.onSecondaryPlayButtonActivated or v11, nil, nil, v30, 2, v31)))
	})
end

return React.memo(PlayButtonGroupView)
