local RunService = game:GetService("RunService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local escapeRichText = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/escapeRichText")
local truncateCommentText = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/truncateCommentText")

local isPointInGuiObjectBounds = Foundation.Utility.isPointInGuiObjectBounds
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	showMore = "Feature.Moments.Action.CommentShowMore",
	showLess = "Feature.Moments.Action.CommentShowLess"
}

local function useCommentBodyClamp(value, p2)
	local v6 = useTokens()
	local v7 = useLocalization(v5)
	local showMore = v7.showMore
	local showLess = v7.showLess
	local v8 = React.useMemo(function()
		local muted = v6.Color.Content.Muted
		local function label(p3)
			local v9 = escapeRichText(p3)
			return `<font color="#{muted.Color3:ToHex()}" transparency="{muted.Transparency}"><b>{v9}</b></font>`
		end

		local v10 = escapeRichText(showMore)
		local v9 = {
			showMoreSuffix = `… {`<font color="#{muted.Color3:ToHex()}" transparency="{muted.Transparency}"><b>{v10}</b></font>`}`,
			showLess = 0
		}
		local v11 = escapeRichText(showLess)
		v9.showLess = `<font color="#{muted.Color3:ToHex()}" transparency="{muted.Transparency}"><b>{v11}</b></font>`
		return v9
	end, { v6, showMore, showLess })
	local showMoreSuffix = v8.showMoreSuffix

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local state, setState = React.useState(nil)
	local v9

	if not (state == nil or state.text ~= value or state.suffix ~= showMoreSuffix) then
		v9 = state.collapsedText
	end

	local v10 = v9 ~= nil

	if v9 == nil then
		v9 = escapeRichText(value)
	elseif p2 then
		v9 = `{module4((string.gsub(value, "%s+$", "")))} {v8.showLess}`
	end

	local v12 = if not (p2 and v10) then v9 else nil
	local v11 = { text = value, suffix = showMoreSuffix, clampedBodyText = v12 }

	local ref5 = React.useRef(v11)
	ref5.current = v11

	local v13 = React.useCallback(function()
		local current = ref2.current

		if current == nil or not current:IsDescendantOf(game) or current.AbsoluteSize.X <= 0 then
			return
		end

		local function measure(text)
			current.Text = text
			return current.TextBounds.Y
		end

		current.Text = "M\nM\nM"
		local v14 = current.TextBounds.Y + 1

		local current2 = ref5.current
		local formatted = `{current.AbsoluteSize.X}|{v14}|{current2.suffix}|{current2.text}`

		if formatted ~= ref3.current then
			ref3.current = formatted
			ref4.current = v14
			setState({
				text = current2.text,
				suffix = current2.suffix,
				collapsedText = truncateCommentText(current2.text, current2.suffix, v14, measure)
			})
		end

		current.Text = "M\nM\nM"
	end, {})

	local ref6 = React.useRef(false)
	local v14 = React.useCallback(function()
		if ref6.current then
			return
		end

		ref6.current = true
		RunService.Heartbeat:Once(function()
			ref6.current = false
			local current = ref.current
			local current2 = ref4.current

			if
				current ~= nil
				and current2 ~= nil
				and current.Text == ref5.current.clampedBodyText
				and current2 < current.TextBounds.Y
			then
				ref3.current = nil
			end

			v13()
		end)
	end, { v13 })

	local v15 = React.useCallback(function(p3)
		v14()
	end, { v14 })

	React.useEffect(function()
		local current = ref2.current

		if current == nil then
			return nil
		end

		local ancestryChangedConnection = current.AncestryChanged:Connect(function()
			if current:IsDescendantOf(game) then
				v14()
			end
		end)
		return function()
			ancestryChangedConnection:Disconnect()
		end
	end, { v14 })

	React.useLayoutEffect(function()
		v13()
	end, { v13, value, showMoreSuffix })

	return {
		bodyText = v9,
		bodyRef = ref,
		measureRef = ref2,
		onBodyAbsoluteSizeChanged = v15,
		isTruncatable = v10,
		containsPoint = React.useCallback(function(p3)
			return isPointInGuiObjectBounds(ref.current, p3)
		end, {})
	}
end

return useCommentBodyClamp
