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
local v14 = Signals.createSignal(nil)

local function formatScoreCell(n1: number?) -- line: 27
	-- upvalues: NumberLocalization (copy), LocalizationService (copy)
	if n1 == nil then
		return "-"
	end

	return NumberLocalization.localize(n1, LocalizationService.RobloxLocaleId)
end
local function formatRankCell(n2: number?) -- line: 34
	if n2 ~= nil then
		return (tostring(n2))
	end

	return "-"
end
local function rankToLayoutOrder(n3: number?) -- line: 38
	if n3 ~= nil then
		return n3
	end

	return 1000000
end
local function PlatformEntryViewImpl(t2: {[any]: any}) -- line: 58
	-- upvalues: SignalsReact (copy), v13 (copy), v14 (copy), React (copy), t1 (copy), formatScoreCell (copy), formatRankCell (copy), rankToLayoutOrder (copy), Constants (copy), LeaderboardRowShell (copy), LeaderboardTextCell (copy), PeopleCell (copy)
	local v23 = t2.isHeader == true
	local v24 = SignalsReact.useSignalBinding(t2.scoreGetter or v13)
	local v25 = SignalsReact.useSignalBinding(t2.rankGetter or v14)
	local scoreLabel = t2.scoreLabel
	local v27 = React.useMemo(function() -- line: 65
		-- upvalues: v23 (copy), scoreLabel (copy), t1 (copy), v24 (copy), formatScoreCell (copy)
		if v23 then
			return scoreLabel or t1.Score
		end

		return v24:map(formatScoreCell)
	end, {
		v23,
		v24,
		scoreLabel
	})
	local v28 = React.useMemo(function() -- line: 72
		-- upvalues: v23 (copy), t1 (copy), v25 (copy), formatRankCell (copy)
		if v23 then
			return t1.Rank
		end

		return v25:map(formatRankCell)
	end, {
		v23,
		v25
	})
	local v29 = if not v23 then t2.displayName or "-" else t2.peopleHeaderText or t1.People
	local v30 = if t2.layoutOrder == nil then v25:map(rankToLayoutOrder) else t2.layoutOrder
	local v31 = not v23 and "size-full text-body-small text-align-x-left content-default" or "size-full text-caption-small text-align-x-left content-muted"
	local v32 = not v23 and "size-full text-body-small text-align-x-right content-default" or "size-full text-caption-small text-align-x-right content-muted"
	local v33 = t2.rowHeight or if not v23 then Constants.PLATFORM_ROW_HEIGHT else Constants.PLATFORM_HEADER_HEIGHT
	local v34 = t2.rankWidth or Constants.PLATFORM_RANK_WIDTH
	local v35 = t2.scoreWidth or Constants.PLATFORM_SCORE_WIDTH

	return React.createElement(LeaderboardRowShell, {
		rowHeight = v33,
		layoutOrder = v30,
		isHighlighted = t2.isViewer == true,
		showDivider = t2.showDivider == true,
		flexTag = Constants.PLATFORM_ROW_FLEX_TAG
	}, {
		RankCell = React.createElement(LeaderboardTextCell, {
			layoutOrder = 1,
			text = v28,
			width = v34,
			rowHeight = v33,
			textTag = v31
		}),
		PeopleCell = React.createElement(PeopleCell, {
			layoutOrder = 2,
			displayName = v29,
			textTag = if not v23 then nil else "size-full text-caption-small text-align-x-left content-muted",
			truncate = not v23
		}),
		ScoreCell = React.createElement(LeaderboardTextCell, {
			layoutOrder = 3,
			text = v27,
			width = v35,
			rowHeight = v33,
			textTag = v32
		})
	})
end

return React.memo(PlatformEntryViewImpl)
