local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local LocalizationService = game:GetService("LocalizationService")
local NumberLocalization = require(ParentParentParent.Localization).NumberLocalization
local Constants = require(ParentParent.Common.Constants)
local FFlagPlayerListReskinOptimization = require(ParentParent.Flags.FFlagPlayerListReskinOptimization)
local LeaderboardRowShell = require(ParentParent.Components.Presentation.LeaderboardRowShell)
local LeaderboardTextCell = require(ParentParent.Components.Presentation.LeaderboardTextCell)
local PeopleCell = require(ParentParent.Components.Presentation.PeopleCell)
local t1 = {
	Rank = "Rank",
	People = "People",
	Score = "-"
}
local v14 = Signals.createSignal(nil)
local v15 = game:DefineFastString("PlatformLeaderboardUnrankedLabel", "100+")
local v16 = Signals.createSignal(nil)

local function formatScoreCell(n1: number?) -- line: 30
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	if n1 == nil then
		return "-"
	end

	return NumberLocalization.localize(n1, LocalizationService.RobloxLocaleId)
end
local function formatRankCell(n2: number?) -- line: 37
	-- upvalues: v15 (copy)
	if n2 ~= nil then
		return (tostring(n2))
	end

	return v15
end
local function rankToLayoutOrder(n3: number?) -- line: 41
	if n3 ~= nil then
		return n3
	end

	return 1000000
end
local function PlatformEntryViewImpl(t2: {[any]: any}) -- line: 61
	-- upvalues: SignalsReact (copy), v14 (copy), v16 (copy), React (copy), t1 (copy), formatScoreCell (copy), formatRankCell (copy), FFlagPlayerListReskinOptimization (copy), rankToLayoutOrder (copy), Constants (copy), LeaderboardRowShell (copy), LeaderboardTextCell (copy), PeopleCell (copy)
	local v25 = t2.isHeader == true
	local v26 = SignalsReact.useSignalBinding(t2.scoreGetter or v14)
	local v27 = SignalsReact.useSignalBinding(t2.rankGetter or v16)
	local scoreLabel = t2.scoreLabel
	local v29 = React.useMemo(function() -- line: 68
		-- upvalues: v25 (copy), scoreLabel (copy), t1 (copy), v26 (copy), formatScoreCell (copy)
		if v25 then
			return scoreLabel or t1.Score
		end

		return v26:map(formatScoreCell)
	end, {
		v25,
		v26,
		scoreLabel
	})
	local v30 = React.useMemo(function() -- line: 75
		-- upvalues: v25 (copy), t1 (copy), v27 (copy), formatRankCell (copy)
		if v25 then
			return t1.Rank
		end

		return v27:map(formatRankCell)
	end, {
		v25,
		v27
	})
	local v31 = if not v25 then t2.displayName or "-" else t2.peopleHeaderText or t1.People
	local v32 = if not FFlagPlayerListReskinOptimization then if t2.layoutOrder == nil then v27:map(rankToLayoutOrder) else t2.layoutOrder else React.useMemo(function() -- line: 86
		-- upvalues: t2 (copy), v27 (copy), rankToLayoutOrder (copy)
		if t2.layoutOrder ~= nil then
			return t2.layoutOrder
		end

		return v27:map(rankToLayoutOrder)
	end, {
		t2.layoutOrder,
		v27
	})
	local v33 = not v25 and "size-full text-body-small text-align-x-left content-default" or "size-full text-caption-small text-align-x-left content-muted"
	local v34 = not v25 and "size-full text-body-small text-align-x-right content-default" or "size-full text-caption-small text-align-x-right content-muted"
	local v35 = t2.rowHeight or if not v25 then Constants.PLATFORM_ROW_HEIGHT else Constants.PLATFORM_HEADER_HEIGHT
	local v36 = t2.rankWidth or Constants.PLATFORM_RANK_WIDTH
	local v37 = t2.scoreWidth or Constants.PLATFORM_SCORE_WIDTH

	return React.createElement(LeaderboardRowShell, {
		rowHeight = v35,
		layoutOrder = v32,
		isHighlighted = t2.isViewer == true,
		showDivider = t2.showDivider == true,
		flexTag = Constants.PLATFORM_ROW_FLEX_TAG
	}, {
		RankCell = React.createElement(LeaderboardTextCell, {
			layoutOrder = 1,
			text = v30,
			width = v36,
			rowHeight = v35,
			textTag = v33
		}),
		PeopleCell = React.createElement(PeopleCell, {
			layoutOrder = 2,
			displayName = v31,
			textTag = if not v25 then nil else "size-full text-caption-small text-align-x-left content-muted",
			truncate = not v25
		}),
		ScoreCell = React.createElement(LeaderboardTextCell, {
			layoutOrder = 3,
			text = v29,
			width = v37,
			rowHeight = v35,
			textTag = v34
		})
	})
end

return React.memo(PlatformEntryViewImpl)
