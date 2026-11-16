local parent = script:FindFirstAncestor("Components").Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Dash = require(parent2.Dash)

local MarkdownCore = require(parent2.MarkdownCore)
local isCli = MarkdownCore.Utils.isCli
local TextSplitBy = require(parent.Enums.TextSplitBy)

local SplitText = require(parent.Utils.SplitText)
require(parent.Types)
local MarkdownCore2 = require(parent2.MarkdownCore)
local Escape = MarkdownCore2.Utils.Escape

local InlineElementType = require(parent.Utils.InlineElementType)
local getFontFace = require(parent.Utils.getFontFace)

local join = Dash.join

local textSet = {}

local function formatTextWithEngineTag(p: string, p2)
	local reduced = Dash.reduce(p2.attributes, function(p3, value, p4)
		local v = string.find(value, "\"") and "'" or "\""
		return `{p3} {p4}={v}{value}{v}`
	end, "")

	return `<{p2.name}{reduced}>{p}</{p2.name}>`
end

local function getRichText(p: string, p2)
	local escapeRichFormatting = Escape.escapeRichFormatting(p)
	return (Dash.reduce(p2, function(p3, p4)
		local reduced = Dash.reduce(p4.attributes, function(p5, value, p6)
			local v = string.find(value, "\"") and "'" or "\""
			return `{p5} {p6}={v}{value}{v}`
		end, "")

		return `<{p4.name}{reduced}>{p3}</{p4.name}>`
	end, escapeRichFormatting))
end

local BaseTextElement = {}
BaseTextElement.__index = BaseTextElement
BaseTextElement.__type = InlineElementType

function BaseTextElement.new(element, props, callback)
	local self = setmetatable({}, BaseTextElement)
	self.props = props
	self.mapProps = callback or Dash.identity
	self.Element = element
	self.canForceSplit = self.splitBy ~= TextSplitBy.Symbol
	local splitBy

	if self.props.SplitBy then
		splitBy = self.props.SplitBy
	else
		splitBy = TextSplitBy.Word
	end

	self.splitBy = splitBy

	self.hasRichText = self.props.EngineTags ~= nil and next(self.props.EngineTags) ~= nil

	if self.hasRichText and self.props.Text then
		self.props = Dash.assign(self.props, {
			Text = Escape.unescapeRichFormatting(self.props.Text)
		})
	end

	return self
end

function BaseTextElement:_clone(p)
	return BaseTextElement.new(self.Element, p or self.props, self.mapProps)
end

local v = game:GetService("TextService")

if isCli() then
	local class = {}
	class.__index = class
	v = setmetatable({}, class)
	function class:GetTextBoundsAsync()
		return { X = 100 }
	end
end

function BaseTextElement:getWidth()
	return self:_getWidth(self.props.Text)
end

function BaseTextElement:_getWidth(text: string)
	local getTextBoundsParams = Instance.new("GetTextBoundsParams")
	getTextBoundsParams.Font = getFontFace(self.props.fontStyle)
	getTextBoundsParams.Size = self.props.fontStyle.FontSize
	getTextBoundsParams.Text = text

	if self.hasRichText then
		local engineTags = self.props.EngineTags
		local escapeRichFormatting = Escape.escapeRichFormatting(text)
		getTextBoundsParams.Text = Dash.reduce(engineTags, function(p, p2)
			local reduced = Dash.reduce(p2.attributes, function(p3, value, p4)
				local v2 = string.find(value, "\"") and "'" or "\""
				return `{p3} {p4}={v2}{value}{v2}`
			end, "")

			return `<{p2.name}{reduced}>{p}</{p2.name}>`
		end, escapeRichFormatting)
		getTextBoundsParams.RichText = true
	end

	local success, result = pcall(function()
		return v:GetTextBoundsAsync(getTextBoundsParams).X
	end)

	if success then
		return result
	end

	if not textSet[getTextBoundsParams.Text] then
		textSet[getTextBoundsParams.Text] = true
		warn(`Failed to get width for the {getTextBoundsParams.Text} in BaseTextElement`)
	end

	getTextBoundsParams.RichText = false
	return v:GetTextBoundsAsync(getTextBoundsParams).X
end

function BaseTextElement:split(p: number, flag: boolean?)
	local v2

	if self.canForceSplit and flag then
		v2 = TextSplitBy.Symbol
	else
		v2 = self.splitBy
	end

	local text, v3 = SplitText(v2, function(p2)
		return self:_getWidth(p2)
	end, self.props.Text, p)

	local clone = self:_clone(join(self.props, { Text = text }))

	if v3 then
		return clone, (self:_clone(join(self.props, { Text = v3:gsub("^%s*", "") })))
	end

	return clone, nil
end

function BaseTextElement:trimStart()
	local text = self.props.Text

	if text == nil then
		return self
	end

	local text2 = text:gsub("^%s+", "")

	if text2 == "" then
		return nil
	end

	if text2 == text then
		return self
	end

	return self:_clone(join(self.props, { Text = text2 }))
end

function BaseTextElement.render(props, id, layoutOrder: number)
	local text2 = props.props.Text

	if props.hasRichText and props.props.Text and props.props.EngineTags then
		local text = props.props.Text
		local engineTags = props.props.EngineTags
		local escapeRichFormatting = Escape.escapeRichFormatting(text)
		text2 = Dash.reduce(engineTags, function(p, p2)
			local reduced = Dash.reduce(p2.attributes, function(p3, value, p4)
				local v2 = string.find(value, "\"") and "'" or "\""
				return `{p3} {p4}={v2}{value}{v2}`
			end, "")

			return `<{p2.name}{reduced}>{p}</{p2.name}>`
		end, escapeRichFormatting)
	end

	return React.createElement(props.Element, props.mapProps(join(props.props, {
		id = id,
		Text = text2,
		RichText = props.hasRichText,
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = layoutOrder,
		key = tostring(layoutOrder),
		EngineTags = Dash.None
	})))
end

return BaseTextElement
