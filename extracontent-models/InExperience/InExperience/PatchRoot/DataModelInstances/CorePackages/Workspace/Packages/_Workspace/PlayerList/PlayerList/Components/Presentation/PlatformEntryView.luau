local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local LocalizationService = game:GetService("LocalizationService")
local NumberLocalization = require(ParentParentParent.Localization).NumberLocalization
local Constants = require(ParentParent.Common.Constants)
local LeaderboardRowShell = require(ParentParent.Components.Presentation.LeaderboardRowShell)
local LeaderboardTextCell = require(ParentParent.Components.Presentation.LeaderboardTextCell)
local PeopleCell = require(ParentParent.Components.Presentation.PeopleCell)
local t1 = {
	Rank = "Rank",
	People = "People",
	Score = "-"
}
local v13 = Signals.createSignal(nil)
local v14 = game:DefineFastString("PlatformLeaderboardUnrankedLabel", "100+")
local v15 = Signals.createSignal(nil)

local function formatScoreCell(n1: number?) -- line: 29
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	if n1 == nil then
		return "-"
	end

	return NumberLocalization.localize(n1, LocalizationService.RobloxLocaleId)
end
local function formatRankCell(n2: number?) -- line: 36
	-- upvalues: v14 (copy)
	if n2 ~= nil then
		return (tostring(n2))
	end

	return v14
end
local function rankToLayoutOrder(n3: number?) -- line: 40
	if n3 ~= nil then
		return n3
	end

	return 1000000
end
local function PlatformEntryViewImpl(t2: {[any]: any}) -- line: 60
	-- upvalues: SignalsReact (copy), v13 (copy), v15 (copy), React (copy), t1 (copy), formatScoreCell (copy), formatRankCell (copy), rankToLayoutOrder (copy), Constants (copy), LeaderboardRowShell (copy), LeaderboardTextCell (copy), PeopleCell (copy)
	local v24 = t2.isHeader == true
	local v25 = SignalsReact.useSignalBinding(t2.scoreGetter or v13)
	local v26 = SignalsReact.useSignalBinding(t2.rankGetter or v15)
	local scoreLabel = t2.scoreLabel
	local v28 = React.useMemo(function() -- line: 67
		-- upvalues: v24 (copy), scoreLabel (copy), t1 (copy), v25 (copy), formatScoreCell (copy)
		if v24 then
			return scoreLabel or t1.Score
		end

		return v25:map(formatScoreCell)
	end, {
		v24,
		v25,
		scoreLabel
	})
	local v29 = React.useMemo(function() -- line: 74
		-- upvalues: v24 (copy), t1 (copy), v26 (copy), formatRankCell (copy)
		if v24 then
			return t1.Rank
		end

		return v26:map(formatRankCell)
	end, {
		v24,
		v26
	})
	local v30 = if not v24 then t2.displayName or "-" else t2.peopleHeaderText or t1.People
	local v31 = if t2.layoutOrder == nil then v26:map(rankToLayoutOrder) else t2.layoutOrder
	local v32 = not v24 and "size-full text-body-small text-align-x-left content-default" or "size-full text-caption-small text-align-x-left content-muted"
	local v33 = not v24 and "size-full text-body-small text-align-x-right content-default" or "size-full text-caption-small text-align-x-right content-muted"
	local v34 = t2.rowHeight or if not v24 then Constants.PLATFORM_ROW_HEIGHT else Constants.PLATFORM_HEADER_HEIGHT
	local v35 = t2.rankWidth or Constants.PLATFORM_RANK_WIDTH
	local v36 = t2.scoreWidth or Constants.PLATFORM_SCORE_WIDTH

	return React.createElement(LeaderboardRowShell, {
		rowHeight = v34,
		layoutOrder = v31,
		isHighlighted = t2.isViewer == true,
		showDivider = t2.showDivider == true,
		flexTag = Constants.PLATFORM_ROW_FLEX_TAG
	}, {
		RankCell = React.createElement(LeaderboardTextCell, {
			layoutOrder = 1,
			text = v29,
			width = v35,
			rowHeight = v34,
			textTag = v32
		}),
		PeopleCell = React.createElement(PeopleCell, {
			layoutOrder = 2,
			displayName = v30,
			textTag = if not v24 then nil else "size-full text-caption-small text-align-x-left content-muted",
			truncate = not v24
		}),
		ScoreCell = React.createElement(LeaderboardTextCell, {
			layoutOrder = 3,
			text = v28,
			width = v36,
			rowHeight = v34,
			textTag = v33
		})
	})
end

return React.memo(PlatformEntryViewImpl)
