local Parent = script:FindFirstAncestor("Components").Parent
local ParentParent = Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)
local isCli = require(ParentParent.MarkdownCore).Utils.isCli
local TextSplitBy = require(Parent.Enums.TextSplitBy)
local SplitText = require(Parent.Utils.SplitText)

require(Parent.Types)

local Escape = require(ParentParent.MarkdownCore).Utils.Escape
local InlineElementType = require(Parent.Utils.InlineElementType)
local getFontFace = require(Parent.Utils.getFontFace)
local join = Dash.join
local t1 = {}

local function formatTextWithEngineTag(s1: string, p1) -- line: 61
	-- upvalues: Dash (copy)
	local v20 = Dash.reduce(p1.attributes, function(p2, p3, p4) -- line: 62
		local v56 = not string.find(p3, "\"") and "\"" or "'"

		return `{ p2 } { p4 }={ v56 }{ p3 }{ v56 }`
	end, "")

	return `<{ p1.name }{ v20 }>{ s1 }</{ p1.name }>`
end
local function getRichText(s2: string, t2: {[any]: any}) -- line: 70
	-- upvalues: Escape (copy), Dash (copy)
	local v23 = Escape.escapeRichFormatting(s2)

	return (Dash.reduce(t2, function(p5, p6) -- line: 72
		-- upvalues: Dash (copy)
		local v59 = Dash.reduce(p6.attributes, function(p7, p8, p9) -- line: 62
			local v70 = not string.find(p8, "\"") and "\"" or "'"

			return `{ p7 } { p9 }={ v70 }{ p8 }{ v70 }`
		end, "")

		return `<{ p6.name }{ v59 }>{ p5 }</{ p6.name }>`
	end, v23))
end

local t3 = {}

t3.__index = t3
t3.__type = InlineElementType

function t3.new(p10: ((...any) -> ...any), p11, p12: ((...any) -> ...any)?) -- line: 82
	-- upvalues: t3 (copy), Dash (copy), TextSplitBy (copy), Escape (copy)
	local self = setmetatable({}, t3)

	self.props = p11
	self.mapProps = p12 or Dash.identity
	self.Element = p10
	self.canForceSplit = self.splitBy ~= TextSplitBy.Symbol
	self.splitBy = if not self.props.SplitBy then TextSplitBy.Word else self.props.SplitBy
	self.hasRichText = self.props.EngineTags ~= nil and next(self.props.EngineTags) ~= nil

	if self.hasRichText and self.props.Text then
		self.props = Dash.assign(self.props, {
			Text = Escape.unescapeRichFormatting(self.props.Text)
		})
	end

	return self
end
function t3._clone(p13, p14) -- line: 116
	-- upvalues: t3 (copy)
	return t3.new(p13.Element, p14 or p13.props, p13.mapProps)
end

local TextService = game:GetService("TextService")

if isCli() then
	local t4 = {}

	t4.__index = t4
	TextService = setmetatable({}, t4)

	function t4.GetTextBoundsAsync(_) -- line: 127
		return {
			X = 100
		}
	end
end

function t3.getWidth(p16) -- line: 132
	return p16:_getWidth(p16.props.Text)
end
function t3._getWidth(t5: {[any]: any}, s3: string) -- line: 136
	-- upvalues: getFontFace (copy), Escape (copy), Dash (copy), TextService (ref), t1 (copy)
	local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

	GetTextBoundsParams.Font = getFontFace(t5.props.fontStyle)
	GetTextBoundsParams.Size = t5.props.fontStyle.FontSize
	GetTextBoundsParams.Text = s3

	if t5.hasRichText then
		local EngineTags = t5.props.EngineTags
		local v36 = Escape.escapeRichFormatting(s3)

		GetTextBoundsParams.Text = Dash.reduce(EngineTags, function(p17, p18) -- line: 72
			-- upvalues: Dash (copy)
			local v62 = Dash.reduce(p18.attributes, function(p19, p20, p21) -- line: 62
				local v74 = not string.find(p20, "\"") and "\"" or "'"

				return `{ p19 } { p21 }={ v74 }{ p20 }{ v74 }`
			end, "")

			return `<{ p18.name }{ v62 }>{ p17 }</{ p18.name }>`
		end, v36)
		GetTextBoundsParams.RichText = true
	end

	local ok, result = pcall(function() -- line: 148
		-- upvalues: TextService (ref), GetTextBoundsParams (copy)
		return TextService:GetTextBoundsAsync(GetTextBoundsParams).X
	end)

	if ok then
		return result
	end

	if not t1[GetTextBoundsParams.Text] then
		t1[GetTextBoundsParams.Text] = true
		warn(`Failed to get width for the { GetTextBoundsParams.Text } in BaseTextElement`)
	end

	GetTextBoundsParams.RichText = false

	return TextService:GetTextBoundsAsync(GetTextBoundsParams).X
end
function t3.split(t6: {[any]: any}, n1: number, b1: boolean?) -- line: 166
	-- upvalues: SplitText (copy), TextSplitBy (copy), join (copy)
	local v42 = t6.canForceSplit and b1
	local v43, v44 = SplitText(if not v42 then t6.splitBy else TextSplitBy.Symbol, function(p22) -- line: 168
		-- upvalues: t6 (copy)
		return t6:_getWidth(p22)
	end, t6.props.Text, n1)
	local v45 = t6:_clone(join(t6.props, {
		Text = v43
	}))

	if v44 then
		return v45, (t6:_clone(join(t6.props, {
			Text = v44:gsub("^%s*", "")
		})))
	end

	return v45, nil
end
function t3.render(t7: {[any]: any}, p23, n2: number) -- line: 179
	-- upvalues: Escape (copy), Dash (copy), React (copy), join (copy)
	local propsText = t7.props.Text

	if t7.hasRichText and (t7.props.Text and t7.props.EngineTags) then
		local propsText2 = t7.props.Text
		local EngineTags = t7.props.EngineTags
		local v52 = Escape.escapeRichFormatting(propsText2)

		propsText = Dash.reduce(EngineTags, function(p24, p25) -- line: 72
			-- upvalues: Dash (copy)
			local v66 = Dash.reduce(p25.attributes, function(p26, p27, p28) -- line: 62
				local v78 = not string.find(p27, "\"") and "\"" or "'"

				return `{ p26 } { p28 }={ v78 }{ p27 }{ v78 }`
			end, "")

			return `<{ p25.name }{ v66 }>{ p24 }</{ p25.name }>`
		end, v52)
	end

	return React.createElement(t7.Element, t7.mapProps(join(t7.props, {
		id = p23,
		Text = propsText,
		RichText = t7.hasRichText,
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = n2,
		key = tostring(n2),
		EngineTags = Dash.None
	})))
end

return t3
