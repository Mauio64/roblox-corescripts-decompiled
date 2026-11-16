local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent2.Localization)
local NumberLocalization = Localization.NumberLocalization

local Constants = require(parent.Common.Constants)
local FormatStatString = require(parent.Common.FormatStatString)
local LeaderboardRowShell = require(parent.Components.Presentation.LeaderboardRowShell)
local LeaderboardTextCell = require(parent.Components.Presentation.LeaderboardTextCell)
local PeopleCell = require(parent.Components.Presentation.PeopleCell)

local FFlagPlayerListPlatformLeaderboardAbbreviateScores = require(parent.Flags.FFlagPlayerListPlatformLeaderboardAbbreviateScores)

local _ = { Rank = "Rank", People = "People", Score = "-" }

local signal = Signals.createSignal(nil)
local defineFastString = game:DefineFastString("PlatformLeaderboardUnrankedLabel", "100+")

local signal2 = Signals.createSignal(nil)

local function formatScoreCell(p: number?)
	if FFlagPlayerListPlatformLeaderboardAbbreviateScores then
		return FormatStatString(p)
	end

	if p == nil then
		return "-"
	end

	return NumberLocalization.localize(p, LocalizationService.RobloxLocaleId)
end

local function formatRankCell(p: number?)
	if p == nil then
		return defineFastString
	end

	return (tostring(p))
end

local function rankToLayoutOrder(p: number?)
	return if p == nil then 1000000 else p
end

local function PlatformEntryViewImpl(props)
	local isHeader = props.isHeader == true

	local v = SignalsReact.useSignalBinding(props.scoreGetter or signal)
	local v2 = SignalsReact.useSignalBinding(props.rankGetter or signal2)

	local scoreLabel = props.scoreLabel
	local text = React.useMemo(function()
		if isHeader then
			return scoreLabel or "-"
		end

		return v:map(formatScoreCell)
	end, { isHeader, v, scoreLabel })

	local rankHeaderText = props.rankHeaderText
	local text2 = React.useMemo(function()
		if isHeader then
			return rankHeaderText or "Rank"
		end

		return v2:map(formatRankCell)
	end, { isHeader, v2, rankHeaderText })
	local displayName

	if isHeader then
		displayName = props.peopleHeaderText or "People"
	else
		displayName = props.displayName or "-"
	end

	local layoutOrder = React.useMemo(function()
		if props.layoutOrder == nil then
			return v2:map(rankToLayoutOrder)
		end

		return props.layoutOrder
	end, { props.layoutOrder, v2 })

	local rowHeight = props.rowHeight

	if not rowHeight then
		if isHeader then
			rowHeight = Constants.PLATFORM_HEADER_HEIGHT
		else
			rowHeight = Constants.PLATFORM_ROW_HEIGHT
		end
	end

	local rankWidth = props.rankWidth or Constants.PLATFORM_RANK_WIDTH
	local scoreWidth = props.scoreWidth or Constants.PLATFORM_SCORE_WIDTH

	return React.createElement(LeaderboardRowShell, {
		rowHeight = rowHeight,
		layoutOrder = layoutOrder,
		isHighlighted = props.isViewer == true and props.highlightViewerRow ~= false,
		showDivider = props.showDivider == true,
		flexTag = Constants.PLATFORM_ROW_FLEX_TAG
	}, {
		RankCell = React.createElement(LeaderboardTextCell, {
			text = text2,
			width = rankWidth,
			rowHeight = rowHeight,
			layoutOrder = 1,
			textTag = isHeader and "size-full text-caption-small text-align-x-left content-muted" or "size-full text-body-small text-align-x-left content-default"
		}),
		PeopleCell = React.createElement(PeopleCell, {
			displayName = displayName,
			layoutOrder = 2,
			textTag = isHeader and "size-full text-caption-small text-align-x-left content-muted" or nil,
			truncate = not isHeader
		}),
		ScoreCell = React.createElement(LeaderboardTextCell, {
			text = text,
			width = scoreWidth,
			rowHeight = rowHeight,
			layoutOrder = 3,
			textTag = isHeader and "size-full text-caption-small text-align-x-right content-muted" or "size-full text-body-small text-align-x-right content-default"
		})
	})
end

return React.memo(PlatformEntryViewImpl)
