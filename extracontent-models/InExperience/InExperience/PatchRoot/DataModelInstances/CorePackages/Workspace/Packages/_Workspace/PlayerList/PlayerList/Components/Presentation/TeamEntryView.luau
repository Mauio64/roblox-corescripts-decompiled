local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text

require(parent2.LeaderboardStore)

local StatCell = require(parent.Components.Presentation.StatCell)
local Constants = require(parent.Common.Constants)
require(parent.Common.computeStatColumns)

local GameTextTranslatorContext = require(parent.Common.GameTextTranslatorContext)
local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local usePreferredTransparencyBinding = require(parent.Hooks.usePreferredTransparencyBinding)
local getContrastingContentStyle = require(parent.Common.getContrastingContentStyle)
local FFlagPlayerListContrastingTeamText = require(parent.Flags.FFlagPlayerListContrastingTeamText)

local useTokens = Foundation.Hooks.useTokens
local usePreferences = Foundation.Hooks.usePreferences

local ROW_FLEX_TAG = Constants.ROW_FLEX_TAG
local TEAM_LAYOUT_MULTIPLIER = Constants.TEAM_LAYOUT_MULTIPLIER

local function TeamEntryView(props)
	local v

	if FFlagPlayerListLocalizeGameText then
		v = React.useContext(GameTextTranslatorContext)
	else
		v = nil
	end

	local v2 = SignalsReact.useSignalBinding(props.name)
	local text

	if FFlagPlayerListLocalizeGameText then
		text = React.useMemo(function()
			if v then
				return (v2:map(v))
			end

			return v2
		end, { v, v2 })
	else
		text = v2
	end

	local color2 = SignalsReact.useSignalBinding(props.color)
	local v3

	if FFlagPlayerListContrastingTeamText then
		v3 = usePreferences()
	end

	local v4

	if v3 then
		v4 = v3.preferredTransparency == nil and 1 or v3.preferredTransparency
	else
		v4 = nil
	end

	local pt

	if FFlagPlayerListContrastingTeamText then
		pt = nil
	else
		pt = usePreferredTransparencyBinding()
	end

	local v5

	if FFlagPlayerListContrastingTeamText then
		v5 = useTokens()
	else
		v5 = nil
	end

	local textStyle

	if FFlagPlayerListContrastingTeamText then
		textStyle = React.useMemo(function()
			local overMedia_200 = v5.Color.OverMedia.OverMedia_200
			return color2:map(function(color: Color3)
				return getContrastingContentStyle(color, 0.5, {
					Color3 = overMedia_200.Color3,
					Transparency = overMedia_200.Transparency * v4
				}, v5.DarkMode.Content.Emphasis, v5.LightMode.Content.Emphasis)
			end)
		end, { color2, v4, v5 })
	end

	local rowHeight = props.rowHeight

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if props.order then
				return props.order(p) * TEAM_LAYOUT_MULTIPLIER
			end

			return props.layoutOrder or 0
		end)
	end, { props.order, props.layoutOrder })
	local layoutOrder = SignalsReact.useSignalBinding(v6)
	local nameLabel

	if FFlagPlayerListContrastingTeamText then
		nameLabel = React.createElement(Text, {
			Text = text,
			LayoutOrder = 1,
			tag = "fill size-0-full text-label-small text-align-x-left clip",
			textStyle = textStyle
		})
	else
		nameLabel = React.createElement(View, { LayoutOrder = 1, tag = "fill size-0-full clip" }, {
			Label = React.createElement(Text, {
				Text = text,
				tag = "size-full text-label-small text-align-x-left content-emphasis"
			})
		})
	end

	local children = { NameLabel = nameLabel }

	if props.statColumns then
		for i, statColumn in ipairs(props.statColumns) do
			local playerStat

			if props.teamStats then
				playerStat = props.teamStats.getData(statColumn.name, false)
			end

			local formatted = `TeamStat_{statColumn.name}`
			local createElement = React.createElement
			local v7 = {
				statName = statColumn.name,
				playerStat = playerStat,
				statWidth = props.statWidth,
				rowHeight = rowHeight,
				layoutOrder = i + 1,
				textTag = not FFlagPlayerListContrastingTeamText and "text-label-small content-emphasis" or nil,
				fontStyle = 0,
				textStyle = 0
			}
			local fontStyle

			if FFlagPlayerListContrastingTeamText then
				fontStyle = v5.Typography.LabelSmall
			end

			v7.fontStyle = fontStyle
			v7.textStyle = textStyle
			children[formatted] = createElement(StatCell, v7)
		end
	end

	local backgroundStyle

	if FFlagPlayerListContrastingTeamText then
		backgroundStyle = React.useMemo(function()
			return color2:map(function(color: Color3)
				return { Color3 = color, Transparency = 0.5 }
			end)
		end, { color2 })
	else
		backgroundStyle = React.useMemo(function()
			return React.joinBindings({ color = color2, pt = pt }):map(function(p)
				return {
					Color3 = p.color,
					Transparency = 0.5 * p.pt
				}
			end)
		end, { color2, pt })
	end

	if FFlagPlayerListContrastingTeamText then
		return React.createElement(View, {
			Size = UDim2.new(1, 0, 0, rowHeight),
			backgroundStyle = backgroundStyle,
			LayoutOrder = layoutOrder,
			selection = Constants.NOT_SELECTABLE,
			testId = "team-entry-view",
			tag = ROW_FLEX_TAG
		}, children)
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, rowHeight),
		backgroundStyle = backgroundStyle,
		LayoutOrder = layoutOrder,
		selection = Constants.NOT_SELECTABLE,
		testId = "team-entry-view"
	}, {
		RowContent = React.createElement(View, { tag = `size-full {ROW_FLEX_TAG}` }, children)
	})
end

return React.memo(TeamEntryView)
