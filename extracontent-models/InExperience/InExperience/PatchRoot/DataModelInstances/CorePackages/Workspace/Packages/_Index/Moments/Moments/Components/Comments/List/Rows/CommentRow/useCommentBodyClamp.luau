local RunService = game:GetService("RunService")

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local escapeRichText = require(Moments.Utils.escapeRichText)
local truncateCommentText = require(script.Parent.truncateCommentText)

local isPointInGuiObjectBounds = Foundation.Utility.isPointInGuiObjectBounds
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

local v = {
	showMore = "Feature.Moments.Action.CommentShowMore",
	showLess = "Feature.Moments.Action.CommentShowLess"
}

local function useCommentBodyClamp(text2: string, flag: boolean)
	local v2 = useTokens()
	local v3 = useLocalization(v)
	local showMore = v3.showMore
	local showLess = v3.showLess
	local v4 = React.useMemo(function()
		local muted = v2.Color.Content.Muted
		local function label(p: string) -- 2 equivalent calls inferred from this helper
			local v4 = escapeRichText(p)
			return `<font color="#{muted.Color3:ToHex()}" transparency="{muted.Transparency}"><b>{v4}</b></font>`
		end
		return { showMoreSuffix = `… {label(showMore)}`, showLess = label(showLess) } -- inferred equivalent call
	end, { v2, showMore, showLess })
	local showMoreSuffix = v4.showMoreSuffix

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local state, setState = React.useState(nil)
	local bodyText

	if not (state == nil or state.text ~= text2 or state.suffix ~= showMoreSuffix) then
		bodyText = state.collapsedText
	end

	local isTruncatable = bodyText ~= nil

	if bodyText == nil then
		bodyText = escapeRichText(text2)
	elseif flag then
		bodyText = `{escapeRichText((string.gsub(text2, "%s+$", "")))} {v4.showLess}`
	end

	local clampedBodyText

	if not (flag and isTruncatable) then
		clampedBodyText = bodyText
	end

	local current3 = { text = text2, suffix = showMoreSuffix, clampedBodyText = clampedBodyText }

	local ref5 = React.useRef(current3)
	ref5.current = current3

	local v5 = React.useCallback(function()
		local current = ref2.current

		if current == nil or not current:IsDescendantOf(game) or current.AbsoluteSize.X <= 0 then
			return
		end

		local function measure(text: string) -- 1 equivalent call inferred from this helper
			current.Text = text
			return current.TextBounds.Y
		end
		local current4 = measure("M\nM\nM") + 1 -- inferred equivalent call

		local current2 = ref5.current
		local formatted = `{current.AbsoluteSize.X}|{current4}|{current2.suffix}|{current2.text}`

		if formatted ~= ref3.current then
			ref3.current = formatted
			ref4.current = current4
			setState({
				text = current2.text,
				suffix = current2.suffix,
				collapsedText = truncateCommentText(current2.text, current2.suffix, current4, measure)
			})
		end

		current.Text = "M\nM\nM"
	end, {})

	local ref6 = React.useRef(false)
	local v6 = React.useCallback(function()
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

			v5()
		end)
	end, { v5 })

	local onBodyAbsoluteSizeChanged = React.useCallback(function(_)
		v6()
	end, { v6 })

	React.useEffect(function()
		local current = ref2.current

		if current == nil then
			return nil
		end

		local ancestryChangedConnection = current.AncestryChanged:Connect(function()
			if current:IsDescendantOf(game) then
				v6()
			end
		end)
		return function()
			ancestryChangedConnection:Disconnect()
		end
	end, { v6 })

	React.useLayoutEffect(function()
		v5()
	end, { v5, text2, showMoreSuffix })

	return {
		bodyText = bodyText,
		bodyRef = ref,
		measureRef = ref2,
		onBodyAbsoluteSizeChanged = onBodyAbsoluteSizeChanged,
		isTruncatable = isTruncatable,
		containsPoint = React.useCallback(function(vector2: Vector2)
			return isPointInGuiObjectBounds(ref.current, vector2)
		end, {})
	}
end

return useCommentBodyClamp
